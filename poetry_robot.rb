class PoetryRobot
  require 'twitter'
  require 'yaml'
  load 'poem_scraper.rb'

  MAX_TWEET_LENGTH   = 140
  MAX_SEARCH_RESULTS =  60
  LANGUAGES          = ["en", "fr"]
  MAX_NUM_HASHTAGS   = 3
  MAX_ATTEMPTS       = 2

  def initialize
    @creds = credentials["twitter"]
    @twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key = @creds["consumer_key"]
      config.consumer_secret = @creds["consumer_secret"]
      config.access_token = @creds["access_token"]
      config.access_token_secret = @creds["access_token_secret"]
    end
  end

  def send_tweet(tweet = :random)
    if tweet.is_a? Symbol
      @twitter_client.update create_poem_tweet(tweet)
    elsif tweet.is_a? String
      @twitter_client.update(tweet) if tweet <= MAX_TWEET_LENGTH
      puts("Tweet is too long. Length: #{tweet.length}. Max: #{MAX_TWEET_LENGTH}.") if tweet > MAX_TWEET_LENGTH
    end
  end

  def retweet_a_poet
    attempts = 0
    begin
      @twitter_client.retweet get_recent_tweets(random_hashtag_string).max_by(&:favorite_count).id
    rescue Twitter::Error::Forbidden
      retry if (attempts += 1) < MAX_ATTEMPTS
    end
  end

  def follow_a_poet
    @twitter_client.follow get_recent_tweets(random_hashtag_string).sample.user.id
  end

  def retweet_mentions
    @twitter_client.mentions_timeline.map do |mention|
      begin
        @twitter_client.retweet mention.id
      rescue Twitter::Error::Forbidden # already retweeted
        return # we're finished
      end
    end
  end

  def reply_to_a_poet
    # only reply to original tweets, not retweets
    return unless poem = get_multiline_poem_tweets.reject{ |t| t.retweet? }.sample

    # don't favorite or reply to a tweet if we've already done so
    my_tweets = @twitter_client.user_timeline(@twitter_client.user(@creds["username"]), count: MAX_SEARCH_RESULTS)
    if my_tweets.none?{ |tweet| tweet.in_reply_to_status_id == poem.id }
      @twitter_client.favorite poem
      @twitter_client.update(get_random_encouragement(poem.user.screen_name), in_reply_to_status_id: poem.id)
    end
  end

  def follow_followers
    already_following = @twitter_client.following.map(&:id)
    @twitter_client.followers.each do |follower|
      next if already_following.find{ |id| id == follower.id }
      @twitter_client.follow(follower.id)
    end
  end

private

  def credentials
    YAML.load File.open('twitter.yml'){ |f| f.read }
  end

  def create_poem_tweet(type = :random)
    poem_hash_to_tweet PoemScraper.new.get_poem_hash(type)
  end

  # Removes lines that are only whitespace, a number, or a roman numeral
  def filter_lines(lines)
    lines.reject do |line|
      line.match(/^[[:space:]]*\z/) || # whitespace
      line.match(/^[ivx]+\.?[[:space:]]*\z/i) || # roman numeral
      line.match(/^\d+\.?[[:space:]]*\z/) # number
    end
  end

  def get_random_encouragement(username)
    ["Thank you for tweeting poetry, @#{username}!",
     "@#{username}, you've poetry'd your way to my metal heart"].sample
  end

  def get_multiline_poem_tweets
    get_recent_tweets("#poem").select { |r| r.text.match(/.\n./) }
  end

  # Turns a poem hash into a tweet string
  # example poem_hash: { title: ..., author: ..., lines: [...], url: ... }
  def poem_hash_to_tweet(poem_hash)
    title_and_link = "#{poem_hash[:title]} by #{poem_hash[:author]} #{poem_hash[:url]}"
    max_length = MAX_TWEET_LENGTH - title_and_link.length - "... ".length

    # filter lines, join them, and remove a trailing "..."
    lines = filter_lines(poem_hash[:lines]).join("\n").gsub(/\.\.\.\z/, '')
    # make sure we don't exceed max_length
    excerpt = lines[0...max_length]
    # remove cut-off word fragment if applicable
    excerpt.gsub!(/[[:space:]]\S*\z/, '') unless (lines[max_length] || " ").match(/[[:space:]]/)

    [title_and_link, excerpt + "..."].shuffle.join(" ")
  end

  # A tweet looks spammy if it contains a link plus a fishy word, like "e-book"
  def is_spammy_tweet?(tweet)
    tweet.text.match(/http:\/\//i) &&
    tweet.text.match(/(buy)|(e-?book)|(order)|(press)/i)
  end

  # Gets a bunch of recent tweets that match the query and pass through language, max # hashtags,
  # and spammy filters
  def get_recent_tweets(query)
    results = @twitter_client.search(query, result_type: "recent").take(MAX_SEARCH_RESULTS)
    results.select do |r|
      LANGUAGES.include?(r.lang) &&
      r.text.split.count{ |word| word[0] == '#' } <= MAX_NUM_HASHTAGS
    end.reject{ |t| is_spammy_tweet? t }
  end

  def random_hashtag_string
    "##{['poetry', 'poem'].sample}"
  end
end
