resource "google_cloud_run_v2_job" "default" {
  name     = var.job_name
  location = var.region
  deletion_protection = false

  template {
    template {
      containers {
        image = var.image
        resources {
          limits = {
            cpu    = "1"
            memory = "512Mi"
          }
        }
      }
    }
  }
  
  lifecycle {
    ignore_changes = [
      launch_stage,
    ]
  }
}
