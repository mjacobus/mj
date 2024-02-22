# frozen_string_literal: true

require_relative "commands/query_file_command_handler"
require_relative "commands/query_file_command"
require "json"

module Mj
  module GraphQL
    class ThorCommand < Thor
      desc "query_file <file>", "Execute a query based on a .graqphql file"
      def query_file(file)
        handler = Commands::QueryFileCommandHandler.new
        data = handler.handle(Commands::QueryFileCommand.new(file, options))
        $stdout.puts JSON.generate(data)
      end
    end
  end
end
