module Commands
  class Download < AbstractCommand
		TIMEOUT = 5

		def initialize(address,length)
			@address = address.int_or_hex
			@length = length.int_or_hex
		end

		def validate
			@validation_errors << "Address must be 4 bytes long" if @address.size != 8
			@validation_errors << "Length must be 4 bytes long" if @length.size != 8
			@validation_errors << "Length is too long (>= #{FS_MAX_DATA_SIZE})" if @length.hex > FS_MAX_DATA_SIZE
		end

		def execute(id, caller)
			input  = [
						"09", 				 # cmd
						"00", 				 # uplink
						"08 00", # data length
						@address.spaced_hex.split,
						@length.spaced_hex.split,
						"CD"
			].flatten

			SerialRequestHandler.instance.request(input, TIMEOUT, id, caller)
		end
  end
end
