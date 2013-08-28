require 'fog'

module Microstatic
  module UsesFog
    def check_and_store_aws_creds( aws_creds )
      [:aws_access_key_id,:aws_secret_access_key].each do |required_key|
        raise ArgumentError, "must supply :#{required_key}" unless aws_creds.key?(required_key)
      end

     store_creds(aws_creds.merge({:provider => 'AWS'}))
    end

    def store_creds(creds)
      @creds = creds
    end

    def connection
      @_connection ||= Fog::Storage.new @creds
    end
  end
end
