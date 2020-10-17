require 'spec_helper'

RSpec.describe GitSafe::Git do
  let(:work_tree) { File.join('spec', 'support', 'working-dirs', 'work') }
  let(:options) do
    {}
  end
  subject(:git) { described_class.new(work_tree, options) }

  its(:work_tree) { is_expected.to eq(work_tree) }
  its(:options) { is_expected.to eq(options) }
end