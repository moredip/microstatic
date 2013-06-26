require 'digest/md5'
require 'pathname'


# The following is based on code generously 
# shared by Giles Alexander (@gga)
class Microstatic::S3Deployer
  include UsesS3
  def initialize( local_dir, bucket, aws_creds )
    check_and_store_aws_creds(aws_creds)

    @local_dir = Pathname.new(local_dir)
    @bucket = bucket
  end

  def upload
    connect_to_s3

    Pathname.glob(@local_dir+"**/*") do |child|
      upload_file(child) unless child.directory?
    end
  end

  def upload_file( file )
    s3_key = file.relative_path_from(@local_dir).to_s

    begin
      s3_object = AWS::S3::S3Object.find(s3_key, @bucket)
    rescue AWS::S3::NoSuchKey
      s3_object = false
    end

    if !s3_object
      log_action('CREATE', s3_key)
      AWS::S3::S3Object.store( s3_key, file.open, @bucket, :access => :public_read )
    else
      s3_md5 = s3_object.about['etag'].sub(/"(.*)"/,'\1')
      local_md5 = Digest::MD5.hexdigest( file.read )

      if( s3_md5 == local_md5 )
        log_action('NO CHANGE', s3_key)
      else
        log_action('UPDATE', s3_key)
        AWS::S3::S3Object.store(s3_key, file.open, @bucket)
      end
    end
  end

  def log_action(action,file)
    message = action.to_s.rjust(10) + "  " + file
    puts message
  end
end

