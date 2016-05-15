require_relative 'poetry_foundation_random_poem_scraper.rb'
require_relative 'twitter_wrapper.rb'

class PoetryRobot
  attr_reader :poem_scraper, :twitter_client

  def initialize
    @poem_scraper = PoetryFoundationRandomPoemScraper.new
    @twitter_client = TwitterWrapper.new
  end

  def tweet_poem
    twitter_client.tweet(create_poem_tweet)
  end

  def retweet_a_poet
    twitter_client.retweet(
      twitter_client.search_recent_tweets(random_hashtag_string).
                     max_by(&:favorite_count)
    )
  end

  def follow_a_poet
    twitter_client.follow(
      twitter_client.search_recent_tweets(random_hashtag_string).
                     sample.
                     user
    )
  end

  def retweet_mentions
    twitter_client.mentions.map do |mention|
      break unless twitter_client.retweet(mention)
    end
  end

  def reply_to_a_poet
    poem_tweet = get_multiline_poem_tweets.reject(&:retweet?).
                                           sample
    return unless poem_tweet

    tweet_ids_already_replied_to = twitter_client.reply_tweets.map(&:in_reply_to_status_id)
    unless tweet_ids_already_replied_to.include?(poem_tweet.id)
      twitter_client.favorite(poem_tweet)
      twitter_client.tweet(
        get_random_encouragement(poem_tweet.user.screen_name),
        in_reply_to_status_id: poem_tweet.id
      )
    end
  end

  def follow_followers
    already_following_user_ids = twitter_client.following.map(&:id)
    twitter_client.followers.each do |follower|
      next if already_following_user_ids.include?(follower.id)
      twitter_client.follow(follower)
    end
  end

  def create_poem_tweet
    poem_hash_to_tweet(poem_scraper.get_poem_hash)
  end

  private

  def poem_hash_to_tweet(poem_hash)
    title_and_link = "#{poem_hash[:title]} by #{poem_hash[:author]} #{poem_hash[:url]}"
    max_excerpt_length = twitter_client.max_tweet_length -
                           title_and_link.length -
                           '... '.length

    # filter lines, join them, and remove a trailing "..."
    excerpt = filter_lines(poem_hash[:lines]).
                join("\n").
                gsub(/\.\.\.\z/, '')
    # make sure we don't exceed max_length
    excerpt = excerpt[0...max_excerpt_length]
    # remove cut-off word fragment if applicable
    last_character = (excerpt[max_excerpt_length] || ' ')
    unless last_character.match(/[[:space:]]/)
      trailing_space_and_word_fragment = /[[:space:]]\S*\z/
      excerpt = excerpt.gsub(trailing_space_and_word_fragment, '')
    end

    [title_and_link, (excerpt + '...')].
      shuffle.
      join(' ')
  end

  def filter_lines(lines)
    lines.reject do |line|
      line.match(/^[ivx]+\.?[[:space:]]*\z/i) || # roman numeral
        line.match(/^\d+\.?[[:space:]]*\z/) # number
    end
  end

  def get_random_encouragement(username)
    [
      "Thank you for tweeting poetry, @#{username}!",
      "@#{username}, you've poetry'd your way to my metal heart"
    ].sample
  end

  def get_multiline_poem_tweets
    twitter_client.search_recent_tweets('#poem').
                   select { |r| r.text.match(/.\n./) }
  end

  def random_hashtag_string
    '#' + ['poetry', 'poem'].sample
  end
end
