# frozen_string_literal: true

module Mj
  module Git
    module Commands
      class DeleteStaleBranchesCommandHandler
        def initialize(stdout:, command_executer: CommandExecuter.new)
          @stdout = stdout
          @command_executer = command_executer
        end

        def handle(command)
          puts("Deleting stale branches", color: :blue)

          list_command = "git branch -a"
          list_command += " | grep remotes/ | grep -v '/HEAD'"

          branches = Git::Branches
            .from_branch_names(@command_executer.execute(list_command))
            .sort_by(&:last_commit_date)

          branches.each do |branch|
            delete_branch(branch, command: command)
          end
        end

        private

        def delete_branch(branch, command:)
          if delete?(branch, command: command)
            puts("Deleting branch #{branch.name}", color: :green)

            unless command.dry_run?
              delete(branch)
            end
          end
        end

        def delete?(branch, command:) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
          if %w[master main].include?(branch.to_local.name)
            puts("Skipping #{branch.name}. No, no, no, no.", color: :red)
            return false
          end

          if branch.last_commit_date >= command.before_date
            puts("Skipping #{branch.name}. Not before #{command.before_date}", color: :yellow)
            return false
          end

          if branch.last_commit_date < command.after_date
            puts("Skipping #{branch.name}. Not after #{command.after_date}", color: :yellow)
            return false
          end

          if (command.only_with_prs || command.only_with_closed_prs) && branch.pr.nil?
            puts("Skipping #{branch.name}. Does not have PR.", color: :yellow)
            return false
          end

          if command.only_with_closed_prs && !branch.pr.closed?
            puts("Skipping #{branch.name}. PR not closed - state: #{branch.pr.state}.", color: :yellow)
            return false
          end

          true
        end

        def delete(branch)
          branch.delete
        rescue Mj::Git::CommandExecuter::Error => exception
          puts("Could not delete branch #{branch.name}: #{exception.message}", color: :red)
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
