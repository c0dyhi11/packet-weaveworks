resource "packet_reserved_ip_block" "metal_lb_ips" {
    project_id = "${packet_project.master_project.id}"
    facility = "${var.facility}"
    quantity = "${var.metal_lb_ip_count}"
}

data "template_file" "worker_user_data" {
    template = "${file("templates/worker_user_data.sh")}"
    vars = {
        message = "Hello world!"
    }
}

resource "packet_device" "k8s_workers" {
    count            = "${var.worker_count}"
    hostname         = "${format("%s-worker%02d", var.cluster_name, count.index + 1)}"
    plan             = "${var.worker_size}"
    facilities       = ["${var.facility}"]
    operating_system = "${var.k8s_os}"
    billing_cycle    = "${var.billing_cycle}"
    project_id       = "${packet_project.master_project.id}"
    user_data        = "${data.template_file.worker_user_data.rendered}"
}

resource "packet_bgp_session" "worker_bgp_session" {
  count = "${var.worker_count}"
  device_id = "${element(packet_device.k8s_workers.*.id, count.index)}"
  address_family = "ipv4"
}
