require 'aws/s3'

class Microstatic::S3BucketCreator
  include UsesS3

  def initialize( suffix, aws_creds )
    check_and_store_aws_creds(aws_creds)
    @suffix = suffix
  end

  def create( name )
    connect_to_s3

    bucket_name = name + @suffix
    AWS::S3::Bucket.create( bucket_name, :access => :public_read )
  end

end
