require 'digest/md5'
require 'pathname'
require 'rake/file_list'

module Microstatic

# The following is based on code generously 
# shared by Giles Alexander (@gga)
class S3Deployer
  include UsesFog

  attr_reader :file_list # TODO: don't expose this directly

  def initialize( local_dir, bucket, aws_creds )
    check_and_store_aws_creds(aws_creds)

    @local_dir = Pathname.new(local_dir)
    @file_list = Rake::FileList.new( (@local_dir+"**/*").to_s )
    @bucket = bucket
  end

  def upload
    @file_list.each do |entry|
      entry = Pathname.new(entry)
      upload_file(entry) unless entry.directory?
    end
  end

  def upload_file( file )
    s3_key = file.relative_path_from(@local_dir).to_s

    begin
      s3_object = connection.head_object(@bucket,s3_key)
    rescue Excon::Errors::NotFound
      s3_object = false
    end

    if !s3_object
      log_action('CREATE', s3_key)
      put_file( s3_key, file )
    else
      s3_md5 = s3_object.headers['ETag'].sub(/"(.*)"/,'\1')
      local_md5 = Digest::MD5.hexdigest( file.read )

      if( s3_md5 == local_md5 )
        log_action('NO CHANGE', s3_key)
      else
        log_action('UPDATE', s3_key)
        put_file( s3_key, file )
      end
    end
  end

  private

  def put_file( s3_key, file )
    connection.put_object( @bucket, s3_key, file.open, 'x-amz-acl' => 'public-read', 'x-amz-storage-class' => 'REDUCED_REDUNDANCY' )
  end

  def log_action(action,file)
    message = action.to_s.rjust(10) + "  " + file
    puts message
  end
end

end
