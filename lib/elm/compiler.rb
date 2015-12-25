require "elm/compiler/version"
require "open3"
require "tempfile"

module Elm
  class Compiler
    def self.compile(pathname)
      Dir.mktmpdir do |dir|
        Dir.chdir(dir)

        File.open("elm.js", "w") do |tempfile|
          Open3.popen3("elm-make", pathname.to_s, "--yes", "--output", tempfile.path) do |_stdin, stdout, stderr, wait_thr|
            if wait_thr.value.exitstatus != 0
              raise stderr.gets
            end
          end

          tempfile.read
        end
      end
    end
  end
end
