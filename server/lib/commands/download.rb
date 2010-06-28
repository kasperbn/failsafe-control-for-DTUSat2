module Commands
  class Download < AbstractCommand

		def initialize(address,length)
			@address = address
			@length = length
		end

		def validate
			validate_addressable "Address", @address
			validate_positive "Length", @length
			validate_max_value "Length", @length, FS_MAX_DATA_SIZE
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

			satellite_command(input) do |return_code,length,data|
				if return_code == FS_DOWNLOAD
					data = data.unpack("C"*length) # Unpack as 1 byte chars
				end
				@client.send response(@id, return_code, data)
			end
		end
  end
end
