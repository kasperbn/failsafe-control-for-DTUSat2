class FSTerm2

	VERSION = '1.0'

	attr_accessor :token, :command, :response, :connection, :input, :auto_lock

	def initialize(connection,auto_lock)
		@connection = connection
		@auto_lock = auto_lock
	end

	def self.author_version
		puts "FSTerm2 Version #{VERSION} - Interactive Mode"
		puts "Kasper Bjørn Nielsen (s052808@student.dtu.dk)"
	end

	def interactive_loop
		@token = nil
		FSTerm2.author_version
		if @auto_lock
			@command = 'lock'
			@response = execute(@command)
			@token = remember_or_forget_token
		end
		loop do
			@command = wait_for_user_input
			break if exit?
			@command = prepend_token
			@response = execute(@command)
			@token = remember_or_forget_token
		end
		unlock_on_clean_exit if @auto_lock
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
		if @command =~ /^lock/ && !(@response =~ /^You must lock the server/ || @response =~ /^Server is locked/)
			puts "Token remembered and will be send automatically before any command."
			return @response
		elsif @response =~ /^Server has been unlocked/
			return nil
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
		puts "Request:  '#{request}'" if verbose
		@connection.puts request
		response = @connection.gets.gsub(/\n/,'') # Remove newline
		puts "Response: '#{response}'" if verbose
		response
	end

end
