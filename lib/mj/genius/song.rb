# frozen_string_literal: true

require "net/http"
require "json"

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
    end
  end
end
