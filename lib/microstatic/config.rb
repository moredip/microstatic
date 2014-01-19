module Microstatic
  class Config
    class MissingEnvVar < RuntimeError
    end

    def self.automagic
      #in the future this'll try to create a config based on 
      #various diff. files, in priority order?
      self.new 
    end

    def site_name
      env_var('MICROSTATIC_SITE_NAME')
    end

    def aws_creds
      {
        :access_key_id => aws_access_key_id,
        :secret_access_key => aws_secret_access_key
      }
    end

    def aws_access_key_id
      env_var('AWS_ACCESS_KEY_ID')
    end

    def aws_secret_access_key
      env_var('AWS_SECRET_ACCESS_KEY')
    end

    private 

    def env_var(key)
      ENV.fetch(key) { raise MissingEnvVar.new("you must set the #{key} environment variable") }
    end
  end
end
