module Commands
  class CalculateCheckSum < AbstractCommand
			TIMEOUT = 5

			def initialize(start_address, length)
				@start_address = start_address
				@length = length
			end

			def validate
				@validation_errors << "Start address must be 4 bytes long" 	if @start_address.size != 8
				@validation_errors << "Length must be 4 bytes long" 				if @length.size != 8
			end

			def execute(id, caller)
				input  = [
							"0a", 														# cmd
							"00", 														# uplink
							"08 00".split,										# data length
							@start_address.spaced_hex.split,	# start address
							@length.spaced_hex.split,					# length
							"CD"
				].flatten

				TokenHandler.instance.stop_timer
				SerialRequestHandler.instance.request(input, TIMEOUT) do |return_code, downlink, data_length, data|
					d = if(return_code == FS_ADDRESS_ERROR)
						"Address Error!"
					else
						data
					end

					caller.send response(:id => id, :status => return_code, :data => d)
					TokenHandler.instance.start_timer
				end

			end
  end
end
