# frozen_string_literal: true

require "pathname"
require_relative "candidate"
require_relative "candidates"
require_relative "current_file"
require_relative "resolver"
require_relative "resolvers/base"
require_relative "resolvers/ruby/rails_resolver"
require_relative "resolvers/ruby/ruby_file"

module Mj
  module AlternativeFile
    class ThorCommand < Thor
      desc "list <reference-file>", "List all alternative files"
      option :types, type: :string, banner: "<comma-separated-types>", aliases: :t
      option :exists, type: :boolean, banner: "files that exist", aliases: :e
      def list(reference_file)
        file = CurrentFile.new(reference_file)
        print_candidates(resolve(file))
      end

      desc "next <reference-file>", "Next alternative file"
      option :types, type: :string, banner: "<comma-separated-types>", aliases: :t
      option :exists, type: :boolean, banner: "files that exist", aliases: :e
      def next(reference_file)
        file = CurrentFile.new(reference_file)
        candidate = resolve(file).after(file)
        print_candidates([candidate])
      end

      desc "prev <reference-file>", "Previous alternative file"
      option :types, type: :string, banner: "<comma-separated-types>", aliases: :t
      option :exists, type: :boolean, banner: "files that exist", aliases: :e
      def prev(reference_file)
        file = CurrentFile.new(reference_file)
        candidate = resolve(file).before(file)
        print_candidates([candidate])
      end

      def self.resolvers
        @resolvers ||= AlternativeFile::Resolver.new.tap do |resolvers|
          resolvers.add(Resolvers::Ruby::RailsResolver.new)
        end
      end

      private

      def print_candidates(candidates)
        $stdout.puts candidates.compact.map(&:path).join(" ")
      end

      def resolve(file)
        candidates = self.class.resolvers.resolve(file)

        if options[:types]
          candidates = candidates.of_types(options[:types].to_s.split(","))
        end

        if options[:exists]
          candidates = candidates.existing
        end

        candidates.unique
      end
    end
  end
end
