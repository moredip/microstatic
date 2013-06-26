require 'aws/s3'

module Microstatic
  module UsesS3
    def check_and_store_aws_creds( aws_creds )
      [:access_key_id,:secret_access_key].each do |required_key|
        raise ArgumentError, "must supply :#{required_key}" unless aws_creds.key?(required_key)
      end

      @aws_creds = aws_creds
    end

    def connect_to_s3
      AWS::S3::Base.establish_connection!(@aws_creds)
    end
  end
end
