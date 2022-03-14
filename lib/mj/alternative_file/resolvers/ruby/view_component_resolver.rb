# frozen_string_literal: true

module Mj
  module AlternativeFile
    module Resolvers
      module Ruby
        class ViewComponentResolver < Resolvers::Base
          private

          def apply_to?(file)
            file.end_with?(
              "component.rb",
              "component.html.erb",
              "component_test.rb",
              "component_spec.rb"
            )
          end

          def add_candidates(file, candidates)
            if file.extension == "rb"
              return resolve_template(file, candidates)
            end

            resolve_component_class(file, candidates)
          end

          def resolve_template(file, candidates)
            file = file.sub(/_component(_test|_spec)?.rb$/, "_component.html.erb")
            file = file.sub(/^(spec|test)/, "app")
            add_candidate(file, "component_template", to: candidates)
          end

          def resolve_component_class(file, candidates)
            file_name = file.sub(/_component.html.erb$/, "_component.rb")
            add_candidate(file_name, "component_class", to: candidates)
          end
        end
      end
    end
  end
end
