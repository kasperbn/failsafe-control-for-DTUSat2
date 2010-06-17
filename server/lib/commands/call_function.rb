module Commands
  class CallFunction < AbstractCommand
		TIMEOUT = 5

		def initialize(address, parameter)
			@address = address
			@parameter = parameter
		end

		def validate
			@validation_errors << "Address must be 4 bytes long" 	if @address.size != 8
			@validation_errors << "Parameter must be 4 bytes long" 	if @parameter.size != 8
		end

		def execute(id, caller)
			input  = [
						"03", 											# cmd
						"00", 											# uplink
						"08 00".split,							# data length
						@address.spaced_hex.split,	# address
						@parameter.spaced_hex.split,	# parameter
						"CD"
			].flatten

			SerialRequestHandler.instance.request(input, TIMEOUT, id, caller)
		end
  end
end
