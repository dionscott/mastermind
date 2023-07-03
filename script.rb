# displays board and gameplay messages
module Display
  # the colors for the game
  COLORS = ["blue", "green", "red", "purple", "yellow", "white"]

  # intro message
  def display_begin_game
    puts "Let's play Mastermind"
  end

  def display_maker_text
    puts "Input your secret code. The computer will try 
    and guess the code in 12 turns."
  end

  def display_wrong_input
    puts "Wrong input. Try again."
  end

  def display_player_setup
    puts "Would you like to play as the \'Maker\' or \'Breaker\'?"
  end

  def display_valid_colors
    puts "Choose a color: #{COLORS.join(", ")}."
  end

  #display current guess(es)
  def display_code_input(current_try)
    puts "Input your #{current_try} code."
  end

  # displays the guesses
  def display_guesses_and_pegs(guesses, pegs)
    puts "You have made #{guesses.length} guesses."
    guesses.each_with_index do |guess, index|
      puts "Guess ##{index + 1} was #{guess.join(", ")}."
      display_pegs(pegs[index])
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

  def display_win(code, number_of_guesses)
    code_string = code.join(", ")
    if number_of_guesses > 2
      puts "Wow! First Try! The code was #{code_string}."
    else
      puts "Congratulations! You win! The code was #{code_string}. 
      It took you #{number_of_guesses} guesses."
    end
  end

  def display_lose(code)
    code_string = code.join(", ")
    puts "Better luck next time. The code was #{code_string}."
  end
end

# allow players to interact with board
class Mastermind
  include Display

  def initialize
    @player = nil
    @code = nil
    @board = Board.new
    @number_of_games = 0
    @won = false
    @turn = nil
  end

  def setup
    # setup the game
    # get player info
    display_player_setup
    player_type = gets.chomp.downcase
    until player_type == "maker" || player_type == "breaker"
      display_wrong_input
      display_player_setup
      player_type = gets.chomp.downcase
    end
    # create new player
    @player = Player.new(player_type)
  end

  def play
    # if maker run maker version
    # if breaker run breaker version
    if @player.role == "breaker"
      breaker
      win_or_lose
    else
      maker
      win_or_lose
    end
  end

  def maker
    display_maker_text
    @code = get_player_code
    get_turn
    play_game(@player.role)
  end

  def breaker
    # generate a random code
    @code = generate_code
    # show the secret code will remove later
    display_code(@code)
    get_turn
    play_game(@player.role)
  end

  def play_game(role)
    until game_over?(@turn)
      display_turn(@turn)
      # changes based on if the player is the breaker or maker
      if role == "breaker"
        guess = get_player_code
      else
        # this will contain the logic for computer play
        guess = generate_code
      end
      @board.add_guess(guess)
      # display human guesses and matching pegs
      peg = check_matches(@code, guess)
      @board.add_peg(peg)
      display_guesses_and_pegs(@board.guesses, @board.pegs)
      # check if the game has been won if so change won
      if game_won?
        @won = true
      else
        get_turn
      end
    end
  end
  
  def win_or_lose
    if game_won?
      display_win(@code, @turn)
    else
      display_lose(@code)
    end
  end

  def current_guesses
    @board.guesses
  end

  def current_pegs
    @board.pegs[-1]
  end

  # generate code based on input
  def generate_code(input_code = [])
    if input_code.empty?
      4.times do 
        color_code = (COLORS).sample
        input_code << color_code
      end
    end
    input_code
  end

  # takes input and returns guesses array
  def get_player_code
    tries = ["first", "second", "third", "fourth"]
    input = []
    4.times do
      current_try = tries.shift
      display_code_input(current_try)
      display_valid_colors
      answer = gets.chomp.downcase
      until COLORS.include?(answer)
        display_wrong_input
        display_valid_colors
        answer = gets.chomp.downcase
      end
      input << answer
    end
    input
  end

  # checks for matches and returns an array with pegs
  def check_matches(code, guesses)
    # create temporary array for guesses
    duplicate_guesses = guesses.dup
    duplicate_code = code.dup
    matching_pegs = []
    code.each_with_index do |code, index|
      # take each number and check both arrays
      if code == guesses[index]
        # delete the correct guess and code from the duplicate array
        duplicate_guesses.delete_at(duplicate_guesses.index(code))
        duplicate_code.delete_at(duplicate_code.index(code))
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

  def game_over?(turn)
    # checks if the game has been won
    # checks the number of turns
    if turn >= 12 || @won == true
      true
    end
  end

  # use to return the current turn
  def get_turn
    @turn = @board.guesses.length + 1
  end
  
  def game_won?
    # check if all 4 pegs are colored
    current_pegs.all?("colored") && current_pegs.length == 4 ? true : false
  end
end

# create the board and keep the game information
class Board
  def initialize
    @code = nil
    @guesses = []
    @pegs = []
  end
  
  # adds the code
  def add_code(code)
    @code = code
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

  # reset the board
  def reset
    @code = nil
    @guesses = []
    @pegs = []
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

  def role
    @role
  end
  # codemaker gets one point for each guess of codebreaker
  # extra point is earned by the codemaker if code is unbroken
end


# Main instance of game

def play_game
  game = Mastermind.new
  game.setup
  game.play
end


play_game
