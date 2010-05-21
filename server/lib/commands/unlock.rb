module Commands
  class Unlock < AbstractCommand
    def execute
      TokenHandler.instance.token = nil
      response(0, "Server has been unlocked")
    end
  end
end
