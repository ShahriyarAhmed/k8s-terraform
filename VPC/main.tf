resource "google_compute_network" "this" {
  name = "${var.name}-vpc"
  delete_default_routes_on_create = false
  auto_create_subnetworks = false
  routing_mode  = "REGIONAL"
}

resource "google_compute_subnetwork" "this" {
name="${var.private_subnet}-subnetwork"
ip_cidr_range= var.private_subnet_ip_cidr_range
region=var.region
network=google_compute_network.this.id
private_ip_google_access =true
}

# Static External IP for the NAT Gateway
resource "google_compute_address" "nat-ip" {
  name = "${var.name}-nat-ip"
  region = var.region   
  network_tier = "STANDARD"
}

# NAT ROUTER
resource "google_compute_router" "this" {
  name    = "${var.name}-router"
  region  = google_compute_subnetwork.this.region
  network = google_compute_network.this.id
}

resource "google_compute_router_nat" "this" {
  name                               = "${var.name}-router-nat"
  router                             = google_compute_router.this.name
  region                             = google_compute_router.this.region
  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = [google_compute_address.nat-ip.self_link]
  

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_firewall" "rules" {
  name    = "allow-ssh"
  network = "${var.name}-vpc"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}
