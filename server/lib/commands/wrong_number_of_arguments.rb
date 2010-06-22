module Commands
  class WrongNumberOfArguments < AbstractCommand
		def execute
			@client.send response(@id, STATUS_WRONG_NUMBER_OF_ARGUMENTS)
		end
  end
end
