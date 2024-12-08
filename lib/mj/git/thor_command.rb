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

      desc "delete_stale_branches", "Delete remote stale branches"
      option :dry_run,
             type: :boolean,
             banner: "Just outputs, does not delete",
             aliases: :d
      option :only_with_prs,
             type: :boolean,
             banner: "Only branches that have PRs (Branch can be restored from PR page)",
             aliases: :p
      option :only_with_closed_prs,
             type: :boolean,
             banner: "Do not delete if PRs are in DRAFT or OPEN - will they maybe be merged?",
             aliases: :c
      option :after_date,
             type: :string,
             banner: "Formatted date YYY-MM-DD",
             aliases: :a
      option :before_date,
             type: :string,
             banner: "Formatted date YYY-MM-DD",
             aliases: :b
      option :from_pull_requestors,
             type: :string,
             banner: "Comma separated github usernames",
             aliases: :u
      option :from_commiters,
             type: :string,
             banner: "Comma separated commiter emails - assumes last commiter",
             aliases: :e
      def delete_stale_branches
        command = Commands::DeleteStaleBranchesCommand.new(options: options)
        handler = Commands::DeleteStaleBranchesCommandHandler.new(stdout: $stdout)
        handler.handle(command)
      end
    end
  end
end
