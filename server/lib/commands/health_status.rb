module Commands
  class HealthStatus < AbstractCommand
			TIMEOUT = 5

			def execute(id, caller)
				TokenHandler.instance.stop_timer
				SerialRequestHandler.instance.request("13 00 00 00 CD".split, TIMEOUT) do |return_code,downlink,data_length,data|
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

					caller.send response(:id => id, :status => return_code, :data => d)
					TokenHandler.instance.start_timer
				end
			end
  end
end
