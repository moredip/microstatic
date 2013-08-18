require "microstatic/version"

require 'microstatic/config'
require 'microstatic/uses_fog'

require "microstatic/s3_deployer"
require "microstatic/s3_bucket_creator"

module Microstatic
  def self.aws_creds_from_env
    {
      access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
      secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY')
    }
  end
end
