require 'pty'

module Commands
  class RunScript < AbstractCommand
		attr_accessor :token

    def initialize(script, *args)
    	@script = script
    	@args = args
    	@token = TokenHandler.instance.token
    end

    def execute(caller, id)
     	Dir.glob(ROOT_DIR+"/scripts/**/*").each do |f|
				cmd = File.expand_path(f)
    		if cmd == File.expand_path(@script) # Does the script exists?
					PTY.spawn(cmd, token, *@args) do |sr, sw, spid| # Open up a pseudo tty
						begin
							loop do # Read line from stdout until tty is closed
								# Send output immediately to client
								caller.send(response(:id => id, :status => STATUS_OK, :data => sr.readline, :partial => true).to_json)
							end
						rescue => e # Done
						end
					end
					return response(:status => STATUS_OK, :data => "End of script")
    		end
    	end
    	response(:status => STATUS_ERROR, :data => "Unknown script")
    end
  end
end
