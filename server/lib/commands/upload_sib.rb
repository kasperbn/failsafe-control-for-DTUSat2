module Commands
  class UploadSib < AbstractCommand

		def initialize(sib)
			@sib = sib
			@sib_length = @sib.spaced_hex.split.size
		end

		def validate
			validate_length "Sib length", @sib_length, 0x1c
		end

		def execute
			input = [
				"11",
				"1c 00",
				@sib.spaced_hex.split.reverse,
				"CD"
			]
			SerialRequestHandler.instance.request(input, @options) do |return_code,length,data|
				@client.send response(@id, return_code, data)
			end
		end
  end
end
