require 'spec_helper'

describe 'MSK Cluster' do
  include_context :terraform

  subject { msk("#{vars.component}-#{vars.deployment_identifier}-#{vars.cluster_name}") }

  it { should exist }

  it 'has the correct kafka version' do
    expect(subject.current_broker_software_info.kafka_version)
      .to(eq(vars.kafka_version))
  end
end
