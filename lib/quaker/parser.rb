module Quaker
  # Parses a quake game log file.
  #
  # @example
  #   Quaker.new("./qgames.log").parse #=> [{ :match_1 => ... }]
  #
  class Parser
    attr_reader :file_path

    # @param file_path [String]
    def initialize(file_path)
      @file_path = file_path
      @current_match = nil
    end

    # Parses a quake game log file and returns a report for each game in the log file.
    #
    # @return [Array<Quaker::Match>]
    def parse
      matches = []

      logs.each do |log|
        parsed_line = LogLineParser.new(log)

        if (killing = parsed_line.killing) && @current_match
          @current_match.log_kill(killing["killer"], killing["killed"], killing["means"])
        elsif parsed_line.new_match?
          @current_match = Match.new
          matches << @current_match
        end
      end

      matches
    end

    private

    def logs
      File.new(file_path)
    end
  end
end
