require './spec/spec_helper.rb'

describe Poetry::Scraper::PoetryFoundationScraper do
  before { skip 'pending a more reliable way to fetch random poem URLs' }

  it_behaves_like 'a poem scraper'
end
