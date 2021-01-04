data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "msk_cluster" {
  source = "../../../../"

  component = var.component
  deployment_identifier = var.deployment_identifier

  tags = var.tags

  cluster_name = var.cluster_name
  vpc_id = data.terraform_remote_state.prerequisites.outputs.vpc_id
  include_default_egress_rule = var.include_default_egress_rule
  egress_cidrs = var.egress_cidrs
  include_default_ingress_rule  = var.include_default_ingress_rule
  allowed_cidrs = var.allowed_cidrs
  
  number_of_broker_nodes = var.number_of_broker_nodes
  client_subnets = data.terraform_remote_state.prerequisites.outputs.private_subnet_ids

  s3_logs_prefix = var.s3_logs_prefix
  s3_logs_enabled = var.s3_logs_enabled
  s3_logs_bucket_name = var.s3_logs_bucket_name

}
