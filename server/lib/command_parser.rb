require File.dirname(__FILE__) + '/translate'
require File.dirname(__FILE__) + '/commands/abstract_command'
Dir.glob(File.dirname(__FILE__) + "/commands/*.rb").each { |f| require f }

class String
  def camelize
    self.split(/[^a-z0-9]/i).map{|w| w.capitalize}.join
  end
end

class CommandParser

	WRONG_ARGUMENTS = "Wrong number of arguments for command: $0"
	UNKNOWN_COMMAND = "Unknown command: $0"

  def self.parse(line)
    token, command, *arguments = *line.split(" ")
    command = token if token =~ /lock/

    command_obj = begin
      eval("Commands::#{command.camelize}.new(*arguments)")
    rescue NameError => e
    	if command.nil?
		    UNKNOWN_COMMAND.translate(token)
	    else
		    UNKNOWN_COMMAND.translate(command)
	    end
    rescue ArgumentError => e
      WRONG_ARGUMENTS.translate(command)
    rescue => e
      e
    end
    return token, command_obj
  end

end
