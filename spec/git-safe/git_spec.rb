require 'spec_helper'

RSpec.describe GitSafe::Git do
  after(:each) do
    FileUtils.rm_rf(work_tree)
  end

  let(:work_tree) { File.join('spec', 'support', 'working-dirs', 'work') }
  let(:remote_uri) { 'https://github.com/perryqh/git-safe-ruby.git' }
  let(:options) { {} }
  subject(:git) { described_class.new(work_tree, options) }

  its(:work_tree) { is_expected.to eq(work_tree) }
  its(:options) { is_expected.to eq(options) }

  describe '#clone' do
    subject(:clone) { git.clone(remote_uri) }
    let(:std) { "Cloning into 'spec/support/working-dirs/work'" }
    let(:exit_status) { 0 }
    let(:status) { double(:status, exitstatus: exit_status) }
    before do
      allow(Open3).to receive(:capture3).and_return(["", std, status])
    end

    it 'clones the provided remote-uri' do
      expect(clone).to eq(std)
      expect(Open3).to have_received(:capture3).with("git clone #{remote_uri} --depth=1 #{work_tree}")
    end

    context 'when error' do
      let(:exit_status) { -1 }

      it 'raises a CommandError' do
        expect { clone }.to raise_error(GitSafe::CommandError)
      end
    end
  end
end