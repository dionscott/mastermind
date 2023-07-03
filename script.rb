# allow players to interact with board
class Mastermind
  attr_accessor :won
  def initialize(player)
  # number of iterations of the game
  @number_of_games = 0
  # the color codes for the game
  # since code is kept on the board I won't need it here
  # remove later
  @player = player
  @won = false
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
      # replace with display get_guess
      p "Input your #{current_try} code."
      answer = gets.chomp.downcase
      until COLORS.include?(answer)
        # replace with display incorrect_color
        p "Incorrect color. Please try again using the colors: 
        #{COLORS.join(", ")}."
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

  # game lasts 12 turns
  # this game will include different colors
  # find a way to include board.turn
  def game_over?(turn)
    # checks if the game has been won
    # checks the number of turns
    if turn >= 12 || @won == true
      true
    end
  end
end

# displays board and gameplay messages
module Display
  # intro message
  def initialize
    puts "Let's play Mastermind"
  end

  #display current guess(es)
  def display_current_guess(guess)
    puts "Your guess is #{guess.join(", ")}."
  end

  # displays the guesses
  def display_guesses_and_pegs(guesses, pegs)
    puts "You have made #{guesses.length} guesses."
    guesses.each_with_index do |guess, index|
      puts "Guess ##{index + 1} is #{guess.join(", ")}."
      puts display_pegs(pegs[index])
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
      puts "Turn ##{turn}. 
      Choose a color: #{Mastermind::COLORS.join(", ")}."
    else
      puts "Turn ##{turn}. Last turn. Choose wisely.
      Choose a color: #{Mastermind::COLORS.join(", ")}."
    end
  end

  def win_or_lose(outcome, code, number_of_guesses)
    code_string = code.join(", ")
    if outcome == "win"
      puts "Congratulations! You win! The code was #{code_string}. 
      It took you #{number_of_guesses} guesses."
    else
      puts "Better luck next time. The code was #{code_string}."
    end
  end
end

# create the board and keep the game information
class Board
  def initialize(code)
    @code = code
    @guesses = []
    @pegs = []
  end

  # use to see the current guesses of the game
  def guesses
    @guesses
  end

  def pegs
    @pegs
  end
  # use to get the current code
  def code
    @code
  end

  # takes an array and adds it to the board
  def add_guess(guess)
    @guesses << guess
  end

  def add_peg(peg)
    @pegs << peg
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
    @points = 0
  end
  # also keeps track of the points made
  # codemaker gets one point for each guess of codebreaker
  # extra point is earned by the codemaker if code is unbroken
end

# calls the main instances of the game
class Main
  include Display
  def initialize(player_type = "breaker")
    # create new player
    @player = Player.new(player_type)
    # create new game with player
    @game = Mastermind.new(@player)
    # generate random code from the game
    @code = @game.generate_code
    # create board with new code
    @board = Board.new(@code)
  end

  def play_game
    # get human guesses
    # game ends after 12 turns game.game_over?(guesses)
    turn = @board.turn
    # show the secret code
    p @code
    until @game.game_over?(turn)
      turn = @board.turn
      # display the turn
      display_turn(turn)
      # ask the player for input
      guess = @game.human_guesses
      @board.add_guess(guess)
      #checking if board.turn works
      p @board.turn
      # display human guesses and matching pegs
      peg = @game.check_matches(@code, guess)
      @board.add_peg(peg)
      # if all the pegs are colored the game is won
      @game.won = true if peg.all?("colored") && peg.length == 4
      display_guesses_and_pegs(@board.guesses, @board.pegs)
    end

    # need function to check if game is won
    if @game.won
      win_or_lose("win", @code, turn)
      # ask to reset game or quit
    else
      win_or_lose("lose", @code, turn)
    end
  end
end

new_game = Main.new
new_game.play_game