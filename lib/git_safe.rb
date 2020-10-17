require 'logger'
require 'git-safe/git'
require 'git-safe/configuration'

module GitSafe
  class << self
    def init(working_dir, options = {})
      Git.new(working_dir, configuration.merge(options))
    end

    # A GitSafe configuration object. Must act like a hash and
    # return sensible values for all GitSafe configuration options.
    #
    # @see GitSafe::Configuration.
    attr_writer :configuration

    # The configuration object.
    #
    # @see GitSafe.configure
    def configuration
      @configuration ||= Configuration.new
    end

    # Call this method to modify defaults in your initializers.
    #
    # @example
    #   GitSafe.configure do |config|
    #     config.binary_path          = '/usr/local/bin/git'
    #     config.logger          = Logger.new(STDOUT)
    #   end
    def configure
      yield(configuration)
    end
  end
end