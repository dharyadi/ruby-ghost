require 'set'
require_relative "player.rb"


class Game
    ALPHABET = Set.new("a".."z")
    attr_reader :players, :fragment
    def initialize
        @players  = Array.new()
        @players << Player.new("Dhamar")
        @players << Player.new("Titish")
        @fragment = ""
        @dictionary = File.readlines("dictionary.txt").map {|word| word.chomp}.to_set
        @losses = Hash.new(0)

    end

    def current_player 
        @players.first
    end
        
    def previous_player
        @players.last
    end

    def next_player!
        @players.rotate!
    end

    def take_turn(player)
        while true
            guess = player.guess
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
        while !@dictionary.include?(@fragment)
            take_turn(self.current_player)
            self.next_player!
        end
        p self.previous_player.name + " lost!"
        @losses[self.previous_player] += 1
    end

    def record(player)
        ghost = "GHOST"
        losses = @losses[player]
        ghost[0...losses]
    end

    def run 
        while !self.game_over?
            self.display_standings
            @fragment = ""
            self.play_round
        end
    end

    def game_over?
        @losses.keys.any? {|player| @losses[player] == 5}
    end

    def display_standings
        @losses.keys.each do |player|
            puts player.name + " : " + record(player)
        end
    end
        
end






