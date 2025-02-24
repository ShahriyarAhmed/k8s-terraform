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
module "Storage-burj-line" {
    source = "./Storage"
    bucket_name = "burj-line-builders"

}
module "VPC" {
    source = "./VPC"

}

module "Compute" {
    source = "./Compute"
    name = "vm-ubuntu-sherry"
}

# module "ServiceAccounts" {
#   source = "./IAM"
#   num_of_acc=4
#   account_name=["artifact-registry","compute","k8s-nodepool","github-actions"]
#   role = [
#   ["roles/artifactregistry.admin"], 
#   ["roles/compute.instanceAdmin"],
#   ["roles/container.admin","roles/artifactregistry.admin"],
#   ["roles/artifactregistry.writer","roles/iam.serviceAccountTokenCreator"]
# ]
# }

#service_accouts with roles
module "artifact-registry-sa" {
  source = "./IAM"
  account_name="artifact-registry"
  role_list = ["roles/artifactregistry.admin"]
}
module "compute" {
  source = "./IAM"
  account_name="compute"
  role_list = ["roles/compute.instanceAdmin"]
}
module "k8s-nodepool-sa" {
  source = "./IAM"
  account_name="k8s-nodepool"
  role_list = ["roles/container.admin","roles/artifactregistry.admin"]
}
module "github-actions" {
  source = "./IAM"
  account_name="github-actions"
  role_list =["roles/artifactregistry.admin","roles/iam.serviceAccountTokenCreator","roles/secretmanager.secretAccessor","roles/container.developer","roles/storage.objectViewer"]
}


module "K8s_staging" {
  source = "./K8s"
  subnet = module.VPC.subnet_name
  network = module.VPC.vpc_name
  project_id = "qureos-mig-gke"
  region = "europe-west1"
  node_size = 02
  cluster_name = "qureos-staging-cluster"
  sa="k8s-nodepool-sa@qureos-mig-gke.iam.gserviceaccount.com"
  k8s_version = "1.30.5-gke.1443001"
}

module "artifactregistry" {
  source = "./Artifact-Registry"
  name=["qureos-stg"]
  num_of_repo = 1
}

module "secret-frontend-stg" {
  source = "./Secrets"
  secret_id = "stg-frontend"
}
module "secret-backend-stg" {
  source = "./Secrets"
  secret_id = "stg-backend"
}
module "secret-inference-stg" {
  source = "./Secrets"
  secret_id = "stg-inference"
}
module "secret-autopilot-stg" {
  source = "./Secrets"
  secret_id = "stg-autopilot"
}
module "secret-candidate-data" {
  source = "./Secrets"
  secret_id = "candidate-data"
}
module "secret-stg-iris-agent" {
  source = "./Secrets"
  secret_id = "stg-iris-agent"
}
module "startup-job" {
  source = "./Job"
  job_name = "qureos-staging-cluster-startup"
  region="europe-west1"
  image="europe-west1-docker.pkg.dev/qureos-mig-gke/qureos-stg-repo/start:1"
  schedule_cron = "0 9 * * 1-5"
  timezone = "Asia/Karachi"
}

module "shutdown-job" {
  source = "./Job"
  job_name = "qureos-staging-cluster-shutdown"
  region="europe-west1"
  image="europe-west1-docker.pkg.dev/qureos-mig-gke/qureos-stg-repo/shutdown:3"
  schedule_cron = "0 21 * * 1-5"
  timezone = "Asia/Karachi"
}