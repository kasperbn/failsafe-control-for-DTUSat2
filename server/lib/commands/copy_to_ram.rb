module Commands
  class CopyToRam < AbstractCommand

		def initialize(from,to,length)
			@from = from
			@to = to
			@length = length
		end

		def validate
			validate_addressable "From address", @from
			validate_addressable "To address", @to
			validate_positive "Length", @length
			validate_byte_length "Length", @length, 4
		end

		def execute
			input  = [
				"07", 				 	# cmd
				"00", 				 	# uplink
				"0c 00", 				# data length
				@from.spaced_hex.split.reverse,
				@to.spaced_hex.split.reverse,
				@length.spaced_hex.split.reverse,
				"CD"
			]

			satellite_command(input)
		end
  end
end
