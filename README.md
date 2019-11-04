# WeaveWorks on Packet
This Terraform plan will deploy the basic infra needed in order to deploy Weave Works on Packet.

**!!!We are assuming you have uploaded your public key to packet that matches with `~/.ssh/id_rsa`!!!**

## How to use:
### override.tf
Create an `override.tf` that looks similar to this:
```
variable "auth_token" {
  default = "32lknjdw9c8dsnfed78l23n79do973in"
}

variable "organization_id" {
    default = "32lknjdw-9c8d-snfe-d78l-23n79do973in"
}

variable "bgp_password" {
    default = "S0m3S3cur3Passw0rd"
}
```

### 00-vars.tf
Update your 00-vars.tf to set the quanity, size, location, & operating system you'd like.

### Kick off terraform:
```bash
terraform init
terraform apply --auto-approve
```

### Output should look similar to this:
```
Apply complete! Resources: 18 added, 0 changed, 0 destroyed.

Outputs:

K8s_API_IP = 147.75.64.3
K8s_Master_IPs = [
  "147.75.97.71",
  "147.75.199.157",
  "147.75.97.187",
]
K8s_Worker_IPs = [
  "147.75.97.69",
  "147.75.65.37",
  "147.75.96.133",
]
MetalLB_BGP_ASN = 65000
MetalLB_BGP_Password = S0m3S3cur3Passw0rd
MetalLB_CIDR = 147.75.96.136/32
```
