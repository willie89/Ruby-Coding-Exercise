class SuperCar < Car

  def initialize
    super(10000, 200, 80)
    @doors = 2
  end

  def move_forward
    puts "VROOM VROOM"
  end

  def turn
    puts "SCREECH"
  end

  def brake
    puts "I stopped."
  end

  def who_am_i?
    self
  end

  def self.turn
    puts "Cars can turn, yes."
  end

end