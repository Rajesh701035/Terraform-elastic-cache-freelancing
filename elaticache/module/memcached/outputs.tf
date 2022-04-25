locals {
  # The cache_nodes output provided by terraform for the aws_elasticache_cluster resource does not work correctly (see
  # https://github.com/hashicorp/terraform/issues/8794). Fortunately, cache nodes have a predictable naming structure
  # where for N nodes, the names will be 0001, 0002, ..., 000N. As a workaround, we output these names here.
  cache_node_ids = [
    for i in range(var.num_cache_nodes) :
    format("%04d", i + 1)
  ]

  # The cache_nodes output provided by terraform for the aws_elasticache_cluster resource does not work correctly (see
  # https://github.com/hashicorp/terraform/issues/8794). Fortunately, cache nodes all have the same URL except for the
  # node_id (see the cache_node_ids output). The URL is of the form:
  #
  # <cache-id>.<node-id>.<aws_region>.cache.amazonaws.com.
  #
  # All we need to do is get the base URL from the first node and replace the <node-id> for each of the subsequent ones.
  cache_addresses = [
    for i in range(var.num_cache_nodes) :
    replace(
      aws_elasticache_cluster.memcached.cache_nodes[0].address,
      "/^(.+?)\\.(.+?)\\.\\d{4}\\.(.+?)$/",
      "$1.$2.${format("%04d", i + 1)}.$3",
    )
  ]
}

output "cache_port" {
  value = var.port
}

output "cache_cluster_id" {
  value = var.name
}

output "cache_node_ids" {
  value = local.cache_node_ids
}

output "cache_addresses" {
  value = local.cache_addresses
}

output "configuration_endpoint" {
  value = aws_elasticache_cluster.memcached.configuration_endpoint
}

output "security_group_id" {
  value = aws_security_group.memcached.id
}
