
resource "aws_msk_cluster" "cluster" {
  cluster_name           = "${var.component}-${var.deployment_identifier}-${var.cluster_name}"
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes
  broker_node_group_info {
    instance_type   = var.instance_type
    ebs_volume_size = var.ebs_volume_size
    client_subnets  = var.client_subnets
    security_groups = [aws_security_group.cluster.id]
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
    arn      = "${aws_msk_configuration.msk-config.arn}"
    revision = "${aws_msk_configuration.msk_config.latest_revision}"
  }



  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = var.cloud_watch_logs_enabled
        log_group = var.log_group_name
      }
      firehose {
        enabled         = var.firehose_enabled
        delivery_stream = var.firehose_stream_name
      }
      s3 {
        enabled = var.s3_logs_enabled
        bucket  = var.s3_logs_bucket_name
        prefix  = var.s3_logs_prefix
      }
    }
  }

  tags = var.tags
}
