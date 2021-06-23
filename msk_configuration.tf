resource "aws_msk_configuration" "msk_config" {
  kafka_versions = [var.kafka_version]
  name           = "${var.component}-${var.deployment_identifier}-${var.configuration_name}"

  server_properties = var.server_properties
}