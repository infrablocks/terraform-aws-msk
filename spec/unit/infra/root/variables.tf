variable "region" {}

variable "component" {}
variable "deployment_identifier" {}

variable "cluster_name" {}
variable "kafka_version" {
  default  = null
}
variable "number_of_broker_nodes" {
  type     = number
  default  = null
}
variable "instance_type" {
  default  = null
}
variable "ebs_volume_size" {
  type     = number
  default  = null
}

variable "configuration_name" {
  default  = null
}

variable "server_properties" {
  default  = null
}

variable "include_default_ingress_rule" {
  type     = bool
  default  = null
}
variable "allowed_cidrs" {
  type     = list(string)
  default  = null
}
variable "include_default_egress_rule" {
  type     = bool
  default  = null
}
variable "egress_cidrs" {
  type     = list(string)
  default  = null
}

variable "enable_s3_logging" {
  type     = bool
  default  = null
}
variable "s3_logging_bucket_name" {
  default  = null
}
variable "s3_logging_object_prefix" {
  default  = null
}

variable "enable_cloudwatch_logging" {
  type     = bool
  default  = null
}
variable "cloudwatch_logging_log_group_name" {
  default  = null
}

variable "enable_firehose_logging" {
  type     = bool
  default  = null
}
variable "firehose_logging_stream_name" {
  default  = null
}

variable "tags" {
  type        = map(string)
  default     = null
}
