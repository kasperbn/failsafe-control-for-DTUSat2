module Commands
  class UploadSib < AbstractCommand

		def initialize(data)
			@data = data
		end

		def validate
			validate_positive_hex "Data", @data
			validate_byte_length "Data", @data, 28
		end

		def execute
			input = [
				"11",
				"00",
				"1c 00",
				@data.spaced_hex(28).split.reverse,
				"CD"
			]
			satellite_command(input)
		end
  end
end
