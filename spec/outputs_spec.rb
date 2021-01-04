require 'spec_helper'

describe 'Outputs' do
  include_context :terraform

  let(:cluster) { msk("#{vars.component}-#{vars.deployment_identifier}-#{vars.cluster_name}") }

  it 'outputs the cluster id' do
    expect(output_for(:harness, 'cluster_id'))
        .to(eq(cluster.cluster_arn))
  end

  it 'outputs the cluster name' do
    expect(output_for(:harness, 'cluster_name'))
        .to(eq(cluster.cluster_name))
  end
end
