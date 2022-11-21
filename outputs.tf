output "cluster_id" {
  value = aws_msk_cluster.cluster.id
}

output "cluster_name" {
  value = aws_msk_cluster.cluster.cluster_name
}

output "cluster_arn" {
  value = aws_msk_cluster.cluster.arn
}

output "cluster_bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs"
  value       = aws_msk_cluster.cluster.bootstrap_brokers_tls
}

output "cluster_zookeeper_connect_string" {
  value = aws_msk_cluster.cluster.zookeeper_connect_string
}

output "security_group_id" {
  value = aws_security_group.cluster.id

}
