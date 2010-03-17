require File.dirname(__FILE__)+"/fs_logger"
require File.dirname(__FILE__)+"/translate"
require File.dirname(__FILE__)+"/command_parser"

class ClientSession
  include Loggable

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
        token, command = CommandParser.parse(line)

        response = if !Server.instance.locked? # Server is not locked
					if command.is_a?(Commands::Lock) # Attempt to lock
            if token != 'lock'
	 						SERVER_NOT_LOCKED
	 					else
		 					command.execute
            end
          else # Must lock before doing anything else
            MUST_LOCK_SERVER
          end
        else # Server is locked
          if Server.instance.token == token # Does tokens match?
				    Server.instance.reset_token_timer
		        if command.is_a?(Commands::Unlock) # Attempt to unlock
		        	command.execute
		        elsif command.is_a?(Commands::Lock)
		        	ALREADY_LOCKED Server.instance.token
		        else
		          (command.is_a?(String)) ? command : command.execute
		        end
          else # Tokens do not match
            SERVER_IS_LOCKED
          end
        end
        log "Response (#{@client}): #{response}"
        @stream.puts response
      end
    rescue => e
      puts e
    ensure
      @stream.close
    end

    log "#{@client} logged off"
  end
end
