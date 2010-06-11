ROOT_DIR = File.dirname(__FILE__)+"/../../../"
require ROOT_DIR+"/test/helpers"
require ROOT_DIR+"/lib/commands/abstract_command"
require ROOT_DIR+"/lib/commands/available_commands"

l = Commands::AvailableCommands.new
p l.execute.to_json
