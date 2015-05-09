module Microstatic module Rake

class S3DeployTask < ::Rake::TaskLib
  attr_accessor :name, :bucket_name, :source_dir, :exclude, :aws_access_key_id, :aws_secret_access_key

  def initialize( opts = {} )
    if opts.is_a?(String) || opts.is_a?(Symbol)
      opts = { name: opts }
    end

    @name = opts.fetch( :name ) { :s3deploy }
    @aws_access_key_id = opts.fetch( :aws_access_key_id ) { ENV.fetch('AWS_ACCESS_KEY_ID',false) }
    @aws_secret_access_key = opts.fetch( :aws_secret_access_key ) { ENV.fetch('AWS_SECRET_ACCESS_KEY',false) }
    @bucket_name = opts.fetch( :bucket_name, false )
    @source_dir = opts.fetch( :source_dir, false )
    @exclude = opts.fetch( :exclude, false )
  end

  def define
    require 'microstatic'

    raise 'must specify bucket_name' unless bucket_name
    raise 'must specify source_dir' unless source_dir

    desc "deploy to the '#{bucket_name}' S3 bucket" unless ::Rake.application.last_comment
    task name do

      raise 'must specify aws_access_key_id' unless aws_access_key_id
      raise 'must specify aws_secret_access_key' unless aws_secret_access_key
      aws_creds = {
        :access_key_id => aws_access_key_id,
        :secret_access_key => aws_secret_access_key
      }

      deployer = Microstatic::S3Deployer.build( source_dir, bucket_name, aws_creds )
      deployer.exclude_files(@exclude) if @exclude
      deployer.upload
    end
  end
end

def self.s3_deploy_task(opts = {})
  task = S3DeployTask.new( opts )
  yield task if block_given?
  task.define
end

end end
