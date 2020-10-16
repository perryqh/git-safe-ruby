require 'spec_helper'

RSpec.describe GitSafe do
  describe '#init' do
    let(:options) { { bare: true } }
    subject(:git) { described_class.init(options) }
    it 'initializes git with options' do
      expect(git.options).to eq(GitSafe::Configuration.new.merge(options))
    end
  end

  describe '#working_dir' do
    let(:options) { { bare: true } }
    it 'initializes git with options' do
      expect(described_class.working_dir(options).options).to eq(GitSafe::Configuration.new.merge(options))
    end
  end
end