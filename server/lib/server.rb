require 'rubygems'
require 'eventmachine'
require 'singleton'
require 'socket'

require ROOT_DIR+"/lib/fs_logger"
require ROOT_DIR+"/lib/string_extensions"
require ROOT_DIR+"/lib/command_parser"
require ROOT_DIR+'/lib/response_helpers'
require ROOT_DIR+'/lib/constants'
require ROOT_DIR+'/lib/token_handler'
require ROOT_DIR+'/lib/serial_request_handler'

class Server
  include Loggable
  include Singleton

	VERSION = '1.0'
	LISTENING_ON = "Listening on $0"

  def start(options)
		EM.run do
			TokenHandler.instance.timeout = options[:token_timeout]
			# Setup serial request handler
			SerialRequestHandler.instance.connect(options)
			EM.start_server options[:host], options[:port], EMServer
			log LISTENING_ON.translate("#{options[:host]}:#{options[:port]}")
		end
  end
end

module EMServer
	include Loggable
	include ResponseHelpers
	include Constants

	def post_init
		# Maintain list of all connected clients
		$clients_list ||= {}
		@identifier = self.object_id
		$clients_list.merge!({@identifier => self})

		# Setup token_reset broadcast
		TokenHandler.instance.reset_callback ||= Proc.new {
			broadcast(message(:type => "server_unlocked", :data => MESSAGE_SERVER_UNLOCKED).to_json+"\0")
		}

		port, ip = Socket.unpack_sockaddr_in(get_peername)
		@client = "<#{ip}:#{port}>"
		log "#{@client} logged on"
	end

	def receive_data(data)
		log "#{@client} requests: #{data}"
		id, token, command = CommandParser.new.parse(data)

		if TokenHandler.instance.taken?
			if TokenHandler.instance.token != token
				send(response(:id => id, :status => STATUS_IS_LOCKED, :data => MESSAGE_IS_LOCKED))
				return;
			end
			TokenHandler.instance.reset_timer
		else
			unless command.is_a?(Commands::Lock)
				send(response(:id => id, :status => STATUS_MUST_LOCK, :data => MESSAGE_MUST_LOCK))
				return;
			end
		end

		# Command is already formatted as an parse error
		if(command.is_a?(Hash))
			send(command)
			return;
		end

		if command.valid?
			# Execute command
			operation = proc { command.execute(id, self) }
			EventMachine.defer(operation)
		else
			send(response(:id => id, :status => STATUS_VALIDATION_ERROR, :data => command.validation_errors))
		end
	end

	def send(data)
		data = data.to_json if data.is_a?(Hash)
		log "#{@client} response: #{data}"
		send_data(data+"\0")
	end

	def unbind
		$clients_list.delete(@identifier)
		log "#{@client} logged off"
	end

	def broadcast(data)
		log "Broadcasting: #{data}"
		$clients_list.values.each do |client|
			client.send_data(data)
		end
	end
end
