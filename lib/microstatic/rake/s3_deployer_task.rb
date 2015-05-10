require 'microstatic/rake/task_environment'

module Microstatic module Rake

class S3DeployTask < ::Rake::TaskLib
  def initialize(task_env)
    @task_env = task_env
  end

  def define
    require 'microstatic'

    te = @task_env
    te.check_for_mandatory_opts!

    desc "deploy to the '#{te.bucket_name}' S3 bucket" unless ::Rake.application.last_comment
    task te.task_name_or('s3deploy') do

      te.check_for_aws_creds!
      deployer = Microstatic::S3Deployer.build( te.source_dir, te.bucket_name, te.aws_creds )
      deployer.exclude_files(te.exclude) if te.exclude
      deployer.upload
    end
  end
end

def self.s3_deploy_task(opts = {})
  task_env = TaskEnvironment.new(opts)
  yield task_env if block_given?
  S3DeployTask.new( task_env ).define
end

end end
