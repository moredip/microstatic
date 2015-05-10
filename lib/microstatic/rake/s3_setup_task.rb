module Microstatic module Rake

class AwsSiteSetupTask < ::Rake::TaskLib
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
end

def self.aws_site_setup_task(opts = {})
  task = AwsSiteSetupTask.new( opts )
  yield task if block_given?
  task.define
end

end end
