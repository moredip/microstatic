require 'microstatic/rake/task_environment'

module Microstatic module Rake

class AwsSiteSetupTask < ::Rake::TaskLib
  def initialize(task_env)
    @task_env = task_env
  end

  def define
    require 'microstatic'

    te = @task_env

    desc "set up S3 bucket and Route53 DNS entry for a new site" unless ::Rake.application.last_comment
    task te.task_name_or('aws_site_setup'), :site_name, :hosted_zone do |t,args|
      site_name = args[:site_name]
      hosted_zone = args.with_defaults(:hosted_zone => false)[:hosted_zone]

      # TODO: check site_name looks like a site name (e.g. foo.thepete.net, not just foo)
      site_name or raise "you must provide a site_name parameter to this rake task"

      te.check_for_aws_creds!
      

      # TODO: check it doesn't already exist for you
      # TODO: handle the bucket name already being taken by someone else
      S3BucketCreator.new( te.aws_creds ).create( site_name )
      
      # TODO: handle DNS record already existing
      Route53Dns.new( te.aws_creds ).add_s3_record_for_bucket( site_name, hosted_zone )
    end
  end
end

def self.aws_site_setup_task(opts = {})
  task_env = TaskEnvironment.new(opts)
  yield task_env if block_given?
  AwsSiteSetupTask.new( task_env ).define
end

end end
