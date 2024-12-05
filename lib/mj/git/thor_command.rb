# frozen_string_literal: true

require_relative "commands/checkout_command_handler"
require_relative "commands/checkout_command"
require_relative "commands/delete_stale_branches_command_handler"
require_relative "commands/delete_stale_branches_command"
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

      desc "delete_stale_branches", "Partial branch"
      option :dry_run,
             type: :boolean,
             banner: "Just outputs, does not delete",
             aliases: :d
      option :only_with_prs, type: :boolean, banner: "Only branches tht have PRs", aliases: :p
      option :only_with_closed_prs,
             type: :boolean,
             banner: "Only branches tht have PRs that are merged or closed",
             aliases: :c
      option :before_date,
             type: :string,
             banner: "Formatted date YYY-MM-DD",
             aliases: :b
      def delete_stale_branches
        command = Commands::DeleteStaleBranchesCommand.new(options: options)
        handler = Commands::DeleteStaleBranchesCommandHandler.new(stdout: $stdout)
        handler.handle(command)
      end
    end
  end
end
