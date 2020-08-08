require 'set'
require_relative "player.rb"
require_relative "ai_player.rb"

class GhostGame
    ALPHABET = Set.new("a".."z")
    MAX_LOSS  = 5
    
    def initialize(aiPlayer_nums, *players)
        words = File.readlines("dictionary.txt").map {|word| word.chomp}
        @dictionary = Set.new(words)
        @players  = players
        aiPlayer_nums.times do |i|
            @players << AiPlayer.new("AI_Player " + (i + 1).to_s)
        end
        @fragment = ""
        @losses = Hash.new()

        # initialize the losses hash with human players
        players.each {|player| @losses[player] = 0}
  


    end

    # Call play_round until game over
    def run 
        self.play_round until self.game_over?
        self.game_finishes
    end

    # Display final standings and winner when the game is over
    def game_finishes
        self.display_standings
        player_won = @players.select {|player| @losses[player] < MAX_LOSS}
        puts player_won.first.name + " won!"
    end

    # Returns the current player that is going to enter a char
    def current_player 
        @players.first
    end
    
    # Returns the previous player before the current player
    def previous_player
        @players.reverse.each do |player|
            return player if @losses[player] < MAX_LOSS
        end
    end

    # Rotate the @players array to get the next player to play
    def next_player!
        loop do 
            @players.rotate! 
            break if @losses[@players.first] < MAX_LOSS
        end
    end

    # Current player take turns. Current player should make a valid guess
    def take_turn(player)
        loop do
            guess = player.is_a?(Player) ? player.guess : player.guess(@dictionary, @fragment, @players.length)
            
            if valid_play?(guess)
                @fragment += guess 
                break 
            else
                player.alert_invalid_guess
            end
        end
    end

    def valid_play?(string)
        return false unless ALPHABET.include?(string)
        @dictionary.any? {|word| word.start_with?(@fragment + string)}
    end


    def play_round
        self.display_standings
        # Reset fragment for every round
        @fragment = ""

        # Loop keeps running until the current player enters a char
        # that makes the fragment a valid word
        while !@dictionary.include?(@fragment)
            puts "Current fragment : " + @fragment
            take_turn(self.current_player)
            self.next_player!
        end
        self.round_finish
    end

    def round_finish
        puts "Fragment completed : " + @fragment.upcase
        puts self.previous_player.name + " lost!"
        puts ""
        @losses[self.previous_player] += 1
    end

    def record(player)
        ghost = "GHOST"
        losses = @losses[player]
        ghost[0...losses]
    end


    # Game finishes when there's only 1 player with number of losses
    # less than MAX_LOSS
    def game_over?
        @losses.keys.one? {|player| @losses[player] < MAX_LOSS}
    end

    def display_standings
        puts "-----------------------"
        puts "Current Standings"
        @losses.keys.each do |player|
            puts player.name + " : " + record(player)
        end
        puts "-----------------------"
    end
end


if __FILE__ == $PROGRAM_NAME
    game = GhostGame.new(2,
        Player.new("Dhamar")
        # Player.new("Titish")
        # Player.new("Anggri")
        # Player.new("Bobby")
    )
    game.run
end






