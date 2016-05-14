require './spec/spec_helper.rb'

describe TweetFilterer do
  describe '#acceptable_tweet?' do
    context 'when a tweet contains bad words' do
      let(:tweet_with_bad_words) { 'Fuck you, asshole!' }

      it 'returns false' do
        expect(
          subject.acceptable_tweet?(tweet_with_bad_words)
        ).to eq(false)
      end
    end

    context 'when a tweet contains several mentions' do
      let(:tweet_with_mentions) { 'Thx 4 the retweets, @bobbybrown @poetryrobot @depaysant' }

      it 'returns false' do
        expect(
          subject.acceptable_tweet?(tweet_with_mentions)
        ).to eq(false)
      end
    end

    context 'when a tweet contains several hashtags' do
      let(:tweet_with_hashtags) { 'look what I cooked! #recipe #brownies #baking #YUM' }

      it 'returns false' do
        expect(
          subject.acceptable_tweet?(tweet_with_hashtags)
        ).to eq(false)
      end
    end

    context 'when a tweet is trying to sell something' do
      let(:sales_tweet) { 'Please buy my newest online tutorial - http://refactoring.com !' }

      it 'returns false' do
        expect(
          subject.acceptable_tweet?(sales_tweet)
        ).to eq(false)
      end
    end

    context 'when a tweet contains a link' do
      let(:tweet_with_link) { 'New blog post: making a ruby gem! http://happydev.com/ruby-gem' }

      context 'when links are allowed' do
        it 'returns true' do
          expect(
            subject.acceptable_tweet?(tweet_with_link)
          ).to eq(true)
        end
      end

      context 'when links are not allowed' do
        it 'returns false' do
          expect(
            subject.acceptable_tweet?(tweet_with_link, allow_links: false)
          ).to eq(false)
        end
      end
    end
  end
end
