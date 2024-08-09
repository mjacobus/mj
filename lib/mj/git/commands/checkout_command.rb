module Mj
  module Git
    module Commands
      class CheckoutCommand
        attr_reader :branch

        def initialize(branch:, options: {})
          @branch = branch
          @options = options
        end

        def dry_run?
          @options[:dry_run]
        end
      end
    end
  end
end
