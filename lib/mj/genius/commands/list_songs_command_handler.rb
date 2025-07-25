# frozen_string_literal: true

require "json"

module Mj
  module Genius
    module Commands
      # Handles the logic for the ListSongs command
      class ListSongsCommandHandler
        PER_PAGE = 50

        def initialize(stdout:, api_client:)
          @stdout = stdout
          @api_client = api_client
        end

        # Process the ListSongs command
        # @param [ListSongs] command The list songs command object
        def handle(command)
          artist = command.artist

          if numeric?(artist)
            fetch_and_display_songs_by_artist_id(artist)
          else
            process_artist_search(artist)
          end
        rescue NetworkError => exception
          @stdout.puts "Network Error: #{exception.message}. Please check your internet connection."
        rescue ApiError => exception
          @stdout.puts "API Error: #{exception.message}. Please verify your request and try again."
        rescue StandardError => exception
          @stdout.puts "Unexpected Error: #{exception.message}. Please contact support if this persists."
        end

        private

        def numeric?(value)
          value.to_s.match?(/\A\d+\z/)
        end

        def fetch_and_display_songs_by_artist_id(artist_id)
          page = 1
          songs = []

          loop do
            response = @api_client.fetch_songs_by_artist_id(artist_id, page: page, per_page: PER_PAGE)
            break if response.empty?

            songs.concat(response)
            page += 1
          end

          display_songs(songs)
        end

        def process_artist_search(artist_name)
          response = @api_client.search_artist(artist_name)

          artists = response.map { |hit| hit["result"]["primary_artist"] }.uniq

          if artists.size > 1
            display_ambiguous_artists(artist_name, artists)
          elsif artists.any?
            fetch_and_display_songs_by_artist_id(artists.first["id"])
          else
            @stdout.puts "No results found for artist: \"#{artist_name}\""
          end
        end

        def display_ambiguous_artists(artist_name, artists)
          @stdout.puts "Ambiguous artist name: \"#{artist_name}\""
          @stdout.puts "Possible matches:\n"

          artists.each do |artist|
            @stdout.puts "#{artist["name"]} (ID: #{artist["id"]})"
          end

          @stdout.puts "\nRe-run the command with the artist ID:\n"
          @stdout.puts "./bin/mj genius list_songs <artist_id>"
        end

        def display_songs(songs)
          sorted_songs = songs.sort_by { |song| song["title"] }

          @stdout.puts "Songs:\n"
          sorted_songs.each do |song|
            @stdout.puts song["title"]
          end
        end
      end
    end
  end
end
