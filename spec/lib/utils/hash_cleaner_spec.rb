require './spec/spec_helper.rb'

describe Utils::HashCleaner do
  describe '#clean' do
    let(:dirty_hash) do
      {
        title: "  Hello world!   \n  \t ",
        lines: ['', 'How are you?  ', " \n Good, thanks"],
        pages: 5
      }
    end

    let(:clean_hash) do
      {
        title: 'Hello world!',
        lines: ['How are you?', 'Good, thanks'],
        pages: 5
      }
    end

    let(:result) do
      subject.clean(dirty_hash)
    end

    it 'cleans its string and array values' do
      expect(result).to eq(clean_hash)
    end
  end
end
