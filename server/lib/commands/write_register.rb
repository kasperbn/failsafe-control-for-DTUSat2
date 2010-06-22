module Commands
  class WriteRegister < AbstractCommand
		def initialize(address, data, timeout=DEFAULT_TIMEOUT)
			@address = address
			@data = data
			@timeout = timeout
		end

		def validate
			validate_addressable "Address", @address
			validate_length "Data", @data
		end

		def execute
			input  = [
				"0d", 															# cmd
				"00", 															# uplink
				"08 00",														# data length
				@address.spaced_hex.split.reverse,	# address
				@data.spaced_hex.split.reverse,			# data
				"CD"
			]

			SerialRequestHandler.instance.request(input, @timeout) do |return_code,length,data|
				@client.send response(@id, return_code, data)
			end
		end
  end
end
