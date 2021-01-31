variable component {
  default = ""
}
variable deployment_identifier {
  default = ""
}
variable vpc_id {
  default = ""
}

variable region {
  default = "eu-west-2"
}

variable include_default_egress_rule {
  default = ""
}
variable egress_cidrs {
  type = list(string)
}

variable include_default_ingress_rule {
  default = ""
}
variable allowed_cidrs {
  type = list(string)
}

variable cluster_name {
  type = string
}
variable kafka_version {
  type    = string
  default = "2.7.0"
}
variable number_of_broker_nodes {
  default = 3
  type    = number
}
variable instance_type {
  type    = string
  default = "kafka.m5.large"
}
variable ebs_volume_size {
  default = 1000
  type    = number
}
variable client_subnets {
  type = list(string)
}
variable s3_logs_prefix {
  type    = string
  default = "logs/msk-"
}
variable cloud_watch_logs_enabled {
  default = false
}
variable log_group_name {
  default = ""
}
variable firehose_enabled {
  default = false
}
variable firehose_stream_name {
  default = ""
}
variable s3_logs_enabled {
  default = false
}
variable s3_logs_bucket_name {
  default = ""
}
variable tags {
  type        = map(string)
  description = "Additional resource tags"
  default     = {}
}