module Commands
  class UploadSib < AbstractCommand

		def initialize(sib,timeout=DEFAULT_TIMEOUT)
			@sib = sib
			@sib_length = @sib.spaced_hex.split.size
			@timeout = timeout
		end

		def validate
			validate_length "Sib length", @sib_length, 0x1c
		end

		def execute
			input = [
				"11",
				"1c 00",
				@sib.spaced_hex,
				"CD"
			]
			SerialRequestHandler.instance.request(input, @timeout) do |return_code,length,data|
				@client.send response(@id, return_code, data)
			end
		end
  end
end
