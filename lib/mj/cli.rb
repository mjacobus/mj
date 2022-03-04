# frozen_string_literal: true

require "thor"
require_relative "alternative_file/thor_command"
require_relative "alternative_file/candidate"
require_relative "alternative_file/current_file"

module Mj
  class Cli < Thor
    desc "alternative-file SUBCOMMAND ...ARGS", "lists alternative files"
    subcommand "alternative-file", AlternativeFile::ThorCommand
  end
end
