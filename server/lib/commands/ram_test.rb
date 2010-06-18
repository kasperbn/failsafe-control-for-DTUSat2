module Commands
  class RamTest < AbstractCommand
		def initialize(address, length, timeout=DEFAULT_TIMEOUT)
			@address = address
			@length = length
			@timeout = timeout
		end

		def validate
			validate_addressable "Address", @address
			validate_length "Length", @length
		end

		def execute
			input  = [
				"0e", 								# cmd
				"00", 								# uplink
				"08 00",							# data length
				@address.spaced_hex,	# address
				@length.spaced_hex,		# data
				"CD"
			]

			SerialRequestHandler.instance.request(input, @timeout) do |return_code,length,data|
				data = data.unpack("V")
				@client.send response(@id, return_code, data)
			end
		end
  end
end
