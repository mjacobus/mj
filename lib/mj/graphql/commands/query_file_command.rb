# frozen_string_literal: true

module Mj
  module GraphQL
    module Commands
      class QueryFileCommand
        attr_reader :file
        attr_reader :options

        def initialize(file, options)
          @file = file
          @options = options
        end
      end
    end
  end
end
