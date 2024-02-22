# frozen_string_literal: true

require_relative "../request_factory"
require_relative "../client"

module Mj
  module GraphQL
    module Commands
      class QueryFileCommandHandler
        def handle(command)
          request = RequestFactory.new.from_file(command.file)
          Client.new.send(request)
        end
      end
    end
  end
end
