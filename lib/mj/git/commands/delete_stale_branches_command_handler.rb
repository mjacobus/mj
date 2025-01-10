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
            puts("Deleting branch #{branch.name} \t| #{branch.summary}", color: :green)

            unless command.dry_run?
              delete(branch)
            end
          end
        end

        def delete?(branch, command:) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
          if %w[master main].include?(branch.to_local.name)
            puts("Skipping #{branch.summary}. No, no, no, no.", color: :red)
            return false
          end

          if branch.last_commit_date >= command.before_date
            return cannot_delete(branch, "Not before #{command.before_date}.")
          end

          if branch.last_commit_date < command.after_date
            return cannot_delete(branch, "Not after #{command.after_date}.")
          end

          unless commiter_check(command, branch)
            return false
          end

          # PR checks later - more efficient. May not have to check them if any of the above is falsy

          if (command.only_with_prs || command.only_with_closed_prs) && branch.pr.nil?
            return cannot_delete(branch, "Does not have a PR")
          end

          if command.only_with_closed_prs && !branch.pr.closed?
            return cannot_delete(branch, "PR not closed - state: #{branch.pr.state}.")
          end

          unless pull_request_author_check(command, branch)
            return false
          end

          true
        end

        def delete(branch)
          branch.delete
        rescue Mj::Git::CommandExecuter::Error => exception
          puts("Could not delete branch #{branch.name}: #{exception.message}.", color: :red)
        end

        def cannot_delete(branch, reason)
          puts("Skipping #{branch.name} \t| #{reason}.", color: :yellow)

          false
        end

        def pull_request_author_check(command, branch)
          if command.from_pull_requestors.empty?
            return true
          end

          if branch.has_pr? && command.from_pull_requestors.include?(branch.pr.author.login)
            return true
          end

          cannot_delete(branch, "PR not from pull requestors: #{command.from_pull_requestors.join(", ")}.")
        end

        def commiter_check(command, branch)
          if command.from_commiters.empty?
            return true
          end

          email = branch.last_commiter_email

          if email && command.from_commiters.map(&:downcase).include?(email)
            return true
          end

          cannot_delete(branch, "PR not from commiters: #{command.from_commiters.join(", ")}.")
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
