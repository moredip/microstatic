require 'pathname'

module Microstatic

class Uploader
  include UsesFog

  def initialize( base_dir, bucket, aws_creds )
    check_and_store_aws_creds(aws_creds)
    @bucket = bucket
    @base_dir = Pathname.new(base_dir)
  end

  def upsert_filepath( filepath )
    pathname = Pathname.new(filepath) 
    s3_key = relative_path_for(pathname)

    begin
      s3_object = connection.head_object(@bucket,s3_key)
    rescue Excon::Errors::NotFound
      log_action("NOT FOUND", s3_key)
      s3_object = false
    rescue Excon::Errors::Forbidden
      log_action("FORBIDDEN", s3_key)
      s3_object = false
    end


    if s3_object
      update_object_if_changed(s3_key, pathname,s3_object)
    else
      create_object(s3_key, pathname)
    end
  end

  private

  def create_object(s3_key, pathname)
    log_action('CREATE', s3_key)
    put_file( s3_key, pathname )
  end

  def update_object_if_changed(s3_key, pathname,s3_object)
    s3_md5 = s3_object.headers['ETag'].sub(/"(.*)"/,'\1')
    local_md5 = Digest::MD5.hexdigest( pathname.read )

    if( s3_md5 == local_md5 )
      log_action('NO CHANGE', s3_key)
    else
      log_action('UPDATE', s3_key)
      put_file( s3_key, pathname )
    end
  end

  def relative_path_for(pathname)
    pathname.relative_path_from(@base_dir).to_s
  end

  def put_file( s3_key, file )
    connection.put_object( @bucket, s3_key, file.open, 'x-amz-acl' => 'public-read', 'x-amz-storage-class' => 'REDUCED_REDUNDANCY' )
  end

  def log_action(action,file)
    message = action.to_s.rjust(10) + "  " + file
    puts message
  end
end

end
