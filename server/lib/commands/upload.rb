module Commands
  class Upload < AbstractCommand
		TIMEOUT = 5
		MAXIMUM_LENGTH = FS_MAX_DATA_SIZE - 4

		def initialize(address,data)
			@address = address
			@data = data
			@length = data.spaced_hex.split.size
		end

		def validate
			@validation_errors << "Address must be 4 bytes long" if @address.size != 8
			@validation_errors << "Data must be 4 bytes long" if @data.size != 8
			@validation_errors << "Data is too long (>= #{MAXIMUM_LENGTH})" if @length > MAXIMUM_LENGTH
		end

		def execute(id, caller)
			input  = [
						"08", 				 # cmd
						"00", 				 # uplink
						(@length+4).to_s(16).spaced_hex.split, # data length
						@address.spaced_hex.split,
						@data.spaced_hex.split,
						"CD"
			].flatten

			SerialRequestHandler.instance.request(input, TIMEOUT, id, caller)
		end
  end
end
