require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
    @letters = []
    10.times { |i| @letters[i] = alphabet.sample }
    session[:passed_variable] = @letters
  end

  def score
    @word = params[:word]
    @letters = session[:passed_variable]

    @result = ""
    if word_hash(@word)["found"] && grid_valid?(@word, @letters)
      @result = "Congratulations #{@word.upcase} is a valid English word"
    else
      @result = word_hash(@word)["found"] ? "Sorry but #{@word.upcase} can't built out of #{@letters.join(",")}" : "Sorry but #{@word.upcase} not an english word"
    end
  end

  private

  def word_hash(attempt)
    url = 'https://wagon-dictionary.herokuapp.com/' + attempt
    return JSON.parse(open(url).read)
  end

  def grid_valid?(attempt, grid)
    attempt_array = attempt.upcase.split("")
    attempt_array.each do |letter|
      if grid.include? letter
        grid.delete_at(grid.index(letter))
      else return false
      end
    end
    return true
  end
end
