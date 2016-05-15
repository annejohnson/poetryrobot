require './spec/spec_helper.rb'

describe PoetryRobot do
  describe '#tweet_poem' do
    it 'tweets a poem'
  end

  describe '#retweet_a_poet' do
    it 'retweets a poet'
  end

  describe '#retweet_mentions' do
    it 'retweets mentions'
  end

  describe '#follow_a_poet' do
    it 'follows a poet'
  end

  describe '#reply_to_a_poet' do
    it 'replies to a poet'
  end

  describe '#follow_followers' do
    it 'follows its followers'
  end

  describe '#create_poem_tweet' do
    it 'creates a twitter-ready poem string' do
      VCR.use_cassette 'create_poem_tweet' do
        tweet = subject.create_poem_tweet
        expect(tweet).to match(/https?:\/\//i)
        expect(tweet.length <= 140).to be(true)
      end
    end
  end
end
