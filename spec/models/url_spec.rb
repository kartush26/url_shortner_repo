require 'rails_helper'

RSpec.describe Url, type: :model do

  describe 'validations' do
    it 'is valid with a valid long_url' do
      url = Url.new(long_url: 'https://www.example.com')
      expect(url).to be_valid
    end

    it 'is invalid without a long_url' do
      url = Url.new(long_url: nil)
      expect(url).not_to be_valid
      expect(url.errors[:long_url]).to include("can't be blank")
    end
  end

  describe 'callbacks' do
    it 'generates a short_url before creation' do
      url = Url.create(long_url: 'https://www.example.com')
      expect(url.short_url).to be_present
      expect(url.short_url.length).to eq(6)
    end

    it 'generates a unique short_url' do
      url1 = Url.create(long_url: 'https://www.example1.com')
      url2 = Url.create(long_url: 'https://www.example2.com')
      expect(url1.short_url).not_to eq(url2.short_url)
    end
  end
end
