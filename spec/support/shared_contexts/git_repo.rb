shared_context 'git repo' do
  after(:each) do
    FileUtils.rm_rf(work_tree)
  end

  let(:work_tree) { File.join('spec', 'support', 'working-dirs', 'work') }
  let(:options) { { logger: ::Logger.new(STDOUT) } }
  let(:add_file_name) {'my-file.txt'}
  let(:add_file_to_working_dir) do
    File.open("#{work_tree}/#{add_file_name}", 'w') { |f| f << "my file contents" }
  end

  subject(:git) { described_class.new(work_tree, options) }
end