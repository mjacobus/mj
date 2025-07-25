# frozen_string_literal: true

require "net/http"
require "json"

module Mj
  module Genius
    # Client for interacting with the Genius API
    class ApiClient
      API_BASE_URL = "https://api.genius.com"

      def initialize(access_token:)
            raise "GENIUS_ACCESS_TOKEN is missing" if access_token.nil? || access_token.empty?

            @access_token = access_token
      end

      # Search for an artist by name
      # @param [String] name The artist name
      # @return [Array<Hash>] Search results
      def search_artist(name)
        uri = URI("#{API_BASE_URL}/search?q=#{URI.encode_www_form_component(name)}")
        response = make_request(uri)
        response["response"]["hits"]
      end

      # Fetch songs by artist ID using pagination
      # @param [Integer] artist_id The ID of the artist
      # @param [Integer] page The page number
      # @param [Integer] per_page Number of items per page
      # @return [Array<Hash>] Songs for the artist
      def fetch_songs_by_artist_id(artist_id, page:, per_page:)
        uri = URI("#{API_BASE_URL}/artists/#{artist_id}/songs?per_page=#{per_page}&page=#{page}")
        response = make_request(uri)
        response["response"]["songs"].map do |song|
          Song.new(song)
        end
      end

      private

      def make_request(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(uri)
        request["Authorization"] = "Bearer #{@access_token}"

        response = http.request(request)

        unless response.is_a?(Net::HTTPSuccess)
          raise "API Error: #{response.code} #{response.message}"
        end

        JSON.parse(response.body)
      rescue JSON::ParserError
        raise "Failed to parse API response"
      rescue StandardError => exception
        raise "Network or API error: #{exception.message}"
      end
    end
  end
end
