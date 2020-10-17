require 'spec_helper'

RSpec.describe GitSafe do
  let(:working_dir) { File.join('spec', 'support', 'working-dirs', 'work') }
  let(:remote_uri) { 'https://github.com/perryqh/git-safe-ruby.git' }
  let(:options) { { branch: 'staging' } }
  subject(:git) { described_class.init(working_dir, options) }

  after(:each) do
    FileUtils.rm_rf(working_dir)
  end

  describe '#init' do
    it 'initializes git with options' do
      expect(git.options).to eq(GitSafe::Configuration.new.merge(options))
    end

    its(:working_dir) { is_expected.to eq(working_dir) }
  end

  describe '#clone' do
    subject(:clone) { git.clone(remote_uri) }

    it 'clones the provided remote-uri' do
      expect { clone }.to change { Dir[working_dir].count }
    end
  end
end