shared_examples 'a tweet' do
  let(:max_num_characters) { 140 }

  it 'contains the correct number of characters' do
    expect(tweet.length <= max_num_characters).to eq(true)
  end
end

shared_examples 'a poem scraper' do
  describe '#get_poem_hash' do
    let(:result) { subject.get_poem_hash }

    it 'contains title, author, and URL strings' do
      [:title, :author, :url].each do |k|
        expect(result[k]).to be_a String
      end
    end

    it 'contains an array of lines' do
      expect(result[:lines]).to be_a Array
    end
  end
end
