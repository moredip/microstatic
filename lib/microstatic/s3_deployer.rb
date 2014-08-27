require 'digest/md5'
require 'pathname'
require 'rake/file_list'

module Microstatic
class S3Deployer

  attr_reader :file_list # TODO: don't expose this directly

  def self.build( local_dir, bucket, aws_creds )
    uploader = Uploader.new( local_dir, bucket, aws_creds )
    new( local_dir, uploader )
  end

  def initialize( local_dir, uploader )
    @local_dir = Pathname.new(local_dir)
    @file_list = ::Rake::FileList.new( (@local_dir+"**/*").to_s )
    @uploader = uploader
  end

  def upload
    @file_list.each do |entry|
      entry = Pathname.new(entry)
      @uploader.upsert_filepath(entry) unless entry.directory?
    end
  end

end
end
