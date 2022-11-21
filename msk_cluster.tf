resource "aws_msk_cluster" "cluster" {
  cluster_name           = "${var.component}-${var.deployment_identifier}-${var.cluster_name}"
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes

  broker_node_group_info {
    instance_type   = var.instance_type
    client_subnets  = var.client_subnets
    security_groups = [aws_security_group.cluster.id]

    storage_info {
      ebs_storage_info {
        volume_size = var.ebs_volume_size
      }
    }
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.cluster_key.arn
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }

  configuration_info {
    arn      = aws_msk_configuration.msk_config.arn
    revision = aws_msk_configuration.msk_config.latest_revision
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = var.enable_cloudwatch_logging
        log_group = var.enable_cloudwatch_logging ? var.cloudwatch_logging_log_group_name : null
      }
      firehose {
        enabled         = var.enable_firehose_logging
        delivery_stream = var.enable_firehose_logging ? var.firehose_logging_stream_name : null
      }
      s3 {
        enabled = var.enable_s3_logging
        bucket  = var.enable_s3_logging ? var.s3_logging_bucket_name : null
        prefix  = var.enable_s3_logging ? var.s3_logging_object_prefix : null
      }
    }
  }

  tags = local.resolved_tags
}
