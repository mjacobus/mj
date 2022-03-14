# frozen_string_literal: true

module Mj
  module AlternativeFile
    module Resolvers
      class Base
        def resolve(file)
          [].tap do |candidates|
            if apply_to?(file)
              add_candidates(file, candidates)
            end
          end
        end

        private

        def add_candidate(path, type, to:)
          candidate = AlternativeFile::Candidate.new(
            path: path.to_s,
            type: type.to_s,
            metadata: { resolved_by: self.class.name }
          )

          to.push(candidate)
        end

        def apply_to?(_file)
          raise NoMethodError, "Method apply_to? not implemented"
        end
      end
    end
  end
end
