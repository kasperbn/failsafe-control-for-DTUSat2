COMMANDS = [
	["RESET", 1],
	["EXECUTE", 2],
	["CALL_FUNCTION", 3],
	["ENABLE_AUTORESET", 4],
	
	["COPY_TO_FLASH", 5],
	["COPY_TO_RAM", 5],
	["UPLOAD", 7],
	["DOWNLOAD", 8],
	["GET_CHECK_SUM", 9],
	["DELETE_FLASH_BLOCK", 10],

	["DOWNLOAD_SIP", 11],
	["UPLOAD_SIP", 12],
	["HELATH_STATUS", 13],
	["READ_SENSORS", 14],
	["RAM_TEST", 15]
]

DESCRIPTIONS = {
	'RESET' => 'Reboot the satelite',
	'EXECUTE' => 'EXECUTE does not return (i.e. this is not a function call)',
	'CALL_FUNCTION' => 'Calls function',
}

RETURN_CODES = [
	["NO_ERROR", 16], # equivalent to ACK
	["UNDEFINED_CMD", 17],
	["RAM_ERROR", 18],
	["FLASH_WRITE_ERROR", 19],
	["FLASH_DELETE_ERROR", 20]
]

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
