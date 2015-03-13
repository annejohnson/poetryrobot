# TODO get URL to the rest of the poem
module Poetry
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'

  URLS = {
    random: 'http://www.poetryfoundation.org/widget/single_random_poem',
    poem_of_the_day: 'http://www.poetryfoundation.org/widget/home'
  }

  def self.clean_and_strip(str)
    str.gsub("\302\240", ' ').gsub(/[[:space:]]+/, ' ').strip
  end

  def self.load_page(type = :random)
    Nokogiri::HTML(open(URLS[type]))
  end

  def self.get_poem(type = :random)
    page = load_page type

    widg = page.css('div.widget-content')[0].at_css('div.single')

    title  = clean_and_strip widg.css('.title')[0].text
    author = clean_and_strip widg.css('.sub')[0].text.sub(/^by /i, '')
    lines  = widg.css('div').map{ |line| clean_and_strip line.text }

    {
      lines: lines,
      title: title,
      author: author
    }
  end
end
