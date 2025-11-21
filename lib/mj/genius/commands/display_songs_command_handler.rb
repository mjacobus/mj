# frozen_string_literal: true

require "terminal-table"
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

          if command.format == "table"
            return render_table(sorted_songs)
          end

          render_plain(sorted_songs)
        end

        private

        def render_plain(songs)
          total_songs = songs.length
          padding = [total_songs.to_s.length, 1].max

          @stdout.puts "Songs by #{songs.first.artist}:\n"

          songs.each_with_index do |song, index|
            padded_index = format("%#{padding}d", index.next).rjust(padding)
            number = "#{padded_index}.".gray
            @stdout.puts "#{number} #{song.title.blue}"
          end
        end

        def render_table(songs)
          rows = [["#".gray, "Song".gray, "Artist".gray]]

          songs.each_with_index do |song, index|
            artist_id = "(#{song.artist_id})".gray
            rows << [
              index.next.to_s.gray,
              song.title.blue,
              "#{song.artist.yellow} #{artist_id}"
            ]
          end
          @stdout.puts(Terminal::Table.new(rows: rows))
        end
      end
    end
  end
end
