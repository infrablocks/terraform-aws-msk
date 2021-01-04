resource "aws_kms_key" "cluster_key" {
  description = "${var.component}-${var.deployment_identifier}-kms-key"
}
