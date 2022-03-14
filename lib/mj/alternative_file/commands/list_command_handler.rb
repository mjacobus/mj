# frozen_string_literal: true

module Mj
  module AlternativeFile
    module Commands
      class ListCommandHandler
        def initialize(resolvers:)
          @resolvers = resolvers
        end

        # rubocop:disable Metrics/MethodLength
        def handle(command)
          candidates = @resolvers.resolve(command.file)

          if command.types.any?
            candidates = candidates.of_types(command.types)
          end

          if command.exists?
            candidates = candidates.existing
          end

          unless command.debug?
            candidates = candidates.unique
          end

          candidates.sorted_by_path
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
