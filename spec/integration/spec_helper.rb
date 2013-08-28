require_relative '../../lib/microstatic'
# require_relative '../../lib/microstatic/uses_fog'

if ENV['FOG_MOCK']
  %w{RAX_USERNAME RAX_API_KEY AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY}.each do |key|
    ENV[key] = 'dummy'
  end
  Fog.mock!
end

def create_bucket(bucket, creds)
  puts "Creating #{bucket}"
  Fog::Storage.new(creds).directories.create(:key => bucket)
end
require 'pry'
