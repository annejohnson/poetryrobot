require './spec/spec_helper.rb'

describe TwitterBot::TopicBot do
  let(:content_preparer) { PoetryContentPreparer.new }
  let(:robot) { described_class.new(content_preparer, twitter_credentials) }

  describe '#tweet' do
    it 'tweets'
  end

  describe '#retweet_someone' do
    it 'retweets someone'
  end

  describe '#follow_someone' do
    it 'follows someone'
  end

  describe '#retweet_mentions' do
    it 'retweets mentions'
  end

  describe '#reply_to_someone' do
    it 'replies to someone'
  end

  describe '#follow_followers' do
    it 'follows its followers'
  end
end
