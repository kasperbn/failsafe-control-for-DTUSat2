require 'singleton'
require 'serialport'
require ROOT_DIR + '/lib/constants'
require ROOT_DIR + '/lib/fs_logger'

class SerialRequestHandler
	include Singleton
	include Constants
  include Loggable

	def initialize
		@mutex = Mutex.new
		@queue = []
		@started = false
	end

	def connect(options)
		@sp = SerialPort.new(options[:serialport], options[:baud], options[:data_bits], options[:stop_bits], options[:parity])
	end

	def request(req, timeout, &callback)
		@mutex.synchronize {
			@queue << {:command => req, :timeout => timeout, :callback => callback}
		}

		execute unless @started
	end

	private
	def execute
		request = nil

		return_code = nil
		downlink = nil
		data_length = nil
		data = nil

		@mutex.synchronize do
			request = @queue.shift
			@started = !request.nil?

			if @started
				# Write

				request[:command].each do |s|
					sleep(0.2)
					@sp.putc s.hex
				end
				log "Serial write: #{request[:command].join(' ')}"

				# Read thread
				read = Thread.new do
					return_code 		= @sp.getc# ;puts "Return Code: #{return_code}"
					downlink 				= @sp.getc# ;puts "Downlink: #{downlink}"
					data_length_raw = @sp.read(2)#  ;puts "Data Length: #{data_length}" # Unpack as short, little endian byte order
					data_length 		= data_length_raw.unpack("v").first
					data_raw 				= @sp.read(data_length)#  ;puts "Data: #{data}" # Unpack as shorts, little endian byte order
					data 						= data_raw.unpack("v"*(data_length/2))
#					log "Serial read: #{return_code.to_s(16)} #{downlink.to_s(16)} #{data_length_raw.bytes.map{|s| s.to_i.to_s(16)}.join(" ")} #{data_raw.bytes.map{|s| s.to_i.to_s(16)}.join(" ")}"
				end

				# Timeout thread
				sleep_step = 0.5
				Thread.new do
					(0..(request[:timeout]/sleep_step)).each do
						sleep(sleep_step)
						return unless return_code.nil?
					end
					log 'Serial read timedout'
					return_code = STATUS_TIMEOUT
					read.kill!
				end

				# Wait for read thread or timeout
				read.join
			end
		end

		unless request.nil?
			Thread.new do
				request[:callback].call(return_code, downlink, data_length, data)
			end
		end

		execute if @started
	end
end
