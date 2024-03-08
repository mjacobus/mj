# frozen_string_literal: true

require_relative "commands/ask_command_handler"
require_relative "commands/ask_command"

module Mj
  module ChatGpt
    class ThorCommand < Thor
      desc "ask <question>", "Ask ChatGPT a question"
      option :request_file, type: :string, desc: "Request file"
      def ask(question)
        handler = Commands::AskCommandHandler.new
        data = handler.handle(Commands::AskCommand.new(question, options: options))
        $stdout.puts JSON.generate(data)
      end
    end
  end
end
