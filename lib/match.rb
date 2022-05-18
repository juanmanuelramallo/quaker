require "securerandom"

class Match
  WORLD = "world"

  def initialize
    @kills = {}
    @name = "match_#{SecureRandom.uuid}"
  end

  # @return [Hash{String => Integer}] Kill count per player excluding the meta-player "world".
  def kills_by_player
    hash = @kills.to_h do |killer, kills|
      [
        killer,
        kills.values.flat_map(&:values).sum - (@kills.dig(WORLD, killer)&.values&.sum || 0)
      ]
    end

    hash.delete(WORLD)
    hash
  end

  # @return [Hash{String => Integer}] Kill count per means.
  def kills_by_means
    means = {}

    @kills.values.flat_map(&:values).each do |player_means|
      player_means.each do |mean, count|
        means[mean] ||= 0
        means[mean] += count
      end
    end

    means
  end

  # Logs a kill into the match instance.
  #
  # @param killer [String]
  # @param killed [String]
  # @param means [String]
  def log_kill(killer, killed, means)
    @kills[killer] ||= {}
    @kills[killer][killed] ||= {}
    @kills[killer][killed][means] ||= 0
    @kills[killed] ||= {}

    @kills[killer][killed][means] += 1
  end

  # @return [Array<String>] List of players in the match.
  def players
    (@kills.keys - [WORLD]).sort
  end

  # Builds a hash with the match's stats including total kills, list of players, kills by player and kills by means.
  #
  # @param by_means [Boolean] (false) Returns exclusively the kill count by means when set to true.
  # @return [Hash{Symbol => Hash{Symbol => Integer, Array<String>, Hash{String => Integer}}}]
  def to_h(by_means: false)
    report = if by_means
      { kills_by_means: kills_by_means }
    else
      {
        total_kills: total_kills,
        players: players,
        kills: kills_by_player
      }
    end

    { @name.to_sym => report }
  end

  # @return [Integer] Total amount of kills in the match.
  def total_kills
    @kills.values.flat_map(&:values).flat_map(&:values).sum
  end
end
