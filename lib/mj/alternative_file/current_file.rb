# frozen_string_literal: true

module Mj
  module AlternativeFile
    class CurrentFile
      attr_reader :path

      def initialize(path)
        @path = path
      end
    end
  end
end
