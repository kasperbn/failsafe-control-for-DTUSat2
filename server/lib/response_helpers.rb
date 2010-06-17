require 'rubygems'
require 'json'
require ROOT_DIR + "/lib/constants"

module ResponseHelpers
	include Constants

	def message(type,status,data=nil,options = {})
		{:type => type, :status => status, :message => MESSAGES[status], :data => data}.merge(options)
	end

	def response(id, status, data=nil, options = {})
		message('response', status, data, {:id => id}.merge(options))
	end

end
