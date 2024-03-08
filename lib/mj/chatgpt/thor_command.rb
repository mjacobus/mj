# frozen_string_literal: true

require_relative "commands/ask_command_handler"
require_relative "commands/ask_command"

module Mj
  module ChatGpt
    class ThorCommand < Thor
      desc "ask <question>", "Ask ChatGPT a question"
      option :config_file, type: :string, desc: "Config file"
      def ask(question)
        client_config = {
          access_token: ENV.fetch("OPENAI_ACCESS_TOKEN")
        }
        client = OpenAI::Client.new(**client_config.compact)
        handler = Commands::AskCommandHandler.new(client: client)
        data = handler.handle(Commands::AskCommand.new(question, options: options))
        $stdout.puts JSON.generate(data)
      end
    end
  end
end
