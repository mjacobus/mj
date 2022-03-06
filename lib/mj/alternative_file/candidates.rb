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

      def after(reference_file)
        next_file(@items, reference_file)
      end

      def before(reference_file)
        next_file(@items.reverse, reference_file)
      end

      private

      def new(*args)
        self.class.new(*args)
      end

      def next_file(items, reference_file)
        items = items.dup
        items.push(items.first)
        items.each_with_index do |item, index|
          if item.path == reference_file.path
            return items[index + 1]
          end
        end
        items.first
      end
    end
  end
end
