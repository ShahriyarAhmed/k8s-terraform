terraform {
required_version = ">= 1.3.0, < 2.0.0"
 backend "gcs" {
    bucket = "terraform-backend-012"
  }
}
provider "google" {
  project = "qureos-mig-gke"
  region  = "europe-west1"
}

module "Storage" {
    source = "./Storage"

}

module "VPC" {
    source = "./VPC"

}

module "Compute" {
    source = "./Compute"
    name = "vm-ubuntu-sherry"
}