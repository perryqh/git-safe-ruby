
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "git-safe/version"

Gem::Specification.new do |spec|
  spec.name          = "git-safe"
  spec.version       = GitSafe::VERSION
  spec.authors       = ["Perry Hertler"]
  spec.email         = ["perry@hertler.org"]

  spec.summary       = %q{A concurrent-safe way to perform multiple ssh configuration git operations against "origin".}
  spec.description   = %q{Some applications need to access git "origin" from multiple threads or processes with different security access approaches. This gem makes it possible}
  spec.homepage      = "https://rubygems.org/gems/git-safe"


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-its", "~> 1.3"
  spec.add_development_dependency "pry"
end
