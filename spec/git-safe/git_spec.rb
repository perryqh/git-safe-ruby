require 'spec_helper'

RSpec.describe GitSafe::Git do
  after(:each) do
    FileUtils.rm_rf(work_tree)
  end

  let(:work_tree) { File.join('spec', 'support', 'working-dirs', 'work') }
  let(:remote_uri) { 'https://github.com/perryqh/git-safe-ruby.git' }
  let(:options) { { logger: ::Logger.new(STDOUT) } }
  subject(:git) { described_class.new(work_tree, options) }

  its(:work_tree) { is_expected.to eq(work_tree) }
  its(:options) { is_expected.to eq(options) }

  describe '#clone' do
    subject(:clone) { git.clone(remote_uri, depth: depth) }
    let(:depth) { 1 }
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

    context 'when depth provided' do
      let(:depth) { nil }
      it 'does not include depth' do
        expect(clone).to eq(std)
        expect(Open3).to have_received(:capture3).with("git clone #{remote_uri} #{work_tree}")
      end
    end

    context 'when ssh file provided' do
      let(:ssh_private_key) { File.join(__dir__, '..', 'support', 'not-really-key') }
      let(:options) { { logger: ::Logger.new(STDOUT), ssh_private_key: ssh_private_key } }
      before do
        allow(git).to receive(:safe_unlink_private_key_tmp_file)
      end

      it 'sets ssh private key' do
        expect(git.ssh_private_key).to eq(ssh_private_key)
      end

      it 'sets the GIT_SSH_COMMAND' do
        expect(clone).to eq(std)
        expect(Open3).to have_received(:capture3).with("GIT_SSH_COMMAND=\"ssh -i #{ssh_private_key} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no\" git clone #{remote_uri} --depth=1 #{work_tree}")
      end

      it 'safe_unlink_private_key_tmp_file' do
        clone
        expect(git).to have_received(:safe_unlink_private_key_tmp_file)
      end
    end

    context 'when ssh string provided' do
      let(:ssh_private_key) { 'mysshkeystring' }
      let(:options) { { logger: ::Logger.new(STDOUT), ssh_private_key: ssh_private_key } }
      let(:tmp_path) { '/a/path/to/ssh/file' }
      let(:private_key_temp_file) { instance_double(Tempfile, path: tmp_path) }
      let(:ssh_tempfile) { instance_double(GitSafe::SshTempfile, private_key_temp_file: double(:tmp, path: tmp_path)) }
      before do
        allow(GitSafe::SshTempfile).to receive(:new).and_return(ssh_tempfile)
        allow(ssh_tempfile).to receive(:safe_unlink_private_key_tmp_file)
      end

      it 'sets the GIT_SSH_COMMAND' do
        expect(clone).to eq(std)
        expect(Open3).to have_received(:capture3).with("GIT_SSH_COMMAND=\"ssh -i #{tmp_path} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no\" git clone #{remote_uri} --depth=1 #{work_tree}")
      end

      it 'unlinks the tmp file' do
        clone
        expect(ssh_tempfile).to have_received(:safe_unlink_private_key_tmp_file)
      end
    end

    context 'when ssh cmd provided (gcsr). This makes more sense for clone_or_pull' do
      let(:options) do
        { clone_command:                       'gcloud source repos clone my-repo <REPO_DIR> --project=pow-play',
          clone_command_repo_dir_replace_text: '<REPO_DIR>',
          logger:                              ::Logger.new(STDOUT) }
      end

      it 'clones the provided remote-uri' do
        expect(clone).to eq(std)
        expect(Open3).to have_received(:capture3).with("gcloud source repos clone my-repo #{work_tree} --project=pow-play")
      end
    end

    context 'when error' do
      let(:exit_status) { -1 }

      it 'raises a CommandError' do
        expect { clone }.to raise_error(GitSafe::CommandError)
      end
    end
  end

  describe '#pull' do
    subject(:pull) { git.pull }

    let(:std) { "pulling'" }
    let(:exit_status) { 0 }
    let(:status) { double(:status, exitstatus: exit_status) }
    before do
      allow(Open3).to receive(:capture3).and_return(["", std, status])
    end

    context 'when branch is not provided' do
      it 'pulls from master' do
        pull
        expect(Open3).to have_received(:capture3).with("git --work-tree=#{work_tree} --git-dir=#{work_tree}/.git pull origin master")
      end
    end

    context 'when branch is provided' do
      subject(:pull) { git.pull(branch: 'staging') }

      it 'pulls from staging' do
        pull
        expect(Open3).to have_received(:capture3).with("git --work-tree=#{work_tree} --git-dir=#{work_tree}/.git pull origin staging")
      end
    end

    context 'when ssh file provided' do
      let(:ssh_private_key) { File.join(__dir__, '..', 'support', 'not-really-key') }
      let(:options) { { logger: ::Logger.new(STDOUT), ssh_private_key: ssh_private_key } }

      before do
        allow(git).to receive(:safe_unlink_private_key_tmp_file)
      end

      it 'pulls use private key' do
        pull
        expect(Open3).to have_received(:capture3).with("GIT_SSH_COMMAND=\"ssh -i #{ssh_private_key} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no\" git --work-tree=#{work_tree} --git-dir=#{work_tree}/.git pull origin master")
      end

      it 'safe_unlink_private_key_tmp_file' do
        pull
        expect(git).to have_received(:safe_unlink_private_key_tmp_file)
      end
    end
  end

  describe '#init' do
    subject(:init) { git.init }
    it 'has a .git directory' do
      init
      expect(Dir.exists?(File.join('.git'))).to be_truthy
    end
  end

  describe '#status' do
    subject(:status) { git.status }
    before { git.init }
    it { is_expected.to match(/On branch master/) }
  end

  describe '#checkout' do
    subject(:checkout) { git.checkout(branch: 'master') }
    before do
      git.init
      git.checkout(branch: 'staging', create: true)
      git.checkout(branch: 'master', create: true)
    end

    context 'when branch provided' do
      it 'checks out the branch' do
        git.checkout(branch: 'staging')
        expect(git.status).to eq('')
      end
      context 'when create flag provided'
    end

    context 'when sha provided'
  end

  describe '#clone_or_pull' do
    context 'with local and remote branches provided'

    context 'with local branch provided'

    context 'with remote branch provided'

    context 'with no branches provided'
  end
end