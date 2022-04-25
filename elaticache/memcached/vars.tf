# ------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ------------------------------------------------------------------------------
# MODULE PARAMETERS
# These variables are expected to be passed in by the operator when calling this
# terraform module
# ------------------------------------------------------------------------------

variable "AWS_ACCESS_KEY" {
 default = ""
 description = "AWS ACCESS KEY HAS BEEN AVAILABLE IN THE ENVIRONMENTAL VAIRABLES"
 }

variable "AWS_SECRET_KEY" {
 default = ""
 description = "AWS SECRET KEY HAS BEEN AVAILABLE IN THE ENVIRONMENTAL VARIABLES"
}


variable "eks_cluster_config" {
 description = "This is a Variables which has all the Key Value pairs for elastic cache service"
 default = ""
}


variable "aws_region" {
  description = "The AWS region in which all resources will be created"
  type        = string
}

variable "aws_account_ids" {
  description = "A list of AWS Account IDs. Only these IDs may be operated on by this template. The first account ID in the list will be used to identify where the VPC Peering Connection should be created. This should be the account ID in which all resources are to be created."
  type        = list(string)
}

variable "name" {
  description = "The name used to namespace all resources created by these templates."
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The type of instance to be used for memcache."
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "The id of the VPC in which this EC2 instance should be deployed"
#  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet ids where the database instances should be deployed. These subnets must be in the availability zones in var.availability_zones. In the standard Gruntwork VPC setup, these should be the private persistence subnet ids."
#  type        = list(string)
}


variable "parameter_group_name" {
  description = "Name of the parameter group to associate with this cache cluster. This can be used to configure custom settings for the cluster."
  type        = string
  default     = null
}

variable "num_cache_nodes" {
  description = "The type of instance to be used for memcache."
#  type        = number
  default     =  ""
}

variable "az_mode" {
  description = "Specifies whether the nodes in this Memcached node group are created in a single Availability Zone or created across multiple Availability Zones in the cluster's region. Valid values for this parameter are single-az or cross-az. If you want to choose cross-az, num_cache_nodes must be greater than 1."
  type        = string
  default     = "single-az"
}

variable "engine" {
  description = "Specifies which engine should be used"
  type        = string
  default     = "memcached"
}

variable "engine_version" {
  description = "Version number of memcached to use (e.g. 1.5.16)."
  type        = string
  default     = "1.5.16"
}

variable "port" {
  description = "The port number through which it communicates."
  type        = list(number)
  default     = []  
}

variable "protocol" {
  description = "Specifies which protocol should be used"
  type        = string
  default     = "tcp"
}

variable "allow_connections_from_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges that can connect to this ElastiCache cluster. For the standard Gruntwork VPC setup, these should be the CIDR blocks of the private app subnet in this VPC plus the private subnet in the mgmt VPC."
   default = []
#  type        = list(string)
}


variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window."
  type        = bool
  default     = "false"
}


variable "allow_connections_from_cidr_blocks_egress" {
  description = "A list of CIDR-formatted IP address ranges that can connect to this ElastiCache cluster. For the standard Gruntwork VPC setup, these should be the CIDR blocks of the private app subnet in this VPC plus the private subnet in the mgmt VPC."
   default = ["10.0.0.1/24"]
#  type        = list(string)
}

variable "allow_connections_from_security_groups_egress" {
   default = []
   type        = list(string)
   description = "Allow the egress rule in the Security Group for elastic cache"
}

