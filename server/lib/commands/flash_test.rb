module Commands
  class FlashTest < AbstractCommand
		def initialize(address)
			@address = address
		end

		def validate
			validate_addressable "Address", @address
		end

		def execute
			input  = [
				"0f", 								# cmd
				"00", 								# uplink
				"04 00",							# data length
				@address.spaced_hex.split.reverse,	# address
				"CD"
			]

			SerialRequestHandler.instance.request(input, @options) do |return_code,length,data|
				# Unpack as 4 bytes little-endian
				data = data.unpack("V")
				@client.send response(@id, return_code, data)
			end
		end
  end
end
