# allow players to interact with board
class Mastermind
  def initialize
  # number of iterations of the game
  @number_of_games = 0
  # the color codes for the game
  @code = []
  end
  

  # the colors for the game
  COLORS = ["blue", "green", "red", "purple", "yellow", "white"]

  # generate unique color code
  def generate_code
    4.times do 
      color_code = (COLORS - @code).sample
      @code << color_code
    end
    @code
  end
  
  # computer randomly selects the secret colors 
  # human guesses them
  # give proper feedback
  # colored key peg for correct color and position
  # white key peg for correct color in wrong position
  # game lasts 8 - 12 turns
  # this game will include different colors

end

# displays board and gameplay messages
class Display


end

# create the board and keep the game information
class Board

end

# create player and if they are the codemaker or codebreaker
class Player
  # also keeps track of the points made
  # codemaker gets one point for each guess of codebreaker
  # extra point is earned by the codemaker if code is unbroken

end

# calls the main instances of the game
class Main

end

game = Mastermind.new
p game.generate_code