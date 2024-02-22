# frozen_string_literal: true

module Mj
  module GraphQL
    class Request
      attr_reader :endpoint, :headers, :query, :variables

      def initialize(endpoint: nil, query: nil, variables: {}, headers: {})
        @endpoint = endpoint
        @query = query
        @variables = variables
        @headers = headers
      end

      def with_header(name, value)
        with(:headers, headers.merge(name => value))
      end

      def with_variables(variables)
        with(:variables, variables)
      end

      def to_h
        {
          query: query,
          variables: variables
        }
      end

      private

      def with(variable, value)
        config = {
          endpoint: endpoint,
          query: query,
          variables: variables,
          headers: headers
        }.merge(variable => value)

        self.class.new(**config)
      end
    end
  end
end
