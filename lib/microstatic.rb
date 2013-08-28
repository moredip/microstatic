require "microstatic/version"

require 'microstatic/uses_fog'

require "microstatic/s3_deployer"

module Microstatic
  def self.aws_creds_from_env
    {
      access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
      secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY')
    }
  end
end
