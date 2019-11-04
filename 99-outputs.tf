output "K8s_Master_IPs" {
  value = "${packet_device.k8s_masters.*.access_public_ipv4}"
}

output "K8s_Worker_IPs" {
  value = "${packet_device.k8s_workers.*.access_public_ipv4}"
}

output "K8s_API_IP" {
  value = "${packet_reserved_ip_block.cluster_ip.address}"
}

output "MetalLB_CIDR" {
  value = "${packet_reserved_ip_block.metal_lb_ips.cidr_notation}"
}

output "MetalLB_BGP_ASN" {
  value = "${var.bgp_asn}"
}

output "MetalLB_BGP_Password" {
  value = "${var.bgp_password}"
}
