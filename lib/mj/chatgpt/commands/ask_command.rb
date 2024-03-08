# frozen_string_literal: true

module Mj
  module ChatGpt
    module Commands
      class AskCommand
        attr_reader :question
        attr_reader :options

        def initialize(question, options: {})
          @question = question
          @options = options
        end
      end
    end
  end
end
