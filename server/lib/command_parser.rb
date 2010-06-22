require ROOT_DIR+'/lib/ext/string'
require ROOT_DIR+'/lib/commands/abstract_command'
require ROOT_DIR+'/lib/response_helpers'
require ROOT_DIR+'/lib/constants'
Dir.glob(ROOT_DIR+"/lib/commands/*.rb").each {|f| require f }

class CommandParser
	include ResponseHelpers
	include Constants

  def parse(raw)
		id = nil
		token = nil
		command = Commands::Unknown.new

		begin
	  	request = JSON.parse(raw)
			id = request["id"]
			token = request["token"]
			cmd_string, *arguments = *request["data"].split(" ")
			command = eval("Commands::#{cmd_string.camelize}.new(*arguments)")
		rescue ArgumentError => e
			command = Commands::WrongNumberOfArguments.new
		rescue => e
  	end

		return id, token, command
  end

end
