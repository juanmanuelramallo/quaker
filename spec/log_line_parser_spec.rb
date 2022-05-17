require "rspec"
require_relative "../lib/log_line_parser"

RSpec.describe LogLineParser do
  describe "#new_match?" do
    subject { described_class.new(line).new_match? }

    context "when the line is for a new game" do
      let(:line) { '  3:32 InitGame: \capturelimit\8' }

      it { is_expected.to eq(true) }
    end

    context "when the line is not for a new game" do
      let(:line) { "  3:25 Item: 2 item_armor_shard InitGame:" }

      it { is_expected.to eq(false) }
    end
  end

  describe "#killing" do
    subject { described_class.new(line).killing }

    context "when the line is for a kill" do
      let(:line) { "  3:12 Kill: 2 7 7: Oootsimo killed Assasinu Credi by MOD_ROCKET_SPLASH" }

      it "returns a hash" do
        expect(subject).to include(
          "killer" => "Oootsimo",
          "killed" => "Assasinu Credi",
          "means" => "MOD_ROCKET_SPLASH"
        )
      end
    end

    context "when the line is for a kill done by the world" do
      let(:line) { "  3:21 Kill: 1022 3 22: <world> killed Isgalamido by MOD_TRIGGER_HURT" }

      it "returns a hash" do
        expect(subject).to include(
          "killer" => "world",
          "killed" => "Isgalamido",
          "means" => "MOD_TRIGGER_HURT"
        )
      end
    end

    context "when the line is not for a kill" do
      let(:line) { "  3:10 Item: 6 weapon_rocketlauncher" }

      it { is_expected.to eq(nil) }
    end
  end
end
