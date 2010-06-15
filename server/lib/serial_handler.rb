require 'serialport'

class SerialHandler

	def initialize(options)
		@options = options
		@sp = SerialPort.new(options[:device], options[:baud], options[:data_bits], options[:stop_bits], options[:parity])
		@requests = []
	end

	def execute(id,req)
		@requests(req)
		req.each do |s|
			@sp.putc s.hex
			sleep(0.1)
		end
	end

	def handle
		handle unless @requests.empty?
	end

end
