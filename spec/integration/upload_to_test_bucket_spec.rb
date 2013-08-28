require_relative 'spec_helper'
require_relative '../../lib/microstatic/base_deployer'
require_relative '../../lib/microstatic/s3_deployer'

module Microstatic
describe 'uploading to a test bucket' do
  def test_bucket
    'microstatic-test-bucket'
  end

  def test_dir 
    File.expand_path( "../fixtures", __FILE__ ) 
  end

  creds = {
    :aws => {
      :provider => 'AWS',
      :aws_access_key_id => ENV.fetch('AWS_ACCESS_KEY_ID'),
      :aws_secret_access_key => ENV.fetch('AWS_SECRET_ACCESS_KEY')
    },
    :rax => {
      :provider => 'Rackspace',
      :rackspace_username => ENV.fetch('RAX_USERNAME'),
      :rackspace_api_key  => ENV.fetch('RAX_API_KEY'),
    }
  }

  creds.each do |provider, creds|
    it "succeeds (#{provider})" do
      create_bucket(test_bucket, creds) # if Fog.mock?
      deployer = BaseDeployer.factory( test_dir, test_bucket, creds )
      deployer.upload
    end
  end

end
end
