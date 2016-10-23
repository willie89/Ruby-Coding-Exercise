class Car

  def initialize
    @cost = 4000
    @top_speed= 60
    @max_fuel = 40
  end

  def cost
    @cost
  end

  def cost=(value)
    @cost = value
  end

  def top_speed
    @top_speed
  end

  def top_speed=(value)
    @top_speed = value
  end

  def max_fuel
    @max_fuel = value
  end

  def max_fuel=(value)
    @max_fuel = value
  end

  # def move_forward
  #   puts "VROOM VROOM"
  # end

  # def turn
  #   puts "SCREECH"
  # end

  # def brake
  #   puts "I stopped."
  # end

  # def who_am_i?
  #   self
  # end

  # def self.turn
  #   puts "Cars can turn, yes."
  # end

  # class << self

  #   def stuff
  #     puts "stuff"
  #   end

  #   def whatevs
  #     puts "whatevs"
  #   end

  #   def who_am_i?
  #     self
  #   end
  # end
end