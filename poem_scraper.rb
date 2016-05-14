require 'nokogiri'
require 'open-uri'
require './hash_cleaner.rb'

class PoemScraper
  attr_reader :hash_cleaner

  def initialize
    @hash_cleaner = HashCleaner.new
  end

  def get_poem_hash
    clean_result(
      get_raw_poem_hash
    )
  end

  def get_raw_poem_hash
    raise 'Please implement in a child class'
  end

  private

  def clean_result(result)
    hash_cleaner.clean(result)
  end
end
