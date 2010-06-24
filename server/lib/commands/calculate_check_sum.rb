module Commands
  class CalculateCheckSum < AbstractCommand
		def initialize(address, length)
			@address = address
			@length = length
		end

		def validate
			validate_addressable "Address", @address
			validate_positive "Length", @length
			validate_length "Length", @length
		end

		def execute
			input  = [
				"0a", 								# cmd
				"00", 								# uplink
				"08 00",							# data length
				@address.spaced_hex.split.reverse,	# address
				@length.spaced_hex.split.reverse,		# length
				"CD"
			]

			SerialRequestHandler.instance.request(input, @options) do |return_code,length,data|
				if return_code == FS_CALCULATE_CHECK_SUM
					# Unpack as 4 bytes little-endian
					data = data.unpack("V").first
				end

				@client.send response(@id, return_code, data)
			end
		end
  end
end
