require 'singleton'
require ROOT_DIR+"/lib/fs_logger"

class TokenHandler
  include Singleton
  include Loggable

	TOKEN_HAS_BEEN_RESET = "Token has been reset after $0 seconds of inactivity"

	attr_reader :token
	attr_accessor :timeout, :reset_callback

	def initialize
		@token = nil
	end

	def token=(token)
		@token = token
		(free?) ? stop_timer : start_timer
	end

	def free?
		@token.nil?
	end

	def taken?
		!free?
	end

	def stop_timer
		@timer_thread.kill
	end

	def reset_timer
		@timer = @timeout
	end

	def start_timer
		reset_timer
		@timer_thread = Thread.new do
			loop do
				sleep(1)
				@timer -= 1
				if @timer < 1
					log TOKEN_HAS_BEEN_RESET.translate(@timeout)
					@token = nil
					@reset_callback.call
					stop_timer
				end
			end
		end
	end

end
