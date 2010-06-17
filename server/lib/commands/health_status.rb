module Commands
  class HealthStatus < AbstractCommand
		TIMEOUT = 5
		def execute(id, caller)
			input = "13 00 00 00 CD".split

			SerialRequestHandler.instance.request(input, TIMEOUT) do |return_code,downlink,data_length,data|
				if return_code == FS_HEALTH_STATUS
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
				caller.send response(id, return_code, data)
			end
		end
  end
end
