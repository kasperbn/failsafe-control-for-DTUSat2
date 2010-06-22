module Commands
  class Unknown < AbstractCommand
		def execute
			@client.send response(@id, STATUS_UNKNOWN_COMMAND)
		end
  end
end
