shared_context 'repo with master and staging branches' do
  include_context 'git repo'

  let(:staging_file) do
    file = "#{work_tree}/my-staging-file.txt"
    File.open(file, 'w') { |f| f << "my staging file contents" }
    file
  end

  before do
    git.init
    add_file_to_working_dir
    git.add_and_commit('committing my file')
    git.checkout(branch: 'staging', create: true)
    staging_file
    git.add_and_commit('committing my staging file')
    git.checkout(branch: 'master')
  end
end