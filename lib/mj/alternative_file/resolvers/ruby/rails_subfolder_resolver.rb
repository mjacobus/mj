# frozen_string_literal: true

module Mj
  module AlternativeFile
    module Resolvers
      module Ruby
        class RailsSubfolderResolver < Resolvers::Base
          private

          def apply_to?(file)
            file.extension == "rb" && file.to_s.match?(%r{^apps/\w+})
          end

          def add_candidates(file, candidates)
            subfolder = file.to_s.match(%r{^apps/\w+}).to_s
            resolver = RailsResolver.new(root: subfolder)
            resolver.resolve(file).each do |candidate|
              add_candidate(candidate.path, candidate.type, to: candidates)
            end
          end
        end
      end
    end
  end
end
