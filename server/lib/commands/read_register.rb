module Commands
  class ReadRegister < AbstractCommand
		def initialize(address)
			@address = address
		end

		def validate
			validate_addressable "Address", @address
		end

		def execute
			input  = [
				"0c", 								# cmd
				"00", 								# uplink
				"04 00",							# data length
				@address.spaced_hex.split.reverse,	# address
				"CD"
			]

			satellite_command(input) do |return_code,length,data|
				if return_code == FS_READ_REGISTER
					# Unpack as 4 byte little endian
					data = data.unpack("V").first
				end
				@client.send response(@id, return_code, data)
			end
		end
  end
end
