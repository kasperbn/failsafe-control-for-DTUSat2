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
	end

	def connect(options)
		@sp = SerialPort.new(options[:serialport], options[:baud], options[:data_bits], options[:stop_bits], options[:parity])
	end

	def request(req, timeout, id=nil, caller=nil, &callback)
		@mutex.synchronize {
			unless block_given? || id.nil? || caller.nil?
				callback = proc {|return_code,downlink,length,data|
					caller.send response(id,return_code,data)
				}
			end
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
					return_code 		= @sp.getc #;puts "Return Code: #{return_code}"
					downlink 				= @sp.getc #;puts "Downlink: #{downlink}"
					data_length_raw = @sp.read(2)
					data_length 		= data_length_raw.unpack("v").first #;puts "Data Length: #{data_length}" # Unpack as short, little endian byte order
					data_raw 				= @sp.read(data_length)
					data 						= data_raw.unpack("v"*(data_length/2)) #;puts "Data: #{data}" # Unpack as shorts, little endian byte order
					log "Serial read: #{return_code.to_s(16)} #{downlink.to_s(16)} #{data_length_raw.bytes.map{|s| s.to_i.to_s(16)}.join(" ")} #{data_raw.bytes.map{|s| s.to_i.to_s(16)}.join(" ")}"
				end

				# Timeout thread
				sleep_step = 0.5
				timeout = Thread.new do
					(0..(request[:timeout]/sleep_step)).each do
						sleep(sleep_step)
						Thread.current.kill! unless return_code.nil?
					end
					read.kill!
					log 'Serial read timedout'
					return_code = STATUS_TIMEOUT
				end

				# Wait for read thread and timeout
				read.join
				timeout.join
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
