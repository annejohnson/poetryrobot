require_relative 'poem_scraper.rb'
require 'open-uri'
require 'nokogiri'

class PoetryFoundationRandomPoemScraper < PoemScraper
  BASE_URL = 'http://www.poetryfoundation.org'.freeze

  MIN_ID = 43000
  MAX_ID = 49990

  MAX_ATTEMPTS = 10

  def get_raw_poem_hash
    url = get_url
    page = get_page(url)

    {
      title: get_title_from_page(page),
      author: get_author_from_page(page),
      url: url,
      lines: get_lines_from_page(page)
    }
  end

  private

  def get_page(url)
    attempts = 0
    begin
      Nokogiri::HTML(open(url))
    rescue OpenURI::HTTPError
      attempts += 1
      retry if attempts < MAX_ATTEMPTS
    end
  end

  def get_url
    "#{BASE_URL}/poetrymagazine/poems/detail/#{random_poem_id}"
  end

  def random_poem_id
    (MIN_ID..MAX_ID).to_a.sample
  end

  def get_title_from_page(page)
    page.at_css('.detail-hd .hdg').text
  end

  def get_author_from_page(page)
    page.at_css('.detail-byline .hdg a').text
  end

  def get_lines_from_page(page)
    page.css('.poem div').map(&:text)
  end
end
