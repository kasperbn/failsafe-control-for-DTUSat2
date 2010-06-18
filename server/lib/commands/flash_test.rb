module Commands
  class FlashTest < AbstractCommand
		def initialize(address, timeout=DEFAULT_TIMEOUT)
			@address = address
			@timeout = timeout
		end

		def validate
			validate_addressable "Address", @address
		end

		def execute
			input  = [
				"0f", 								# cmd
				"00", 								# uplink
				"04 00",							# data length
				@address.spaced_hex,	# address
				"CD"
			]

			SerialRequestHandler.instance.request(input, @timeout) do |return_code,length,data|
				data = data.unpack("V")
				@client.send response(@id, return_code, data)
			end
		end
  end
end
