filter packet_bgp {
    if net = ${floating_ip}/${floating_cidr} then accept;
}
router id ${private_ipv4};
protocol direct {
    interface "lo";
}
protocol kernel {
    scan time 10;
    persist;
    import all;
    export all;
}
protocol device {
    scan time 10;
}
protocol bgp {
    export filter packet_bgp;
    local as ${local_asn};
    neighbor ${gateway_ip} as 65530;
    password "${bgp_password}"; 
}