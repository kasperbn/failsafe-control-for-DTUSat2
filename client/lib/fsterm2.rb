require 'rubygems'
require 'json'

class FSTerm2

	VERSION = '1.0'

	attr_accessor :token, :command, :response, :connection, :input, :auto_lock

	def initialize(connection,auto_lock)
		@connection = connection
		@auto_lock = auto_lock
	end

	def self.author_version
		puts "FSTerm2 Version #{VERSION} - Interactive Mode"
	end

	def interactive_loop
		begin
			@token = nil
			FSTerm2.author_version
			if @auto_lock
				@command = 'lock'
				@response = execute(@command)#.gsub("\n",'')
				remember_or_forget_token
			end
			loop do
				@command = wait_for_user_input
				break if exit?
				@command = prepend_token
				@response = execute(@command)
				remember_or_forget_token
			end
			unlock_on_clean_exit if @auto_lock
		rescue Errno::EPIPE => e
			puts "Connection to server was lost"
		end
	end

	def wait_for_user_input
		putc ">"
		putc " "
		$stdin.gets.gsub(/\n/,'')  # Remove newline
	end

	def exit?
		@command =~ /^exit/
	end

	def prepend_token
		if(@token.nil? || @command == 'lock')
			@command
		else
			"#{@token} #{@command}"
		end
	end

	def remember_or_forget_token
		@token = if @command =~ /^lock/ && !(@response =~ /^You must lock the server/ || @response =~ /^Server is locked/)
			puts "Token remembered and will be send automatically before any command."
			@response['body']
		elsif @response =~ /^Server has been unlocked/
			nil
		else
			@token
		end
	end

	def unlock_on_clean_exit
		execute("#{@token} unlock") unless @token.nil?
	end

	def single_command(command)
		puts execute(command, false)
	end

	def execute(request,verbose=true)
		# Send request
		@connection.puts request

		# Read until zero byte
		response = @connection.gets("\0").delete("\0")

		# Parse string response to json
		response = JSON.parse(response)

		# Print to screen
		puts "< STATUS: #{response['status']}" if verbose
		puts "#{response['body']}" if verbose

		response
	end
end
