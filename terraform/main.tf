terraform {
  required_version = "~> 1.9"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }

  # GCS backend for shared state management
  # Create the bucket and enable versioning before running `terraform init`:
  #   gcloud storage buckets create gs://hibara428-dev-tfstate --location=asia-northeast1
  #   gcloud storage buckets update gs://hibara428-dev-tfstate --versioning
  backend "gcs" {
    bucket = "hibara428-dev-tfstate"
    prefix = "evidence-tutorial"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  service_name    = "evidence-tutorial"
  repository_name = "evidence-tutorial"
}

resource "google_project_service" "apis" {
  for_each = toset([
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "iap.googleapis.com",
    "containerscanning.googleapis.com",
  ])

  service            = each.key
  disable_on_destroy = false
}
