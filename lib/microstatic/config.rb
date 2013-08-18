module Microstatic
  class Config
    def self.automagic
      #in the future this'll try to create a config based on 
      #various diff. files, in priority order?
      self.new 
    end

    def site_name
      ENV.fetch('MICROSTATIC_SITE_NAME')
    end

    def aws_creds
      {
        :access_key_id => aws_access_key_id,
        :secret_access_key => aws_secret_access_key
      }
    end

    def aws_access_key_id
      ENV.fetch('AWS_ACCESS_KEY_ID')
    end

    def aws_secret_access_key
      ENV.fetch('AWS_SECRET_ACCESS_KEY')
    end
  end
end
