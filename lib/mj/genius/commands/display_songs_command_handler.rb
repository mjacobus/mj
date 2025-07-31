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

          @stdout.puts "Songs by #{sorted_songs.first.artist}:\n"
          total_songs = sorted_songs.length
          padding = [total_songs.to_s.length, 1].max

          sorted_songs.each_with_index do |song, index|
            padded_index = format("%#{padding}d", index.next).rjust(padding)
            number = "#{padded_index}.".gray
            @stdout.puts "#{number} #{song.title.blue}"
          end
        end
      end
    end
  end
end
