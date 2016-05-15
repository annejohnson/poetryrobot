require './spec/spec_helper.rb'

describe PoetryRobot do
  describe '#tweet_poem' do
  end

  describe '#retweet_a_poet' do
  end

  describe '#retweet_mentions' do
  end

  describe '#follow_a_poet' do
  end

  describe '#reply_to_a_poet' do
  end

  describe '#follow_followers' do
  end

  describe '#create_poem_tweet' do
    it 'creates a twitter-ready poem string' do
      VCR.use_cassette 'create_poem_tweet' do
        tweet = subject.create_poem_tweet
        puts tweet.inspect
        expect(tweet).to match(/https?:\/\//i)
        expect(tweet.length <= 140).to be(true)
      end
    end
  end
end
