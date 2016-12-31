class Player

  def shoot
  end

  def pass
  end

  def steal
  end

  class << self
    def select_active_player
      if has_ball?(player)
        player
      end
    end
  end
end

class Goalie < Player

  def block
  end

end

Player.select_active_player

ronaldo = Player.new
ronaldo.shoot
ronaldo.pass
ronaldo.has_ball?