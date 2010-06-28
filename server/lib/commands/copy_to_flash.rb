module Commands
  class CopyToFlash < AbstractCommand
		EXTERNAL_FLASH_RANGE = (0x80000000..0x801e8480) # 2 MB
		INTERNAL_RAM_RANGE	 = (0x40000000..0x40003e80) # 16 K
		INTERNAL_FLASH_RANGE = (0..256000)							# 256 K
		INTERNAL_LENGTHS = ["512","1024","2048","4096"]

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

			if EXTERNAL_FLASH_RANGE.include?(@to.int_or_hex)
				@validation_errors << "For external flash, length must be a multipler of 2" unless (@length.int_or_hex % 2 == 0)
			elsif INTERNAL_FLASH_RANGE.include?(@to.int_or_hex)
				@validation_errors << "For internal flash, source address must be within internal RAM" unless INTERNAL_RAM_RANGE.include?(@from.int_or_hex)
				@validation_errors << "For internal flash, length must be one of #{INTERNAL_LENGTHS.join(", ")}" unless INTERNAL_LENGTHS.include?(@length)
			else
				@validation_errors << "To address must be within the external of interal flash range"
			end
		end

		def execute
			input  = [
				"06", 				 # cmd
				"00", 				 # uplink
				"0c 00",			 # data length
				@from.spaced_hex.split.reverse,
				@to.spaced_hex.split.reverse,
				@length.spaced_hex.split.reverse,
				"CD"
			]

			satellite_command(input)
		end
  end
end
