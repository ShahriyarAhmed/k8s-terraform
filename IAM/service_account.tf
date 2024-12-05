resource"google_service_account""this" {
count = var.num_of_acc 
account_id="${local.account_list[count.index]}-sa"
display_name = "${local.account_list[count.index]}-sa"
}

resource "google_project_iam_member" "this" {
  count = var.num_of_acc 
  project = "qureos-mig-gke"
  role    = local.role_list[count.index]
  member  = "serviceAccount:${google_service_account.this[count.index].email}"
  depends_on = [ google_service_account.this ]
}

locals {
  account_list = tolist(var.account_name)
  role_list=tolist(var.role)
}
output "sa_email_k8s" {
  value = google_service_account.this[2].email
}

