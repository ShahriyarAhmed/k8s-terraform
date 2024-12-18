resource "google_container_node_pool" "spot" {
  name    = "spot"
  cluster = google_container_cluster.primary.name

  management {
    auto_repair  = true
    auto_upgrade = true
  }
  node_count = var.node_size
  
  
  node_config {
    preemptible  = true
    machine_type = "e2-standard-2"
    image_type = "UBUNTU_CONTAINERD"
    labels = {
      team = "devops"
    }


    service_account = var.sa
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform" 
    ]
  }

}
