require 'open3'

module GitSafe
  class Git
    include PrivateKeyFile

    attr_reader :options, :work_tree, :ssh_private_key, :logger

    def initialize(work_tree, options)
      @work_tree       = work_tree
      @options         = options
      @ssh_private_key = options[:ssh_private_key]
      @logger          = options[:logger]
      FileUtils.mkdir_p(work_tree)
    end

    def init
      execute_git_cmd("git #{git_locale} init")
    end

    def status
      execute_git_cmd("git #{git_locale} status")
    end

    def checkout(branch: nil, create: false)
      co = "git #{git_locale} checkout"
      if branch && create
        co = "#{co} -b #{branch}"
      elsif branch
        co = "#{co} #{branch}"
      end
      execute_git_cmd(co)
    end

    def pull(branch: 'master')
      execute_git_cmd("#{ssh_cmd}git #{git_locale} pull origin #{branch}")
    ensure
      safe_unlink_private_key_tmp_file
    end

    def clone(remote_uri, depth: nil)
      if options[:clone_command]
        execute_git_cmd(options[:clone_command].gsub(options[:clone_command_repo_dir_replace_text], work_tree))
      else
        depth_cmd = depth ? " --depth=#{depth}" : ''
        execute_git_cmd("#{ssh_cmd}git clone #{remote_uri}#{depth_cmd} #{work_tree}")
      end
    ensure
      safe_unlink_private_key_tmp_file
    end

    def git_locale
      "#{work_tree_flag} --git-dir=#{work_tree}/.git"
    end

    def work_tree_flag
      "--work-tree=#{work_tree}"
    end

    def execute_git_cmd(git_cmd)
      stdout_str, stderr_str, status = Open3.capture3(git_cmd)
      raise CommandError.new("error executing '#{git_cmd}', status: #{status.exitstatus}, std_error: #{stderr_str}") unless status.exitstatus == 0

      [stdout_str, stderr_str].reject { |out| out.nil? || out.strip == '' }.join(',')
    end
  end
end