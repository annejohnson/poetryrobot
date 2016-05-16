require './spec/spec_helper.rb'

shared_examples 'a tweet' do
  let(:max_num_characters) { 140 }

  it 'contains the correct number of characters' do
    expect(tweet.length <= max_num_characters).to eq(true)
  end
end

describe Poetry::ContentPreparer do
  describe '#prepare_tweet' do
    let(:tweet) { subject.prepare_tweet }

    it_behaves_like 'a tweet'

    it 'contains a url' do
      expect(tweet).to match(/https?:\/\//i)
    end

    it 'contains an author attribution' do
      expect(tweet).to match(/\S by \S/i)
    end
  end

  describe '#prepare_reply' do
    let(:tweet_to_reply_to) { 'Roses are red, violets are blue #poetry' }
    let(:user_to_reply_to) { 'poetryrobot' }

    let(:tweet) { subject.prepare_reply(tweet_to_reply_to, user_to_reply_to) }

    it_behaves_like 'a tweet'

    it 'contains the user\'s twitter handle' do
      expect(tweet).to match("@#{user_to_reply_to}")
    end
  end

  describe '#topic_search_string' do
    it 'is a poetry-related hashtag' do
      expect(subject.topic_search_string).to match(/\A#poe.*/)
    end
  end
end
