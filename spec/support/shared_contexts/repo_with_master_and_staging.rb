shared_context 'repo with master and staging branches' do
  include_context 'git repo'

  before do
    git.init
    add_file_to_working_dir
    git.add_and_commit('committing my file')
    git.checkout(branch: 'staging', create: true)
    File.open("#{work_tree}/my-staging-file.txt", 'w') { |f| f << "my staging file contents" }
    git.add_and_commit('committing my staging file')
    git.checkout(branch: 'master')
  end
end