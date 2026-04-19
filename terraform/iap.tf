# IAP OAuth client setup
#
# IMPORTANT: google_iap_brand and google_iap_client use the IAP OAuth Admin API,
# which was permanently shut down on March 19, 2026. You must create the OAuth
# client manually via the Google Cloud console:
#
#   1. Go to APIs & Services > OAuth consent screen
#      - Set User Type to "External" for out-of-org access
#   2. Go to APIs & Services > Credentials > Create Credentials > OAuth client ID
#      - Application type: Web application
#      - Add authorized redirect URI:
#        https://iap.googleapis.com/v1/oauth/clientIds/<CLIENT_ID>:handleRedirect
#   3. Copy the client ID and secret into terraform.tfvars:
#      iap_client_id     = "..."
#      iap_client_secret = "..."

# Link custom OAuth client to the Cloud Run service
# Name format: projects/PROJECT_NUMBER/iap_web/REGION/services/SERVICE_NAME
resource "google_iap_settings" "evidence" {
  name = "projects/${data.google_project.project.number}/iap_web/${var.region}/services/${google_cloud_run_v2_service.evidence.name}"

  access_settings {
    oauth_settings {
      oauth_client_id     = var.iap_client_id
      oauth_client_secret = var.iap_client_secret
    }
  }
}

# Grant IAP access to specified members
# Use google_iap_web_cloud_run_service_iam_binding (not google_cloud_run_v2_service_iam_binding)
# per official Cloud Run IAP documentation
resource "google_iap_web_cloud_run_service_iam_binding" "iap_access" {
  project                = var.project_id
  location               = var.region
  cloud_run_service_name = google_cloud_run_v2_service.evidence.name
  role                   = "roles/iap.httpsResourceAccessor"
  members                = var.iap_allowed_members
}
