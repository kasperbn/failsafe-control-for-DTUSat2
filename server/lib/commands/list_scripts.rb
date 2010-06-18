module Commands
  class ListScripts < AbstractCommand
    def execute
			list = Dir.glob("scripts/**/*").select do |f|
				File.executable?(f) && !File.directory?(f)
    	end.sort.map do |f|
  			{
					:path => f[8..-1], # Remove scripts/
					:help => `#{File.expand_path(f)} --help`
				}
    	end
			@client.send response(@id, STATUS_OK, list)
    end
  end
end
