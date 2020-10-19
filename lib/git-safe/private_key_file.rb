module GitSafe
  module PrivateKeyFile
    def ssh_cmd
      return '' unless ssh_private_key_file_path
      "GIT_SSH_COMMAND=\"ssh -i #{ssh_private_key_file_path} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no\" "
    end

    def ssh_private_key_file_path
      return unless ssh_private_key

      if File.exist?(ssh_private_key)
        logger.info('ssh_private_key key is a file')
        ssh_private_key
      else
        logger.info('ssh_private_key key is a string')
        ssh_tempfile.private_key_temp_file.path
      end
    end

    def ssh_tempfile
      @ssh_tempfile ||= SshTempfile.new(ssh_private_key)
    end

    def safe_unlink_private_key_tmp_file
      ssh_tempfile&.safe_unlink_private_key_tmp_file
    end
  end
end