module Mj
  module Git
    class LocalBranch
      attr_reader :name

      def initialize(name)
        @name = name
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
