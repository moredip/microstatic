require 'thor'
require 'rainbow'

module Microstatic
  class CLI < Thor
    desc "setup <APP_NAME>", "do the needful to get started hosting your static site. S3, Route 53, whatever it takes."
    def setup( app_name = false )
      app_name ||= inferred_app_name
      bucket_name = subdomain_for(app_name)

      bucket = bucket( bucket_name )
      # TODO: pass bucket through to dns setup so we don't have to look it up again
      dns( app_name )

      # TODO: add Rakefile, Gemfile, etc for doing a rake deploy using this gem
    end

    desc "bucket <BUCKET_NAME>", "create an S3 bucket which can host your static site"
    def bucket( bucket_name = false )
      bucket_name ||= guess_bucket_name
      # TODO: check it doesn't already exist for you
      # TODO: check bucket_name looks like a site name (e.g. foo.thepete.net, not just foo)
      # TODO: handle the bucket name already being taken by someone else
      # TODO: fail gracefully if aws creds not available
      
      describe_operation( "create S3 bucket '#{bucket_name}'" ) do
        S3BucketCreator.new( config.aws_creds ).create( bucket_name )
      end
    end

    desc "dns <APP_NAME>", "create a Route 53 entry pointing to the S3 bucket containing your static site"
    def dns( app_name = false )
      app_name ||= inferred_app_name
      bucket_name = subdomain_for(app_name)

      describe_operation( "create Route 53 entry '#{bucket_name}'" ) do
        Route53Dns.new( config.aws_creds ).add_s3_record_for_bucket( bucket_name )
      end
    end

    private 

    def guess_bucket_name
      subdomain_for( inferred_app_name )
    end

    def subdomain_for( app_name )
      "#{app_name}.#{config.site_name}"
    end

    def inferred_app_name
      File.basename(Dir.pwd)
    end

    def config
      Config.automagic
    end

    def describe_operation( operation_desc )
      STDOUT.print "  #{operation_desc} ..."
      yield
      STDOUT.puts "\r- #{operation_desc}   "+CHECKMARK
    rescue
      STDOUT.puts "\r- #{operation_desc}   "+SADMARK
      raise
    end

    CHECKMARK="\u2713".color(:green)
    SADMARK="\u2718".color(:red)

  end
end
