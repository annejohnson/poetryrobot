require './spec/spec_helper.rb'

describe TwitterTopicRobot do
  let(:content_preparer) { PoetryContentPreparer.new }
  let(:robot) { TwitterTopicRobot.new(content_preparer) }

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
