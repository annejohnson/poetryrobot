require 'open-uri'
require 'nokogiri'

module Poetry
  module Scraper
    class Base
      MAX_ATTEMPTS = 10

      def initialize
        @hash_cleaner = Utils::HashCleaner.new
      end

      def get_poem_hash
        clean_result(
          get_raw_poem_hash
        )
      end

      private

      attr_reader :hash_cleaner

      def get_url
        raise NotImplementedError.new 'Please implement in a child class'
      end

      def get_title_from_page(page)
        raise NotImplementedError.new 'Please implement in a child class'
      end

      def get_author_from_page(page)
        raise NotImplementedError.new 'Please implement in a child class'
      end

      def get_lines_from_page(page)
        raise NotImplementedError.new 'Please implement in a child class'
      end

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

      def get_page(url)
        attempts = 0
        begin
          Nokogiri::HTML(open(url))
        rescue OpenURI::HTTPError
          attempts += 1
          retry if attempts < MAX_ATTEMPTS
        end
      end

      def clean_result(result)
        hash_cleaner.clean(result)
      end
    end
  end
end
