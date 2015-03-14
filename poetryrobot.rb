module PoetryRobot
  require 'nokogiri'
  require 'open-uri'
  require 'twitter'
  require 'yaml'

  MAX_TWEET_LENGTH = 140
  URLS = {
    base:            'http://poetryfoundation.org',
    poem_of_the_day: 'http://poetryfoundation.org/widget/home',
    random:          'http://poetryfoundation.org/widget/single_random_poem'
  }

  def credentials
    YAML.load File.open('twitter.yml'){ |f| f.read }
  end

  def twitter_client
    creds = credentials["twitter"]

    Twitter::REST::Client.new do |config|
      config.consumer_key = creds["consumer_key"]
      config.consumer_secret = creds["consumer_secret"]
      config.access_token = creds["access_token"]
      config.access_token_secret = creds["access_token_secret"]
    end
  end

  def clean_string(str)
    str.gsub("\302\240", ' ').gsub(/[[:space:]]+/, ' ').strip
  end

  def load_page(url)
    Nokogiri::HTML(open(url))
  end

  def get_poem(type = :random)
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

  def poem_to_tweet(poem_hash)
    title_and_link = "#{poem_hash[:title]} by #{poem_hash[:author]} #{poem_hash[:url]}"
    max_length = MAX_TWEET_LENGTH - title_and_link.length - "... ".length

    # filter lines, join them, and remove a trailing "..."
    lines = filter_lines(poem_hash[:lines]).join("\n").gsub(/\.\.\.\z/, '')
    # make sure we don't exceed max_length
    excerpt = lines[0...max_length]
    # remove cut-off word fragment if applicable
    excerpt = (lines[max_length] || " ").match(/[[:space:]]/) ? excerpt : excerpt.gsub(/[[:space:]]\S*\z/, '')

    [title_and_link, excerpt + "..."].shuffle.join(" ")
  end

  def filter_lines(lines)
    lines.reject do |line|
      # reject a line if it's only whitespace, a number, or a roman numeral
      line.match(/^[[:space:]]*\z/) || line.match(/^[ivx]+\.?[[:space:]]*\z/i) || line.match(/^\d+\.?[[:space:]]*\z/)
    end
  end

  def get_tweet(type = :random)
    poem_to_tweet get_poem(type)
  end

  def send_tweet(type = :random)
    twitter_client.update get_tweet(type)
  end

  def get_recent_tweet
    client = twitter_client
    results = client.search("#poetry", result_type: "recent").take(30)
    results.max_by &:favorite_count
  end

  def retweet
    twitter_client.retweet get_recent_tweet.id
  end

  def follow
    twitter_client.follow get_recent_tweet.user.id
  end

  extend self
end
