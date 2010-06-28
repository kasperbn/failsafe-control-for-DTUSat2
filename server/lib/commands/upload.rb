module Commands
  class Upload < AbstractCommand
		def initialize(address,data)
			@address = address
			@data = data
		end

		def validate
			validate_addressable "Address", @address
			validate_positive_hex "Data", @data
			validate_byte_length "Data", @data, (FS_MAX_DATA_SIZE - 4)
		end

		def execute
			input  = [
						"08", 				 # cmd
						"00", 				 # uplink
						(@data.byte_length+4).spaced_hex(2).split.reverse, # data length
						@address.spaced_hex.split.reverse,
						@data.spaced_hex(@data.byte_length).split,
						"CD"
			]

			satellite_command(input)
		end
  end
end
