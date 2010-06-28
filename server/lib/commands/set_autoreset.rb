module Commands
  class SetAutoreset < AbstractCommand
		def initialize(value)
			@value = value
		end

		def validate
			@validation_errors << "Value must be either 01 (enable) or 00 (disable)" unless ["00","01"].include?(@value)
		end

		def execute
			input  = [
						"04", 				 # cmd
						"00", 				 # uplink
						"01 00", 			 # data length
						@value,				 # value
						"CD"
			]

			satellite_command(input)
		end
  end
end
