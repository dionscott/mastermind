# allow players to interact with board
class Mastermind
  attr_accessor :guesses, :code
  def initialize(player)
  # number of iterations of the game
  @number_of_games = 0
  # the color codes for the game
  # since code is kept on the board I won't need it here
  # remove later
  @player = player
  end
  
  def player
    @player
  end

  # the colors for the game
  COLORS = ["blue", "green", "red", "purple", "yellow", "white"]
  
  # computer randomly selects the secret colors 
  # generate unique color code
  def generate_code
    code = []
    4.times do 
      color_code = (COLORS - code).sample
      code << color_code
    end
    code
  end
  
  # generate random colors
  def generate_random_colors
    random_colors = []
    4.times  do
      color_code = COLORS.sample
      random_colors << color_code
    end
    random_colors
  end

  
  # takes input and returns guesses array
  def human_guesses
    tries = ["first", "second", "third", "fourth"]
    guesses = []
    4.times do
      current_try = tries.shift
      p "Input your #{current_try} code."
      answer = gets.chomp.downcase
      until COLORS.include?(answer)
        p "Incorrect color. Please try again using the colors: #{COLORS}"
        answer = gets.chomp.downcase
      end
      guesses << answer
    end
    guesses
  end

  # checks for matches and returns an array with pegs
  def check_matches(code, guesses)
    # create temporary array for guesses
    duplicate_guesses = guesses.dup
    duplicate_code = code.dup
    # reset the matches
    matching_pegs = []
    (0..3).each do |i|
      # take each number and check both arrays
      if code[i] == guesses[i]
        # delete the correct guess and code from the duplicate array
        duplicate_guesses.delete(guesses[i])
        duplicate_code.delete(code[i])
        # add to the matches array
        matching_pegs << "colored"
      end
    end
    # check the temp_guesses array to see if any colors match
    if duplicate_guesses
      duplicate_guesses.each do |guess|
        if duplicate_code.include?(guess)
          matching_pegs << "white"
        end
      end
    end
    # return an array with how many colored pegs vs white
    matching_pegs
  end
  # give proper feedback
  # colored key peg for correct color and position
  # white key peg for correct color in wrong position
  # game lasts 12 turns
  # this game will include different colors
  # find a way to include board.turn
  def game_over?(guesses)
    # checks the number of guesses
    if guesses.length >= 12
      true
    end
  end
end

# displays board and gameplay messages
class Display
  # intro message
  def initialize
    puts "Let's play Mastermind"
  end

  # displays the guesses
  def display_guesses(guesses)
    puts "You have made #{guesses.length} guesses."
    guesses.each_with_index do |guess, index|
      puts "Guess ##{index + 1} is #{guess.join(", ")}."
    end
  end

  # displays the code
  def display_code(code)
    puts "The secret code is #{code.join(", ")}."
  end

  # displays the colored pegs
  def display_pegs(pegs)
    puts "This guess has #{pegs.count("colored")} colored pegs
    and #{pegs.count("white")} white pegs."
  end

  # displays the turn
  def display_turn(turn)
    if turn < 12
      puts "Turn ##{turn}."
    else
      puts "Turn ##{turn}. Last turn. Choose wisely."
    end
  end

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

  # use to get the current code
  def code
    @code
  end

  # takes an array and adds it to the board
  def add_guess(guess)
    @guesses << guess
  end

  # reset the guesses
  def reset_guesses
    @guesses = []
  end

  # use to return the current turn
  def turn
    @guesses.length + 1
  end

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
# start the game with display
display = Display.new
# create new player
player = Player.new("breaker")
# create new game with player
game = Mastermind.new(player)
# generate code from the game
code = game.generate_code
# create board with new code
p board = Board.new(code)
# add guesses to the board
3.times { board.add_guess(game.generate_random_colors) }
# display the board guesses
display.display_guesses(board.guesses)
# display the code
display.display_code(code)
# check the matches
pegs = game.check_matches(board.code, board.guesses[-1])
display.display_pegs(pegs)