require_relative "../spec_helper"

RSpec.describe Quaker::Parser do
  describe "#parse" do
    subject { described_class.new(file_path).parse }

    let(:file_path) { File.join(__dir__, "../fixtures", "qgames.log") }

    it "returns a list of all the match reports" do
      expect(subject.size).to eq(2)
      expect(subject).to contain_exactly(
        have_attributes(
          total_kills: 0,
          players: [],
          kills_by_player: {}
        ),
        have_attributes(
          total_kills: 11,
          players: contain_exactly("Isgalamido", "Mocinha"),
          kills_by_player: include(
            "Isgalamido" => -5,
            "Mocinha" => 0
          )
        )
      )
    end

    context "when the log is missing the first init game event" do
      let(:file_path) { File.join(__dir__, "../fixtures", "qgames-without-init.log") }

      it "returns an empty array" do
        expect(subject.size).to eq(0)
      end
    end
  end
end
