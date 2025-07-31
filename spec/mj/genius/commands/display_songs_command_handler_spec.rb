# frozen_string_literal: true

RSpec.describe Mj::Genius::Commands::DisplaySongsCommandHandler do
  subject(:handler) { described_class.new(stdout: output) }

  let(:output) { StringIO.new }
  let(:command) { Mj::Genius::Commands::DisplaySongs.new(songs: songs) }
  let(:songs) do
    [
      double("Song", title: "Zebra"),
      double("Song", title: "Apple"),
      double("Song", title: "Monkey")
    ]
  end

  describe "#handle" do
    it "displays songs sorted by title with correct padding" do
      handler.handle(command)

      expect(output.string).to eq(
        "Songs:\n" \
        "1. Apple\n" \
        "2. Monkey\n" \
        "3. Zebra\n"
      )
    end

    context "when there is only one song" do
      let(:songs) { create_songs(1) }

      it "does not pad the number" do
        handler.handle(command)

        expect(output.string).to eq(
          "Songs:\n" \
          "1. Song 001\n"
        )
      end
    end

    context "when the total songs are in double digits" do
      let(:songs) { create_songs(12) }

      it "pads the numbers to three digits" do
        handler.handle(command)

        expect(output.string).to include(
          "Songs:\n",
          " 1. Song 001\n",
          "12. Song 012\n"
        )
      end
    end

    context "when the total songs are in triple digits" do
      let(:songs) { create_songs(100) }

      it "pads the numbers to three digits" do
        handler.handle(command)

        expect(output.string).to include(
          "Songs:\n",
          "  1. Song 001\n",
          " 99. Song 099\n",
          "100. Song 100\n"
        )
      end
    end
  end

  def create_songs(number)
    Array.new(number) { |i| double("Song", title: "Song #{format("%03d", i.next)}") }
  end
end
