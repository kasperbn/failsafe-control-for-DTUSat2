module Commands
  class DownloadSib < AbstractCommand
		def execute
			input = "10 00 00 00 CD"
			SerialRequestHandler.instance.request(input, @options) do |return_code,length,data|
				# Unpack as 32 unsigned chars
				data = data.unpack("C"*32)
				@client.send response(@id, return_code, data)
			end
		end
  end
end
