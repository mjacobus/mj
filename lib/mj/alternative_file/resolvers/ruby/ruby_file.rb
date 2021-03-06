# frozen_string_literal: true

module Mj
  module AlternativeFile
    module Resolvers
      module Ruby
        class RubyFile < AlternativeFile::CurrentFile
          def class_path
            path_without_extension
              .without_prefix("spec")
              .without_prefix("test")
              .without_prefix("app")
              .without_prefix("lib")
              .without_suffix("_spec")
              .without_suffix("_test")
              .trim_slashes
          end
        end
      end
    end
  end
end
