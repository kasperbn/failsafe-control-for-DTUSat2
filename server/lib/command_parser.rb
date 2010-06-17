require ROOT_DIR+'/lib/string_extensions'
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
						response(:status => STATUS_WRONG_ARGUMENTS, :data => MESSAGE_WRONG_ARGUMENTS.translate(command))
					rescue => e
						c = (command.nil?) ? token : command;
						response(:status => STATUS_UNKNOWN_COMMAND, :data => MESSAGE_UNKNOWN_COMMAND.translate(c))
					end

					return id, token, command_obj
    		end
    	end
			return id, token, response(:status => STATUS_UNKNOWN_COMMAND, :data => MESSAGE_UNKNOWN_COMMAND.translate(command))
		rescue JSON::ParserError => e
  		return nil,nil, response(:status => STATUS_INVALID_FORMAT, :data => MESSAGE_INVALID_FORMAT.translate(raw))
  	end
  end

end
