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

        def after_date
          if @after_date
            return @after_date
          end

          if @options[:after_date]
            @after_date ||= DateTime.parse(@options[:after_date])
          end

          # Default to 100 years ago - sure there are no commits that old
          @after_date ||= DateTime.new(1900, 1, 1, 0, 0, 0)
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
