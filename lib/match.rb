require "securerandom"

class Match
  WORLD = "world"

  def initialize
    @kills = {}
    @name = "match_#{SecureRandom.uuid}"
  end

  def kills
    hash = @kills.to_h do |killer, kills|
      [
        killer,
        kills.values.flat_map(&:values).sum - (@kills.dig(WORLD, killer)&.values&.sum || 0)
      ]
    end

    hash.delete(WORLD)
    hash
  end

  def log_kill(killer, killed, means)
    @kills[killer] ||= {}
    @kills[killer][killed] ||= {}
    @kills[killer][killed][means] ||= 0
    @kills[killed] ||= {}

    @kills[killer][killed][means] += 1
  end

  def players
    (@kills.keys - [WORLD]).sort
  end

  def to_h
    {
      @name => {
        total_kills: total_kills,
        players: players,
        kills: kills
      }
    }
  end

  def total_kills
    @kills.values.flat_map(&:values).flat_map(&:values).sum
  end
end
