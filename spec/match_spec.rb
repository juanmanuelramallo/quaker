require "rspec"
require_relative "../lib/match"

RSpec.describe Match do
  let(:match) { described_class.new }

  before do
    match.log_kill(killer: "Juan", killed: "Mateo", means: "MOD_RAILGUN")
    match.log_kill(killer: "Juan", killed: "FKJ", means: "MOD_RAILGUN")
    match.log_kill(killer: "world", killed: "Juan", means: "MOD_TRIGGER_HURT")
  end

  describe "#total_kills" do
    subject { match.total_kills }

    it { is_expected.to eq(3) }

    context "when there are no kills" do
      subject { described_class.new.total_kills }

      it { is_expected.to eq(0) }
    end
  end

  describe "#players" do
    subject { match.players }

    it { is_expected.to contain_exactly("Juan", "Mateo", "FKJ") }
  end

  describe "#kills" do
    subject { match.kills }

    it "returns a hash with the kill count for each player" do
      expect(subject).to include(
        "Juan" => 1,
        "Mateo" => 0,
        "FKJ" => 0
      )
      expect(subject).not_to include(
        "world"
      )
    end
  end

  describe "#to_h" do
    subject { match.to_h }

    it "returns the grouped information for the match" do
      expect(subject.values.first).to include(
        total_kills: 3,
        players: contain_exactly("Juan", "Mateo", "FKJ"),
        kills: {
          "Juan" => 1,
          "Mateo" => 0,
          "FKJ" => 0
        }
      )
    end
  end
end
