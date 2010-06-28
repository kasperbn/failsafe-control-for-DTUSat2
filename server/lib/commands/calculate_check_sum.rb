module Commands
  class CalculateCheckSum < AbstractCommand
		def initialize(address, length)
			@address = address
			@length = length
		end

		def validate
			validate_addressable "Address", @address
			validate_positive "Length", @length
			validate_byte_length "Length", @length, 4
		end

		def execute
			input  = [
				"0a", 								# cmd
				"00", 								# uplink
				"08 00",							# data length
				@address.spaced_hex.split.reverse,	# address
				@length.spaced_hex.split.reverse,		# length
				"CD"
			]

			satellite_command(input) do |return_code,length,data|
				if return_code == FS_CALCULATE_CHECK_SUM
					data = data.unpack("V").first # Unpack as 4 bytes little-endian
				end

				@client.send response(@id, return_code, data)
			end
		end
  end
end
