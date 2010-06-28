module Commands
  class HealthStatus < AbstractCommand

		def execute
			input = "13 00 00 00 CD"

			satellite_command(input) do |return_code,length,data|
				if return_code == FS_HEALTH_STATUS
					# Unpack as 4 chars and 6 little-endian shorts
					data = data.unpack("CCCCvvvvvv")
				end

				@client.send response(@id, return_code, data)
			end
		end
  end
end
