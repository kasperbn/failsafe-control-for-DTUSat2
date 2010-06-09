require 'rubygems'
require 'eventmachine'
require 'singleton'
require 'socket'

require ROOT_DIR+"/lib/fs_logger"
require ROOT_DIR+"/lib/translate"
require ROOT_DIR+"/lib/command_parser"
require ROOT_DIR+'/lib/response_helpers'
require ROOT_DIR+'/lib/messages_and_statuses'
require ROOT_DIR+'/lib/token_handler'

class Server
  include Loggable
  include Singleton

	VERSION = '1.0'
	LISTENING_ON = "Listening on $0"

  def start(host, port, timeout)
		EM.run do
			TokenHandler.instance.timeout = timeout
			EM.start_server host, port, EMServer
			log LISTENING_ON.translate("#{host}:#{port}")
		end
  end
end

module EMServer
	include Loggable
	include ResponseHelpers
	include MessagesAndStatuses

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
		id, token, command = CommandParser.new(data).parse

		# Execute in separate thread so we can listen for more incoming requests
		operation = proc {
			begin
				check_lock_and_execute_command(id, token,command)
			rescue => e
				log "Error in operation: #{e}"
			end
		}
		callback = proc {|response|
			begin
				r = response.merge!({:id => id}).to_json # Add id
				send(r)
			rescue => e
				log "Error in callback: #{e}"
			end
		}

		# Defer it!
		EventMachine.defer(operation,callback)
	end

	def send(data)
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

	def check_lock_and_execute_command(id, token, command)
		unless TokenHandler.instance.taken? # Server is not locked
			if command.is_a?(Commands::Lock) # Attempt to lock
					command.execute(self, id)
			else # Must lock before doing anything else
				response(:status => STATUS_MUST_LOCK, :data => MESSAGE_MUST_LOCK)
			end
		else # Server is locked
			if TokenHandler.instance.token != token # Tokens does not match
				response(:status => STATUS_IS_LOCKED, :data => MESSAGE_IS_LOCKED)
			else # Tokens match
				TokenHandler.instance.reset_timer
				if command.is_a?(Commands::Unlock) # Attempt to unlock
					command.execute(self, id)
				elsif command.is_a?(Commands::Lock) # Attempt to lock
					response(:status => STATUS_ALREADY_LOCKED, :data => MESSAGE_ALREADY_LOCKED.translate(TokenHandler.instance.token))
				else
					if(command.is_a?(Hash)) # Command is already formatted as an parse error
						command
					else
						command.execute(self, id)
					end
				end
			end
		end
	end
end
