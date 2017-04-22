class Robot

  @@count = 0

  attr_accessor(:hp, :attack, :rambo, :billy)

  def initialize(hp, attack)
    @@count += 1
    @hp = hp
    @attack = attack
  end

  # def hp
  #   @hp
  # end

  # def hp=(value)
  #   @hp = value
  # end

  def jump
    puts "PEW"
  end

  def destroy
    @@count -= 0
  end

  class << self

    def count
      puts @@count
    end

  end

end

class Gundam < Robot

  def jump
    super
    puts "BOING"
  end

end