require 'rubygems'
require 'eventmachine'
require 'singleton'
require 'json'

class Client
	include Singleton

	attr_accessor :auto_lock, :interactive, :data_only

	def start(host, port, auto_lock, interactive, data_only)
		@auto_lock = auto_lock
		@interactive = interactive
		@data_only = data_only

		EventMachine::run do
			EventMachine::connect host, port, EMClient
		end
	end
end

module EMClient
  def post_init
  	@auto_lock = Client.instance.auto_lock
  	@interactive = Client.instance.interactive
  	@data_only = Client.instance.data_only

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
		data.split("\0").each do |raw|
			@response = JSON.parse(raw)

			if @verbose
				if @data_only
					puts @response["data"]
				else
					puts raw
				end
			end

			if @response['partial'].nil?
				@token = remember_or_forget_token(@request, @response)

				if @exit
					unbind
				else
					wait_for_user_request
				end
			end
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
		(@token.nil?) ? request : "#{@token} #{request}";
	end

	def remember_or_forget_token(request, response)
		if(request =~ /^lock/ && response['status'] == 0)
			puts "Token remembered and will be send automatically before any command."
			response['data']
		elsif response['data'] =~ /^Server has been unlocked/ # TODO: Use the STATUS_HAS_BEEN_UNLOCKED instead
			nil
		else
			@token
		end
	end

	def execute(request,verbose=true)
		@verbose = verbose
		send_data({:id => generate_unique_id, :data => request}.to_json)
	end

	def generate_unique_id(len=6)
		chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
		id = ""
		1.upto(len) { |i| id << chars[rand(chars.size-1)] }
		id
	end
end
