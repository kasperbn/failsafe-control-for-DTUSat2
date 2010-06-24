module Commands
  class Reset < AbstractCommand
		def execute
			input = "01 00 00 00 CD"
			SerialRequestHandler.instance.request(input, @options) do |return_code,length,data|
				@client.send response(@id, return_code, data)
			end
		end
  end
end
