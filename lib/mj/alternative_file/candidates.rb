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

      def existing
        select(&:exist?)
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

      def sorted_by_path
        new(@items.sort_by(&:path))
      end

      private

      def new(*args)
        self.class.new(*args)
      end

      def next_file(items, reference_file)
        index = items.find_index { |e| e.path.to_s == reference_file.path.to_s } || -1
        items[index + 1] || items.first
      end
    end
  end
end
