resource"google_service_account""this" {
account_id="${var.account_name}-sa"
display_name = "${var.account_name}-sa"
}

resource "google_project_iam_member" "this" {
 for_each = toset(var.role_list)
  role = each.key
  member = "serviceAccount:${google_service_account.this.email}"
  project = "qureos-mig-gke"

  depends_on = [google_service_account.this]
}

output "sa_email" {
  value=google_service_account.this.email  
}



