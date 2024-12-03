variable "name" {
  default = "stg-qureos-mig"
}

variable "private_subnet" {
    default= "stg-qureos-private-subnet"
}

variable "private_subnet_ip_cidr_range" {
    default = "10.0.1.0/24"
}

variable region {
    default="europe-west1"
}