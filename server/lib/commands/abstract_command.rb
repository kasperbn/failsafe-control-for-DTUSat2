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

	def validate
	end

  def valid?
  	@validation_errors = []
		validate_positive_integer "Timeout", @options["timeout"]
		validate
		@validation_errors.empty?
  end

	def validate_addressable(name, var, length=8)
		@validation_errors << "#{name} must be addressable (<= 4 bytes)" unless !var.nil? && var.addressable?(length)
	end

	def validate_positive(name, var)
		@validation_errors << "#{name} must be a positive number" unless !var.nil? && var.positive?
	end

	def validate_positive_integer(name, var)
		@validation_errors << "#{name} must be a positive integer" unless !var.nil? && var.positive_integer?
	end

	def validate_length(name, var, max=0xffffffff)
		@validation_errors << "#{name} is too long (<= #{max})" if var.nil? || var.int_or_hex > max
	end

end
