module Commands
  class Unlock < AbstractCommand
    def execute
      Server.instance.token = nil
      "Server has been unlocked"
    end
  end
end
