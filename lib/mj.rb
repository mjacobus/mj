# frozen_string_literal: true

require_relative "mj/version"
require_relative "mj/cli"
require "mj/hash_utils"

module Mj
  class Error < StandardError; end
  # Your code goes here...
  require "logger"
  require "fileutils"

  def self.logger
    @logger ||= begin
      log_dir = File.join(Dir.home, ".log")
      FileUtils.mkdir_p(log_dir)
      log_file = File.join(log_dir, "mj.log")
      Logger.new(log_file)
    end
  end
end
