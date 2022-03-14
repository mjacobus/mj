# frozen_string_literal: true

module Mj
  module AlternativeFile
    module Resolvers
      module Ruby
        class RailsResolver < Resolvers::Base
          private

          def apply_to?(file)
            file.extension == "rb"
          end

          def add_candidates(file, candidates)
            ruby_file = Ruby::RubyFile.new(file)
            candidates.push(create_candidate("app/#{ruby_file.class_path}.rb", "model"))
            candidates.push(create_candidate("spec/#{ruby_file.class_path}_spec.rb", "spec"))
            candidates.push(create_candidate("test/#{ruby_file.class_path}_test.rb", "minitest"))

            # lib files
            candidates.push(create_candidate("lib/#{ruby_file.class_path}.rb", "lib"))
          end
        end
      end
    end
  end
end
