require 'net/http'

module Poetry
  module Scraper
    class PoetryDotNetScraper < Poetry::Scraper::Base
      BASE_URL = 'http://www.poetry.net'

      private

      def get_url
        response = Net::HTTP.get_response(URI("#{BASE_URL}/random.php"))
        poem_path = response['location']
        [BASE_URL, poem_path].join('')
      end

      def get_title_from_page(page)
        page.at_css('#disp-poem-title').text
      end

      def get_author_from_page(page)
        page.at_css('.author').text
      end

      def get_lines_from_page(page)
        poem_node = page.at_css('#disp-quote-body')
        poem_node.search('br').each do |br|
          br.replace("\n")
        end
        poem_node.text.split("\n")
      end
    end
  end
end
