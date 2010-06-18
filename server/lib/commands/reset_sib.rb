module Commands
  class ResetSib < AbstractCommand
		def execute
			input = "12 00 00 00 CD"
			SerialRequestHandler.instance.request(input, @timeout) do |return_code,length,data|
				@client.send response(@id, return_code, data)
			end
		end
  end
end
