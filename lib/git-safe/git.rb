require 'open3'

module GitSafe
  class Git
    attr_reader :options, :work_tree

    def initialize(work_tree, options)
      @work_tree = work_tree
      @options   = options
      FileUtils.mkdir_p(work_tree)
    end

    def clone(remote_uri, depth: nil)
      depth_cmd = depth ? " --depth=#{depth}" : ''
      execute_git_cmd("clone #{remote_uri}#{depth_cmd} #{work_tree}")
    end

    def execute_git_cmd(cmd)
      git_cmd                        = "git #{cmd}"
      stdout_str, stderr_str, status = Open3.capture3(git_cmd)
      raise CommandError.new("error executing '#{git_cmd}', status: #{status.exitstatus}, std_error: #{stderr_str}") unless status.exitstatus == 0
      [stdout_str, stderr_str].reject { |out| out.nil? || out.strip == '' }.join(',')
    end
  end
end