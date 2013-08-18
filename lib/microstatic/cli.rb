require 'thor'
require 'rainbow'

module Microstatic
  class CLI < Thor
    desc "create <BUCKET_NAME>", "create an S3 bucket which can host your static site"
    def create_bucket( bucket_name = false )
      bucket_name ||= guess_bucket_name
      # TODO: check it doesn't already exist for you
      # TODO: handle the bucket name already being taken by someone else
      # TODO: fail gracefully if aws creds not available
      
      describe_operation( "create bucket '#{bucket_name}'" ) do
        S3BucketCreator.new( config.aws_creds ).create( bucket_name )
      end
    end

    desc "deploy <BUCKET_NAME>", "create an S3 bucket which can host your static site"
    def deploy_to_bucket( bucket_name )
    end

    private 

    def guess_bucket_name
      guessed_app_name = File.basename(Dir.pwd)
      "#{guessed_app_name}.#{config.site_name}"
    end

    def config
      Config.automagic
    end

    def describe_operation( operation_desc )
      STDOUT.print "#{operation_desc} ..."
      yield
      STDOUT.puts "\r#{operation_desc}   "+CHECKMARK
    end

    CHECKMARK="\u2713".color(:green)

  end
end
