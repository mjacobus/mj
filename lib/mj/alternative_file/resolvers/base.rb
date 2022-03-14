# frozen_string_literal: true

module Mj
  module AlternativeFile
    module Resolvers
      class Base
        def resolve(file)
          [].tap do |alternatives|
            if apply_to?(file)
              add_candidates(file, alternatives)
            end
          end
        end

        private

        def create_candidate(path, type)
          AlternativeFile::Candidate.new(
            path: path.to_s,
            type: type.to_s,
            metadata: { resolved_by: self.class.name }
          )
        end

        def apply_to?(_file)
          raise NoMethodError, "Method apply_to? not implemented"
        end
      end
    end
  end
end
