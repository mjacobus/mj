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
            add_candidate("app/#{ruby_file.class_path}.rb", :model, to: candidates)
            add_candidate("spec/#{ruby_file.class_path}_spec.rb", :spec, to: candidates)
            add_candidate("test/#{ruby_file.class_path}_test.rb", :minitest, to: candidates)

            # lib files
            add_candidate("lib/#{ruby_file.class_path}.rb", "lib", to: candidates)
          end
        end
      end
    end
  end
end
