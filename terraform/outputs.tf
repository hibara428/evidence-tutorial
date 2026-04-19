output "cloud_run_url" {
  description = "Cloud Run URL (protected by IAP)"
  value       = google_cloud_run_v2_service.evidence.uri
}

output "artifact_registry_url" {
  description = "Artifact Registry URL for docker push"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.evidence.repository_id}"
}

output "service_account_email" {
  description = "Cloud Run service account email"
  value       = google_service_account.evidence.email
}
