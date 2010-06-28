module Commands
  class Reset < AbstractCommand
		def execute
			satellite_command("01 00 00 00 CD")
		end
  end
end
