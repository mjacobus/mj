# frozen_string_literal: true

require "thor"
require_relative "version"
require_relative "alternative_file/thor_command"
require_relative "graphql/thor_command"
require_relative "chatgpt/thor_command"
require_relative "git/thor_command"

module Mj
  class Cli < Thor
    def self.exit_on_failure?
      true
    end

    desc "version", "Prints the version"
    def version
      puts Mj::VERSION
    end

    desc "alternative_file", "Lists alternative files"
    subcommand "alternative_file", AlternativeFile::ThorCommand

    desc "graphql", "CLI client for GraphQL"
    subcommand "graphql", GraphQL::ThorCommand

    desc "chatgpt", "CLI client for ChatGPT"
    subcommand "chatgpt", ChatGpt::ThorCommand

    desc "git", "Git utilities"
    subcommand "git", Git::ThorCommand
  end
end
