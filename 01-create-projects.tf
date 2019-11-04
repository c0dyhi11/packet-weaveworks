provider "packet" {
    auth_token = "${var.auth_token}"
}

resource "packet_project" "master_project" {
    name = "${format("%s-masters", var.cluster_name)}"
    organization_id = "${var.organization_id}"
    bgp_config {
        deployment_type = "local"
        md5 = "${var.bgp_password}"
        asn = "${var.bgp_asn}"
   }
}

resource "packet_project" "worker_project" {
    name = "${format("%s-workers", var.cluster_name)}"
    organization_id = "${var.organization_id}"
    bgp_config {
        deployment_type = "local"
        md5 = "${var.bgp_password}"
        asn = "${var.bgp_asn}"
   }
}
