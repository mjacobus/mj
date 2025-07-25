# frozen_string_literal: true

module Mj
  module Genius
    module Commands
      # Command class for listing songs of a specific artist
      class ListSongs
        attr_reader :artist, :options

        # Initialize with artist name or ID and additional options
        # @param [String, Integer] artist Name or ID of the artist
        # @param [Hash] options Additional parameters for the command
        def initialize(artist:, options: {})
          @artist = artist
          @options = options
        end
      end
    end
  end
end
