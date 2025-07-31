# frozen_string_literal: true

require_relative "api_client"
require_relative "commands/list_songs"
require_relative "commands/list_songs_command_handler"
require_relative "commands/display_songs"
require_relative "commands/display_songs_command_handler"
require_relative "song"
require_relative "artist"

module Mj
  module Genius
    class ThorCommand < Thor
      desc "list_songs <artist_name_or_id>", "List songs by an artist"
      option :format, type: :string, banner: "Format table or plain", aliases: :f
      def list_songs(artist_name_or_id)
        command = Commands::ListSongs.new(artist: artist_name_or_id, options: options)
        handler = Commands::ListSongsCommandHandler.new(api_client: api_client)
        songs = handler.handle(command)

        display_command = Commands::DisplaySongs.new(songs: songs, options: options)
        display_handler = Commands::DisplaySongsCommandHandler.new(stdout: $stdout)
        display_handler.handle(display_command)
      rescue Commands::ListSongsCommandHandler::AmbiguousArtistError => exception
        display_ambiguous_artists(exception.artist_name, exception.artists)
        exit(1)
      rescue Commands::ListSongsCommandHandler::ArtistNotFoundError
        puts "No results found for artist: \"#{artist_name_or_id}\"".red
      rescue StandardError => exception
        $stdout.puts "An error occurred:\n\t#{exception.message.red}"
        exit(1)
      end

      private

      # TODO: Move to command
      def display_ambiguous_artists(artist_name, artists)
        puts "Ambiguous artist name: \"#{artist_name}\"".red
        puts "Possible matches:\n"

        artists.each do |artist|
          puts "- #{artist.name} (ID: #{artist.id.to_s.green})"
        end

        puts "\nRe-run the command with the artist ID:\n"
        puts "./bin/mj genius list_songs <artist_id>"
      end

      def api_client
        ApiClient.new(
          access_token: ENV.fetch("GENIUS_ACCESS_TOKEN")
        )
      end
    end
  end
end
