module GitSafe
  class SshTempfile
    attr_reader :private_key_string, :private_key_temp_file

    def initialize(private_key_string)
      @private_key_string    = private_key_string
      @private_key_temp_file = create_private_key_tmp_file
    end

    def safe_unlink_private_key_tmp_file
      private_key_temp_file&.unlink
    end

    def create_private_key_tmp_file
      tf = Tempfile.new('git-ssh-wrapper')
      tf << private_key_string
      tf.puts('') # required for openssh keys
      tf.chmod(0600)
      tf.flush
      tf.close
      tf
    end
  end
end