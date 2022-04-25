# ------------------------------------------------------------------------------
# MODULE PARAMETERS
# These variables are expected to be passed in by the operator when calling this
# terraform module.
# ------------------------------------------------------------------------------

variable "name" {
  description = "The name used to namespace all resources created by these templates, including the ElastiCache cluster itself (e.g. mycache). Must be unique in this region. Must be a lowercase string."
  type        = string
}

# For a list of instance types, see https://aws.amazon.com/elasticache/details/#Available_Cache_Node_Types
# Note, snapshotting functionality is not compatible with t2 instance types.
variable "instance_type" {
  description = "The compute and memory capacity of the nodes (e.g. cache.m3.medium)."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet ids where the ElastiCache instances should be deployed. For the standard Gruntwork VPC setup, these should be the private peristence subnet ids."
  type        = list(string)
}

variable "vpc_id" {
  description = "The id of the VPC in which the ElastiCache cluster should be deployed."
  type        = string
}

variable "allow_connections_from_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges that can connect to this ElastiCache cluster. For the standard Gruntwork VPC setup, these should be the CIDR blocks of the private app subnet in this VPC plus the private subnet in the mgmt VPC."
  type        = list(string)
}

variable "allow_connections_from_security_groups" {
  description = "Specifies a list of Security Groups to allow connections from."
  type        = list(string)
  default     = []
}

variable "num_cache_nodes" {
  description = "The initial number of cache nodes that the cache cluster will have. Must be between 1 and 20."
  type        = number
}

# ------------------------------------------------------------------------------
# DEFINE CONSTANTS
# Generally, these values won't need to be changed.
# ------------------------------------------------------------------------------

# For a list of versions, see: https://docs.aws.amazon.com/AmazonElastiCache/latest/mem-ug/supported-engine-versions.html
variable "memcached_version" {
  description = "Version number of memcached to use (e.g. 1.5.16)."
  type        = string
  default     = "1.5.16"
}

variable "az_mode" {
  description = "Specifies whether the nodes in this Memcached node group are created in a single Availability Zone or created across multiple Availability Zones in the cluster's region. Valid values for this parameter are single-az or cross-az. If you want to choose cross-az, num_cache_nodes must be greater than 1."
  type        = string
  default     = "single-az"
}

# By default, do maintenance from 3-4am EST on Saturday, which is 7-8am UTC.
variable "maintenance_window" {
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed (e.g. sun:05:00-sun:09:00). The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period."
  type        = string
  default     = "sat:07:00-sat:08:00"
}

variable "port" {
  description = "The port number on which each of the cache nodes will accept connections (e.g. 6379)."
  type        = number
  default     = 11211
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window."
  type        = bool
  default     = false
}

variable "parameter_group_name" {
  description = "Name of the parameter group to associate with this cache cluster. This can be used to configure custom settings for the cluster."
  type        = string
  default     = null
}

