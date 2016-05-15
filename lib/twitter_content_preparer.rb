class TwitterContentPreparer
  MAX_TWEET_LENGTH = 140

  def prepare_tweet
    raise NotImplementedError.new 'Please implement in a child class'
  end

  def prepare_reply(tweet_to_reply_to, user_to_reply_to)
    raise NotImplementedError.new 'Please implement in a child class'
  end

  def topic_search_string
    raise NotImplementedError.new 'Please implement in a child class'
  end
end
