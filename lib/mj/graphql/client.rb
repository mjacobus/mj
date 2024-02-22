# frozen_string_literal: true

require "koine/rest_client"

module Mj
  module GraphQL
    class Client
      def send(request)
        base_url = request.endpoint.split("/graphql").first
        base_request = Koine::RestClient::Request.new(base_url: base_url)
        http_client = Koine::RestClient::Client.new(base_request: base_request)
        http_client.post("/graphql", request.to_h, headers: request.headers)
      end
    end
  end
end
