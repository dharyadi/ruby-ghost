class Animal
    attr_reader :name
    def initialize(name)
        @name = name
        
    end
end

animals = Array.new()
animals << Animal.new("dog")
animals << Animal.new("fish")
animals << Animal.new("cow")

dog = animals.select {|animal| animal.name == "dog"}
p dog