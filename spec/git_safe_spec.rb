require 'spec_helper'

RSpec.describe GitSafe do
  let(:work_tree) { File.join('spec', 'support', 'working-dirs', 'work') }
  let(:remote_uri) { 'https://github.com/perryqh/git-safe-ruby.git' }
  let(:options) { { branch: 'staging' } }
  subject(:git) { described_class.init(work_tree, options) }

  after(:each) do
    FileUtils.rm_rf(work_tree)
  end

  describe '#init' do
    it 'initializes git with options' do
      expect(git.options).to eq(GitSafe::Configuration.new.merge(options))
    end

    its(:work_tree) { is_expected.to eq(work_tree) }
  end

  describe '#clone' do
    subject(:clone) { git.clone(remote_uri) }

    it 'clones the provided remote-uri' do
      expect { clone }.to change { Dir[work_tree].count }
    end
  end
end