resource"google_service_account""this" {
count = var.num_of_acc 
account_id="${local.account_list[count.index]}-sa"
display_name = "${local.account_list[count.index]}-sa"
}

resource "google_project_iam_member" "this" {
 for_each = merge(flatten([
    for idx in range(var.num_of_acc) : {
      for role in coalesce(var.role[idx], []) : 
      "${google_service_account.this[idx].email}_${trimspace(role)}" => {
        project = "qureos-mig-gke"
        sa_email = google_service_account.this[idx].email
        role    = trimspace(role)
      }
    }
  ])...)

  project = each.value.project
  role    = each.value.role
  member  = "serviceAccount:${each.value.sa_email}"

  depends_on = [google_service_account.this]
}

locals {
  account_list = tolist(var.account_name)
  role_list=tolist(var.role)
}
output "sa_email_k8s" {
  value = google_service_account.this[2].email
}

