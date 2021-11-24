variable component {}
variable deployment_identifier {}

variable vpc_id {}

variable include_default_egress_rule {
  default = "yes"
}
variable egress_cidrs {
  type = list(string)
}

variable include_default_ingress_rule {
  default = "yes"
}
variable allowed_cidrs {
  type = list(string)
}

variable cluster_name {}
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

variable configuration_name {
  default = ""
}

variable server_properties {
  default = <<PROPERTIES
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
}