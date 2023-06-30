# allow players to interact with board
class Mastermind
  attr_accessor :guesses, :code
  def initialize(player, code = [])
  # number of iterations of the game
  @number_of_games = 0
  # the color codes for the game
  # since code is kept on the board I won't need it here
  # remove later
  @code = code
  @player = player
  # will guesses also be kept on the board
  @guesses = []
  @matches = []
  end
  
  def player
    @player
  end

  # the colors for the game
  COLORS = ["blue", "green", "red", "purple", "yellow", "white"]
  
  # computer randomly selects the secret colors 
  # generate unique color code
  def generate_code
    4.times do 
      color_code = (COLORS - @code).sample
      @code << color_code
    end
    @code
  end
  
  
  # human guesses them
  def human_guesses
    tries = ["first", "second", "third", "fourth"]
    4.times do
      current_try = tries.shift
      p "Input your #{current_try} code."
      answer = gets.chomp.downcase
      until COLORS.include?(answer)
        p "Incorrect color. Please try again using the colors: #{COLORS}"
        answer = gets.chomp.downcase
      end
      @guesses << answer
    end
    @guesses
  end

  def check_matches
    # create temporary array for guesses
    duplicate_guesses = @guesses.dup
    duplicate_code = @code.dup
    # reset the matches
    @matches = []
    (0..3).each do |i|
      # take each number and check both arrays
      if @code[i] == @guesses[i]
        # delete the correct guess and code from the duplicate array
        duplicate_guesses.delete(@guesses[i])
        duplicate_code.delete(@code[i])
        # add to the matches array
        @matches << "color"
      end
    end
    # check the temp_guesses array to see if any colors match
    if duplicate_guesses
      duplicate_guesses.each do |guess|
        if duplicate_code.include?(guess)
          @matches << "white"
        end
      end
    end
    # return an array with how many colored pegs vs white
    @matches
  end
  # give proper feedback
  # colored key peg for correct color and position
  # white key peg for correct color in wrong position
  # game lasts 12 turns
  # this game will include different colors
  def game_over?(guesses)
    # checks the number of guesses
    if guesses.length >= 12
      true
    end
  end
end

# displays board and gameplay messages
class Display


end

# create the board and keep the game information
class Board
  def initialize(code)
    @code = code
    @guesses = []
  end

  # use to see the current guesses of the game
  def guesses
    @guesses
  end

  # takes an array and adds it to the board
  def add_guess(guess)
    @guesses << guess
  end
  # create a board that holds the code
  # hold the guesses 
  # check if the collected guesses are longer than 12
  # after that game over

end

# create player and if they are the codemaker or codebreaker
class Player
  def initialize(maker_or_breaker)
    if maker_or_breaker == "breaker"
      @role = "breaker"
    else
      @role = "maker"
    end
  end
  # also keeps track of the points made
  # codemaker gets one point for each guess of codebreaker
  # extra point is earned by the codemaker if code is unbroken

end

# calls the main instances of the game
class Main

end
player = Player.new("breaker")
game = Mastermind.new(player)
game.code = ["white", "red", "blue", "green"]
game.player
game.guesses = ["purple", "yellow", "white", "purple"]
game.check_matches
p board = Board.new(game.code)
12.times { board.add_guess(game.guesses) }
p board.guesses
p game.game_over?(board.guesses)