variable "name" {
    default =    "vm-test-ubuntu"
}
variable "zone"{
    default= "europe-west1-b"
}
variable "machine_type" {
    default =   "e2-medium"
}
variable "image" {
    default =   "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
}
variable "network" {
    default = "stg-qureos-mig-vpc"
}

variable "subnet" {
    default = "stg-qureos-private-subnet-subnetwork"
}

