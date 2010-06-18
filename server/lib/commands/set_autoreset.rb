module Commands
  class SetAutoreset < AbstractCommand
		def initialize(value, timeout = DEFAULT_TIMEOUT)
			@value = value
			@timeout = timeout
		end

		def validate
			@validation_errors << "Value must be either 01 (enable) or 00 (disable)" unless ["00","01"].include?(@value)
		end

		def execute
			input  = [
						"04", 				 # cmd
						"00", 				 # uplink
						"01 00", # data length
						@value,				 # value
						"CD"
			]

			SerialRequestHandler.instance.request(input, @timeout) do |return_code,length,data|
				@client.send response(@id, return_code, data)
			end
		end
  end
end
