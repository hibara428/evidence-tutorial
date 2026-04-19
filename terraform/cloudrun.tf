resource "google_artifact_registry_repository" "evidence" {
  repository_id = local.repository_name
  format        = "DOCKER"
  location      = var.region

  # Ensure policies actually delete (not dry-run)
  cleanup_policy_dry_run = false

  # Keep latest 5 tagged images; delete untagged images immediately
  cleanup_policies {
    id     = "keep-latest-5"
    action = "KEEP"
    most_recent_versions {
      keep_count = 5
    }
  }
  cleanup_policies {
    id     = "delete-untagged"
    action = "DELETE"
    condition {
      tag_state = "UNTAGGED"
    }
  }

  depends_on = [google_project_service.apis]
}

resource "google_service_account" "evidence" {
  account_id   = local.service_name
  display_name = "Evidence Cloud Run SA"
}

# Pull image from Artifact Registry
resource "google_artifact_registry_repository_iam_member" "evidence_reader" {
  project    = var.project_id
  location   = var.region
  repository = google_artifact_registry_repository.evidence.repository_id
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.evidence.email}"
}

# Write logs and metrics (required for custom service accounts)
resource "google_project_iam_member" "evidence_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.evidence.email}"
}

resource "google_project_iam_member" "evidence_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.evidence.email}"
}

resource "google_cloud_run_v2_service" "evidence" {
  name                = local.service_name
  location            = var.region
  ingress             = "INGRESS_TRAFFIC_ALL"
  deletion_protection = false

  template {
    service_account = google_service_account.evidence.email

    # Static site: short timeout, high concurrency
    timeout                          = "30s"
    max_instance_request_concurrency = 1000

    containers {
      image = var.image

      ports {
        container_port = 80
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "256Mi"
        }
        # Throttle CPU when not handling requests (required for < 512Mi memory)
        cpu_idle = true
      }

      # startup_probe must succeed before liveness_probe begins
      # Gives nginx up to 30s to start (10 attempts × 3s period)
      startup_probe {
        http_get {
          path = "/"
        }
        initial_delay_seconds = 0
        period_seconds        = 3
        failure_threshold     = 10
        timeout_seconds       = 2
      }

      liveness_probe {
        http_get {
          path = "/"
        }
        period_seconds    = 10
        failure_threshold = 3
        timeout_seconds   = 3
      }
    }

    scaling {
      min_instance_count = 0
      max_instance_count = 3
    }
  }

  depends_on = [
    google_project_service.apis,
    google_artifact_registry_repository_iam_member.evidence_reader,
    google_project_iam_member.evidence_log_writer,
    google_project_iam_member.evidence_metric_writer,
  ]
}

data "google_project" "project" {
  project_id = var.project_id
}

# Allow IAP service agent to invoke Cloud Run
resource "google_cloud_run_v2_service_iam_member" "iap_invoker" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.evidence.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-iap.iam.gserviceaccount.com"
}
