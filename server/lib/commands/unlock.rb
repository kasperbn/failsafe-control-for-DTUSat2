module Commands
  class Unlock < AbstractCommand
    def execute(caller, id)
      TokenHandler.instance.token = nil
      response(:status => STATUS_OK, :data => "Server has been unlocked")
    end
  end
end
