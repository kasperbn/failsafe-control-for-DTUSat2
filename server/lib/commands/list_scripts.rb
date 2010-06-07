module Commands
  class ListScripts < AbstractCommand

    def execute(caller, id)
			list = Dir.glob("scripts/**/*").select do |f|
				File.executable?(f) && !File.directory?(f)
    	end.sort.map do |f|
  			{
					:path => f,
					:help => `#{File.expand_path(f)} --help`
				}
    	end
			response(:status => STATUS_OK, :data => list)
    end
  end
end
