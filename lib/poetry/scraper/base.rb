module Poetry
  module Scraper
    class Base
      def initialize
        @hash_cleaner = Utils::HashCleaner.new
      end

      def get_poem_hash
        clean_result(
          get_raw_poem_hash
        )
      end

      def get_raw_poem_hash
        raise NotImplementedError.new('Please implement in a child class')
      end

      private

      attr_reader :hash_cleaner

      def clean_result(result)
        hash_cleaner.clean(result)
      end
    end
  end
end
