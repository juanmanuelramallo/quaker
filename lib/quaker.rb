require_relative "match"
require_relative "log_line_parser"

class Quaker
  attr_reader :file_path

  # @param [String]
  def initialize(file_path)
    @file_path = file_path
    @matches = []
    @current_match = nil
  end

  def parse
    logs.each do |log|
      parsed_line = LogLineParser.new(log)

      if (killing = parsed_line.killing)
        # What happens if match start is not identified (current_match is empty)
        @current_match.log_kill(killer: killing["killer"], killed: killing["killed"], means: killing["means"])
      elsif parsed_line.new_match?
        @current_match = Match.new
        @matches << @current_match
      end
    end

    @matches.map(&:to_h)
  end

  private

  def logs
    File.new(file_path)
  end
end
