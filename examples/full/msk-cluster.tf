module "msk_cluster" {
  source = "../../"

  component = var.component
  deployment_identifier = var.deployment_identifier

  cluster_name = "test-cluster"

  vpc_id = module.base_network.vpc_id
  client_subnets = module.base_network.private_subnet_ids

  allowed_cidrs = ["10.0.0.0/8"]
  egress_cidrs = [var.vpc_cidr]

  tags = {
    Important : "tag"
  }
}
