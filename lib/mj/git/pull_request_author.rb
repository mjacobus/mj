# frozen_string_literal: true

module Mj
  module Git
    class PullRequestAuthor
      attr_reader :id
      attr_reader :name
      attr_reader :login
      attr_reader :is_bot

      def initialize(id:, name:, login:, is_bot:)
        @id = id
        @login = login
        @name = name
        @is_bot = is_bot
      end
    end
  end
end
