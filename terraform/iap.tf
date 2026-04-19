# IAP configuration for Cloud Run
#
# IMPORTANT: The IAP OAuth Admin API was permanently shut down on March 19, 2026.
# OAuth client and IAP enablement must be done manually via the Google Cloud console:
#
#   1. APIs & Services > OAuth consent screen
#      - Set User Type to "External" (or "Internal" for org users only)
#   2. APIs & Services > Credentials > Create Credentials > OAuth client ID
#      - Application type: Web application
#      - Add authorized redirect URI:
#        https://iap.googleapis.com/v1/oauth/clientIds/<CLIENT_ID>:handleRedirect
#   3. Cloud Run service > Security > Authentication > enable IAP
#      - Select the OAuth client created above
#
# The IAM binding below controls which users can access the service via IAP.

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
