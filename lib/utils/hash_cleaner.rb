module Utils
  class HashCleaner
    def initialize
      @string_cleaner = Utils::StringCleaner.new
    end

    def clean(h)
      h.inject({}) do |new_h, (k, val)|
        if val.is_a?(String)
          new_h[k] = clean_string(val)
        elsif val.respond_to?(:map)
          new_h[k] = clean_string_collection(val)
        else
          new_h[k] = val
        end
        new_h
      end
    end

    private

    attr_reader :string_cleaner

    def clean_string_collection(str_collection)
      str_collection.map { |str| clean_string(str) }.
                     reject { |str| str == '' }
    end

    def clean_string(str)
      string_cleaner.clean(str)
    end
  end
end
