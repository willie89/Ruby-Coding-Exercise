class Car

  def move_forward
    puts "VROOM VROOM"
  end

  def turn
    puts "SCREECH"
  end

  def brake
    puts "I stopped."
  end

  def self.turn
    puts "Cars can turn, yes."
  end

  def who_am_i?
    self
  end

  class << self

    def stuff
      puts "stuff"
    end

    def whatevs
      puts "whatevs"
    end

    def who_am_i?
      self
    end
  end
end