# TODO get URL to the rest of the poem
module Poetry
  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'

  URLS = {
    base: 'http://www.poetryfoundation.org',
    random: 'http://www.poetryfoundation.org/widget/single_random_poem',
    poem_of_the_day: 'http://www.poetryfoundation.org/widget/home'
  }

  def self.clean_string(str)
    str.gsub("\302\240", ' ').gsub(/[[:space:]]+/, ' ').strip
  end

  def self.load_page(type = :random)
    Nokogiri::HTML(open(URLS[type]))
  end

  def self.get_poem(type = :random)
    page = load_page type
    widg = page.at_css('div.widget-content').at_css('div.single')
    title_a = widg.at_css('.title')

    {
      title:  clean_string(title_a.text),
      author: clean_string(widg.at_css('.sub').text.sub(/^by /i, '')),
      lines:  widg.css('div').map{ |line| clean_string line.text },
      url:    "#{URLS[:base]}#{title_a['href']}"
    }
  end
end
