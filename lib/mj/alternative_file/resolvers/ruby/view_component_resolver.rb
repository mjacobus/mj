# frozen_string_literal: true

module Mj
  module AlternativeFile
    module Resolvers
      module Ruby
        class ViewComponentResolver < Resolvers::Base
          private

          def apply_to?(file)
            file.end_with?("component.rb", "component.html.erb")
          end

          def add_candidates(file, candidates)
            if file.end_with?("component.rb")
              return resolve_template(file, candidates)
            end

            resolve_component_class(file, candidates)
          end

          def resolve_template(file, candidates)
            file_name = file.sub(/_component.rb$/, "_component.html.erb")
            add_candidate(file_name, "component_template", to: candidates)
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
