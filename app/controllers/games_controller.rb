require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = (1..10).map { ('a'..'z').to_a[rand(26)] }.join.upcase.split('')
  end

  def score
    english_word?(params[:word])
    # p can_build_word?(@letters, params[:word])
    @output = if english_word?(params[:word])
                if word_in_grid?(params[:word], @letters)
                  "Congratulations, #{params[:word]} is a valid English word"
                else
                  "Sorry but #{params[:word]} can't be build out of #{@letters.join(',')}"
                end
              else
                "Sorry but #{params[:word]} doesn't seem to be an English word"
              end
  end

  def word_in_grid?(word, grid)
    word.upcase.split('').each do |letter|
      return false unless grid.include?(letter)

      grid.delete_at(grid.index(letter))
    end
    true
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    p JSON.parse(open(url).read)["found"]
  end
end
