# frozen_string_literal: true

module Mj
  module Genius
    module Commands
      # Command class for displaying sorted songs
      class DisplaySongs
        attr_reader :songs

        # Initialize with the songs to display
        # @param [Array<Song>] songs An array of song objects
        def initialize(songs:)
          @songs = songs
        end
      end
    end
  end
end
