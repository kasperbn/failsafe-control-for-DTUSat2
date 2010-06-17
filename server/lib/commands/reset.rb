module Commands
  class Reset < AbstractCommand
			TIMEOUT = 5
			def execute(id, caller)
				SerialRequestHandler.instance.request("01 00 00 00 CD".split, TIMEOUT) do |return_code, downlink, data_length, data|
					caller.send response(:id => id, :status => return_code, :data => "")
				end
			end
  end
end
