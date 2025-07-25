# frozen_string_literal: true

require_relative "api_client"
require_relative "commands/list_songs"
require_relative "commands/list_songs_command_handler"
require_relative "song"

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
        songs = handler.handle(command)

        display_songs(songs)
      end

      private

      # TODO: move to a command
      def display_songs(songs)
        sorted_songs = songs.sort_by(&:title)

        $stdout.puts "Songs:\n"
        sorted_songs.each_with_index do |song, index|
          $stdout.puts "#{index.next}. #{song.title}"
        end
      end

      def api_client
        ApiClient.new(
          access_token: ENV.fetch("GENIUS_ACCESS_TOKEN")
        )
      end
    end
  end
end
