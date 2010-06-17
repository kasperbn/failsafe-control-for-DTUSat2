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

    def execute(id, caller)
     	Dir.glob(ROOT_DIR+"/scripts/**/*").each do |f|
				cmd = File.expand_path(f)
    		if cmd == File.expand_path(File.join("scripts/",@script)) # Does the script exists?

					begin
						PTY.spawn(cmd, token, *@args) do |r, w, pid|
							loop {
								out = r.expect(%r/^.+\n$/io)
								caller.send response(:id => id, :status => STATUS_OK, :data => out[0], :partial => true) unless out.nil?
							}
						end
					rescue PTY::ChildExited => e
						caller.send response(:id => id, :status => e.status.to_i, :data => "End of script")
						return;
					end

    		end
    	end
    	caller.send response(:id => id, :status => STATUS_ERROR, :data => "Unknown script")
    end
  end
end
