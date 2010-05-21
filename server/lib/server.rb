require 'rubygems'
require 'eventmachine'
require 'singleton'

require ROOT_DIR+"/lib/fs_logger"
require ROOT_DIR+"/lib/translate"
require ROOT_DIR+"/lib/command_parser"
require ROOT_DIR+'/lib/response_helpers'
require ROOT_DIR+'/lib/token_handler'

class Server
  include Loggable
  include Singleton

	VERSION = '1.0'
	LISTENING_ON = "Listening on $0"

  def start(host, port)
		EM.run do
			EM.start_server host, port, EMServer
			log LISTENING_ON.translate("#{host}:#{port}")
		end
  end
end

module EMServer
	include Loggable
	include ResponseHelpers

	MUST_LOCK_SERVER = "You must lock the server before executing commands"
	SERVER_NOT_LOCKED = "Server not locked. Perhaps your token timed out? Please lock again"
	ALREADY_LOCKED = "You have already locked with token: $0"
	SERVER_IS_LOCKED = "Server is locked"

	def post_init
		@client = "#{get_peername[2]}:#{get_peername[1]}"
		log "#{@client} logged on"
	end

	def receive_data(data)
		log "Request  (#{@client}): #{data}"
		token, command = CommandParser.new(data).parse
		response = check_lock_and_execute_command(token,command)
		log "Response (#{@client}): #{response}"
		send_data response+"\0"
	end

	def unbind
		log "#{@client} logged off"
	end

	def check_lock_and_execute_command(token, command)
		unless TokenHandler.instance.taken? # Server is not locked
			if command.is_a?(Commands::Lock) # Attempt to lock
				if token != 'lock'
					error(SERVER_NOT_LOCKED)
				else
					command.execute
				end
			else # Must lock before doing anything else
				error(MUST_LOCK_SERVER)
			end
		else # Server is locked
			if TokenHandler.instance.token == token # Does tokens match?
				TokenHandler.instance.reset_timer
				if command.is_a?(Commands::Unlock) # Attempt to unlock
					command.execute
				elsif command.is_a?(Commands::Lock)
					error(ALREADY_LOCKED(TokenHandler.instance.token))
				else
					(command.is_a?(String)) ? command : command.execute
				end
			else # Tokens do not match
				error(SERVER_IS_LOCKED)
			end
		end
	end
end
