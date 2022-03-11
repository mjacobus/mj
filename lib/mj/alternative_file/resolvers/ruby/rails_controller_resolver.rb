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
              add_integration_test(file, alternatives, "spec")
              add_integration_test(file, alternatives, "test")
              return
            end

            resolve_controller(file, alternatives)
          end

          def add_integration_test(file, alternatives, type)
            path = file.without_prefix("app/controllers").without_suffix(".rb").trim_slashes
            alternative = create_candidate("#{type}/integration/#{path}_#{type}.rb", "integration_#{type}")
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
