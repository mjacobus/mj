# frozen_string_literal: true

require_relative "../branches"
require "colorize"

module Mj
  module Git
    module Commands
      class CheckoutCommandHandler
        def initialize(stdout:, command_executer: CommandExecuter.new)
          @stdout = stdout
          @command_executer = command_executer
        end

        def handle(command)
          branches = @command_executer.execute("git branch -a")
          branches = Git::Branches.from_branch_names(branches).matching(command.branch)

          if branches.to_local.uniq.length > 1
            warn_multiple_matches(branches)
          end

          winner = branches.min_by(&:length)

          if winner.nil?
            puts("No branche found matching #{command.branch}", color: :red)
            exit(1)
          end

          puts(winner.checkout_command, color: :green)

          if command.dry_run?
            return
          end

          @command_executer.execute(winner.checkout_command)
        end

        private

        def warn_multiple_matches(branches)
          puts("Multiple branches found:", color: :blue)

          branches.each do |branch|
            puts("\t#{branch.name}", color: :yellow)
          end
          puts("\n")
        end

        def puts(string, color: nil)
          if color
            string = string.colorize(color)
          end

          @stdout.puts(string)
        end
      end
    end
  end
end
