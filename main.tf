data "aws_caller_identity" "current" {}

locals {
  account_id         = data.aws_caller_identity.current.account_id
  egress_cidr_block  = "0.0.0.0/0"
  ingress_cidr_block = "192.168.1.0/24"
}
