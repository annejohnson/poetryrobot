class TwitterTopicRobot
  def initialize(twitter_content_preparer, credentials)
    @twitter_content_preparer = twitter_content_preparer
    @twitter_client = Twitter::Client.new(credentials)
  end

  def tweet
    twitter_client.tweet(
      twitter_content_preparer.prepare_tweet
    )
  end

  def retweet_someone
    twitter_client.retweet(tweet_to_retweet)
  end

  def follow_someone
    twitter_client.follow(user_to_follow)
  end

  def retweet_mentions
    twitter_client.mentions.map do |mention|
      break unless twitter_client.retweet(mention)
    end
  end

  def reply_to_someone
    tweet = tweet_to_reply_to
    reply = twitter_content_preparer.prepare_reply(
              tweet.text,
              tweet.user.screen_name
            )

    twitter_client.favorite(tweet)
    twitter_client.tweet(
      reply,
      in_reply_to_status_id: tweet.id
    )
  end

  def follow_followers
    already_following_user_ids = twitter_client.following.map(&:id)
    twitter_client.followers.each do |follower|
      next if already_following_user_ids.include?(follower.id)
      twitter_client.follow(follower)
    end
  end

  private

  attr_reader :twitter_content_preparer, :twitter_client

  def tweet_to_retweet
    get_topic_tweets.max_by(&:favorite_count)
  end

  def user_to_follow
    get_topic_tweets.sample.user
  end

  def tweet_to_reply_to
    tweet_ids_already_replied_to = twitter_client.replies.map(&:in_reply_to_status_id)

    get_multiline_tweets.reject do |tweet|
      tweet_ids_already_replied_to.include?(tweet.id)
    end.reject(&:retweet?).sample
  end

  def get_topic_tweets
    twitter_client.search_recent_tweets(
      twitter_content_preparer.topic_search_string
    )
  end

  def get_multiline_tweets
    linebreak = /.\n./
    get_topic_tweets.select { |r| r.text.match(linebreak) }
  end
end
