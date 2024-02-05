# frozen_string_literal: true

module Mj
  module AlternativeFile
    module Resolvers
      module Ruby
        class VendoredGemsResolver < Resolvers::Base
          private

          def apply_to?(file)
            file.extension == "rb" && find_root(file)
          end

          def add_candidates(file, candidates)
            @rails = RailsResolver.new(root: find_root(file))

            @rails.resolve(file).each do |resolved|
              add_candidate(resolved, resolved.type, to: candidates)
            end
          end

          def find_root(file)
            root = nil

            parts = file.to_s.split("/")
            parts.each do |part|
              root = [root, part].compact.join("/")

              if Dir["#{root}/*.gemspec"].any?
                return root
              end
            end

            nil
          end
        end
      end
    end
  end
end
