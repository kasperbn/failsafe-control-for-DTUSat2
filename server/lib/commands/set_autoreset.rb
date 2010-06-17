module Commands
  class SetAutoreset < AbstractCommand
		TIMEOUT = 5

		def initialize(value)
			@value = value
		end

		def validate
			@validation_errors << "Value must be either 01 (enable) or 00 (disable)" unless ["00","01"].include?(@value)
		end

		def execute(id, caller)
			input  = [
						"04", 				 # cmd
						"00", 				 # uplink
						"01 00".split, # data length
						@value,				 # value
						"CD"
			].flatten

			SerialRequestHandler.instance.request(input, TIMEOUT, id, caller)
		end
  end
end
