# frozen_string_literal: true

module Mj
  module AlternativeFile
    class Candidate
      attr_reader :path
      attr_reader :type

      def initialize(path:, type:)
        @path = path
        @type = type
      end

      def exist?
        File.exist?(path)
      end
    end
  end
end
