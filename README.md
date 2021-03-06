# Git::Safe

This ruby git gem can safely be executed in concurrent environments with multiple ssh keys

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'git-safe'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git-safe

## Usage
Configuration
```ruby
require 'git_safe'
GitPusher.configure do |config|
  config.logger = Logger.new(STDOUT)
end
```

Initialize with work_tree and an optional ssh_private_key (string or path)
```ruby
git_safe = GitSafe.init('/my/work/tree', ssh_private_key: 'path-to-file-or-string')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/git-safe.
