require_relative "local_branch"
require_relative "remote_branch"

module Mj
  module Git
    class Branches
      include Enumerable

      def self.from_branch_names(branch_names)
        branches = branch_names.map do |branch|
          branch = branch.sub("*", "").strip

          if branch.start_with?("remotes/")
            next RemoteBranch.new(branch)
          end

          next LocalBranch.new(branch)
        end

        new(branches)
      end

      def initialize(branches)
        @branches = branches
      end

      def each(&block)
        @branches.each(&block)
      end

      def length
        @branches.length
      end

      def matching(pattern)
        self.class.new(@branches.select { |branch| branch.name.match?(pattern) })
      end
    end
  end
end
