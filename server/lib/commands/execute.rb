module Commands
  class Execute < AbstractCommand
		HELP = {
				:description => "Execute at the given address",
				:arguments => [
					{:name => "address", :type => "integer", :description => "Address to execute from"},
				]
			}

    def initialize(address)
    end
  end
end
