require ROOT_DIR + "/lib/camelize"
Dir.glob(ROOT_DIR+"/lib/commands/*.rb").each {|f| require f }

module Commands
  class AvailableCommands < AbstractCommand
		HELP = {
				:description => "Get a list of available commands"
			}

		def execute(caller=nil, id=nil)
			list = Dir.glob(ROOT_DIR+"/lib/commands/*.rb").map do |f|
				begin
					cmd = File.basename(f).split(".")[0]
					eval("Commands::#{cmd.camelize}::HELP").merge({:command => cmd})
				rescue => e
					nil
				end
			end
			list.delete(nil)
			response(:status => STATUS_OK, :data => list)
		end
  end
end
