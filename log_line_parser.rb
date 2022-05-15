class LogLineParser
  NEW_GAME_REGEX = /\s+[0-9:]*\sInitGame:/
  KILL_REGEX = /\s+[0-9:]*\sKill:[0-9\s]*:\s\<?(?<killer>[\w\s]*)\>? killed (?<killed>[\w\s]*) by (?<means>\w*)/

  attr_reader :line

  # @param [String]
  def initialize(line)
    @line = line
  end

  def new_game?
    line.match?(NEW_GAME_REGEX)
  end

  def kills
    # 14:02 Kill: 1022 5 22: <world> killed Assasinu Credi by MOD_TRIGGER_HURT
    # 14:15 Kill: 2 5 10: Zeh killed Assasinu Credi by MOD_RAILGUN
    line.match(KILL_REGEX)&.named_captures
  end
end
