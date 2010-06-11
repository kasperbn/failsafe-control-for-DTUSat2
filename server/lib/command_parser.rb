require ROOT_DIR+'/lib/translate'
require ROOT_DIR+'/lib/camelize'
require ROOT_DIR+'/lib/commands/abstract_command'
require ROOT_DIR+'/lib/response_helpers'
require ROOT_DIR+'/lib/messages_and_statuses'
Dir.glob(ROOT_DIR+"/lib/commands/*.rb").each {|f| require f }

class CommandParser
	include ResponseHelpers
	include MessagesAndStatuses

	def initialize(raw)
		@raw = raw
	end

  def parse

		begin
	  	request = JSON.parse(@raw)

			token, command, *arguments = *request["data"].split(" ")
			command = token if token =~ /lock/

			command_obj = begin
			  eval("Commands::#{command.camelize}.new(*arguments)")
			rescue NameError => e
				c = (command.nil?) ? token : command;
				response(:status => STATUS_UNKNOWN_COMMAND, :data => MESSAGE_UNKNOWN_COMMAND.translate(c))
			rescue ArgumentError => e
				response(:status => STATUS_WRONG_ARGUMENTS, :data => MESSAGE_WRONG_ARGUMENTS.translate(command))
			end

		  return request["id"], token, command_obj

		rescue JSON::ParserError => e
  		return nil,nil, response(:status => STATUS_INVALID_FORMAT, :data => MESSAGE_INVALID_FORMAT.translate(@raw))
  	end
  end

end
