ROOT_DIR = File.dirname(__FILE__)+"/../../../"
require ROOT_DIR+"/lib/commands/abstract_command"
require ROOT_DIR+"/lib/commands/list_scripts"
require ROOT_DIR+"/test/helpers"

l = Commands::ListScripts.new
pp JSON.parse(l.execute)["data"]
