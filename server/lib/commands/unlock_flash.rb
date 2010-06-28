module Commands
  class UnlockFlash < AbstractCommand
		def execute
			satellite_command("05 00 00 00 CD")
		end
  end
end
