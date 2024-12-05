# frozen_string_literal: true

module Mj
  module Git
    class RemoteBranch
      attr_reader :name

      def initialize(name, command_executer: CommandExecuter.new)
        @name = name
        @command_executer = command_executer
      end

      def checkout_command
        "git checkout -b #{local_branch_name} #{name}"
      end

      def last_commit_date
        @last_commit_date ||= DateTime.parse(@command_executer.execute("git log -1 --format=%cd #{name}").first)
      end

      def length
        @name.length
      end

      def to_local
        LocalBranch.new(local_branch_name)
      end

      def has_pr?
        !pr.nil?
      end

      # @return [Git::PullRequest]
      def pr
        if defined?(@pr)
          return @pr
        end

        @pr ||= fetch_pr
      end

      def delete
        @command_executer.execute("git push origin :#{local_branch_name}")
      end

      private

      def local_branch_name
        pattern = %r{^remotes/\w+/}
        name.sub(pattern, "")
      end

      def fetch_pr # rubocop:disable Metrics/MethodLength
        data = @command_executer.execute(
          "gh pr list --head #{local_branch_name} --state=all --json=number,state,title,updatedAt"
        )

        data = JSON.parse(data.join("")).first

        if data.nil?
          return
        end

        # I.E. ["14", "WIP on packer", "handle-packer-files", "DRAFT", "2022-03-14T20:14:17Z"]
        Git::PullRequest.new(
          number: data['number'],
          title: data['title'],
          state: data['state'],
          updated_at: DateTime.parse(data['updatedAt'])
        )
      rescue StandardError
        nil
      end
    end
  end
end
