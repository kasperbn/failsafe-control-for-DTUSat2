require 'pty'
require 'expect'

module Commands
  class RunScript < AbstractCommand
		HELP = {
				:description => "Run a server script",
				:arguments => [
					{:name => "script_path", :type => "string", :description => "The path to the server script"},
					{:name => "*script_args", :type => "unknown", :description => "Any arguments seperated by a space"},
				]
			}

		attr_accessor :token

    def initialize(script, *args)
    	@script = script
    	@args = args
    	@token = TokenHandler.instance.token
    end

    def execute(caller, id)
     	Dir.glob(ROOT_DIR+"/scripts/**/*").each do |f|
				cmd = File.expand_path(f)
    		if cmd == File.expand_path(File.join("scripts/",@script)) # Does the script exists?

					begin
						PTY.spawn(cmd, token, *@args) do |r, w, pid|
							loop {
								out = r.expect(%r/^.+\n$/io)
								caller.send(response(:id => id, :status => STATUS_OK, :data => out[0], :partial => true).to_json) unless out.nil?
							}
						end
					rescue PTY::ChildExited => e
						return response(:status => e.status.to_i, :data => "End of script")
					end

    		end
    	end
    	response(:status => STATUS_ERROR, :data => "Unknown script")
    end
  end
end
