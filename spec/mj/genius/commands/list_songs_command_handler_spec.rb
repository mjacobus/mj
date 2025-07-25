RSpec.describe Mj::Genius::Commands::ListSongsCommandHandlerSpec do
  let(:command) { Commands::ListSongs.new(artist: "Mallu Magalhães", options: {}) }
  let(:songs) { handler.handle(command).sort_by(&:title) }
  let(:handler)  { Commands::ListSongsCommandHandler.new(stdout: $stdout, api_client: api_client) }

  describe "integration test" do
    expect(songs.length).to eq(92)
    expect(songs.first.title).to eq("America Latina")
    expect(songs.last.title).to eq("Ô, Ana")
  end
end
