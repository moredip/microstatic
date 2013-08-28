require 'digest/md5'
require 'pathname'

module Microstatic

# The following is based on code generously 
# shared by Giles Alexander (@gga)
class BaseDeployer
  include UsesFog
  def initialize( local_dir, bucket, creds )
    store_creds(creds)

    @local_dir = Pathname.new(local_dir)
    @bucket = bucket
  end

  def self.factory( local_dir, bucket, creds )
    case creds[:provider]
    when 'AWS'
      S3Deployer.new local_dir, bucket, creds
    else
      BaseDeployer.new local_dir, bucket, creds
    end
  end

  def upload
    Pathname.glob(@local_dir+"**/*") do |child|
      upload_file(child) unless child.directory?
    end
  end

  def file_metadata
    # Override this if you need more!
    { :public => true }
  end

  def upload_file( file )
    file_key = file.relative_path_from(@local_dir).to_s

    begin
      file_object = connection.head_object(@bucket,file_key)
    rescue Excon::Errors::NotFound
      file_object = false
    end

    if !file_object
      log_action('CREATE', file_key)
      connection.put_object( @bucket, file_key, file.open, file_metadata )
    else
      etag = file_object.headers['ETag'] || file_object.headers['Etag']
      file_md5 = etag.sub(/"(.*)"/,'\1')
      local_md5 = Digest::MD5.hexdigest( file.read )

      if( file_md5 == local_md5 )
        log_action('NO CHANGE', file_key)
      else
        log_action('UPDATE', file_key)
        connection.put_object( @bucket, file_key, file.open )
      end
    end
  end

  def log_action(action,file)
    message = action.to_s.rjust(10) + "  " + file
    puts message
  end
end

end
