require_relative 'twitter_content_preparer.rb'
require_relative 'poetry_foundation_random_poem_scraper.rb'

class PoetryContentPreparer < TwitterContentPreparer
  def prepare_tweet
    poem_hash_to_tweet(get_poem_hash)
  end

  def prepare_reply(tweet_to_reply_to, user_to_reply_to)
    [
      "Thank you for tweeting poetry, @#{user_to_reply_to}!",
      "@#{user_to_reply_to}, you've poetry'd your way to my metal heart"
    ].sample
  end

  def topic_search_string
    '#' + ['poetry', 'poem'].sample
  end

  private

  def poem_scraper
    PoetryFoundationRandomPoemScraper.new
  end

  def get_poem_hash
    poem_scraper.get_poem_hash
  end

  def poem_hash_to_tweet(poem_hash)
    excerpt_suffix = '...'
    component_separator = ' '
    attribution = poem_hash_to_attribution(poem_hash)

    max_excerpt_length = MAX_TWEET_LENGTH -
                           attribution.length -
                           excerpt_suffix.length -
                           component_separator.length
    excerpt = poem_hash_to_excerpt(poem_hash, max_excerpt_length) +
                excerpt_suffix

    [attribution, excerpt].
      shuffle.
      join(component_separator)
  end

  def poem_hash_to_attribution(poem_hash)
    "#{poem_hash[:title]} by #{poem_hash[:author]} #{poem_hash[:url]}"
  end

  def poem_hash_to_excerpt(poem_hash, max_length)
    excerpt = filter_lines(poem_hash[:lines]).
                join("\n").
                gsub(/\.\.\.\z/, '') # remove a trailing '...'

    truncate_string(excerpt, max_length)
  end

  def filter_lines(lines)
    lines.reject do |line|
      line.match(/^[ivx]+\.?[[:space:]]*\z/i) || # roman numeral
        line.match(/^\d+\.?[[:space:]]*\z/) # number
    end
  end

  def truncate_string(str, max_length)
    str = str[0...max_length]

    last_character = (str[max_length] || ' ')
    if last_character.match(/[[:space:]]/)
      str.strip
    else
      # remove a possible cut-off word fragment
      trailing_space_and_word_fragment = /[[:space:]]+\S*\z/
      str.gsub(trailing_space_and_word_fragment, '')
    end
  end
end
