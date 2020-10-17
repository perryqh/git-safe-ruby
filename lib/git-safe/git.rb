module GitSafe
  class Git
    attr_reader :options, :working_dir

    def initialize(working_dir, options)
      @working_dir = working_dir
      @options     = options
    end

    def clone(remote_uri)

    end
  end
end