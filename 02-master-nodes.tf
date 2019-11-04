resource "packet_reserved_ip_block" "cluster_ip" {
    project_id = "${packet_project.new_project.id}"
    facility = "${var.facility}"
    quantity = 1
}

data "template_file" "master_user_data" {
    template = "${file("templates/master_user_data.sh")}"
    vars = {
        message = "Hello world!"
    }
}

resource "packet_device" "k8s_masters" {
    count = "${var.master_count}"
    hostname = "${format("%s-master%02d", var.cluster_name, count.index + 1)}"
    plan = "${var.master_size}"
    facilities = ["${var.facility}"]
    operating_system = "${var.k8s_os}"
    billing_cycle = "${var.billing_cycle}"
    project_id = "${packet_project.new_project.id}"
    user_data = "${data.template_file.master_user_data.rendered}"
}

resource "packet_bgp_session" "master_bgp_session" {
    count = "${var.master_count}"
    device_id = "${element(packet_device.k8s_masters.*.id, count.index)}"
    address_family = "ipv4"
}
