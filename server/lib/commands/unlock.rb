module Commands
  class Unlock < AbstractCommand
    def execute(id, caller)
      TokenHandler.instance.token = nil
      caller.send response(id,STATUS_SERVER_UNLOCKED)
    end
  end
end
