module Mj
  module ChatGpt
    module Commands
      class AskCommandHandler
        def handle(command)
          return {
            question: command.question,
            options: command.options
          }
        end
      end
    end
  end
end
