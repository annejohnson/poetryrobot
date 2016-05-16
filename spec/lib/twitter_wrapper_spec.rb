require './spec/spec_helper.rb'
require 'yaml'

describe TwitterWrapper do
  let(:credentials) do
    YAML.load(
      File.open('twitter.yml', &:read)
    )['twitter']
  end

  subject { described_class.new(credentials) }

  let(:test_topic) { 'elephant' }

  describe '#max_tweet_length' do
    it 'is 140 characters' do
      expect(subject.max_tweet_length).to eq(140)
    end
  end

  describe '#favorite' do
    it 'favorites the specified tweet' do
      VCR.use_cassette 'favorite' do
        tweet_to_favorite = subject.search_recent_tweets(test_topic).first
        result = subject.favorite(tweet_to_favorite)
        expect(result.first.id).to eq(tweet_to_favorite.id)
      end
    end
  end

  describe '#following' do
    it 'returns a collection of users' do
      VCR.use_cassette 'following' do
        following = subject.following
        expect_user_collection(following)
      end
    end
  end

  describe '#followers' do
    it 'returns a collection of users' do
      VCR.use_cassette 'followers' do
        followers = subject.followers
        expect_user_collection(followers)
      end
    end
  end

  describe '#tweet' do
    it 'sends a tweet' do
      VCR.use_cassette 'tweet' do
        test_tweet = 'Roses are red. Violets are blue. Expect tweet_send_success == true.'
        published_tweet = subject.tweet(test_tweet)
        expect(published_tweet.text).to eq(test_tweet)
      end
    end
  end

  describe '#retweet' do
    it 'retweets the specified tweet' do
      VCR.use_cassette 'retweet' do
        tweet_to_retweet = subject.search_recent_tweets(test_topic).first
        result = subject.retweet(tweet_to_retweet)
        expect(result.first.text).to eq(tweet_to_retweet.text)
      end
    end
  end

  describe '#follow' do
    it 'follows the specified user' do
      VCR.use_cassette 'follow' do
        user_to_follow = subject.search_recent_tweets(test_topic).
                                 first.
                                 user
        result = subject.follow(user_to_follow)
        expect(result.first.id).to eq(user_to_follow.id)
      end
    end
  end

  describe '#search_recent_tweets' do
    it 'gets recent tweets containing the search terms' do
      VCR.use_cassette 'search_recent_tweets' do
        tweets = subject.search_recent_tweets(test_topic)
        tweets.each do |tweet|
          expect(tweet.text).to match(Regexp.new(test_topic, Regexp::IGNORECASE))
        end
      end
    end
  end

  describe '#mentions' do
    it 'gets tweets mentioning the user' do
      VCR.use_cassette 'mentions' do
        tweets = subject.mentions
        tweets.each do |tweet|
          expect(tweet.text).to match(
            Regexp.new(subject.username, Regexp::IGNORECASE)
          )
        end
      end
    end
  end

  describe '#tweets' do
    it 'gets tweets by the user' do
      VCR.use_cassette 'tweets' do
        tweets = subject.tweets
        tweets.each do |tweet|
          expect(tweet.user.screen_name).to eq(subject.username)
        end
      end
    end
  end

  describe '#replies' do
    it 'gets replies by the user' do
      VCR.use_cassette 'replies' do
        tweets = subject.replies
        tweets.each do |tweet|
          expect(tweet.user.screen_name).to eq(subject.username)
          expect(tweet.in_reply_to_status_id).not_to be_nil
        end
      end
    end
  end

  def expect_user_collection(collection)
    expect(collection.respond_to?(:map)).to eq(true)
    expect(collection.first.id.to_s).to match(/\d*/)
  end
end
