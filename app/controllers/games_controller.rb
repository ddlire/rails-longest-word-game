require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = []
    10.times { @letters << alphabet.sample }
    @start = Time.now
  end

  def score
    @word = params[:word]
    @start = Time.parse(params[:start])
    @letters = params[:letters].split(' ')
    api_url = 'https://wagon-dictionary.herokuapp.com/'
    result = JSON.parse(URI.open(api_url + @word).read)
    @time = (Time.now - @start).to_f
    condition = true
    @word.upcase.chars.each { |char| condition = false if @word.upcase.chars.count(char) > @letters.count(char) }
    if !result['found']
      @score = 0
      @message = 'Sorry, This is not an english word!'
    elsif condition
      @score = result['length'] + 1 / (1 + @time).to_f
      @message = 'Well done!'
    else
      @score = 0
      @message = "Sorry but #{@word.upcase} cannot be built with #{@letters.join(' ')}"
    end
  end
end
