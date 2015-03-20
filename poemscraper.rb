class PoemScraper
  require 'nokogiri'
  require 'open-uri'

  URLS = {
    base:            'http://poetryfoundation.org',
    poem_of_the_day: 'http://poetryfoundation.org/widget/home',
    random:          'http://poetryfoundation.org/widget/single_random_poem'
  }

  # Remove funky non-ASCII spaces and leading/trailing whitespace
  def clean_string(str)
    str.gsub("\302\240", ' ').gsub(/[[:space:]]+/, ' ').strip
  end

  # Gets a page ready for scraping
  def load_page(url)
    Nokogiri::HTML(open(url))
  end

  # Scrapes a poem (type :random or :poem_of_the_day) from poetryfoundation.org
  # and constructs a poem hash
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
end
