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
              "test/integration",
              "test/controllers",
              "spec/controllers"
            )
          end

          def add_candidates(file, candidates)
            if file.start_with?("app/controllers")
              add_controller_test(file, candidates, "spec")
              add_controller_test(file, candidates, "test")
              add_integration_test(file, candidates, "spec")
              add_integration_test(file, candidates, "test")
              return
            end

            resolve_controller(file, candidates)
          end

          def add_integration_test(file, candidates, type)
            path = file.without_prefix("app/controllers").without_suffix(".rb").trim_slashes
            candidate = create_candidate("#{type}/integration/#{path}_#{type}.rb", "integration_#{type}")
            candidates.push(candidate)
          end

          def add_controller_test(file, candidates, type)
            path = file.without_prefix("app/controllers").without_suffix(".rb").trim_slashes
            candidate = create_candidate("#{type}/controllers/#{path}_#{type}.rb", "controller_#{type}")
            candidates.push(candidate)
          end

          def resolve_controller(file, candidates)
            controller_path = file.sub("test/integration", "app/controllers")
              .sub("spec/integration", "app/controllers")
              .sub("spec/controllers", "app/controllers")
              .sub("test/controllers", "app/controllers")
              .sub("_spec.rb", ".rb")
              .sub("_test.rb", ".rb")
              .to_s

            candidates.push(create_candidate(controller_path, "controller"))
          end
        end
      end
    end
  end
end
