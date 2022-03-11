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

          def create_alternatives(file, alternatives)
            ruby_file = Ruby::RubyFile.new(file)
            alternatives.push(create_candidate("app/#{ruby_file.class_path}.rb", "model"))
            alternatives.push(create_candidate("spec/#{ruby_file.class_path}_spec.rb", "rspec"))
            alternatives.push(create_candidate("test/#{ruby_file.class_path}_test.rb", "minitest"))

            handle_controllers(file, alternatives)
          end

          def handle_controllers(file, alternatives)
            if file.start_with?("app/controllers")
              add_integration_test_for_controller(file, alternatives)
              add_integration_spec_for_controller(file, alternatives)
            end

            if file.start_with?("test/integration", "spec/integration")
              controller_path = file.sub("test/integration", "app/controllers")
                .sub("spec/integration", "app/controllers")
                .sub("_spec.rb", ".rb")
                .sub("_test.rb", ".rb")
                .to_s

              alternatives.push(create_candidate(controller_path, "controller"))
            end
          end

          def add_integration_test_for_controller(file, alternatives)
            test_path = file.without_prefix("app/controllers").without_suffix(".rb").trim_slashes

            alternative = create_candidate("test/integration/#{test_path}_test.rb", "integration_test")

            alternatives.push(alternative)
          end

          def add_integration_spec_for_controller(file, alternatives)
            spec_path = file.without_prefix("app/controllers").without_suffix(".rb").trim_slashes

            alternative = create_candidate("spec/integration/#{spec_path}_spec.rb", "integration_spec")

            alternatives.push(alternative)
          end
        end
      end
    end
  end
end
