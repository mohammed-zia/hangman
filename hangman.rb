require 'set'
require 'pp'
require 'colorize'

class Board
  attr_accessor :board
  def initialize(size)
    @board = []
    size.times do
      @board << '_'
    end
  end

  def print_board
    puts "CURRENT BOARD: ".colorize(:green)
    p @board
  end

  def update_board(index, val)
    @board[index] = val
  end

end




class Game
  def initialize
    @round = 0
    @guesses = []
    @characters = [*('a'..'z')]
    @incorrect_guesses = []
    @selected_word = random_word
    @selected_word_chars = @selected_word.split('')
    @current_guess = ""
    board_size = @selected_word.length
    @board = Board.new(board_size)
    # puts board_size
    start_game
  end

  def random_word
    word_arr = []
    words = File.open("google-10000-english-no-swears.txt", "r")
    words.each do |line|
      line = line.strip
      if line.length > 5 && line.length < 12
        word_arr << line
      end
    end
    word_arr.sample
  end

  def make_guess
    puts "Enter a character"
    input = gets.chomp
    input = input.downcase.strip
      if @characters.include?(input) && input.length == 1
        # puts "Allowed"
        @guesses << input
        @current_guess = input
      else
        puts "Please enter one alphabetical character (No numbers or special characters)"
        make_guess
      end
  end

  def valid_guess?(current_guess)
    if @incorrect_guesses.include?(current_guess) || @board.board.include?(current_guess)
      return false
    else
      return true
    end
  end

  def check_guess(current_guess)
      @selected_word_chars.each_with_index do |val, index|
        if current_guess == val
          @board.update_board(index, val)
        end
      end
      unless @selected_word_chars.include?(current_guess)
        @incorrect_guesses << current_guess
      end
  end
  

  def game_won?(board)
    if board.board == @selected_word_chars
      puts "GAME WON".colorize(:yellow)
      exit
    end
  end

  def play_round(board, round)
    make_guess
    if valid_guess?(@current_guess)
      check_guess(@current_guess)
      puts "INCORRECT GUESSES: ".colorize(:red)
      p @incorrect_guesses
      board.print_board
    else
      puts "You've already made that guess, try again"
      play_round(board, round)
    end
  end
  
  def start_game
    puts "Let's play Hangman!"
    sleep(1)
    puts "The CPU has chosen a random word between 5 and 12 characters (exclusive)"
    sleep(1)
    puts "You have 15 rounds to figure out the word by entering one character at a time"
    sleep(1)
    puts "You will be shown which characters are in the word and which aren't"
    sleep(1)
    @board.print_board
    while @round < 15
      puts "It's round #{@round + 1}".colorize(:light_blue)
      play_round(@board, @round)
      game_won?(@board)
      @round += 1
    end
    puts "YOU LOSE!".colorize(:red)
    puts "The word was #{@selected_word}".colorize(:yellow)
  end
end

Game.new
