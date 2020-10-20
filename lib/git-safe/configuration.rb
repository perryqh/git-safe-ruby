module GitSafe
  class Configuration
    OPTIONS = {
      logger:                              ::Logger.new(STDOUT),
      branch:                              'master',
      remote:                              'origin',
      clone_command_repo_dir_replace_text: '<REPO_DIR>',
      ssh_private_key:                     nil, # path or string
    }.freeze

    # Defines accessors for all OPTIONS
    OPTIONS.each_pair do |key, _value|
      attr_accessor key
    end

    # Initializes defaults to be the environment varibales of the same names
    def initialize
      OPTIONS.each_pair do |key, value|
        send("#{key}=", value)
      end
    end

    # Allows config options to be read like a hash
    #
    # @param [Symbol] option Key for a given attribute
    def [](option)
      send(option)
    end

    # Returns a hash of all configurable options
    def to_hash
      OPTIONS.each_with_object({}) do |option, hash|
        key       = option.first
        hash[key] = send(key)
      end
    end

    # Returns a hash of all configurable options merged with +hash+
    #
    # @param [Hash] hash A set of configuration options that will take 
    # precedence over the defaults
    def merge(hash)
      to_hash.merge(hash)
    end
  end
end