module Mj
  module Git
    class LocalBranch
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def checkout_command
        "git checkout #{name}"
      end
    end
  end
end
