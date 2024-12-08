# frozen_string_literal: true

require_relative "local_branch"
require_relative "remote_branch"
require_relative "pull_request"
require_relative "pull_request_author"

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

      def to_local
        self.class.new(map(&:to_local))
      end

      def uniq
        branches = {}
        each do |branch|
          branches[branch.name] ||= branch
        end

        self.class.new(branches.values)
      end

      def initialize(branches)
        @branches = branches
      end

      def each(&block)
        @branches.each(&block)
      end

      def sort_by(&block)
        self.class.new(@branches.sort_by(&block))
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
