# frozen_string_literal: true

require 'spec_helper'

describe 'key' do
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

    it 'creates a KMS key' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_kms_key')
              .once)
    end

    it 'includes the component in the key description' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_kms_key')
              .with_attribute_value(
                :description,
                including(component)
              ))
    end

    it 'includes the deployment identifier in the key description' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_kms_key')
              .with_attribute_value(
                :description,
                including(deployment_identifier)
              ))
    end
  end
end
