require ROOT_DIR+'/lib/ext/string'
require ROOT_DIR+'/lib/commands/abstract_command'
require ROOT_DIR+'/lib/response_helpers'
require ROOT_DIR+'/lib/constants'
Dir.glob(ROOT_DIR+"/lib/commands/*.rb").each {|f| require f }

class CommandParser
	include ResponseHelpers
	include Constants

  def parse(raw)

		begin
	  	request = JSON.parse(raw)

			id = request["id"]
			token, command, *arguments = *request["data"].split(" ")
			command = token if token =~ /lock/

			Dir.glob(ROOT_DIR+"/lib/commands/*").each do |f|
    		if command == File.basename(f).split(".")[0] # Does the command exist?
					command_obj = begin
						eval("Commands::#{command.camelize}.new(*arguments)")
					rescue ArgumentError => e
						response(id, STATUS_WRONG_ARGUMENTS)
					rescue => e
						c = (command.nil?) ? token : command;
						response(id, STATUS_UNKNOWN_COMMAND)
					end

					return id, token, command_obj
    		end
    	end
			return id, token, response(id, STATUS_UNKNOWN_COMMAND)
		rescue JSON::ParserError => e
  		return nil,nil, response(nil, STATUS_UNKNOWN_COMMAND)
  	end
  end

end
