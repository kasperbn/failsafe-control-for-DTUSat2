module Commands
  class RunScript < AbstractCommand
		attr_accessor :token

    def initialize(script, *args)
    	@script = script
    	@args = args
    	@token = Server.instance.token
    end

    def execute
     	Dir.glob(File.dirname(__FILE__) + "/../../scripts/*").each do |f|
    		if File.basename(f) == @script
    			body = `#{File.expand_path(f)} #{@token} #{@args.join(' ')}` #.gsub("\n",'__NEWLINE__').gsub("\'",'__SINGLETICK__')
					return response($?.exitstatus, body)
    		end
    	end
    	error("Unknown script")
    end
  end
end
