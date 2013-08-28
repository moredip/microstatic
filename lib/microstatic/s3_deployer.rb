require 'digest/md5'
require 'pathname'
require File.expand_path '../base_deployer', __FILE__

module Microstatic

# The following is based on code generously 
# shared by Giles Alexander (@gga)
class S3Deployer < BaseDeployer
  include UsesFog
  def initialize( local_dir, bucket, creds )
    check_and_store_aws_creds(creds)
    super(local_dir, bucket, creds)
  end
end

end
