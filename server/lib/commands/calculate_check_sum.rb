module Commands
  class CalculateCheckSum < AbstractCommand
			TIMEOUT = 10

			def initialize(start_address, length)
				@start_address = start_address
				@length = length
			end

			def validate
				@validation_errors << "Start address must be 4 bytes long" 	if @start_address.size != 8
				@validation_errors << "Length must be 4 bytes long" 				if @length.size != 8
			end

			def execute(id, caller)
				input  = [
							"0a", 														# cmd
							"00", 														# uplink
							"08 00".split,										# data length
							@start_address.spaced_hex.split,	# start address
							@length.spaced_hex.split,					# length
							"CD"
				].flatten

				SerialRequestHandler.instance.request(input, TIMEOUT, id, caller)
			end
  end
end
