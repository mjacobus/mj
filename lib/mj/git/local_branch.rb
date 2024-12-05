# frozen_string_literal: true

module Mj
  module Git
    class LocalBranch
      attr_reader :name

      def initialize(name, command_executer: CommandExecuter.new)
        @name = name
        @command_executer = command_executer
      end

      def length
        @name.length
      end

      def checkout_command
        "git checkout #{name}"
      end

      def to_local
        self
      end
    end
  end
end
