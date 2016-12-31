class Car

  attr_accessor(:top_speed, :max_fuel, :cost, :doors)

  def top_speed
    @top_speed
  end

  def top_speed=(value)
    @top_speed = value
  end

  def initialize(max_fuel, cost = 4000, top_speed = 80)
    @cost = cost
    @top_speed= top_speed
    @max_fuel = max_fuel
  end

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