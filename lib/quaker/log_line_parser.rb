module Quaker
  class LogLineParser
    PREFIX_REGEX = Regexp.new('\s+[0-9:]*\s')
    NEW_GAME_REGEX = Regexp.new [PREFIX_REGEX, "InitGame:"].join
    KILL_REGEX = Regexp.new [
      PREFIX_REGEX,
      'Kill:[0-9\s]*:\s',
      '<?(?<killer>[\w\s]*)\>?',
      ' killed ',
      '(?<killed>[\w\s]*)',
      ' by ',
      '(?<means>\w*)'
    ].join

    attr_reader :line

    # @param line [String]
    def initialize(line)
      @line = line
    end

    # @return [Boolean] True if line is to start a new match.
    def new_match?
      line.match?(NEW_GAME_REGEX)
    end

    # @return [Hash{"killer", "killed", "means" => String}, nil] A hash containing the killer, killed and means of the kill event.
    def killing
      line.match(KILL_REGEX)&.named_captures
    end
  end
end
