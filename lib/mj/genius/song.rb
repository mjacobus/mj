# frozen_string_literal: true

module Mj
  module Genius
    class Song
      # Direct attributes from the api
      def initialize(attributes)
        @attributes = attributes
      end

      def title
        @attributes["title"]
      end

      def artist
        @attributes["primary_artist"]["name"]
      end

      def artist_id
        @attributes["primary_artist"]["id"]
      end
    end
  end
end
