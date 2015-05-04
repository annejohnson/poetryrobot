require 'minitest/autorun'
load "#{__dir__}/../poem_scraper.rb"

class TestPoemScraper < MiniTest::Unit::TestCase
  def setup
    @scraper = ::PoemScraper.new
  end

  def test_clean_string
    assert_equal "cray string", @scraper.clean_string(" \t cray  string \n")
  end

  def test_load_page
    pg = @scraper.load_page('http://poetryfoundation.org')
    assert_instance_of Nokogiri::HTML::Document, pg
    assert_equal "Poetry Foundation", pg.title
  end

  def test_get_poem_hash
    poem_hash = @scraper.get_poem_hash
    assert_equal poem_hash.keys.sort, [:author, :lines, :title, :url].sort
    validate_url poem_hash[:url]
    validate_lines poem_hash[:lines]

    poem_hash.values.select { |val| val.is_a? String }.each do |val|
      refute_empty val.strip
    end
  end

private

  def validate_lines(lines)
    assert_instance_of Array, lines
    refute_empty lines
  end

  def validate_url(url)
    assert_match /^https?:\/\/[\S]+/i, url
  end
end
