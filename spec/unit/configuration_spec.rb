# frozen_string_literal: true

require 'spec_helper'

describe 'configuration' do
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates an MSK configuration' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_configuration')
              .once)
    end

    it 'targets kafka version 2.7.0' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_configuration')
              .with_attribute_value(
                :kafka_versions, ['2.7.0']
              ))
    end

    it 'uses the default server properties' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_configuration')
              .with_attribute_value(
                :server_properties,
                "auto.create.topics.enable=false\n" \
                "default.replication.factor=3\n" \
                "min.insync.replicas=2\n" \
                "num.io.threads=8\n" \
                "num.network.threads=5\n" \
                "num.partitions=1\n" \
                "num.replica.fetchers=2\n" \
                "replica.lag.time.max.ms=30000\n" \
                "socket.receive.buffer.bytes=102400\n" \
                "socket.request.max.bytes=104857600\n" \
                "socket.send.buffer.bytes=102400\n" \
                "unclean.leader.election.enable=true\n" \
                "zookeeper.session.timeout.ms=18000\n"
              ))
    end
  end

  describe 'when configuration_name provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.configuration_name = 'msk-config-2022-11-20'
      end
    end

    it 'includes the component in the configuration name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_configuration')
              .with_attribute_value(
                :name, including(component)
              ))
    end

    it 'includes the deployment identifier in the configuration name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_configuration')
              .with_attribute_value(
                :name, including(deployment_identifier)
              ))
    end

    it 'includes the provided value in the configuration name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_configuration')
              .with_attribute_value(
                :name, including('msk-config-2022-11-20')
              ))
    end
  end

  describe 'when kafka_version provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.kafka_version = '3.2.0'
      end
    end

    it 'targets the provided kafka version' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_configuration')
              .with_attribute_value(
                :kafka_versions, ['3.2.0']
              ))
    end
  end

  describe 'when server_properties provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.server_properties =
          "default.replication.factor=3\n" \
          "min.insync.replicas=2\n" \
      end
    end

    it 'uses the provided server properties' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_msk_configuration')
              .with_attribute_value(
                :server_properties,
                "default.replication.factor=3\n" \
                "min.insync.replicas=2\n" \
              ))
    end
  end
end
