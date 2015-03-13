# TODO filter out boring lines like I.
module PoetryBot
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'
  require 'twitter'

  URLS = {
    base:            'http://www.poetryfoundation.org',
    poem_of_the_day: 'http://www.poetryfoundation.org/widget/home',
    random:          'http://www.poetryfoundation.org/widget/single_random_poem'
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

  def poem_to_string(poem_hash)
    [ poem_hash[:title], "By #{poem_hash[:author]}" ].concat(poem_hash[:lines]).join('\n')
  end

  def poem_to_tweet(poem_hash)
    " #{poem_hash[:url]}"
  end

  def filter_lines(lines)
    lines.reject do |line|
      line.gsub(/[[:space:]]+/, '').empty?
    end
  end

  extend self
end

poem = PoetryBot.poem_to_string(PoetryBot.get_poem)
puts "#{poem.length}\n\n"
poem.each_line('\n'){ |l| puts l }
