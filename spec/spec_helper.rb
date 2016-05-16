require './lib/poetry_robot.rb'
require './spec/shared_examples.rb'

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :faraday
end

def twitter_credentials
  YAML.load(
    File.open('twitter.yml', &:read)
  )['twitter']
end
