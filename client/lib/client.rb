require 'rubygems'
require 'eventmachine'
require 'singleton'
require 'json'

class Client
	include Singleton

	attr_accessor :options

	def start(options)
		@options = options
		EventMachine::run do
			EventMachine::connect options[:host], options[:port], EMClient
		end
	end
end

module EMClient
  def post_init
  	@auto_lock = Client.instance.options[:auto_lock]
  	@interactive = Client.instance.options[:interactive]
  	@data_only = Client.instance.options[:data_only]
		@token = Client.instance.options[:token]

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
		data.split("\0").each do |raw| # Split in case of broadcast messages
			@response = JSON.parse(raw)

			if @verbose
				if @data_only
					puts @response["data"]
				else
					puts raw
				end
			end

			if @response["type"] == "response"
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
  end

	def safe_exit
  	# Unlock and stop EM
		if @auto_lock
			@exit = true
			execute("#{@token} unlock", false)
		else
		  unbind
		end
	end

	def unbind
		EventMachine.stop_event_loop
	end

	def wait_for_user_request
		putc ">"
		putc " "
		@request = $stdin.gets.gsub(/\n/,'')  # Remove newline

		if @request =~ /^exit/
			safe_exit
		elsif @request == ""
			wait_for_user_request
		else
			execute(@request)
		end
	end

	def remember_or_forget_token(request, response)
		if(request =~ /lock/ && response['status'] == 100)
			puts "Token remembered and will be send automatically before any command."
			response['data']
		elsif response['status'] =~ 108
			nil
		else
			@token
		end
	end

	def execute(request,verbose=true)
		@verbose = verbose
		send_data({:id => generate_unique_id, :data => request, :token => @token}.to_json)
	end

	def generate_unique_id(len=6)
		chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
		id = ""
		1.upto(len) { |i| id << chars[rand(chars.size-1)] }
		id
	end
end
