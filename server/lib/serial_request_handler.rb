require 'singleton'
require 'serialport'
require ROOT_DIR + '/lib/constants'
require ROOT_DIR + '/lib/fs_logger'
require ROOT_DIR + '/lib/response_helpers'

class SerialRequestHandler
	include Singleton
	include Constants
  include Loggable
	include ResponseHelpers

	def initialize
		@mutex = Mutex.new
		@queue = []
		@started = false
		@connected = false
	end

	def connect(options)
		@sp = SerialPort.new(options[:serialport], options[:baud], options[:data_bits], options[:stop_bits], options[:parity])
		@connected = true
	end

	def request(req, timeout, &callback)
		if @connected
			req = req.to_a.flatten.join(" ").split
			@mutex.synchronize {
				@queue << {:command => req, :timeout => timeout.to_i, :callback => callback}
			}

			execute unless @started
		else
			callback.call(STATUS_SERIALPORT_NOT_CONNECTED,0,nil)
		end
	end

	private
	def execute
		@mutex.synchronize do
			request = @queue.shift
			@started = !request.nil?

			begin
				request[:callback].call(write_read(request)) if @started
			rescue Errno::EIO => e
				@connected = false
				@started = false
				log "Serialport has been disconnected"
				request[:callback].call(STATUS_SERIALPORT_NOT_CONNECTED, 0, nil)
			end
		end

		execute if @started && @connected
	end

	def write_read(request)
		done_reading = false
		return_code = nil
		data_length = nil
		data = nil

		# Write
		request[:command].each do |s|
			sleep(0.2)
			@sp.putc s.hex
		end
		log "Serial write: #{request[:command].join(' ')}"

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
