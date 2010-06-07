require 'rubygems'
require 'json'

module ResponseHelpers

	def message(params = {})
		params
	end

	def response(params = {})
		message(params.merge({:type => 'response'}))
	end

end
