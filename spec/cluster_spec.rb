require 'spec_helper'

describe 'MSK Cluster' do
  include_context :terraform

  subject { msk("#{vars.component}-#{vars.deployment_identifier}-#{vars.cluster_name}") }

  it { should exist }

end
