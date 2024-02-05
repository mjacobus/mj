# frozen_string_literal: true

module Mj
  module AlternativeFile
    module Resolvers
      module Ruby
        class VendoredGemsResolver < Resolvers::Base
          def initialize
            @rails = RailsResolver.new
          end

          private

          def apply_to?(file)
            file.extension == "rb" && find_root(file)
          end

          def add_candidates(file, candidates) # rubocop:disable Metrics/MethodLength
            root = find_root(file)

            @rails.resolve(file).each do |resolved|
              found = resolved.to_s.sub("#{root}/app/", "")
              found = found.sub("#{root}/", "")

              unless found.match?("_spec.rb")
                found = found.sub("spec/", "")
              end

              unless found.match?("_test.rb")
                found = found.sub("test/", "")
              end

              file = [root, found].flatten.join("/")
              add_candidate(file, resolved.type, to: candidates)
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
