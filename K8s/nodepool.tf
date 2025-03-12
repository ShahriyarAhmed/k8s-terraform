
resource "google_container_node_pool" "dedicated" {
  name    = "nodepool-dedicated"
  cluster = google_container_cluster.primary.name

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = var.min_node
    max_node_count = var.max_node
    
  }
  
  
  node_config {
    machine_type = var.machine_type
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
