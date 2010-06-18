module Commands
  class HealthStatus < AbstractCommand

		def execute
			input = "13 00 00 00 CD"

			SerialRequestHandler.instance.request(input, @timeout) do |return_code,length,data|
				if return_code == FS_HEALTH_STATUS

					# Unpack as 4 chars and 6 little-endian shorts
					data = data.unpack("CCCCvvvvvv")

					d = {
						:auto_reset_status 	=> data[0],
						:boot_count 				=> data[1],
						:fs_error 					=> data[2],
						:number_of_sibs 		=> data[3],
						:solar_current 			=> data[4],
						:batt_current 			=> data[5],
						:batt_voltage 			=> data[6],
						:unreg_voltage 			=> data[7],
						:reg_voltage 				=> data[8],
						:reg_current 				=> data[9]
					}
					data = d
				end

				@client.send response(@id, return_code, data)
			end
		end
  end
end
