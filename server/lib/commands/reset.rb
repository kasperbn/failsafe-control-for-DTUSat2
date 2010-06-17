module Commands
  class Reset < AbstractCommand
		TIMEOUT = 5
		def execute(id, caller)
			input = "01 00 00 00 CD".split
			SerialRequestHandler.instance.request(input, TIMEOUT, id, caller)
		end
  end
end
