require "rspec"
require_relative "../lib/quaker"

RSpec.describe Quaker do
  describe "#parse" do
    subject { described_class.new(file_path).parse }

    let(:file_path) { File.join(__dir__, "fixtures", "qgames.log") }

    it "returns a list of all the match reports" do
      expect(subject.size).to eq(2)
      expect(subject).to contain_exactly(
        include(
          be_a(Symbol) => include(
            total_kills: 0,
            players: [],
            kills: {}
          ),
        ),
        include(
          be_a(Symbol) => include(
            total_kills: 11,
            players: contain_exactly("Isgalamido", "Mocinha"),
            kills: {
              "Isgalamido" => -5,
              "Mocinha" => 0
            }
          )
        )
      )
    end
  end
end
