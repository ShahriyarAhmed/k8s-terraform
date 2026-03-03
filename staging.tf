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
    additional-subnets = [
  {
    name   = "stg-mumbai"
    region = "asia-south1"
    cidr   = "10.10.0.0/24"
  },
  {
    name   = "stg-asia"
    region = "asia-east1"
    cidr   = "10.20.0.0/24"
  },
  {
    name   = "stg-dammam"
    region = "me-central2"
    cidr   = "10.30.0.0/24"
  }
]
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
  role_list = ["roles/container.admin","roles/artifactregistry.admin","roles/container.defaultNodeServiceAccount"]
}
module "github-actions" {
  source = "./IAM"
  account_name="github-actions"
  role_list =["roles/artifactregistry.admin","roles/iam.serviceAccountTokenCreator","roles/secretmanager.secretAccessor","roles/container.developer","roles/storage.objectViewer", "roles/run.admin","roles/iam.serviceAccountUser"]
}


module "K8s_staging" {
  source = "./K8s"
  is_spot = "true"
  subnet = "stg-qureos-private-subnet-subnetwork"
  network = module.VPC.vpc_name
  project_id = "qureos-mig-gke"
  region = "europe-west1"
  min_node = 3
  max_node = 3
  machine_type = "custom-4-12288"
  cluster_name = "qureos-staging-cluster"
  sa="k8s-nodepool-sa@qureos-mig-gke.iam.gserviceaccount.com"
  k8s_version = "1.30.5-gke.1443001"
  node_locations = [
   "europe-west1-b" 
  ]
  logging = "none"
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
module "secret-iris-employer-stg" {
  source = "./Secrets"
  secret_id = "stg-iris-employer"
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

module "livekit-asia-south1" {
    source = "./Compute"
    name = "livekit-asia-south1"
    machine_type = "e2-standard-2"
    subnet = "stg-mumbai-subnetwork"
    zone="asia-south1-a"
    service_account_email = "k8s-nodepool-sa@qureos-mig-gke.iam.gserviceaccount.com"
}
module "livekit-me-central2" {
    source = "./Compute"
    name = "livekit-me-central2"
    machine_type = "e2-standard-2"
    subnet = "stg-dammam-subnetwork"
    zone= "me-central2-a"
    service_account_email = "k8s-nodepool-sa@qureos-mig-gke.iam.gserviceaccount.com"
}
module "livekit-asia-east1" {
    source = "./Compute"
    name = "livekit-asia-east1"
    machine_type = "e2-standard-2"
    subnet = "stg-asia-subnetwork"
    zone="asia-east1-a"
    service_account_email = "k8s-nodepool-sa@qureos-mig-gke.iam.gserviceaccount.com"
}