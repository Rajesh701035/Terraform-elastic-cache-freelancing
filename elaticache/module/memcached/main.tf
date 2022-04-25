# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY AN ELASTICACHE CLUSTER TO RUN MEMCACHED
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

terraform {
  # This module is now only being tested with Terraform 1.1.x. However, to make upgrading easier, we are setting 1.0.0 as the minimum version.
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "< 4.0"
    }
  }
}

# ------------------------------------------------------------------------------
# CREATE THE ELASTICACHE CLUSTER
# ------------------------------------------------------------------------------

resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = var.name
  port                 = var.port
  parameter_group_name = var.parameter_group_name == null ? local.default_parameter_group_name : var.parameter_group_name

  num_cache_nodes = var.num_cache_nodes
  node_type   = var.instance_type
  az_mode         = var.az_mode

  engine         = "memcached"
  engine_version = var.memcached_version

  apply_immediately  = var.apply_immediately
  maintenance_window = var.maintenance_window

  subnet_group_name  = aws_elasticache_subnet_group.memcached.name
  security_group_ids = [aws_security_group.memcached.id]
}

# This is a workaround for https://github.com/terraform-providers/terraform-provider-aws/issues/2468. If we don't set
# the parameter group name, ElastiCache will show a diff every time you run plan, and exit with an error when you run
# apply. The default parameter group value is of the format default.memcachedXXX, where XXX is the major.minor version
# number (but no patch!).
locals {
  default_parameter_group_name = "default.memcached${replace(var.memcached_version, "/(.+?)\\.(.+?)\\..+/", "$1.$2")}"
}

# ------------------------------------------------------------------------------
# CREATE THE SUBNET GROUP THAT SPECIFIES IN WHICH SUBNETS TO DEPLOY THE CACHE INSTANCES
# ------------------------------------------------------------------------------

resource "aws_elasticache_subnet_group" "memcached" {
  name        = "${var.name}-subnet-group"
  description = "Subnet group for the ${var.name} ElastiCache cluster"
  subnet_ids  = var.subnet_ids
}

# ------------------------------------------------------------------------------
# CREATE THE SECURITY GROUP THAT CONTROLS WHAT TRAFFIC CAN CONNECT TO THE CACHE
# ------------------------------------------------------------------------------

resource "aws_security_group" "memcached" {
  name        = var.name
  description = "Security group for the ${var.name} ElastiCache cluster"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "allow_connections_from_cidr_blocks" {
  count       = signum(length(var.allow_connections_from_cidr_blocks))
  type        = "ingress"
  from_port   = var.port
  to_port     = var.port
  protocol    = "tcp"
  cidr_blocks = var.allow_connections_from_cidr_blocks

  security_group_id = aws_security_group.memcached.id
}

resource "aws_security_group_rule" "allow_connections_from_security_group" {
  count                    = length(var.allow_connections_from_security_groups)
  type                     = "ingress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  source_security_group_id = element(var.allow_connections_from_security_groups, count.index)

  security_group_id = aws_security_group.memcached.id
}
