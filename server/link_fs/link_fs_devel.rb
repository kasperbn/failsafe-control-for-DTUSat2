require 'serialport'

require ROOT_DIR + "/lib/logger"
require ROOT_DIR + "/lib/constants"

module Link_fs

	class << self
		include Constants
		include Loggable

		DEVICE 		= "/dev/ttyUSB0"
		BAUD			= 9600
		DATA_BITS	= 8
		STOP_BITS = 1
		PARITY 		= SerialPort::NONE

		def link_fs_init(rw)
			begin
				$sp = SerialPort.new(DEVICE, BAUD, DATA_BITS, STOP_BITS, PARITY)
				return PRO_OK
			rescue => e
				log "SerialPort init error: #{e}"
				return PRO_FAILURE
			end
		end

		def link_fs_send_packet(data, length)
			begin
				data.each do |s|
					sleep(0.2)
					$sp.putc(s)
				end
				return PRO_OK
			rescue => e
				log "SerialPort write error: #{e}"
				return PRO_FAILURE
			end
		end

		def link_fs_receive_packet(buffer, maxlength, timeout)
			done_reading = false
			status = ""

			# Read thread
			r = Thread.new do
				begin
					return_code 		= $sp.getc
					downlink 				= $sp.getc
					data_length_raw = $sp.read(2)
					data_length 		= data_length_raw.unpack("v").first
					data 						= $sp.read(data_length)

					done_reading 		= true
					buffer 					<< return_code << downlink << data_length_raw << data
					status 					= PRO_OK
				rescue => e
					log "SerialPort read error: #{e}"
					status 					= PRO_FAILURE
				end
			end

			# Timeout thread
			sleep_step = 0.5
			t = Thread.new do
				(0..(timeout/(100*sleep_step))).each do
					sleep(sleep_step)
					Thread.current.kill! if done_reading
				end
				r.kill!
				status = PRO_TIMEOUT
			end

			# Wait for read thread and timeout
			r.join
			t.join

			return buffer, status
		end

	end
end
