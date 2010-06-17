module Commands
  class CopyToRam < AbstractCommand
		TIMEOUT = 5

		def initialize(from,to,length)
			@from = from
			@to = to
			@length = length
		end

		def validate
			@validation_errors << "From address must be 4 bytes long" if @from.size != 8
			@validation_errors << "To address must be 4 bytes long" if @to.size != 8
			@validation_errors << "Length must be 4 bytes long" if @to.size != 8
		end

		def execute(id, caller)
			input  = [
						"07", 				 # cmd
						"00", 				 # uplink
						"0c 00".split, # data length
						@from.spaced_hex.split,
						@to.spaced_hex.split,
						@length.spaced_hex.split,
						"CD"
			].flatten

			SerialRequestHandler.instance.request(input, TIMEOUT, id, caller)
		end
  end
end
