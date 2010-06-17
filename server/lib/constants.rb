module Constants

	# Messages
	MESSAGE_MUST_LOCK 				= "You must lock the server before executing commands"
	MESSAGE_ALREADY_LOCKED 		= "You have already locked with token: $0"
	MESSAGE_IS_LOCKED 				= "Server is locked"
	MESSAGE_SERVER_UNLOCKED 	= "Server has been unlocked"
	MESSAGE_WRONG_ARGUMENTS 	= "Wrong number of arguments for command: $0"
	MESSAGE_UNKNOWN_COMMAND 	= "Unknown command: $0"
	MESSAGE_INVALID_FORMAT 		= "Invalid format: $0"

	# Stati
	STATUS_OK 								= 0
	STATUS_ERROR 							= 1
	STATUS_IS_LOCKED 					= 2
	STATUS_MUST_LOCK 					= 3
	STATUS_ALREADY_LOCKED 		= 4
	STATUS_WRONG_ARGUMENTS 		= 5
	STATUS_UNKNOWN_COMMAND 		= 6
	STATUS_INVALID_FORMAT 		= 7
	STATUS_TIMEOUT 						= 8
	STATUS_VALIDATION_ERROR 	= 9

	# Return Codes
	FS_NO_ERROR								= 0xFF
	FS_UNDEFINED_CMD					= 0xFE
	FS_RAM_ERROR							= 0xFD
	FS_FLASH_WRITE_ERROR			= 0xFC
	FS_FLASH_DELETE_ERROR			= 0xFB
	FS_PACKET_LENGTH_ERROR		= 0xFA
	FS_RAM_ADDRESS_ERROR			= 0xF9
	FS_FLASH_ADDRESS_ERROR		= 0xF8
	FS_FLASH_OPERATION_LOCKED	= 0xF7
	FS_ADDRESS_ERROR					= 0xF6
	FS_UNKONWN_SENSOR					= 0xF5
end
