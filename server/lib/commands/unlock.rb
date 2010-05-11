module Commands
  class Unlock < AbstractCommand
    def execute
      Server.instance.token = nil
      response(0, "Server has been unlocked")
    end
  end
end
