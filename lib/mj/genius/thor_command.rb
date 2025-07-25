# frozen_string_literal: true

module Mj
  module Genius
    class ThorCommand < Thor
      desc "list <artist_name_or_id>", "Artist"
      def list_songs(artist_name_or_id)
        command = Commands::ListSongs.new(artist: artist_name_or_id, options: options)
        handler = Commands::ListSongsCommandHandler.new(
          stdout: $stdout,
          api_client: api_client
        )
        handler.handle(command)
      end

      private

      def api_client
        ApiClient.new(
          access_token: ENV.fetch("GENIUS_ACCESS_TOKEN")
        )
      end
    end
  end
end
