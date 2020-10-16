require 'git-safe/git'

module GitSafe
  def self.init(options={})
    Git.new(options)
  end
end