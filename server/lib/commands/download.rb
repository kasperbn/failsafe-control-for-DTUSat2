module Commands
  class Download < AbstractCommand

		def initialize(address,length,timeout=DEFAULT_TIMEOUT)
			@address = address
			@length = length
			@timeout = timeout
		end

		def validate
			validate_addressable "Address", @address
			validate_positive "Length", @length
			validate_length "Length", @length, FS_MAX_DATA_SIZE
		end

		def execute
			input  = [
				"09", 				# cmd
				"00", 				# uplink
				"08 00",			# data length
				@address.spaced_hex.split.reverse,
				@length.spaced_hex.split.reverse,
				"CD"
			]

			SerialRequestHandler.instance.request(input, @timeout) do |return_code,length,data|
				if return_code == FS_DOWNLOAD
					# Unpack as 1 byte chars
					data = data.unpack("C"*length)
				end
				@client.send response(@id, return_code, data)
			end
		end
  end
end
