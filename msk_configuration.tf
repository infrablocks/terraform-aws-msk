locals {
  configuration_name = coalesce(var.configuration_name, "msk-config-${random_id.server.dec}")
}

resource "random_id" "server" {
  keepers = {
    server_properties = var.server_properties
    kafka_version = var.kafka_version
  }

  byte_length = 8
}

resource "aws_msk_configuration" "msk_config" {
  kafka_versions = [random_id.server.keepers.kafka_version]
  name           = "${var.component}-${var.deployment_identifier}-${local.configuration_name}"

  server_properties = random_id.server.keepers.server_properties

  lifecycle {
    create_before_destroy = true
  }
}