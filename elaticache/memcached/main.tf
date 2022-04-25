
terraform {
  cloud {
    organization = "ranjithtest"
    hostname = "app.terraform.io" # Optional; defaults to app.terraform.io

    #credentials "app.terraform.io" {
    #token = "*****************************************************************************************"
    #}

    workspaces {
      name = "ranjithtest-workspace"
      #    tags = ["networking", "source:cli"]
    }
  }
}

provider "aws" {

  region     = var.aws_region
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY

  # kindly Mark the Environmental Variable as Senstive in the Terraform Cloud

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = var.aws_account_ids
}


module "memcached" {
  source = "../module/memcached/"
  name =   lookup(var.eks_cluster_config, "name", "testcluster")
  instance_type = lookup(var.eks_cluster_config , "instance_type", "cache.rg6.large")
  vpc_id                             = lookup(var.eks_cluster_config, "vpc_id", ["vpc-****************"])
  subnet_ids                         = lookup(var.eks_cluster_config, "subnet_ids", ["subnet-***********,subnet-************"])
  allow_connections_from_cidr_blocks = lookup(var.eks_cluster_config, "cidr_block", ["0.0.0.0/0"])
# source_security_group_id = lookup(allow_connections_from_security_groups, terraform.workspace, "sg-************")
  num_cache_nodes    = lookup(var.eks_cluster_config, "cachenodesnum", 1)
  memcached_version  = lookup(var.eks_cluster_config, "memcached_version", "1.6.6")
  az_mode            = lookup(var.eks_cluster_config, "az_mode", "single-az")
  maintenance_window = lookup(var.eks_cluster_config, "maintenance_window", "sat:07:00-sat:08:00")
#  apply_immediately    = lookup(var.apply_immediately, "apply_immediately", "false")
#  parameter_group_name = lookup(var.parameter_group_name, "parameter_group_name", "default.memcached1.6")
}

resource "aws_security_group" "memcached" {
  name        = var.name
  description = "Security group for the ${var.name} ElastiCache cluster"
  vpc_id      = var.vpc_id
}

#################################################################################
### THE BELOW MENTIONED ENTRIES ARE FOR THE SECURITY GROUP RULE FOR THE EGRESS###
#################################################################################

resource "aws_security_group_rule" "allow_connections_from_cidr_blocks_egress" {
for_each = toset(var.eks_cluster_config.port)
  type        = "egress"
  protocol    = "tcp"
  security_group_id = aws_security_group.memcached.id

  from_port = each.value
  to_port = each.value
  cidr_blocks = var.allow_connections_from_cidr_blocks_egress
#  cidr_blocks = [for i in aws_instance.instance: format("%s/32, i.private_ip")]
}

resource "aws_security_group_rule" "allow_connections_from_security_group_egress" {
  for_each = toset(var.eks_cluster_config.port)
  type                     = "egress"
  from_port                = each.value
  to_port                  = each.value
  protocol                 = "tcp"
# source_security_group_id = element(var.allow_connections_from_security_groups_egress, count.index)
  security_group_id = aws_security_group.memcached.id
}


#################################################################################
### THE BELOW MENTIONED ENTRIES ARE FOR THE SECURITY GROUP RULE FOR THE INGRESS###
#################################################################################


resource "aws_security_group_rule" "allow_connections_from_cidr_blocks" {
for_each = toset(var.eks_cluster_config.port)
  type        = "ingress"
  protocol    = "tcp"
  security_group_id = aws_security_group.memcached.id

  from_port = each.value
  to_port = each.value
  cidr_blocks = var.allow_connections_from_cidr_blocks_egress
#  cidr_blocks = [for i in aws_instance.instance: format("%s/32, i.private_ip")]
}

resource "aws_security_group_rule" "allow_connections_from_security_group" {
  for_each = toset(var.eks_cluster_config.port)
  type                     = "ingress"
  from_port                = each.value
  to_port                  = each.value
  protocol                 = "tcp"
# source_security_group_id = element(var.allow_connections_from_security_groups_egress, count.index)
  security_group_id = aws_security_group.memcached.id
}
