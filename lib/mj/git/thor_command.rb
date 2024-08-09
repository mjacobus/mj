require_relative "commands/checkout_command_handler"
require_relative "commands/checkout_command"
require_relative "command_executer"

module Mj
  module Git
    class ThorCommand < Thor
      desc "checkout <branch>", "Partial branch"
      option :dry_run, type: :boolean, banner: "Just outputs, does not checkout", aliases: :d
      def checkout(branch)
        command = Commands::CheckoutCommand.new(branch: branch, options: options)
        handler = Commands::CheckoutCommandHandler.new(stdout: $stdout)
        handler.handle(command)
      end
    end
  end
end
