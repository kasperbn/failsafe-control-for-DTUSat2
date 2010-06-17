module Commands
  class UnlockFlash < AbstractCommand
		TIMEOUT = 5
		def execute(id, caller)
			input = "05 00 00 00 CD"
			SerialRequestHandler.instance.request(input, TIMEOUT, id, caller)
		end
  end
end
