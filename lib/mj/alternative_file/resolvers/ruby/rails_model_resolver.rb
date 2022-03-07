# frozen_string_literal: true

module Mj
  module AlternativeFile
    module Resolvers
      module Ruby
        class RailsModelResolver < Resolvers::Base
          private

          def apply_to?(file)
            file.extension == "rb"
          end

          def create_alternatives(file, alternatives)
            ruby_file = Ruby::RubyFile.new(file)
            alternatives.push(create_candidate("app/#{ruby_file.class_path}.rb", "model"))
            alternatives.push(create_candidate("spec/#{ruby_file.class_path}_spec.rb", "rspec"))
            alternatives.push(create_candidate("test/#{ruby_file.class_path}_test.rb", "minitest"))
          end
        end
      end
    end
  end
end
