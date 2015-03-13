module PoetryBot
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'
  require 'twitter'

  MAX_TWEET_LENGTH = 140
  URLS = {
    base:            'http://poetryfoundation.org',
    poem_of_the_day: 'http://poetryfoundation.org/widget/home',
    random:          'http://poetryfoundation.org/widget/single_random_poem'
  }

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
    title_and_link = "... #{poem_hash[:title]} by #{poem_hash[:author]} #{poem_hash[:url]}"
    max_length = MAX_TWEET_LENGTH - title_and_link.length

    # filter lines, join them, and remove a trailing "..."
    lines = filter_lines(poem_hash[:lines]).join("\n").gsub(/\.\.\.\z/, '')
    # make sure we don't exceed max_length
    excerpt = lines[0...max_length]
    # remove cut-off word fragment if applicable
    excerpt = (lines[max_length] || " ").match(/[[:space:]]/) ? excerpt : excerpt.gsub(/[[:space:]]\S*\z/, '')

    "#{excerpt}#{title_and_link}"
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

  extend self
end

tweet = PoetryBot.get_tweet
puts tweet
puts "Length: #{tweet.length} chars"
