module Microstatic module Rake

class TaskEnvironment
  def initialize( opts, env = ENV )
    if opts.is_a?(String) || opts.is_a?(Symbol)
      opts = { name: opts }
    end

    @opts = opts
    @env = env
  end

  def task_name_or(default)
    @opts.fetch(:name,default)
  end

  def bucket_name
    @opts.fetch(:bucket_name)
  end
  def bucket_name=(bn)
    @opts[:bucket_name] = bn
  end

  def source_dir
    @opts.fetch(:source_dir)
  end
  def source_dir=(sd)
    @opts[:source_dir] = sd
  end

  def exclude
    @opts.fetch( :exclude, false )
  end
  def exclude=(e)
    @opts[:exclude] = e
  end

  def aws_access_key_id
    @opts.fetch(:aws_access_key_id) { @env.fetch("AWS_ACCESS_KEY_ID") }
  end

  def aws_secret_access_key
    @opts.fetch(:aws_secret_access_key) { @env.fetch("AWS_SECRET_ACCESS_KEY") }
  end

  def aws_creds
    {
      access_key_id: aws_access_key_id,
      secret_access_key: aws_secret_access_key
    }
  end

  def check_for_mandatory_opts!
    bucket_name rescue raise "must provide a bucket_name"
    source_dir rescue raise "must provide a source_dir"
    true
  end

  def check_for_aws_creds! 
    aws_access_key_id rescue raise "must provide an aws access key id either via an :aws_access_key_id opt or an AWS_ACCESS_KEY_ID environment variable"
    aws_secret_access_key rescue raise "must provide an aws secret access key either via an :aws_secret_access_key opt or an AWS_SECRET_ACCESS_KEY environment variable"
  end
end

end end
