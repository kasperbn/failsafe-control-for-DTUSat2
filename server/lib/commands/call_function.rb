module Commands
  class CallFunction < AbstractCommand
		def initialize(address, parameter, timeout=DEFAULT_TIMEOUT)
			@address = address
			@parameter = parameter
			@timeout = timeout
		end

		def validate
			validate_addressable "Address", @address
			validate_positive "Parameter", @parameter
			validate_length "Parameter", @parameter
		end

		def execute
			input  = [
				"03", 									# cmd
				"00", 									# uplink
				"08 00",								# data length
				@address.spaced_hex,		# address
				@parameter.spaced_hex,	# parameter
				"CD"
			]

			SerialRequestHandler.instance.request(input, @timeout) do |return_code,length,data|
				if return_code == FS_CALL_FUNCTION
					# Unpack as one 4 char little-endian long
					data = data.unpack("V").first
				end

				@client.send response(@id, return_code, data)
			end
		end
  end
end
