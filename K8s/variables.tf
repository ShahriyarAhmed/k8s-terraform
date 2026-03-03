variable "cluster_name" {
}

variable "region" {  
}

variable  "min_node" {
}
variable  "max_node" {
}
variable  "project_id" {
}

variable "network" {
  
}
variable "subnet" {
  
}
variable "machine_type" {
  
}
variable "sa" {
  
}
variable "k8s_version" {
  
}
variable "is_spot" {
}
variable "monitoring"{
    default = "monitoring.googleapis.com/kubernetes"
}
variable node_locations{
    type=list(string)
}
variable logging{
    
}