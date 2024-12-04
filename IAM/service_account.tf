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
}

locals {
  account_list = tolist(var.account_name)
  role_list=tolist(var.role)
}
