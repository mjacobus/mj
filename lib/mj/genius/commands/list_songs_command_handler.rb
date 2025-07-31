# frozen_string_literal: true

require "json"

module Mj
  module Genius
    module Commands
      # Handles the logic for the ListSongs command
      class ListSongsCommandHandler
        PER_PAGE = 50

        class AmbiguousArtistError < StandardError
          attr_accessor :artist_name, :artists

          def initialize(artist_name, artists)
            @artist_name = artist_name
            @artists = artists
            super("Ambiguous artist name: \"#{artist_name}\". Possible matches: #{artists.map(&:name).join(", ")}")
          end
        end

        def initialize(stdout:, api_client:)
          @stdout = stdout
          @api_client = api_client
        end

        # Process the ListSongs command
        # @param [ListSongs] command The list songs command object
        def handle(command)
          if command.artist_id?
            return fetch_and_display_songs_by_artist_id(command.artist_id)
          end

          process_artist_search(command.artist)
        end

        private

        def fetch_and_display_songs_by_artist_id(artist_id)
          page = 1
          songs = []

          loop do
            response = @api_client.fetch_songs_by_artist_id(artist_id, page: page, per_page: PER_PAGE)
            songs.concat(response)

            break if response.size < PER_PAGE

            page += 1
          end

          songs
        end

        def process_artist_search(artist_name)
          response = @api_client.search_artist(artist_name)

          artists = response.map { |hit| hit["result"]["primary_artist"] }.uniq.map do |artist|
            Artist.new(artist)
          end

          if artists.size > 1
            raise AmbiguousArtistError.new(artist_name, artists)
          end

          if artists.any?
            return fetch_and_display_songs_by_artist_id(artists.first.id)
          end

          @stdout.puts "No results found for artist: \"#{artist_name}\""
        end
      end
    end
  end
end
