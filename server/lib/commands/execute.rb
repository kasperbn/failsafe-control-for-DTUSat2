module Commands
  class Execute < AbstractCommand

		def initialize(address)
			@address = address
		end

		def validate
			validate_addressable "Address", @address
		end

		def execute
			input  = [
				"02", 								# cmd
				"00", 								# uplink
				"04 00",							# data length
				@address.spaced_hex.split.reverse,	# address
				"CD"
			]

			SerialRequestHandler.instance.request(input, @options) do |return_code,length,data|
				@client.send response(@id, return_code, data)
			end
		end
  end
end
