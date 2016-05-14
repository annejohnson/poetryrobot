require './spec/spec_helper.rb'

describe PoetryFoundationRandomPoemScraper do
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
