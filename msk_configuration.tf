//resource "aws_msk_configuration" "msk_config" {
//  kafka_versions = [
//    var.kafka_version]
//  name = "${var.component}-${var.deployment_identifier}-msk-config"
//
//  server_properties = <<PROPERTIES
//auto.create.topics.enable = true
//delete.topic.enable = true
//allow.everyone.if.no.acl.found = true
//auto.create.topics.enable = false
//auto.leader.rebalance.enable = true
//default.replication.factor = 3
//min.insync.replicas = 2
//num.io.threads = 8
//num.network.threads = 5
//num.partitions = 1
//num.replica.fetchers = 2
//replica.lag.time.max.ms = 30000
//socket.receive.buffer.bytes = 102400
//socket.request.max.bytes = 104857600
//socket.send.buffer.bytes = 102400
//unclean.leader.election.enable = true
//zookeeper.session.timeout.ms = 18000
//zookeeper.set.acl = false
//PROPERTIES
//}
//
//
//
//
