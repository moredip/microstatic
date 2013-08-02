require 'fog'

module Microstatic
  module UsesFog
    def check_and_store_aws_creds( aws_creds )
      [:access_key_id,:secret_access_key].each do |required_key|
        raise ArgumentError, "must supply :#{required_key}" unless aws_creds.key?(required_key)
      end

      @aws_creds = aws_creds
    end

    def connection
      @_connection ||= Fog::Storage.new({
        :provider => 'AWS',
        :aws_access_key_id => @aws_creds.fetch(:access_key_id),
        :aws_secret_access_key => @aws_creds.fetch(:secret_access_key)
      })
    end
  end
end
