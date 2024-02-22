# frozen_string_literal: true

require_relative "request"

module Mj
  module GraphQL
    class RequestFactory
      def from_file(file) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize, Metrics/MethodLength
        contents = File.read(file)
        comments = contents.split("\n").take_while { |line| line.match(/^#/) }.join("\n")
        query = contents.split("\n").drop_while { |line| line.match(/^#/) }.join("\n")
        endpoint = comments.match(/# gql-endpoint: (.+)/)&.captures&.first

        request = Request.new(query: query, endpoint: endpoint)

        headers = comments.split("\n")
          .select { |line| line.match(/^# gql-header:/) }
          .map { |line| line.split("gql-header:")[1..].join.strip }

        headers.map do |value|
          values = value.split(":").map(&:strip)
          request = request.with_header(*values)
        end

        variables_string = comments.match(/# gql-variables:\s?(.+)/)&.captures&.first

        if variables_string
          variables = JSON.parse(variables_string)
          request = request.with_variables(variables)
        end

        request
      end
    end
  end
end
