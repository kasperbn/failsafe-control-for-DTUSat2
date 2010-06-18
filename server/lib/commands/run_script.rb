require 'pty'
require 'expect'

module Commands
  class RunScript < AbstractCommand
		attr_accessor :token

    def initialize(script, *args)
    	@script = script
    	@args = args
    	@token = TokenHandler.instance.token
    end

		def validate
			script_exists = false
			Dir.glob(ROOT_DIR+"/scripts/**/*").each do |f|
				cmd = File.expand_path(f)
    		if cmd == File.expand_path(File.join("scripts/",@script)) # Does the script exists?
    			@cmd = cmd
    			script_exists = true
    		end
    	end
			@validation_errors << "Unknown script" unless script_exists
		end

    def execute
			begin
				PTY.spawn(@cmd, @token, *@args) do |r, w, pid|
					loop {
						out = r.expect(%r/^.+\n$/io)
						@client.send response(@id,STATUS_OK,out[0],:partial => true) unless out.nil?
					}
				end
			rescue PTY::ChildExited => e
				@client.send response(@id,e.status.to_i)
				return;
			end
    end
  end
end
