# frozen_string_literal: true

require "openai"
require_relative "../request"

module Mj
  module ChatGpt
    module Commands
      class AskCommandHandler
        def initialize(client:)
          @client = client
        end

        def handle(command)
          request = Request.from_config_file(command.options.fetch("config_file"))
          @client.chat(**request.asking(command.question).to_h)
        rescue Faraday::Error => exception
          {
            error: exception.message,
            body: exception.response&.dig(:body, "error") || exception.response
          }
        end
      end
    end
  end
end
