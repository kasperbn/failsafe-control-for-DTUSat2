require 'singleton'

# TODO: REPLACE WITH C EXTENSION TO REAL DATALINK
require ROOT_DIR + '/link_fs/link_fs_devel'

require ROOT_DIR + "/lib/constants"
require ROOT_DIR + "/lib/logger"
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
		status = Link_fs.link_fs_init("w")
		if status == PRO_OK
			@connected = true
			log "Initialized the datalink"
		else
			log "Could not initialize the datalink"
		end
	end

	def ready?
		@connected
	end

	def not_ready(request, &callback)
		callback.call(STATUS_SERIALPORT_NOT_CONNECTED,0,nil)
	end

	def request(request, options, &callback)
		req = request.to_a.flatten.join(" ").split(" ")
		enqueue({"command" => req, "timeout" => options["timeout"].to_i, "no-response" => options["no-response"]},&callback)
	end

	def process(request, &callback)
		begin
			write(request)
			if request["no-response"]
				return_code, length, data = STATUS_OK, nil, nil
			else
				return_code, length, data = read(request)
			end
			Thread.new do
				callback.call(return_code, length, data)
			end
		rescue Errno::EIO => e
			@connected = false
			log "The datalink has been disconnected"
			not_ready(request, &callback)
			raise ProcessingError
		end
	end

	def write(request)
		data = request["command"].map{|h| h.hex}
		log "Datalink writing ... "
		status = Link_fs.link_fs_send_packet(data, data.length)
		if status == PRO_OK
			log "Datalink wrote: #{request["command"].join(' ')}"
		else
			log "An failure occured during write to the datalink"
		end
	end

	def read(request)
		buffer = ""
		log "Datalink reading ..."
		buffer, result = Link_fs.link_fs_receive_packet(buffer, FS_MAX_PACKET_SIZE, request["timeout"])

		if result == PRO_OK
			return_code 		= buffer[0]
			downlink 				= buffer[1]
			data_length_raw = buffer[2..3]
			data_length 		= data_length_raw.unpack("v").first
			data						= buffer[4..(4+data_length-1)]
			log "Datalink read: #{return_code.spaced_hex(1)} #{downlink.spaced_hex(1)} #{data_length_raw.bytes.map{|s| s.to_i.spaced_hex(1)}.join(" ")} #{data.bytes.map{|s| s.to_i.spaced_hex(1)}.join(" ")}"
			return return_code, data_length, data
		else
			log 'Datalink read timeout'
			return STATUS_TIMEOUT,nil,nil
		end
	end

end
