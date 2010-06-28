module Commands
  class DeleteFlashBlock < AbstractCommand
		def initialize(address)
			@address = address
		end

		def validate
			validate_addressable "Address", @address
		end

		def execute
			input  = [
				"0b", 								# cmd
				"00", 								# uplink
				"04 00",							# data length
				@address.spaced_hex.split.reverse,	# address
				"CD"
			]

			satellite_command(input)
		end
  end
end
