module GitSafe
  module PrivateKeyFile
    def ssh_cmd
      return '' unless ssh_private_key_file_path
      "GIT_SSH_COMMAND=\"ssh -i #{ssh_private_key_file_path} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no\" "
    end

    def ssh_private_key_file_path
      return unless ssh_private_key
      ssh_private_key
    end
  end
end