require_relative '../../lib/microstatic'
# require_relative '../../lib/microstatic/uses_fog'

if ENV['FOG_MOCK']
  Fog.mock!
  include Microstatic::UsesFog
  check_and_store_aws_creds(Microstatic.aws_creds_from_env)
  connection.directories.create(:key => 'microstatic-test-bucket')
end
require 'pry'
