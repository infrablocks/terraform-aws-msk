variable "component" {
  type = string
}
variable "deployment_identifier" {
  type = string
}

variable "vpc_id" {
  type = string
}
variable "client_subnets" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}
variable "kafka_version" {
  type     = string
  default  = "2.7.0"
  nullable = false
}
variable "number_of_broker_nodes" {
  type     = number
  default  = 3
  nullable = false
}
variable "instance_type" {
  type     = string
  default  = "kafka.m5.large"
  nullable = false
}
variable "ebs_volume_size" {
  type     = number
  default  = 1000
  nullable = false
}

variable "configuration_name" {
  type     = string
  default  = ""
  nullable = false
}

variable "server_properties" {
  type     = string
  default  = <<-PROPERTIES
    auto.create.topics.enable=false
    default.replication.factor=3
    min.insync.replicas=2
    num.io.threads=8
    num.network.threads=5
    num.partitions=1
    num.replica.fetchers=2
    replica.lag.time.max.ms=30000
    socket.receive.buffer.bytes=102400
    socket.request.max.bytes=104857600
    socket.send.buffer.bytes=102400
    unclean.leader.election.enable=true
    zookeeper.session.timeout.ms=18000
  PROPERTIES
  nullable = false
}

variable "include_default_ingress_rule" {
  type     = bool
  default  = true
  nullable = false
}
variable "allowed_cidrs" {
  type     = list(string)
  default  = []
  nullable = false
}
variable "include_default_egress_rule" {
  type     = bool
  default  = true
  nullable = false
}
variable "egress_cidrs" {
  type     = list(string)
  default  = []
  nullable = false
}

variable "enable_s3_logging" {
  type     = bool
  default  = false
  nullable = false
}
variable "s3_logging_bucket_name" {
  type     = string
  default  = ""
  nullable = false
}
variable "s3_logging_object_prefix" {
  type     = string
  default  = "logs/msk-"
  nullable = false
}

variable "enable_cloudwatch_logging" {
  type     = bool
  default  = false
  nullable = false
}
variable "cloudwatch_logging_log_group_name" {
  type     = string
  default  = ""
  nullable = false
}

variable "enable_firehose_logging" {
  type     = bool
  default  = false
  nullable = false
}
variable "firehose_logging_stream_name" {
  type     = string
  default  = ""
  nullable = false
}

variable "tags" {
  type        = map(string)
  description = "Additional resource tags"
  default     = {}
  nullable    = false
}
