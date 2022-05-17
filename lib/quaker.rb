class Quaker
  attr_reader :file_path

  attr_accessor :current_match

  # @param [String]
  def initialize(file_path)
    @file_path = file_path
    @matches = []
  end

  def parse
    current_match = Match.new
    logs.each do |log|
      parsed_line = LogLineParser.new(log)

      if parsed_line.kills.present?
        current_match.log_kill(parsed_line.kills)
      elsif parsed_line.new_match?
        @matches << current_match
        current_match = Match.new
      end
    end

    @matches.map(&:to_h)
  end

  private

  def logs
    File.new(file_path)
  end
end
