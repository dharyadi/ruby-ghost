class Player
    attr_reader :name
    def initialize(name)
        @name = name
    end

    def guess
        p "Enter a character: "
        char = gets.chomp
        char
    end

    def alert_invalid_guess
        p 'Invalid guess. Please enter valid guess.'
    end
end