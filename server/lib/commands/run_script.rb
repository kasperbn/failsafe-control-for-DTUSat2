require 'open3'

module Commands
  class RunScript < AbstractCommand
		attr_accessor :token

    def initialize(script, *args)
    	@script = script
    	@args = args
    	@token = TokenHandler.instance.token
    end

    def execute
     	Dir.glob(ROOT_DIR+"/scripts/*").each do |f|
    		if File.basename(f) == @script

					cmd = File.expand_path(f)
					stdin, stdout, stderr = Open3.popen3(cmd, token, *@args)
					body = stdout.readlines.join

					return response($?.exitstatus, body)
    		end
    	end
    	error("Unknown script")
    end
  end
end
