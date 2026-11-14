require 'rails_helper'

describe Movie do
  describe 'searching TMDB by keyword' do
    it 'calls Faraday gem' do
      expect(Faraday).to receive(:get)
      Movie.find_in_tmdb('https://nyu.edu')
    end
  end
end