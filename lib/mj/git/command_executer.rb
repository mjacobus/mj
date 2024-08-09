require "open3"

module Mj
  module Git
    class CommandExecuter
      Error = Class.new(RuntimeError)

      def execute(command)
        stdout_str, stderr_str, status = Open3.capture3(command)

        if status.success?
          return stdout_str.split("\n")
        end

        raise Error, "Command '#{command}' exited with (#{status.exitstatus}): #{stderr_str.strip}"
      end
    end
  end
end
