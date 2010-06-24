require 'serialport'
require 'singleton'
require ROOT_DIR + "/lib/constants"
require ROOT_DIR + "/lib/fs_logger"
require ROOT_DIR + "/lib/response_helpers"
require ROOT_DIR + "/lib/processing_queue"

class SerialRequestHandler
	include Singleton
	include Constants
  include Loggable
	include ResponseHelpers
	include ProcessingQueue

	def initialize
		setup_processing_queue
	end

	def connect(options)
		begin
			@sp = SerialPort.new(options[:serialport], options[:baud], options[:data_bits], options[:stop_bits], options[:parity])
			@connected = true
		rescue Errno::ENOENT => e
			log "Could not connect to the serialport"
		end
	end

	def ready?
		@connected
	end

	def not_ready
		[STATUS_SERIALPORT_NOT_CONNECTED,0,nil]
	end

	def request(request, options, &callback)
		req = request.to_a.flatten.join(" ").split(" ")
		enqueue({:command => req, :timeout => options["timeout"].to_i, :noresponse => options["noresponse"]},&callback)
	end

	def process(request, &callback)
		begin
			write(request)
			callback.call(read(request)) unless request["noresponse"]
		rescue Errno::EIO => e
			@connected = false
			log "Serialport has been disconnected"
			callback.call(STATUS_SERIALPORT_NOT_CONNECTED, 0, nil)
			raise ProcessingError
		end
	end

	def write_read(request)
		# Write
		request[:command].each do |s|
			sleep(0.2)
			@sp.putc s.hex
		end
		log "Serial write: #{request[:command].join(' ')}"
	end

	def read(request)
		done_reading = false
		return_code = nil
		data_length = nil
		data = nil

		# Read thread
		read = Thread.new do
			return_code 		= @sp.getc #;puts "Return Code: #{return_code}"
			downlink 				= @sp.getc #;puts "Downlink: #{downlink}"
			data_length_raw = @sp.read(2)
			data_length 		= data_length_raw.unpack("v").first #;puts "Data Length: #{data_length}" # Unpack as 2 byte little endian
			data_raw 				= @sp.read(data_length)
			data 						= data_raw#.unpack("v"*(data_length/2))#.map {|s| s.to_i.to_s(16)} # Unpack as 2 byte little endian, assemble
			done_reading = true
			log "Serial read: #{return_code.to_s(16)} #{downlink.to_s(16)} #{data_length_raw.bytes.map{|s| s.to_i.to_s(16)}.join(" ")} #{data_raw.bytes.map{|s| s.to_i.to_s(16)}.join(" ")}"
		end

		# Timeout thread
		sleep_step = 0.5
		timeout = Thread.new do
			(0..(request[:timeout]/sleep_step)).each do
				sleep(sleep_step)
				Thread.current.kill! if done_reading
			end
			read.kill!
			log 'Serial read timedout'
			return_code = STATUS_TIMEOUT
		end

		# Wait for read thread and timeout
		read.join
		timeout.join

		return return_code, data_length, data
	end

end
