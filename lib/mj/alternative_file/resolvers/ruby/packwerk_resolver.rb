# frozen_string_literal: true

module Mj
  module AlternativeFile
    module Resolvers
      module Ruby
        class PackwerkResolver < Resolvers::Base
          def initialize
            @rails = RailsResolver.new
          end

          private

          def apply_to?(file)
            file.extension == "rb" && file.start_with?(
              "packages",
              "spec",
              "test"
            )
          end

          def add_candidates(file, candidates) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
            parts = file.split("/")
            prefix = []
            prefix.push(parts.shift)
            prefix.push(parts.shift)

            file = parts.join("/")
            file = CurrentFile.new(file)

            @rails.resolve(file).each do |resolved|
              file = [prefix, resolved].flatten.join("/")
              file = file.sub("/spec/public/", "/spec/")
              file = file.sub("/test/public/", "/test/")
              add_candidate(file, resolved.type, to: candidates)
            end

            add_public(candidates)
          end

          def add_public(candidates)
            public_candidates = candidates.reject do |file|
              file.type == :spec || file.type == :minitest
            end

            public_candidates.each do |candidate|
              parts = candidate.path.split("/app/")
              public_candidate = [parts[0], "/app/public/", parts[1]].compact.join
              add_candidate(public_candidate, candidate.type, to: candidates)
            end
          end
        end
      end
    end
  end
end
