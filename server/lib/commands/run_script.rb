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
    			body = `#{File.expand_path(f)} #{@token} #{@args.join(' ')}`
					return response($?.exitstatus, body)
    		end
    	end
    	error("Unknown script")
    end
  end
end
