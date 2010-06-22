module Commands
  class DeleteFlashBlock < AbstractCommand
		def initialize(address, timeout=DEFAULT_TIMEOUT)
			@address = address
			@timeout = timeout
		end

		def validate
			validate_addressable "Address", @address
		end

		def execute
			input  = [
				"0b", 								# cmd
				"00", 								# uplink
				"04 00",							# data length
				@address.spaced_hex.split.reverse,	# address
				"CD"
			]

			SerialRequestHandler.instance.request(input, @timeout) do |return_code,length,data|
				@client.send response(@id, return_code, data)
			end
		end
  end
end
