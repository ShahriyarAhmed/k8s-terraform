module "VPC-prod" {
    source = "./VPC"
    name="prod-qureos-mig"
    private_subnet = "prod-qureos-private-subnet"
    private_subnet_ip_cidr_range = "20.0.0.0/16"

    additional-subnets = []
}

module "iris-api-call" {
  source = "./IAM"
  account_name="iris-api-call"
  role_list =["roles/storage.admin"]
}
module "artifactregistry-prod" {
  source = "./Artifact-Registry"
  name=["qureos-prod"]
  num_of_repo = 1
}

module "K8s_prod" {
  source = "./K8s"
  is_spot = "false"
  subnet = "prod-qureos-private-subnet-subnetwork"
  network = module.VPC-prod.vpc_name
  project_id = "qureos-mig-gke"
  region = "europe-west1"
  min_node = 1
  max_node = 2
  machine_type = "custom-6-20480"
  cluster_name = "qureos-prod-cluster"
  sa="k8s-nodepool-sa@qureos-mig-gke.iam.gserviceaccount.com"
  k8s_version = "1.31.5-gke.1023000"
  node_locations = [
   "europe-west1-b" ,
   "europe-west1-c" ,
   "europe-west1-d"
  ]
  logging = "logging.googleapis.com/kubernetes"
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

module "secret-candidate-data-prd" {
  source = "./Secrets"
  secret_id = "prd-candidate-data"
}


module "secret-iris-prd" {
  source = "./Secrets"
  secret_id = "prd-iris-agent"
}

module "Storage-iris" {
    source = "./Storage"
    bucket_name = "iris-recordings"
}