provider "packet" {
    auth_token = "${var.auth_token}"
}

resource "packet_project" "new_project" {
    name = "${var.cluster_name}"
    organization_id = "${var.organization_id}"
    bgp_config {
        deployment_type = "local"
        md5 = "${var.bgp_password}"
        asn = "${var.bgp_asn}"
   }
}
