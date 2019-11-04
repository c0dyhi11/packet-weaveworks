data "template_file" "interface_lo0" {
    template = "${file("templates/lo_interface.tpl")}"

    vars = {
        floating_ip = "${packet_reserved_ip_block.cluster_ip.address}"
        floating_netmask  = "${packet_reserved_ip_block.cluster_ip.netmask}"
    }
}

data "template_file" "bird_conf_template" {
    count = "${var.master_count}"
    template = "${file("templates/bird_conf.tpl")}"
    
    vars = {
        floating_ip = "${packet_reserved_ip_block.cluster_ip.address}"
        floating_cidr = "${packet_reserved_ip_block.cluster_ip.cidr}"
        private_ipv4 = "${element(packet_device.k8s_masters.*.network.2.address, count.index)}"
        gateway_ip = "${element(packet_device.k8s_masters.*.network.2.gateway, count.index)}"
        bgp_password = "${var.bgp_password}"
        local_asn = "${var.bgp_asn}"
    }
}

resource "null_resource" "configure_bird" {
    count = "${var.master_count}"
    connection {
        type = "ssh"
        user = "root"
        private_key = "${file("~/.ssh/id_rsa")}"
        host = "${element(packet_device.k8s_masters.*.access_public_ipv4, count.index)}"
    }

    provisioner "remote-exec" {
        inline = [
            "apt-get install bird",
            "mv /etc/bird/bird.conf /etc/bird/bird.conf.old"
        ]
    }

    provisioner "file" {
        content = "${element(data.template_file.bird_conf_template.*.rendered, count.index)}"
        destination = "/etc/bird/bird.conf"
    }

    provisioner "file" {
        content = "${data.template_file.interface_lo0.rendered}"
        destination = "/etc/network/interfaces.d/lo0"
    }

    provisioner "remote-exec" {
        inline = [
            "sysctl net.ipv4.ip_forward=1",
            "grep /etc/network/interfaces.d /etc/network/interfaces || echo 'source /etc/network/interfaces.d/*' >> /etc/network/interfaces",
            "ifup lo:0",
            "service bird restart"
        ]
    }
}