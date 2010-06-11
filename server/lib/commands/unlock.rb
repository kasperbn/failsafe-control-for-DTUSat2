module Commands
  class Unlock < AbstractCommand
		HELP = {
				:description => "Attempts to unlock the server"
			}

    def execute(caller, id)
      TokenHandler.instance.token = nil
      response(:status => STATUS_OK, :data => "Server has been unlocked")
    end
  end
end
