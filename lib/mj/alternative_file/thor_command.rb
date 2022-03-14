# frozen_string_literal: true

require "pathname"
require_relative "candidate"
require_relative "candidates"
require_relative "current_file"
require_relative "resolver"
require_relative "resolvers/base"
require_relative "resolvers/ruby/rails_resolver"
require_relative "resolvers/ruby/rails_controller_resolver"
require_relative "resolvers/ruby/view_component_resolver"
require_relative "resolvers/ruby/packer_resolver"
require_relative "resolvers/ruby/ruby_file"

module Mj
  module AlternativeFile
    class ThorCommand < Thor
      desc "list <reference-file>", "List all alternative files"
      option :types, type: :string, banner: "<comma-separated-types>", aliases: :t
      option :exists, type: :boolean, banner: "files that exist", aliases: :e
      option :debug, type: :boolean, banner: "print debug information", aliases: :d
      def list(reference_file)
        file = CurrentFile.new(reference_file)
        print_candidates(resolve(file))
      end

      desc "next <reference-file>", "Next alternative file"
      option :types, type: :string, banner: "<comma-separated-types>", aliases: :t
      option :exists, type: :boolean, banner: "files that exist", aliases: :e
      option :debug, type: :boolean, banner: "print debug information", aliases: :d
      def next(reference_file)
        file = CurrentFile.new(reference_file)
        candidate = resolve(file).after(file)
        print_candidates([candidate].compact)
      end

      desc "prev <reference-file>", "Previous alternative file"
      option :types, type: :string, banner: "<comma-separated-types>", aliases: :t
      option :exists, type: :boolean, banner: "files that exist", aliases: :e
      option :debug, type: :boolean, banner: "print debug information", aliases: :d
      def prev(reference_file)
        file = CurrentFile.new(reference_file)
        candidate = resolve(file).before(file)
        print_candidates([candidate].compact)
      end

      def self.resolvers
        @resolvers ||= AlternativeFile::Resolver.new.tap do |resolvers|
          resolvers.add(Resolvers::Ruby::RailsResolver.new)
          resolvers.add(Resolvers::Ruby::RailsControllerResolver.new)
          resolvers.add(Resolvers::Ruby::ViewComponentResolver.new)
          resolvers.add(Resolvers::Ruby::PackerResolver.new)
        end
      end

      private

      def print_candidates(candidates)
        $stdout.puts candidates.map { |i| i.to_s(debug: options[:debug]) }.join(" ")
      end

      # rubocop:disable Metrics/MethodLength
      def resolve(file)
        candidates = self.class.resolvers.resolve(file)

        if options[:types]
          candidates = candidates.of_types(options[:types].to_s.split(","))
        end

        if options[:exists]
          candidates = candidates.existing
        end

        unless options[:debug]
          candidates = candidates.unique
        end

        candidates
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
