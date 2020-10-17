require 'spec_helper'

RSpec.describe GitSafe do
  let(:working_dir) { File.join('spec', 'support', 'working-dirs', 'work') }
  after(:each) do
    FileUtils.rm_rf(working_dir)
  end

  describe '#init' do
    let(:options) { { branch: 'staging' } }
    subject(:git) { described_class.init(working_dir, options) }

    it 'initializes git with options' do
      expect(git.options).to eq(GitSafe::Configuration.new.merge(options))
    end

    its(:working_dir) {is_expected.to eq(working_dir)}
  end
end