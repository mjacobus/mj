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
        self.class.new.tap do |selection|
          each do |item|
            if types.include?(item.type)
              selection.add(item)
            end
          end
        end
      end

      def unique
        self.class.new.tap do |selection|
          each_with_object([]) do |i, paths|
            unless paths.include?(i.path)
              selection.add(i)
              paths.push(i.path)
            end
          end
        end
      end
    end
  end
end
