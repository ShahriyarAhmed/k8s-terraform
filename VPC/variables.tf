variable "name" {
  default = "stg-qureos-mig"
}

variable "private_subnet" {
    default= "stg-qureos-private-subnet"
}

variable "private_subnet_ip_cidr_range" {
    default = "10.0.0.0/16"
}
variable "private_subnet_ip_cidr_range_2" {
    default = "10.1.0.0/16"
}
variable region {
    default="europe-west1"
}

variable "additional-subnets" {
  description = "List of subnet configurations"
  type = list(object({
    name   = string
    region = string
    cidr   = string
  }))
}