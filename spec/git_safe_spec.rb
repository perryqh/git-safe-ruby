require 'spec_helper'

RSpec.describe GitSafe do
  subject(:git) { described_class.init(work_tree, options) }

  let(:work_tree) { File.join('spec', 'support', 'working-dirs', 'work') }
  let(:options) { { branch: 'staging' } }

  describe '#init' do
    it 'initializes git with options' do
      expect(git.options).to eq(GitSafe::Configuration.new.merge(options))
    end

    its(:work_tree) { is_expected.to eq(work_tree) }
  end
end