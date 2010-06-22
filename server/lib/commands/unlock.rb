module Commands
  class Unlock < AbstractCommand
    def execute
      TokenHandler.instance.token = nil
      @client.send response(@id,STATUS_OK)
			@client.broadcast message("server_unlocked", STATUS_SERVER_UNLOCKED)
    end
  end
end
