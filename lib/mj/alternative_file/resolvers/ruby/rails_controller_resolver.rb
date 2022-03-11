# frozen_string_literal: true

module Mj
  module AlternativeFile
    module Resolvers
      module Ruby
        class RailsControllerResolver < Resolvers::Base
          private

          def apply_to?(file)
            file.extension == "rb" && file.start_with?(
              "app/controllers",
              "spec/integration",
              "test/integration"
            )
          end

          def create_alternatives(file, alternatives)
            if file.start_with?("app/controllers")
              add_integration_test_for_controller(file, alternatives)
              add_integration_spec_for_controller(file, alternatives)
              return
            end

            resolve_controller(file, alternatives)
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

          def resolve_controller(file, alternatives)
            controller_path = file.sub("test/integration", "app/controllers")
              .sub("spec/integration", "app/controllers")
              .sub("_spec.rb", ".rb")
              .sub("_test.rb", ".rb")
              .to_s

            alternatives.push(create_candidate(controller_path, "controller"))
          end
        end
      end
    end
  end
end
