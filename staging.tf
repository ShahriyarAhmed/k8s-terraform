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

module "ServiceAccounts" {
  source = "./IAM"
  num_of_acc=3
  account_name=["artifact-registry","compute","k8s-nodepool"]
  #role=["","roles/compute.instanceAdmin","roles/container.admin"]
  role = [
  ["roles/artifactregistry.admin"], 
  ["roles/compute.instanceAdmin"],
  ["roles/container.admin","roles/artifactregistry.admin"]
]
}

module "K8s_staging" {
  source = "./K8s"
  subnet = module.VPC.subnet_name
  network = module.VPC.vpc_name
  project_id = "qureos-mig-gke"
  region = "europe-west1"
  node_size = 2
  cluster_name = "qureos-staging-cluster"
  sa=module.ServiceAccounts.sa_email_k8s
  k8s_version = "1.30.5-gke.1443001"
}

output "sa" {
  value=module.ServiceAccounts.sa_email_k8s
}