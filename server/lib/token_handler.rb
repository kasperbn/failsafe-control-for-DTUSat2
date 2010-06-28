require 'singleton'

require ROOT_DIR+"/lib/logger"

class TokenHandler
  include Singleton
  include Loggable

	attr_reader :token
	attr_accessor :timeout, :reset_callback

	def initialize
		@token = nil
		@mutex = Mutex.new
		@started = false # Shared variable. Must protect reads and writes.
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
		@mutex.synchronize {
			@started = false
			@timer_thread.kill
		}
	end

	def reset_timer
		@timer = @timeout
	end

	def start_timer
		@mutex.synchronize {
			unless @started
				@started = true
				reset_timer
				@timer_thread = Thread.new do
					loop do
						sleep(1)
						@timer -= 1
						if @timer < 1
							log "Token has been reset after #{@timeout} seconds."
							@token = nil
							@reset_callback.call
							stop_timer
						end
					end
				end
			end
		}
	end

end
