# frozen_string_literal: true

module Mj
  module ChatGpt
    class Request
      def initialize(data = {})
        @data = HashUtils.new.deep_symbolize_keys(data)
      end

      def asking(question)
        data = @data.dup
        data[:parameters] ||= {}
        data[:parameters][:messages] ||= []
        data[:parameters][:messages] << {
          role: :user,
          content: question
        }
        self.class.new(data)
      end

      def to_h
        @data
      end

      def self.from_config_file(file)
        data = YAML.load_file(file)
        new(data.fetch("request"))
      end
    end
  end
end
