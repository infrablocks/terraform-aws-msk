# frozen_string_literal: true

require 'spec_helper'

describe 'security group' do
  let(:component) do
    var(role: :root, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :root, name: 'deployment_identifier')
  end
  let(:cluster_name) do
    var(role: :root, name: 'cluster_name')
  end
  let(:vpc_id) do
    output(role: :prerequisites, name: 'vpc_id')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates a security group' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .once)
    end

    it 'includes the component in the security group name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(:name, including(component)))
    end

    it 'includes the deployment identifier in the security group name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(:name, including(deployment_identifier)))
    end

    it 'includes the cluster name in the security group name' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(:name, including(cluster_name)))
    end

    it 'includes the component in the security group description' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(:description, including(component)))
    end

    it 'includes the deployment identifier in the security group description' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                :description, including(deployment_identifier)
              ))
    end

    it 'includes the cluster name in the security group description' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(:description, including(cluster_name)))
    end

    it 'includes component and deployment identifier tags' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Component: component,
                  DeploymentIdentifier: deployment_identifier
                )
              ))
    end

    it 'includes a name tag' do
      name = "#{component}-#{deployment_identifier}-#{cluster_name}"
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  Name: name
                )
              ))
    end

    it 'includes a cluster name tag' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(
                :tags,
                a_hash_including(
                  ClusterName: cluster_name
                )
              ))
    end

    it 'uses the provided VPC ID' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group')
              .with_attribute_value(:vpc_id, vpc_id))
    end

    it 'creates a default ingress rule' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'ingress')
              .with_attribute_value(:protocol, '-1')
              .with_attribute_value(:from_port, 0)
              .with_attribute_value(:to_port, 0))
    end

    it 'creates a default egress rule' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'egress')
              .with_attribute_value(:protocol, '-1')
              .with_attribute_value(:from_port, 0)
              .with_attribute_value(:to_port, 0))
    end

    it 'outputs the security group ID' do
      expect(@plan)
        .to(include_output_creation(name: 'security_group_id'))
    end
  end

  describe 'when allowed_cidrs provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.allowed_cidrs = %w[
          10.0.0.0/16
          10.1.0.0/16
        ]
      end
    end

    it 'creates a default ingress rule using the allowed CIDRs' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'ingress')
              .with_attribute_value(:protocol, '-1')
              .with_attribute_value(:from_port, 0)
              .with_attribute_value(:to_port, 0)
              .with_attribute_value(
                :cidr_blocks,
                %w[
                  10.0.0.0/16
                  10.1.0.0/16
                ]
              ))
    end
  end

  describe 'when egress_cidrs provided' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.egress_cidrs = %w[
          10.2.0.0/16
          10.3.0.0/16
        ]
      end
    end

    it 'creates a default egress rule using the allowed CIDRs' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'egress')
              .with_attribute_value(:protocol, '-1')
              .with_attribute_value(:from_port, 0)
              .with_attribute_value(:to_port, 0)
              .with_attribute_value(
                :cidr_blocks,
                %w[
                  10.2.0.0/16
                  10.3.0.0/16
                ]
              ))
    end
  end

  describe 'when include_default_ingress_rule is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_default_ingress_rule = true
        vars.allowed_cidrs = %w[
          10.0.0.0/16
          10.1.0.0/16
        ]
      end
    end

    it 'creates a default ingress rule using the allowed CIDRs' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'ingress')
              .with_attribute_value(:protocol, '-1')
              .with_attribute_value(:from_port, 0)
              .with_attribute_value(:to_port, 0)
              .with_attribute_value(
                :cidr_blocks,
                %w[
                  10.0.0.0/16
                  10.1.0.0/16
                ]
              ))
    end
  end

  describe 'when include_default_ingress_rule is false' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_default_ingress_rule = false
      end
    end

    it 'does not create a default ingress rule' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'ingress'))
    end
  end

  describe 'when include_default_egress_rule is true' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_default_egress_rule = true
        vars.egress_cidrs = %w[
          10.2.0.0/16
          10.3.0.0/16
        ]
      end
    end

    it 'creates a default egress rule using the allowed CIDRs' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_security_group_rule')
              .with_attribute_value(:type, 'egress')
              .with_attribute_value(:protocol, '-1')
              .with_attribute_value(:from_port, 0)
              .with_attribute_value(:to_port, 0)
              .with_attribute_value(
                :cidr_blocks,
                %w[
                  10.2.0.0/16
                  10.3.0.0/16
                ]
              ))
    end
  end

  describe 'when include_default_egress_rule is false' do
    before(:context) do
      @plan = plan(role: :root) do |vars|
        vars.include_default_egress_rule = false
      end
    end

    it 'does not create a default egress rule' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_security_group_rule')
                  .with_attribute_value(:type, 'egress'))
    end
  end
end
