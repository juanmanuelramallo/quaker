class LogLineParser
  NEW_GAME_REGEX = /\s+[0-9:]*\sInitGame:/
  KILL_REGEX = /\s+[0-9:]*\sKill:[0-9\s]*:\s\<?(?<killer>[\w\s]*)\>? killed (?<killed>[\w\s]*) by (?<means>\w*)/

  attr_reader :line

  # @param [String]
  def initialize(line)
    @line = line
  end

  def new_match?
    line.match?(NEW_GAME_REGEX)
  end

  def kills
    line.match(KILL_REGEX)&.named_captures
  end
end
