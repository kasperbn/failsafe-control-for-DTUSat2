module Commands
  class DownloadSib < AbstractCommand
		def execute
			satellite_command("10 00 00 00 CD")
		end

		def unpack(data)
			data.unpack("C"*32) # Unpack as 32 unsigned chars
		end
  end
end
