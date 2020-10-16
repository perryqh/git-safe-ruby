require 'spec_helper'

RSpec.describe GitSafe do
  describe '#init' do
    let(:options) { { bare: true } }
    it 'initializes git with options' do
      expect(described_class.init(options).options).to eq(options)
    end
  end
end