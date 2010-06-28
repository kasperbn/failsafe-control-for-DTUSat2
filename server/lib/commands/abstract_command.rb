require ROOT_DIR+'/lib/response_helpers'
require ROOT_DIR+'/lib/constants'
require ROOT_DIR+'/lib/ext/string'
require ROOT_DIR+"/lib/ext/fixnum"

class AbstractCommand
	include ResponseHelpers
	include Constants

	attr_accessor :validation_errors, :timeout, :client, :id, :options

  def execute
    caller.send response(@id, STATUS_OK)
  end

	def unpack(data)
		data
	end

	def satellite_command(cmd)
		SerialRequestHandler.instance.request(cmd, @options) do |return_code,length,data|
			if return_code == STATUS_SERIALPORT_NOT_CONNECTED
				@client.send response(@id, return_code, data)
			else
				if block_given?
					yield(return_code,length,data)
				else
					data = unpack(data)
					@client.send response(@id, return_code, data)
				end
			end
		end
	end

	def validate
	end

  def valid?
  	@validation_errors = []
		validate_positive_integer "Timeout", @options["timeout"]
		validate
		@validation_errors.empty?
  end

	def validate_addressable(name, var, bytes=4)
		@validation_errors << "#{name} must be addressable (<= #{bytes} bytes)" unless !var.nil? && var.addressable?(bytes)
	end

	def validate_positive(name, var)
		@validation_errors << "#{name} must be a positive number" unless !var.nil? && var.positive?
	end

	def validate_positive_integer(name, var)
		@validation_errors << "#{name} must be a positive integer" unless !var.nil? && var.positive_integer?
	end

	def validate_positive_hex(name, var)
		@validation_errors << "#{name} must be a positive hex" unless !var.nil? && var.positive_hex?
	end

	def validate_byte_length(name, var, max=4)
		@validation_errors << "#{name} is too many bytes (<= #{max})" if var.nil? || var.byte_length > max
	end

	def validate_max_value(name, var, max)
		@validation_errors << "#{name} is too long (<= #{max})" if var.nil? || var.int_or_hex > max
	end

end
