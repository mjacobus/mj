# frozen_string_literal: true

module Mj
  module Git
    class PullRequest
      attr_reader :number
      attr_reader :title
      attr_reader :state
      attr_reader :updated_at

      def initialize(number:, title:, state:, updated_at:)
        @number = number
        @title = title
        @state = state
        @updated_at = updated_at
      end

      def closed?
        state == "MERGED" || state == "CLOSED"
      end
    end
  end
end
