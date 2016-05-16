shared_examples 'a tweet' do
  let(:max_num_characters) { 140 }

  it 'contains the correct number of characters' do
    expect(tweet.length <= max_num_characters).to eq(true)
  end
end
