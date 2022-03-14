# frozen_string_literal: true

module Mj
  module AlternativeFile
    module Resolvers
      module Ruby
        class PackerResolver < Resolvers::Base
          private

          def apply_to?(file)
            file.start_with?("packages") && file.extension == ".rb"
          end

          def create_alternatives(file, _candidates)
            if test_file?(file)
            end

            ruby_file = RubyFile.new(file)
            ruby_file.class_path
            add_candidate("#{ruby_file.class_path}_test.rb", "minitest", alternatives)
          end

          def test_file?(file)
            file.end_with?("_test.rb", "_spec.rb")
          end

          # def resolve_template(file, alternatives)
          #   file_name = file.sub(/_component.rb$/, "_component.html.erb")
          #   alternatives.push(create_candidate(file_name, "component_template"))
          # end
          #
          # def resolve_component_class(file, alternatives)
          #   file_name = file.sub(/_component.html.erb$/, "_component.rb")
          #   alternatives.push(create_candidate(file_name, "component_class"))
          # end
        end
      end
    end
  end
end
