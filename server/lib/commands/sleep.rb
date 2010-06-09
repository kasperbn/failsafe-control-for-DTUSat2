module Commands
  class Sleep < AbstractCommand
		def initialize(seconds)
			@seconds = seconds.to_i
		end

    def execute(caller, id)
    	TokenHandler.instance.stop_timer
	    sleep(@seconds)
    	TokenHandler.instance.start_timer
			response(:status => STATUS_OK, :data => "Slept #{@seconds} seconds.")
    end
  end
end
