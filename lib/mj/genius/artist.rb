# frozen_string_literal: true

module Mj
  module Genius
    class Artist
      # Direct attributes from the api
      def initialize(attributes)
        @attributes = attributes
      end

      def id
        @attributes["id"]
      end

      def name
        @attributes["name"]
      end
    end
  end
end
