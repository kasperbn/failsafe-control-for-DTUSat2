module Commands
  class ListScripts < AbstractCommand
    def execute(id, caller)
			list = Dir.glob("scripts/**/*").select do |f|
				File.executable?(f) && !File.directory?(f)
    	end.sort.map do |f|
  			{
					:path => f,
					:help => `#{File.expand_path(f)} --help`
				}
    	end
			caller.send response(id, STATUS_OK, list)
    end
  end
end
