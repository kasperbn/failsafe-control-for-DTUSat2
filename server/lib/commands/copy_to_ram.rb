module Commands
  class CopyToRam < AbstractCommand

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
		end

		def execute
			input  = [
				"07", 				 	# cmd
				"00", 				 	# uplink
				"0c 00", 				# data length
				@from.spaced_hex.split.reverse,
				@to.spaced_hex.split.reverse,
				@length.spaced_hex.split.reverse,
				"CD"
			]

			SerialRequestHandler.instance.request(input, @timeout) do |return_code,length,data|
				@client.send response(@id, return_code, data)
			end
		end
  end
end
