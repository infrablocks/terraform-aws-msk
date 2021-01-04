output "cluster_id" {
  value = aws_msk_cluster.cluster.id
}

output "cluster_name" {
  value = aws_msk_cluster.cluster.cluster_name
}

output "cluster_arn" {
  value = aws_msk_cluster.cluster.arn
}

output "security_group_id" {
  value = aws_security_group.cluster.id

}