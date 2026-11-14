class Movie < ApplicationRecord
  def self.all_ratings
    %w[G PG PG-13 R]
  end

  def self.with_ratings(ratings, sort_by)
    if ratings.nil?
      all.order sort_by
    else
      where(rating: ratings.map(&:upcase)).order sort_by
    end
  end
  def self.find_in_tmdb(opts)
    title = opts[:title]
    release_year = opts[:release_year]
    language = opts[:language]

    query = { api_key: ENV['TMDB_API_KEY'], query: title }
    query[:year] = release_year if release_year.present?
    query[:language] = 'en-US' if language == 'en'

    url = "https://api.themoviedb.org/3/search/movie?#{URI.encode_www_form(query)}"
    response = Faraday.get(url)
    data = JSON.parse(response.body)

    (data['results'] || []).map do |r|
      Movie.new(
        title: r['title'],
        release_date: r['release_date'].present? ? Date.parse(r['release_date']) : nil,
        description: r['overview'],
        rating: 'R'
      )
    end
  end
end
