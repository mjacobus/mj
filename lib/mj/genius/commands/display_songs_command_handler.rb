# frozen_string_literal: true

module Mj
  module Genius
    module Commands
      # Handles the logic for the DisplaySongs command
      class DisplaySongsCommandHandler
        def initialize(stdout:)
          @stdout = stdout
        end

        # Process the DisplaySongs command
        # @param [DisplaySongs] command The display songs command object
        def handle(command)
          sorted_songs = command.songs.sort_by(&:title)

          @stdout.puts "Songs:\n"
          sorted_songs.each_with_index do |song, index|
            @stdout.puts "#{index.next}. #{song.title}"
          end
        end
      end
    end
  end
end
