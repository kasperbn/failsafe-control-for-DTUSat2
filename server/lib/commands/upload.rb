module Commands
  class Upload < AbstractCommand
		def initialize(address,data,timeout=DEFAULT_TIMEOUT)
			@address = address
			@data = data
			@length = data.spaced_hex.split.size
			@timeout = timeout
		end

		def validate
			validate_addressable "Address", @address
			validate_length "Data length", @length, (FS_MAX_DATA_SIZE - 4)
		end

		def execute
			input  = [
						"08", 				 # cmd
						"00", 				 # uplink
						(@length+4).to_s(16).spaced_hex, # data length
						@address.spaced_hex,
						@data.spaced_hex,
						"CD"
			]

			SerialRequestHandler.instance.request(input, @timeout) do |return_code,length,data|
				@client.send response(@id, return_code, data)
			end
		end
  end
end
