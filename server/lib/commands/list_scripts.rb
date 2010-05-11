module Commands
  class ListScripts < AbstractCommand
    def execute
     	body = Dir.glob(File.dirname(__FILE__) + "/../../scripts/*").map do |f|
    		File.basename(f)
    	end
			response(0,body)
    end
  end
end
