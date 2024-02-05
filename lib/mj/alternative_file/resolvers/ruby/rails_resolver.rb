# frozen_string_literal: true

module Mj
  module AlternativeFile
    module Resolvers
      module Ruby
        class RailsResolver < Resolvers::Base
          attr_reader :root

          def initialize(root: nil)
            if root
              root = "#{root.chomp("/")}/"
            end

            @root = root
          end

          private

          def apply_to?(file)
            file.extension == "rb"
          end

          def add_candidates(file, candidates) # rubocop:disable Metrics/AbcSize
            ruby_file = Ruby::RubyFile.new(file).without_prefix(root)

            add_candidate("#{root}app/#{ruby_file.class_path}.rb", :model, to: candidates)
            add_candidate("#{root}spec/#{ruby_file.class_path}_spec.rb", :spec, to: candidates)
            add_candidate("#{root}test/#{ruby_file.class_path}_test.rb", :minitest, to: candidates)

            # lib files
            add_candidate("#{root}lib/#{ruby_file.class_path}.rb", "lib", to: candidates)
            add_candidate("#{root}#{ruby_file.class_path}.rb", "lib", to: candidates)
            add_candidate("#{root}spec/lib/#{ruby_file.class_path}_spec.rb", :spec, to: candidates)
            add_candidate("#{root}test/lib/#{ruby_file.class_path}_test.rb", :minitest, to: candidates)
          end
        end
      end
    end
  end
end
