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
    it "displays songs sorted by title" do
      handler.handle(command)

      expect(output.string).to eq(
        "Songs:\n" \
        "1. Apple\n" \
        "2. Monkey\n" \
        "3. Zebra\n"
      )
    end
  end
end
