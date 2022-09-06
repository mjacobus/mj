# frozen_string_literal: true

module Mj
  module AlternativeFile
    class Candidate
      attr_reader :path
      attr_reader :type

      def initialize(path:, type:, metadata: {})
        @path = path
        @type = type
        @metadata = metadata || {}
      end

      def exist?
        File.exist?(path)
      end

      def ==(other)
        unless other.is_a?(self.class)
          return false
        end

        other.path == path && other.type == type
      end

      def inspect
        "#{path}|#{type}"
      end

      def to_s(debug: false)
        parts = [path]

        if debug
          parts.push("(#{metadata})")
        end

        parts.join
      end

      private

      def metadata
        data = {
          type: type,
          exists: exist?
        }

        @metadata.keys.sort.each do |key|
          data[key] = @metadata[key]
        end

        data.map { |k, v| "#{k}:#{v}" }.join(",")
      end
    end
  end
end
