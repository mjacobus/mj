# frozen_string_literal: true

module Mj
  module Git
    class PullRequest
      attr_reader :number
      attr_reader :title
      attr_reader :head
      attr_reader :status
      attr_reader :updated_at

      def initialize(number:, title:, head:, status:, updated_at:)
        @number = number
        @title = title
        @status = status
        @head = head
        @updated_at = updated_at
      end

      def closed?
        status == "MERGED" || status == "CLOSED"
      end
    end
  end
end
