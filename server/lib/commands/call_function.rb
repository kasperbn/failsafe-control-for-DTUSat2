module Commands
  class CallFunction < AbstractCommand
		def initialize(address, parameter)
			@address = address
			@parameter = parameter
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
				@address.spaced_hex.split.reverse,		# address
				@parameter.spaced_hex.split.reverse,	# parameter
				"CD"
			]

			SerialRequestHandler.instance.request(input, @options) do |return_code,length,data|
				if return_code == FS_CALL_FUNCTION
					# Unpack as 4 bytes little-endian
					data = data.unpack("V").first
				end

				@client.send response(@id, return_code, data)
			end
		end
  end
end
