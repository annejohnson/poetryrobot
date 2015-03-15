class PoetryRobot
  require 'nokogiri'
  require 'open-uri'
  require 'twitter'
  require 'yaml'

  attr_reader :twitter_client

  MAX_TWEET_LENGTH   = 140
  MAX_SEARCH_RESULTS =  60
  LANGUAGES          = ["en", "fr"]
  MAX_NUM_HASHTAGS   = 3
  MAX_ATTEMPTS       = 3

  URLS = {
    base:            'http://poetryfoundation.org',
    poem_of_the_day: 'http://poetryfoundation.org/widget/home',
    random:          'http://poetryfoundation.org/widget/single_random_poem'
  }

  def initialize
    @creds = credentials["twitter"]
    @twitter_client = Twitter::REST::Client.new do |config|
      config.consumer_key = @creds["consumer_key"]
      config.consumer_secret = @creds["consumer_secret"]
      config.access_token = @creds["access_token"]
      config.access_token_secret = @creds["access_token_secret"]
    end
  end

  # Remove funky non-ASCII spaces and leading/trailing whitespace
  def clean_string(str)
    str.gsub("\302\240", ' ').gsub(/[[:space:]]+/, ' ').strip
  end

  # Gets a page ready for scraping
  def load_page(url)
    Nokogiri::HTML(open(url))
  end

  # Scrapes a poem and constructs a poem hash
  def get_poem_hash(type = :random)
    raise "Invalid poem type #{type}" unless [:random, :poem_of_the_day].include?(type)

    page    = load_page URLS[type]
    widg    = page.at_css('div.widget-content').at_css('div.single')
    title_a = widg.at_css('.title')

    {
      title:  clean_string(title_a.text),
      author: clean_string(widg.at_css('.sub').text.sub(/^by /i, '')),
      lines:  widg.css('div').map{ |line| clean_string line.text },
      url:    "#{URLS[:base]}#{title_a['href']}"
    }
  end

  # Removes lines that are only whitespace, a number, or a roman numeral
  def filter_lines(lines)
    lines.reject do |line|
      line.match(/^[[:space:]]*\z/) || # whitespace
      line.match(/^[ivx]+\.?[[:space:]]*\z/i) || # roman numeral
      line.match(/^\d+\.?[[:space:]]*\z/) # number
    end
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

  def get_poem_tweet(type = :random)
    poem_hash_to_tweet get_poem_hash(type)
  end

  def send_tweet(tweet = :random)
    if tweet.is_a? Symbol
      @twitter_client.update get_poem_tweet(tweet)
    elsif tweet.is_a? String
      @twitter_client.update(tweet) if tweet <= MAX_TWEET_LENGTH
      puts("Tweet is too long. Length: #{tweet.length}. Max: #{MAX_TWEET_LENGTH}.") if tweet > MAX_TWEET_LENGTH
    end
  end

  def get_recent_tweets(query)
    results = @twitter_client.search(query, result_type: "recent").take(MAX_SEARCH_RESULTS)
    results.select do |r|
      LANGUAGES.include?(r.lang) &&
      r.text.split.count{ |word| word[0] == '#' } <= MAX_NUM_HASHTAGS
    end
  end

  def random_query_string
    "##{['poetry', 'poem', 'haiku', 'spokenword', 'micropoem', 'micropoetry'].sample}"
  end

  def retweet
    attempts = 0
    begin
      @twitter_client.retweet get_recent_tweets(random_query_string).sample.id
    rescue Twitter::Error::Forbidden
      retry if (attempts += 1) < MAX_ATTEMPTS
    end
  end

  def follow
    @twitter_client.follow get_recent_tweets(random_query_string).max_by(&:favorite_count).user.id
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

  def get_multiline_poem_tweets
    get_recent_tweets("#poem").select { |r| r.text.match(/.\n./) }
  end

  def reply_to_a_poem
    return unless poem = get_multiline_poem_tweets.sample

    # don't favorite+reply to a tweet if we've already done so
    my_tweets = @twitter_client.user_timeline(@twitter_client.user(@creds["username"]), count: MAX_SEARCH_RESULTS)
    if my_tweets.select{ |tweet| tweet.in_reply_to_status_id == poem.id }.empty?
      @twitter_client.favorite poem
      @twitter_client.update("Thank you for tweeting poetry, @#{poem.user.screen_name}!", in_reply_to_status_id: poem.id )
    end
  end

private

  def credentials
    YAML.load File.open('twitter.yml'){ |f| f.read }
  end
end
