class CommandsController < ApplicationController

	def index
	end
	
	def show
		@command = params['command']
		render "unknown_command" unless COMMANDS.any? {|name,code| name == @command}
	end
	
	def unknown_command
		@command = params['command']
	end
	
	def execute
		@command = params['command']
		@arguments = params['arguments']
		request = "fsterm2 #{@command} #{@arguments.join(" ") rescue ""}"
		flash[:request] = request
		flash[:response] = `#{RAILS_ROOT}/../fsterm2/#{request}`
		redirect_to :back
	end

end
