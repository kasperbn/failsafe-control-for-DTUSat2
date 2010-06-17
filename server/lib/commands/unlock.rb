module Commands
  class Unlock < AbstractCommand
    def execute(id, caller)
      TokenHandler.instance.token = nil
      caller.send response(:id => id, :status => STATUS_OK, :data => "Server has been unlocked")
    end
  end
end
