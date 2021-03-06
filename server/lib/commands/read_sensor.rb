module Commands
  class ReadSensor < AbstractCommand
		def initialize(address)
			@address = address
		end

		def validate
			validate_addressable "Address", @address
		end

		def execute
			input  = [
				"14", 								# cmd
				"00", 								# uplink
				"04 00",							# data length
				@address.spaced_hex.split.reverse,	# address
				"CD"
			]

			satellite_command(input) do |return_code,length,data|
				if return_code == FS_READ_SENSOR
					# Unpack as one 4 char little-endian long
					data = data.unpack("V").first
				end

				@client.send response(@id, return_code, data)
			end
		end
  end
end
