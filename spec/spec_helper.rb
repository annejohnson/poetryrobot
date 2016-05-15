require './lib/hash_cleaner.rb'
require './lib/string_cleaner.rb'
require './lib/tweet_filterer.rb'
require './lib/twitter_wrapper.rb'
require './lib/poetry_foundation_random_poem_scraper.rb'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :faraday
end
