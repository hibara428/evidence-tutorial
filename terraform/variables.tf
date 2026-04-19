variable "project_id" {
  description = "GCP project ID"
  type        = string
  validation {
    condition     = length(var.project_id) > 0
    error_message = "project_id must not be empty."
  }
}

variable "region" {
  description = "Cloud Run region"
  type        = string
  default     = "asia-northeast1"
}

variable "iap_client_id" {
  description = "OAuth client ID for IAP (create manually via GCP console: APIs & Services > Credentials)"
  type        = string
  validation {
    condition     = length(var.iap_client_id) > 0
    error_message = "iap_client_id must not be empty."
  }
}

variable "iap_client_secret" {
  description = "OAuth client secret for IAP (create manually via GCP console: APIs & Services > Credentials)"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.iap_client_secret) > 0
    error_message = "iap_client_secret must not be empty."
  }
}

variable "iap_allowed_members" {
  description = "List of members allowed to access via IAP (e.g. [\"user:foo@example.com\", \"group:team@example.com\"])"
  type        = list(string)
  validation {
    condition     = length(var.iap_allowed_members) > 0
    error_message = "iap_allowed_members must contain at least one member."
  }
}

variable "image" {
  description = "Full container image URL (e.g. asia-northeast1-docker.pkg.dev/PROJECT/evidence/app:latest)"
  type        = string
  validation {
    condition     = can(regex("^.+-docker\\.pkg\\.dev/.+/.+/.+:.+$", var.image))
    error_message = "image must be a valid Artifact Registry Docker image URL."
  }
}
