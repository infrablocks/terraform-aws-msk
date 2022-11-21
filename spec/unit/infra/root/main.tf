data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "msk_cluster" {
  source = "../../../.."

  component = var.component
  deployment_identifier = var.deployment_identifier

  tags = var.tags

  cluster_name = var.cluster_name

  kafka_version = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes
  instance_type = var.instance_type
  ebs_volume_size = var.ebs_volume_size

  server_properties = var.server_properties

  configuration_name = var.configuration_name

  vpc_id = data.terraform_remote_state.prerequisites.outputs.vpc_id
  client_subnets = data.terraform_remote_state.prerequisites.outputs.private_subnet_ids

  include_default_egress_rule = var.include_default_egress_rule
  include_default_ingress_rule  = var.include_default_ingress_rule

  egress_cidrs = var.egress_cidrs
  allowed_cidrs = var.allowed_cidrs

  enable_cloudwatch_logging = var.enable_cloudwatch_logging
  cloudwatch_logging_log_group_name = var.cloudwatch_logging_log_group_name

  enable_s3_logging = var.enable_s3_logging
  s3_logging_bucket_name = var.s3_logging_bucket_name
  s3_logging_object_prefix = var.s3_logging_object_prefix

  enable_firehose_logging = var.enable_firehose_logging
  firehose_logging_stream_name = var.firehose_logging_stream_name
}
