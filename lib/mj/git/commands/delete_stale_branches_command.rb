# frozen_string_literal: true

module Mj
  module Git
    module Commands
      class DeleteStaleBranchesCommand
        def initialize(options: {})
          @options = options
        end

        def dry_run?
          @options[:dry_run]
        end

        def before_date
          if @before_date
            return @before_date
          end

          if @options[:before_date]
            @before_date ||= DateTime.parse(@options[:before_date])
          end

          # Default to now, because all things happened before now.
          @before_date ||= DateTime.now
        end

        def only_with_prs
          @options[:only_with_prs]
        end

        def only_with_closed_prs
          @options[:only_with_closed_prs]
        end
      end
    end
  end
end
