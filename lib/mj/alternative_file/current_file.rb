# frozen_string_literal: true

module Mj
  module AlternativeFile
    class CurrentFile
      attr_reader :path

      def initialize(path)
        @path = Pathname.new(path.to_s)
      end

      def to_s
        path.to_s
      end

      def extension
        parts = split(".")

        if parts.length > 1
          parts.last
        end
      end

      def trim_slashes
        to_s.gsub("//", "/").sub(%r{^/}, "").sub(%r{/$}, "")
      end

      def path_without_extension
        sub(/.#{extension}$/, "")
      end

      def name
        to_s.split("/").last
      end

      def split(char = "/")
        to_s.split(char)
      end

      def start_with?(*args)
        to_s.start_with?(*args)
      end

      def without_prefix(prefix)
        sub(/^#{prefix}/, "")
      end

      def without_suffix(suffix)
        sub(/#{suffix}$/, "")
      end

      def match?(*args)
        to_s.match?(*args)
      end

      def sub(find, replace)
        new(to_s.sub(find, replace))
      end

      def gsub(find, replace)
        new(to_s.gsub(find, replace))
      end

      def join(other_part)
        new(@path.join(other_part.to_s))
      end

      def prefix_with(prefix)
        new(prefix).join(self)
      end

      def exist?
        ::File.exist?(to_s)
      end

      private

      def new(path)
        self.class.new(path)
      end
    end
  end
end
