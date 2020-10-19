require 'spec_helper'

RSpec.describe GitSafe::SshTempfile do
  let(:private_key) { 'a private key' }
  let(:tmp_file) { instance_double(Tempfile) }
  subject(:ssh_tmp_file) { described_class.new(private_key) }

  before do
    allow(Tempfile).to receive(:new).and_return(tmp_file)
    allow(tmp_file).to receive(:<<)
    allow(tmp_file).to receive(:puts)
    allow(tmp_file).to receive(:chmod)
    allow(tmp_file).to receive(:flush)
    allow(tmp_file).to receive(:close)
  end

  it 'initialized tmp file' do
    ssh_tmp_file
    expect(Tempfile).to have_received(:new).with('git-ssh-wrapper')
  end

  it 'adds private_key to tmpfile' do
    ssh_tmp_file
    expect(tmp_file).to have_received(:<<).with(private_key)
  end

  it 'adds new line after private_key so that I do not spend hours debugging why the ssh key file is invalid' do
    ssh_tmp_file
    expect(tmp_file).to have_received(:puts).with('')
  end

  it 'chmods the tmpfile to 0600' do
    ssh_tmp_file
    expect(tmp_file).to have_received(:chmod).with(0600)
  end

  it 'flushes and closes the tmp_file' do
    ssh_tmp_file
    expect(tmp_file).to have_received(:flush)
    expect(tmp_file).to have_received(:close)
  end
end