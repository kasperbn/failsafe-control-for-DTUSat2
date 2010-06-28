module Commands
  class WriteRegister < AbstractCommand
		def initialize(address, data)
			@address = address
			@data = data
		end

		def validate
			validate_addressable "Address", @address
			validate_byte_length "Data", @data, 4
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

			satellite_command(input)
		end
  end
end
