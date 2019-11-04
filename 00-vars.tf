variable "auth_token" {
}

variable "organization_id" {
}

variable "cluster_name" {
  default = "go-k8s"
}


variable "master_size" {
  default = "t1.small.x86"
}

variable "worker_size" {
  default = "t1.small.x86"
}

variable "facility" {
  default = "ewr1"
}

variable "k8s_os" {
  default = "ubuntu_16_04"
}

variable "billing_cycle" {
  default = "hourly"
}

variable "master_count" {
  default = 3
}

variable "worker_count" {
  default = 3
}

variable "metal_lb_ip_count" {
    default = 1
}

variable "bgp_password" {
}

variable "bgp_asn" {
}