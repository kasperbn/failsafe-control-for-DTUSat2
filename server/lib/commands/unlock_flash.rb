module Commands
  class UnlockFlash < AbstractCommand
		def execute
			input = "05 00 00 00 CD"
			SerialRequestHandler.instance.request(input, @options) do |return_code,length,data|
				@client.send response(@id, return_code, data)
			end
		end
  end
end
