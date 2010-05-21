require ROOT_DIR+'/lib/translate'
require ROOT_DIR+'/lib/commands/abstract_command'
require ROOT_DIR+'/lib/response_helpers'
Dir.glob(ROOT_DIR+"/lib/commands/*.rb").each {|f| require f }

class String
  def camelize
    self.split(/[^a-z0-9]/i).map{|w| w.capitalize}.join
  end
end

class CommandParser
	include ResponseHelpers

	WRONG_ARGUMENTS = "Wrong number of arguments for command: $0"
	UNKNOWN_COMMAND = "Unknown command: $0"

	def initialize(line)
		@line = line
	end

  def parse
    token, command, *arguments = *@line.split(" ")
    command = token if token =~ /lock/

    command_obj = begin
      eval("Commands::#{command.camelize}.new(*arguments)")
    rescue NameError => e
    	if command.nil?
		   error(UNKNOWN_COMMAND.translate(token))
	    else
		   error(UNKNOWN_COMMAND.translate(command))
	    end
    rescue ArgumentError => e
      error(WRONG_ARGUMENTS.translate(command))
    end

    puts "parsed as #{command_obj}"

    return token, command_obj
  end

end
