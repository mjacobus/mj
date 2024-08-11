# frozen_string_literal: true

module Mj
  module Git
    class RemoteBranch
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def checkout_command
        "git checkout -b #{local_branch_name} #{name}"
      end

      def length
        @name.length
      end

      def to_local
        LocalBranch.new(local_branch_name)
      end

      private

      def local_branch_name
        pattern = %r{^remotes/\w+/}
        name.sub(pattern, "")
      end
    end
  end
end
