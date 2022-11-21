output "vpc_id" {
  value = module.base_network.vpc_id
}

output "vpc_cidr" {
  value = module.base_network.vpc_cidr
}

output "private_subnet_ids" {
  value = module.base_network.private_subnet_ids
}

output "cluster_id" {
  value = module.msk_cluster.cluster_id
}

output "cluster_name" {
  value = module.msk_cluster.cluster_name
}

output "cluster_arn" {
  value = module.msk_cluster.cluster_arn
}

output "cluster_bootstrap_brokers_tls" {
  value = module.msk_cluster.cluster_bootstrap_brokers_tls
}

output "cluster_zookeeper_connect_string" {
  value = module.msk_cluster.cluster_zookeeper_connect_string
}

output "security_group_id" {
  value = module.msk_cluster.security_group_id
}
