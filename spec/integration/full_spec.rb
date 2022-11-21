# frozen_string_literal: true

require 'spec_helper'

describe 'full' do
  let(:component) do
    var(role: :full, name: 'component')
  end
  let(:deployment_identifier) do
    var(role: :full, name: 'deployment_identifier')
  end
  let(:cluster_name) do
    'test-cluster'
  end

  before(:context) do
    apply(role: :full)
  end

  after(:context) do
    destroy(
      role: :full,
      only_if: -> { !ENV['FORCE_DESTROY'].nil? || ENV['SEED'].nil? }
    )
  end

  describe 'cluster' do
    subject(:msk_cluster) do
      msk("#{component}-#{deployment_identifier}-#{cluster_name}")
    end

    it { is_expected.to exist }

    it 'has the correct kafka version' do
      expect(msk_cluster.current_broker_software_info.kafka_version)
        .to(eq('2.7.0'))
    end

    it 'outputs the cluster id' do
      expect(output(role: :full, name: 'cluster_id'))
        .to(eq(msk_cluster.cluster_arn))
    end

    it 'outputs the cluster name' do
      expect(output(role: :full, name: 'cluster_name'))
        .to(eq(msk_cluster.cluster_name))
    end
  end
end
