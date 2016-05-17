module Poetry
  module Scraper
    class PoetryFoundationScraper < Poetry::Scraper::Base
      BASE_URL = 'http://www.poetryfoundation.org'.freeze

      MIN_ID = 43000
      MAX_ID = 49990

      private

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
  end
end
