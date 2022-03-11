# frozen_string_literal: true

module Mj
  module AlternativeFile
    module Resolvers
      class Base
        def resolve(file)
          [].tap do |alternatives|
            if apply_to?(file)
              create_alternatives(file, alternatives)
            end
          end
        end

        private

        def create_candidate(path, type)
          AlternativeFile::Candidate.new(path: path, type: type)
        end

        def apply_to?(_file)
          raise NoMethodError, "Method apply_to? not implemented"
        end
      end
    end
  end
end
