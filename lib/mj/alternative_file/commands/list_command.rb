# frozen_string_literal: true

module Mj
  module AlternativeFile
    module Commands
      class ListCommand
        attr_reader :file

        def initialize(file, options)
          @file = CurrentFile.new(file.to_s)
          @options = options
        end

        def exists?
          @options[:exists]
        end

        def types
          @options[:types].to_s.split(",")
        end

        def debug?
          @options[:debug]
        end
      end
    end
  end
end
