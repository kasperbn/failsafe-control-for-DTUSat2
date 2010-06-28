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

			opts = arguments.map {|a| a[0].chr == "-" ? a : nil};opts.delete(nil)
			options = {}
			opts.each do |o|
				key,val = o.split("=")
				options[key[2..-1]] = val || true
			end
			arguments = arguments.delete_if {|a| a[0].chr == "-"}

			if cmd_string[0].chr.match(/[a-zA-Z]/)
				command = eval("Commands::#{cmd_string.camelize}.new(*arguments)")
			end
		rescue ArgumentError => e
			command = Commands::WrongNumberOfArguments.new
		rescue => e
  	end

		# Set defaults
		options["timeout"] ||= DEFAULT_TIMEOUT
		options["no-response"] ||= false
		command.options = options
		command.id = id

		return id, token, command
  end

end
