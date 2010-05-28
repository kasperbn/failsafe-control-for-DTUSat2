module Commands
  class ListScripts < AbstractCommand
    def execute
     	body = Dir.glob(ROOT_DIR+"/scripts/*").map do |f|
    		{
    			:name => File.basename(f),
    			:help => `#{File.expand_path(f)} --help`
    		}
    	end
			response(0,body)
    end
  end
end
