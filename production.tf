module "VPC-prod" {
    source = "./VPC"
    name="prod-qureos-mig"
    private_subnet = "prod-qureos-private-subnet"
    private_subnet_ip_cidr_range = "20.0.0.0/16"
}

module "artifactregistry-prod" {
  source = "./Artifact-Registry"
  name=["qureos-prod"]
  num_of_repo = 1
}

module "K8s_prod" {
  source = "./K8s"
  subnet = module.VPC-prod.subnet_name
  network = module.VPC-prod.vpc_name
  project_id = "qureos-mig-gke"
  region = "europe-west1"
  node_size = 02
  cluster_name = "qureos-prod-cluster"
  sa="k8s-nodepool-sa@qureos-mig-gke.iam.gserviceaccount.com"
  k8s_version = "1.31.5-gke.1023000"
}

 
module "secret-frontend-prd" {
  source = "./Secrets"
  secret_id = "prd-frontend"
}
module "secret-backend-prd" {
  source = "./Secrets"
  secret_id = "prd-backend"
}
module "secret-inference-prd" {
  source = "./Secrets"
  secret_id = "prd-inference"
}


module "secret-autopilot-prd" {
  source = "./Secrets"
  secret_id = "prd-autopilot"
}


module "secret-places-prd" {
  source = "./Secrets"
  secret_id = "prd-places"
}