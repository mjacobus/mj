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
          total_songs = sorted_songs.length
          padding = [total_songs.to_s.length, 1].max

          sorted_songs.each_with_index do |song, index|
            padded_index = format("%#{padding}d", index.next).rjust(padding)
            @stdout.puts "#{padded_index}. #{song.title}"
          end
        end
      end
    end
  end
end
