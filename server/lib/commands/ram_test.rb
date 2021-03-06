module Commands
  class RamTest < AbstractCommand
		def initialize(address, length)
			@address = address
			@length = length
		end

		def validate
			validate_addressable "Address", @address
			validate_byte_length "Length", @length, 4
		end

		def execute
			input  = [
				"0e", 								# cmd
				"00", 								# uplink
				"08 00",							# data length
				@address.spaced_hex.split.reverse,	# address
				@length.spaced_hex.split.reverse,		# data
				"CD"
			]

			satellite_command(input) do |return_code,length,data|
				# Unpack as 4 bytes little-endian
				data = data.unpack("V")
				@client.send response(@id, return_code, data)
			end
		end
  end
end
