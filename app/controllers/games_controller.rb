require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    alphabet = ("A".."Z").to_a
    @letters = Array.new(10) { alphabet.sample }
  end

 def score
    @word = (params[:word] || "").upcase
    @grid = params[:letters].split # On transforme la chaîne reçue en Array

    if !included?(@word, @grid)
      @message = "Désolé, mais **#{@word}** ne peut pas être fait avec #{@grid.join(', ')}"
    elsif !english_word?(@word)
      @message = "Désolé, mais **#{@word}** n'est pas un mot anglais valide."
    else
      @message = "Félicitations ! **#{@word}** est un mot anglais valide !"
    end
  end

  private

  def included?(word, letters)
    # Vérifie si chaque lettre du mot est dans la grille (en comptant les occurrences)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    # Appel à l'API du dictionnaire
    response = URI.open("https://dictionary.lewagon.com/#{word}")
    json = JSON.parse(response.read)
    json["found"]
  end
end
