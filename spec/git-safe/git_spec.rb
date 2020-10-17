require 'spec_helper'

RSpec.describe GitSafe::Git do
  let(:working_dir) { File.join('spec', 'support', 'working-dirs', 'work') }
  let(:options) do
    {}
  end
  subject(:git) { described_class.new(working_dir, options) }

  its(:working_dir) { is_expected.to eq(working_dir) }
  its(:options) { is_expected.to eq(options) }
end