require ROOT_DIR+"/lib/fs_logger"
require ROOT_DIR+"/lib/translate"
require ROOT_DIR+"/lib/command_parser"
require ROOT_DIR+'/lib/response_helpers'

class ClientSession
  include Loggable
  include ResponseHelpers

	MUST_LOCK_SERVER = "You must lock the server before executing commands"
	SERVER_NOT_LOCKED = "Server not locked. Perhaps your token timed out? Please lock again"
	ALREADY_LOCKED = "You have already locked with token: $0"
	SERVER_IS_LOCKED = "Server is locked"

  def initialize(stream, client)
    @stream = stream
    @client = client

    log "#{@client} logged on"
    read_stream
  end

  def read_stream
    begin
      while line = @stream.gets
        break if line =~ /^exit\r?$/

        log "Request  (#{@client}): #{line}"
        token, command = CommandParser.new(line).parse
        response = check_lock_and_execute_command(token,command)
        log "Response (#{@client}): #{response}"

        @stream.puts response+"\0"
      end
    rescue => e
      log e
    ensure
      @stream.close
    end
    log "#{@client} logged off"
  end

	private
	def check_lock_and_execute_command(token, command)
		unless Server.instance.locked? # Server is not locked
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
			if Server.instance.token == token # Does tokens match?
				Server.instance.reset_token_timer
				if command.is_a?(Commands::Unlock) # Attempt to unlock
					command.execute
				elsif command.is_a?(Commands::Lock)
					error(ALREADY_LOCKED(Server.instance.token))
				else
				  (command.is_a?(String)) ? command : command.execute
				end
			else # Tokens do not match
				error(SERVER_IS_LOCKED)
			end
		end
	end
end
