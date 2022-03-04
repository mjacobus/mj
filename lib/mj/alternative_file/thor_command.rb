# frozen_string_literal: true

module Mj
  module AlternativeFile
    class ThorCommand < Thor
      desc "list <reference-file>", "List all alternative files"
      def list(reference_file); end

      desc "next <reference-file>", "Next alternative file"
      def next(reference_file); end

      desc "prev <reference-file>", "Previous alternative file"
      def prev(reference_file); end
    end
  end
end
