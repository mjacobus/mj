# frozen_string_literal: true

module Mj
  module AlternativeFile
    class Resolver
      def initialize
        @stack = []
      end

      def add(resolver)
        @stack.push(resolver)
      end

      def resolve(file)
        file = AlternativeFile::CurrentFile.new(file.to_s)
        resolved = @stack.map do |resolver|
          resolver.resolve(file)
        end

        AlternativeFile::Candidates.new(resolved.flatten.compact)
      end
    end
  end
end
