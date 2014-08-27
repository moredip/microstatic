require_relative 'spec_helper'
require_relative '../../lib/microstatic/s3_deployer'

module Microstatic
describe 'uploading to a test bucket' do
  def test_bucket
    'microstatic-test-bucket'
  end

  def test_dir 
    File.expand_path( "../fixtures", __FILE__ ) 
  end

  def aws_creds
    {
      :access_key_id => ENV.fetch('AWS_ACCESS_KEY_ID'),
      :secret_access_key => ENV.fetch('AWS_SECRET_ACCESS_KEY')
    }
  end

  it 'succeeds' do
    deployer = S3Deployer.build( test_dir, test_bucket, aws_creds )
    deployer.exclude_files(%r|ignored/|)
    deployer.upload
  end
  
end
end
