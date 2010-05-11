require 'rubygems'
require 'json'

module ResponseHelpers

	def ok(body)
		response(0,body)
	end

	def error(body)
		response(1,body)
	end

	def response(status, body)
		{:status => status, :body => body}.to_json
	end

end
