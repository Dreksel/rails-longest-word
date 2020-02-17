class GamesController < ApplicationController
  def new
    @letters = []
    alph = ('A'..'Z').to_a
    10.times do
      @letters << alph[rand(0..25)]
    end
  end

  def request_api(url)
    response = Excon.get(
      url,
      headers: {
        'X-RapidAPI-Host' => URI.parse(url).host
      }
    )
    return nil if response.status != 200

    JSON.parse(response.body)
  end

  def find_word(name)
    request_api("https://wagon-dictionary.herokuapp.com/#{name}")
  end

  def score
    new
    @word = find_word(params[:word])
    @found if @word['found'] == true
    @included = @letters.all? { |e| @word['word'].upcase.split('').include?(e) }
    @scored = @word['length'] * 15
  end
end
