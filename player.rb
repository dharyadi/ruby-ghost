class Player
    attr_reader :name
    def initialize(name)
        @name = name
    end

    def guess
        puts @name + " enters a character: "
        char = gets.chomp
        char
    end

    def alert_invalid_guess
        puts 'Invalid guess. Please enter valid guess.'
    end
end