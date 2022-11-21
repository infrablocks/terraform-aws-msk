# frozen_string_literal: true

require 'spec_helper'
require 'base64'
require 'digest'

describe 'cluster' do
  let(:region) do
    var(role: :root, name: 'region')
  end
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end
  let(:cluster_name) do
    var(role: :root, name: 'cluster_name')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates an MSK cluster' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .once)
    end

    it 'constructs a cluster name using the provided component, deployment ' \
       'identifier and cluster name' do
      name = "#{component}-#{deployment_identifier}-#{cluster_name}"
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                :cluster_name, name
              ))
    end

    it 'uses a kafka version of "2.7.0"' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                :kafka_version, '2.7.0'
              ))
    end

    it 'uses a number of broker nodes of 3' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                :number_of_broker_nodes, 3
              ))
    end

    it 'uses a broker node instance type of "kafka.m5.large"' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:broker_node_group_info, 0, :instance_type],
                'kafka.m5.large'
              ))
    end

    it 'uses an EBS volume size of 1TB' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:broker_node_group_info, 0,
                 :storage_info, 0,
                 :ebs_storage_info, 0,
                 :volume_size],
                1000
              ))
    end

    it 'uses the provided client subnets' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:broker_node_group_info, 0, :client_subnets],
                contain_exactly(
                  *output(role: :prerequisites, name: 'private_subnet_ids')
                )
              ))
    end

    it 'enables client encryption in transit' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:encryption_info, 0,
                 :encryption_in_transit, 0,
                 :client_broker],
                'TLS'
              ))
    end

    it 'enables in cluster encryption in transit' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:encryption_info, 0,
                 :encryption_in_transit, 0,
                 :in_cluster],
                true
              ))
    end

    it 'enables the prometheus JMX exporter' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:open_monitoring, 0,
                 :prometheus, 0,
                 :jmx_exporter, 0,
                 :enabled_in_broker],
                true
              ))
    end

    it 'enables the prometheus node exporter' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:open_monitoring, 0,
                 :prometheus, 0,
                 :node_exporter, 0,
                 :enabled_in_broker],
                true
              ))
    end

    it 'does not enable cloudwatch logging' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :cloudwatch_logs, 0,
                 :enabled],
                false
              ))
    end

    it 'sets the cloudwatch log group name to null' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :cloudwatch_logs, 0,
                 :log_group],
                a_nil_value
              ))
    end

    it 'does not enable firehose logging' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :firehose, 0,
                 :enabled],
                false
              ))
    end

    it 'sets the firehose delivery stream to null' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :firehose, 0,
                 :delivery_stream],
                a_nil_value
              ))
    end

    it 'does not enable S3 bucket logging' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :s3, 0,
                 :enabled],
                false
              ))
    end

    it 'sets the S3 bucket name to null' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :s3, 0,
                 :bucket],
                a_nil_value
              ))
    end

    it 'sets the S3 object prefix to null' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :s3, 0,
                 :prefix],
                a_nil_value
              ))
    end

    it 'includes component and deployment identifier tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Component: component,
                  DeploymentIdentifier: deployment_identifier
                )
              ))
    end

    it 'outputs the cluster ID' do
      expect(@plan)
        .to(include_output_creation(name: 'cluster_id'))
    end

    it 'outputs the cluster name' do
      expect(@plan)
        .to(include_output_creation(name: 'cluster_name'))
    end

    it 'outputs the cluster ARN' do
      expect(@plan)
        .to(include_output_creation(name: 'cluster_arn'))
    end

    it 'outputs the cluster bootstrap brokers TLS connection string' do
      expect(@plan)
        .to(include_output_creation(name: 'cluster_bootstrap_brokers_tls'))
    end

    it 'outputs the cluster zookeeper connection string' do
      expect(@plan)
        .to(include_output_creation(name: 'cluster_zookeeper_connect_string'))
    end
  end

  describe 'when kafka_version provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.kafka_version = '3.2.0'
      end
    end

    it 'uses the provided kafka version' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(:kafka_version, '3.2.0'))
    end
  end

  describe 'when number_of_broker_nodes provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.number_of_broker_nodes = 3
      end
    end

    it 'uses the provided number of broker nodes' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(:number_of_broker_nodes, 3))
    end
  end

  describe 'when instance_type provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.instance_type = 'kafka.t3.small'
      end
    end

    it 'uses the provided instance type' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:broker_node_group_info, 0, :instance_type],
                'kafka.t3.small'
              ))
    end
  end

  describe 'when ebs_volume_size provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.ebs_volume_size = 2000
      end
    end

    it 'uses the provided EBS volume size' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:broker_node_group_info, 0,
                 :storage_info, 0,
                 :ebs_storage_info, 0,
                 :volume_size],
                2000
              ))
    end
  end

  describe 'when enable_cloudwatch_logging is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.enable_cloudwatch_logging = true
        vars.cloudwatch_logging_log_group_name = 'msk-cluster/logs'
      end
    end

    it 'enables cloudwatch logging' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :cloudwatch_logs, 0,
                 :enabled],
                true
              ))
    end

    it 'uses the provided cloudwatch log group name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :cloudwatch_logs, 0,
                 :log_group],
                'msk-cluster/logs'
              ))
    end
  end

  describe 'when enable_cloudwatch_logging is false' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.enable_cloudwatch_logging = false
      end
    end

    it 'does not enable cloudwatch logging' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :cloudwatch_logs, 0,
                 :enabled],
                false
              ))
    end

    it 'sets the cloudwatch log group name to null' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :cloudwatch_logs, 0,
                 :log_group],
                a_nil_value
              ))
    end
  end

  describe 'when enable_firehose_logging is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.enable_firehose_logging = true
        vars.firehose_logging_stream_name = 'msk-cluster-logs'
      end
    end

    it 'enables firehouse logging' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :firehose, 0,
                 :enabled],
                true
              ))
    end

    it 'uses the provided firehose stream name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :firehose, 0,
                 :delivery_stream],
                'msk-cluster-logs'
              ))
    end
  end

  describe 'when enable_firehose_logging is false' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.enable_firehose_logging = false
      end
    end

    it 'does not enable firehose logging' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :firehose, 0,
                 :enabled],
                false
              ))
    end

    it 'sets the firehose delivery stream to null' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :firehose, 0,
                 :delivery_stream],
                a_nil_value
              ))
    end
  end

  describe 'when enable_s3_logging is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.enable_s3_logging = true
        vars.s3_logging_bucket_name = 'msk-cluster-logs'
        vars.s3_logging_object_prefix = 'logs/'
      end
    end

    it 'enables S3 logging' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :s3, 0,
                 :enabled],
                true
              ))
    end

    it 'uses the provided S3 bucket name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :s3, 0,
                 :bucket],
                'msk-cluster-logs'
              ))
    end

    it 'uses the provided S3 object prefix' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :s3, 0,
                 :prefix],
                'logs/'
              ))
    end
  end

  describe 'when enable_s3_logging is false' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.enable_s3_logging = false
      end
    end

    it 'does not enable S3 logging' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :s3, 0,
                 :enabled],
                false
              ))
    end

    it 'sets the S3 bucket name to null' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :s3, 0,
                 :bucket],
                a_nil_value
              ))
    end

    it 'sets the S3 object prefix to null' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                [:logging_info, 0,
                 :broker_logs, 0,
                 :s3, 0,
                 :prefix],
                a_nil_value
              ))
    end
  end

  describe 'when tags is provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.tags = {
          Tag1: 'value1',
          Tag2: 'value2'
        }
      end
    end

    it 'includes component and deployment identifier tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Component: component,
                  DeploymentIdentifier: deployment_identifier
                )
              ))
    end

    it 'includes the provided tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_cluster')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Tag1: 'value1',
                  Tag2: 'value2'
                )
              ))
    end
  end
end
