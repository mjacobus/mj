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
              "spec/controllers",
              "spec/requests",
              "test/requests"
            )
          end

          def add_candidates(file, candidates)
            if file.start_with?("app/controllers")
              add_controller_test(file, candidates, "spec")
              add_controller_test(file, candidates, "test")
              add_integration_test(file, candidates, "spec")
              add_integration_test(file, candidates, "test")
              add_request_test(file, candidates, "spec")
              add_request_test(file, candidates, "test")
              return
            end

            resolve_controller(file, candidates)
          end

          def add_integration_test(file, candidates, type)
            path = file.without_prefix("app/controllers").without_suffix(".rb").trim_slashes
            add_candidate("#{type}/integration/#{path}_#{type}.rb", "integration_#{type}", to: candidates)
          end

          def add_request_test(file, candidates, type)
            path = file.without_prefix("app/controllers").sub("_controller", "").without_suffix(".rb").trim_slashes
            add_candidate("#{type}/requests/#{path}_#{type}.rb", "request_#{type}", to: candidates)
          end

          def add_controller_test(file, candidates, type)
            path = file.without_prefix("app/controllers").without_suffix(".rb").trim_slashes
            add_candidate("#{type}/controllers/#{path}_#{type}.rb", "controller_#{type}", to: candidates)
          end

          # rubocop:disable Metrics/MethodLength
          def resolve_controller(file, candidates)
            # requests specs don't usually have "request_{type}.rb" suffix
            if file.start_with?(%r{(test|spec)/requests})
              file = file.sub("requests", "controllers")
                .sub("_spec.rb", "_controller_spec.rb")
                .sub("_test.rb", "_controller_test.rb")
            end

            controller_path = file.sub("test/integration", "app/controllers")
              .sub("spec/integration", "app/controllers")
              .sub("spec/controllers", "app/controllers")
              .sub("test/controllers", "app/controllers")
              .sub("_spec.rb", ".rb")
              .sub("_test.rb", ".rb")
              .to_s

            add_candidate(controller_path, "controller", to: candidates)
          end
          # rubocop:enable Metrics/MethodLength
        end
      end
    end
  end
end
