resource "google_container_cluster" "primary" {
  name                     = var.cluster_name
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = var.network
  subnetwork               = var.subnet
  logging_service          = var.logging
  monitoring_service       = var.monitoring
  networking_mode          = "VPC_NATIVE"

  # Optional, if you want multi-zonal cluster
  node_locations = var.node_locations
  maintenance_policy {
    recurring_window {
        end_time   = "2025-04-12T19:00:00Z"
        recurrence = "FREQ=WEEKLY;BYDAY=SA"
        start_time = "2025-04-11T19:00:00Z"
      }
  }
  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }
  release_channel {
    channel = "STABLE"
  }


  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
   
  }
  
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
  }
  min_master_version = var.k8s_version
}
