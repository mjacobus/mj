# frozen_string_literal: true

require "thor"
require_relative "alternative_file/thor_command"

module Mj
  class Cli < Thor
    def self.exit_on_failure?
      true
    end

    desc "alternative_file", "lists alternative files"
    subcommand "alternative_file", AlternativeFile::ThorCommand
  end
end
