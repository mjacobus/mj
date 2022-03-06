# frozen_string_literal: true

module Mj
  module AlternativeFile
    class Candidates
      include Enumerable

      def initialize(candidates = [])
        @items = candidates.dup
      end

      def each(&block)
        @items.each(&block)
      end

      def add(candidate)
        @items.push(candidate)
      end

      def of_types(types)
        select { |item| types.include?(item.type) }
      end

      def unique
        new(@items.uniq(&:path))
      end

      def select(&block)
        new(@items.select(&block))
      end

      private

      def new(*args)
        self.class.new(*args)
      end
    end
  end
end
