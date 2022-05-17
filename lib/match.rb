require "securerandom"

class Match
  WORLD = "world"

  def initialize
    @kills = {}
  end

  def kills
    hash = @kills.to_h { |killer, kills| [killer, kills.size] }
    hash.delete(WORLD)
    hash
  end

  def log_kill(killer:, killed:, means:)
    @kills[killer] ||= []
    @kills[killed] ||= []

    @kills[killer].push([killed, means])
  end

  def players
    (@kills.keys - [WORLD]).sort
  end

  def to_h
    {
      "match_#{SecureRandom.uuid}": {
        total_kills: total_kills,
        players: players,
        kills: kills
      }
    }
  end

  def total_kills
    @kills.map { |_killer, kills| kills.size }.sum
  end
end
