variable component {}
variable deployment_identifier {}
variable vpc_id {}

variable region {
  default = "eu-west-2"
}

variable include_default_egress_rule {}
variable egress_cidrs {
  type = list(string)
}

variable include_default_ingress_rule {}
variable allowed_cidrs {
  type = list(string)
}

variable cluster_name {}
variable kafka_version {
  default = "2.7.0"
}
variable number_of_broker_nodes {
  default = 3
  type    = number
}
variable instance_type {
  default = "kafka.m5.large"
}
variable ebs_volume_size {
  default = 1000
  type    = number
}
variable client_subnets {
  type = list(string)
}
variable cloud_watch_logs_enabled {
  default = false
}
variable log_group_name {}
variable firehose_enabled {
  default = false
}
variable firehose_stream_name {}
variable s3_logs_enabled {
  default = false
}
variable s3_logs_prefix {}
variable s3_logs_bucket_name {}
variable tags {
  type        = map(string)
  description = "Additional resource tags"
  default     = {}
}