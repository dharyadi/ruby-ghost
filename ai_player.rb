# If adding a letter to the fragment would spell a word, then the letter is a losing move.
# If adding a letter to the fragment would leave only words with n or fewer additional letters 
# as possibilities, then the letter is a winning move.
# Your AI should take any available winning move; if none is available, randomly 
# select a losing move.


class AiPlayer
  ALPHABET = Set.new("a".."z")
  attr_reader :name
  def initialize(name, game )
    @name = name
    @game = game
  end

  def guess
    print @name + " enters a character: "
    sleep(0.5)

    p find_best_guess
    find_best_guess
  end
  
  def find_best_guess
    # new_fragment to full word length is less than player.length - 1
    # random tapi aja new fragment is full word
    # otherwise random meneh sakarepe

    fragment = @game.fragment 
    dictionary = @game.dictionary
    options = Hash.new() {Hash.new(0)}
    ALPHABET.each do |char|
      options[char] = Hash.new(0)
      new_fragment = fragment + char 
      dictionary.each do |word|
        # && word[new_fragment.length..-1].length <= @game.players.length - 1
        if word.start_with?(new_fragment) 
          if word == new_fragment
            p word
            

            options[char]["full_word"] += 1
          end

          if word.length > new_fragment.length 
            if word[new_fragment.length..-1].length <= @game.players.length - 1
              options[char]["win_words"] += 1
            end
          end
        end
      end
    end
    options
  end

  def alert_invalid_guess
    puts 'Invalid guess. Please enter valid guess.'
  end


end