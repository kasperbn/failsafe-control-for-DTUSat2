module Commands
  class CopyToFlash < AbstractCommand
		TIMEOUT = 5

		EXTERNAL_FLASH_RANGE = (0x80000000..0x8fffffff)
		INTERNAL_FLASH_RANGE = (0x0..0x200)
		INTERNAL_LENGTHS = ["512","1024","2048","4096"]

		def initialize(from,to,length)
			@from = from
			@to = to
			@length = length
		end

		def validate
			@validation_errors << "From address must be 4 bytes long" if @from.size != 8
			@validation_errors << "To address must be 4 bytes long" if @to.size != 8
			@validation_errors << "Length address must be 4 bytes long" if @to.size != 8

			if(EXTERNAL_FLASH_RANGE.include?(@to.hex))
				@validation_errors << "For external flash, length must be a multipler of 2" unless (@length.hex % 2 == 0)
			elsif(INTERNAL_FLASH_RANGE.include?(@to.hex))
				@validation_errors << "For internal flash, length must be one of #{INTERNAL_LENGTHS.join(", ")}" unless INTERNAL_LENGTHS.include?(@length)
			else
				@validation_errors << "To address must be within the external of interal flash range"
			end
		end

		def execute(id, caller)
			input  = [
						"06", 				 # cmd
						"00", 				 # uplink
						"0c 00".split, # data length
						@from.spaced_hex.split,
						@to.spaced_hex.split,
						@length.spaced_hex.split,
						"CD"
			].flatten

			SerialRequestHandler.instance.request(input, TIMEOUT, id, caller)
		end
  end
end
