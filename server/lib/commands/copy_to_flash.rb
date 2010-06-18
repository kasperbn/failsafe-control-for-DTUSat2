module Commands
  class CopyToFlash < AbstractCommand
		EXTERNAL_FLASH_RANGE = (0x80000000..0x8fffffff)
		INTERNAL_FLASH_RANGE = (0x0..0x200)
		INTERNAL_LENGTHS = ["512","1024","2048","4096"]

		def initialize(from,to,length,timeout=DEFAULT_TIMEOUT)
			@from = from
			@to = to
			@length = length
			@timeout = timeout
		end

		def validate
			validate_addressable "From address", @from
			validate_addressable "To address", @to
			validate_positive "Length", @length
			validate_length "Length", @length

			if EXTERNAL_FLASH_RANGE.include?(@to.hex)
				@validation_errors << "For external flash, length must be a multipler of 2" unless (@length.hex % 2 == 0)
			elsif INTERNAL_FLASH_RANGE.include?(@to.hex)
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
				@from.spaced_hex,
				@to.spaced_hex,
				@length.spaced_hex,
				"CD"
			]

			SerialRequestHandler.instance.request(input, @timeout) do |return_code,length,data|
				@client.send response(@id, return_code, data)
			end
		end
  end
end
