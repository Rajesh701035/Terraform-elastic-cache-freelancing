## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | < 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_memcached"></a> [memcached](#module\_memcached) | ../../module/memcached | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_connections_from_cidr_blocks"></a> [allow\_connections\_from\_cidr\_blocks](#input\_allow\_connections\_from\_cidr\_blocks) | A list of CIDR-formatted IP address ranges that can connect to this ElastiCache cluster. For the standard Gruntwork VPC setup, these should be the CIDR blocks of the private app subnet in this VPC plus the private subnet in the mgmt VPC. | `list(string)` | n/a | yes |
| <a name="input_aws_account_ids"></a> [aws\_account\_ids](#input\_aws\_account\_ids) | A list of AWS Account IDs. Only these IDs may be operated on by this template. The first account ID in the list will be used to identify where the VPC Peering Connection should be created. This should be the account ID in which all resources are to be created. | `list(string)` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which all resources will be created | `string` | n/a | yes |
| <a name="input_az_mode"></a> [az\_mode](#input\_az\_mode) | Specifies whether the nodes in this Memcached node group are created in a single Availability Zone or created across multiple Availability Zones in the cluster's region. Valid values for this parameter are single-az or cross-az. If you want to choose cross-az, num\_cache\_nodes must be greater than 1. | `string` | `"single-az"` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | Specifies which engine should be used | `string` | `"memcached"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Version number of memcached to use (e.g. 1.5.16). | `string` | `"1.5.16"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The type of instance to be used for memcache. | `string` | `"cache.t3.micro"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name used to namespace all resources created by these templates. | `string` | `"memcached-example"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | The type of instance to be used for memcache. | `number` | `2` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Name of the parameter group to associate with this cache cluster. This can be used to configure custom settings for the cluster. | `string` | `null` | no |
| <a name="input_port"></a> [port](#input\_port) | The port number through which it communicates. | `number` | `11711` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | Specifies which protocol should be used | `string` | `"tcp"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnet ids where the database instances should be deployed. These subnets must be in the availability zones in var.availability\_zones. In the standard Gruntwork VPC setup, these should be the private persistence subnet ids. | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The id of the VPC in which this EC2 instance should be deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cache_addresses"></a> [cache\_addresses](#output\_cache\_addresses) | n/a |
| <a name="output_cache_cluster_id"></a> [cache\_cluster\_id](#output\_cache\_cluster\_id) | n/a |
| <a name="output_cache_node_ids"></a> [cache\_node\_ids](#output\_cache\_node\_ids) | n/a |
| <a name="output_cache_port"></a> [cache\_port](#output\_cache\_port) | n/a |
| <a name="output_configuration_endpoint"></a> [configuration\_endpoint](#output\_configuration\_endpoint) | n/a |
