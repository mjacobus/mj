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
        false
      end

      def pr_closed?
        false
      end

      def delete
        @command_executer.execute("git push origin :#{local_branch_name}")
      end

      private

      def local_branch_name
        pattern = %r{^remotes/\w+/}
        name.sub(pattern, "")
      end
    end
  end
end
