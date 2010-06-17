module Commands
  class Execute < AbstractCommand
		TIMEOUT = 5

		def initialize(address)
			@address = address
		end

		def validate
			@validation_errors << "Address must be 4 bytes long" 	if @address.size != 8
		end

		def execute(id, caller)
			input  = [
						"02", 											# cmd
						"00", 											# uplink
						"04 00".split,							# data length
						@address.spaced_hex.split,	# address
						"CD"
			].flatten

			SerialRequestHandler.instance.request(input, TIMEOUT, id, caller)
		end
  end
end
