module Commands
  class ResetSib < AbstractCommand
		def execute
			satellite_command("12 00 00 00 CD")
		end
  end
end
