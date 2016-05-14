require './string_cleaner.rb'

describe StringCleaner do
  describe '#clean' do
    let(:dirty_string) { " \t cray  string \n" }
    let(:clean_string) { 'cray string' }
    let(:result) { subject.clean(dirty_string) }

    it 'removes extra whitespace off a string' do
      expect(result).to eq(clean_string)
    end
  end
end
