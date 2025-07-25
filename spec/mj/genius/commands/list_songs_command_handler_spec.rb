# frozen_string_literal: true

RSpec.describe Mj::Genius::Commands::ListSongsCommandHandler do
  subject(:handler) { described_class.new(stdout: $stdout, api_client: api_client) }

  let(:command) { Mj::Genius::Commands::ListSongs.new(artist: "Mallu Magalhães", options: {}) }
  let(:songs) { handler.handle(command).sort_by(&:title) }
  let(:api_client) { Mj::Genius::ApiClient.new(access_token: ENV.fetch("GENIUS_ACCESS_TOKEN")) }

  describe "integration test" do
    it "fetches songs" do
      VCR.use_cassette("list_songs_command_handler_spec") do
        expect(songs.length).to eq(92)
        expect(songs.first.title).to eq("America Latina")
        expect(songs.last.title).to eq("Ô, Ana")
      end
    end
  end
end
