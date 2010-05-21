require 'rubygems'
require 'eventmachine'
require 'singleton'
require 'json'

class Client
	include Singleton

	attr_accessor :auto_lock, :interactive

	def start(host, port, auto_lock = false, interactive = false)
		@auto_lock = auto_lock
		@interactive = interactive
		EventMachine::run do
			EventMachine::connect host, port, EMClient
		end
	end
end

module EMClient
  def post_init
  	@auto_lock = Client.instance.auto_lock
  	@interactive = Client.instance.interactive

		unless @interactive
			@exit = true
			execute(ARGV.join(' '), true)
		else
			@token = nil
			puts "FSClient - Interactive Mode"

			# Autolock
			if @auto_lock
				@request = 'lock'
				execute(@request, false)
			else
				wait_for_user_request
			end
		end
  end

  def receive_data(data)
		# Parse string response to json
		data = data.delete("\0")
		@response = JSON.parse(data)

		# Print to screen
		puts data if @verbose

		# Remember token?
		@token = remember_or_forget_token(@request, @response)

		# Wait for new request
		if @exit
			unbind
		else
			wait_for_user_request
		end
  end

	def unlock
  	# Unlock and stop EM
  	@exit = true
		execute("#{@token} unlock", false) if @auto_lock
	end

  def unbind
    EventMachine::stop_event_loop
  end

	def wait_for_user_request
		putc ">"
		putc " "
		@request = $stdin.gets.gsub(/\n/,'')  # Remove newline

		if @request =~ /^exit/
			unlock
		else
			@request = prepend_token(@request)
			execute(@request)
		end
	end

	def prepend_token(request)
		if(@token.nil? || request == 'lock')
			request
		else
			"#{@token} #{request}"
		end
	end

	def remember_or_forget_token(request, response)
		if(request =~ /^lock/ && response['status'] == 0)
			puts "Token remembered and will be send automatically before any command."
			response['body']
		elsif response['body'] =~ /^Server has been unlocked/
			nil
		else
			@token
		end
	end

	def execute(request,verbose=true)
		@verbose = verbose
		send_data request
	end
end
