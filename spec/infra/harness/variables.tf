variable component {}

variable region {}
variable deployment_identifier {}

variable include_default_egress_rule {}
variable egress_cidrs {
  type = list(string)
}

variable include_default_ingress_rule {}
variable allowed_cidrs {
  type = list(string)
}

variable cluster_name {}
variable kafka_version {}
variable number_of_broker_nodes {
  type = number
}

variable s3_logs_prefix {}
variable s3_logs_enabled {}
variable s3_logs_bucket_name {}

variable tags {
  type = map(string)
}
