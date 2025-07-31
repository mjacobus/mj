# frozen_string_literal: true

require_relative "api_client"
require_relative "commands/list_songs"
require_relative "commands/list_songs_command_handler"
require_relative "commands/display_songs"
require_relative "commands/display_songs_command_handler"
require_relative "song"

module Mj
  module Genius
    class ThorCommand < Thor
      desc "list_songs <artist_name_or_id>", "List songs by an artist"
      option :format, type: :string, banner: "Format table or plain", aliases: :f
      def list_songs(artist_name_or_id)
        command = Commands::ListSongs.new(artist: artist_name_or_id, options: options)
        handler = Commands::ListSongsCommandHandler.new(
          stdout: $stdout,
          api_client: api_client
        )
        songs = handler.handle(command)

        display_command = Commands::DisplaySongs.new(songs: songs, options: options)
        display_handler = Commands::DisplaySongsCommandHandler.new(stdout: $stdout)
        display_handler.handle(display_command)
      rescue StandardError => e
        $stdout.puts "An error occurred:\n\t#{e.message.red}"
        exit(1)
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
