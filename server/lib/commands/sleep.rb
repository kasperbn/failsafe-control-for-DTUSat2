module Commands
  class Sleep < AbstractCommand
		def initialize(seconds)
			@seconds = seconds
		end

		def validate
			validate_positive_integer "Seconds", @seconds
		end

    def execute
    	TokenHandler.instance.stop_timer
	    sleep(@seconds.to_i)
    	TokenHandler.instance.start_timer
			@client.send response(@id,STATUS_OK,nil)
    end
  end
end
