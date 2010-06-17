module Constants

	# Server Status Codes
	STATUS_OK 								= 100
	STATUS_ERROR 							= 101
	STATUS_IS_LOCKED 					= 102
	STATUS_MUST_LOCK 					= 103
	STATUS_WRONG_ARGUMENTS 		= 104
	STATUS_UNKNOWN_COMMAND 		= 105
	STATUS_TIMEOUT 						= 106
	STATUS_VALIDATION_ERROR 	= 107
	STATUS_SERVER_UNLOCKED		= 108
	STATUS_UNKNOWN_SCRIPT			= 109

	# FS
	FS_MAX_DATA_SIZE 					= 1024
	FS_CMD_SIZE  							= 1
	FS_DIRECTION 							= 1
	FS_DATA_LENGTH_SIZE 			= 2

	# Packet header size
	FS_PACKET_HEADER_SIZE 		= FS_CMD_SIZE + FS_DIRECTION + FS_DATA_LENGTH_SIZE

	# Maximal packet size
	FS_MAX_PACKET_SIZE 				= FS_PACKET_HEADER_SIZE + FS_MAX_DATA_SIZE

	# Size of the SIB block
	FS_SIB_SIZE 							= 32

	# DIRECTION CODES
	FS_UP_LINK								= 0
	FS_DOWN_LINK 							= 255

	# Command Codes
	FS_RESET								= 1
	FS_EXECUTE							= 2
	FS_CALL_FUNCTION				= 3
	FS_SET_AUTORESET				= 4
	FS_UNLOCK_FLASH					= 5
	FS_COPY_TO_FLASH 				= 6
	FS_COPY_TO_RAM					= 7
	FS_UPLOAD								= 8
	FS_DOWNLOAD							= 9
	FS_CALCULATE_CHECK_SUM	= 10
	FS_DELETE_FLASH_BLOCK 	=	11
	FS_READ_REGISTER				= 12
	FS_WRITE_REGISTER				= 13
	FS_RAM_TEST							= 14
	FS_FLASH_TEST						= 15
	FS_DOWNLOAD_SIB					= 16
	FS_UPLOAD_SIB						= 17
	FS_RESET_SIB						= 18
	FS_HEALTH_STATUS				= 19
	FS_READ_SENSOR					= 20


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

	# Messages
	MESSAGES = {
		STATUS_OK 								=> "OK",
		STATUS_ERROR 							=> "Error",
		STATUS_IS_LOCKED 					=> "Server is locked",
		STATUS_MUST_LOCK 					=> "You must lock the server before executing commands",
		STATUS_WRONG_ARGUMENTS		=> "Wrong number of arguments",
		STATUS_UNKNOWN_COMMAND		=> "Unknown command",
		STATUS_TIMEOUT						=> "Timeout",
		STATUS_VALIDATION_ERROR		=> "Validation error",
		STATUS_SERVER_UNLOCKED		=> "Server has been unlocked",
		STATUS_UNKNOWN_SCRIPT			=> "Unknown script",

		FS_RESET								=> "ACK",
		FS_EXECUTE							=> "ACK",
		FS_CALL_FUNCTION				=> "ACK",
		FS_SET_AUTORESET				=> "ACK",
		FS_UNLOCK_FLASH					=> "ACK",
		FS_COPY_TO_FLASH 				=> "ACK",
		FS_COPY_TO_RAM					=> "ACK",
		FS_UPLOAD								=> "ACK",
		FS_DOWNLOAD							=> "ACK",
		FS_CALCULATE_CHECK_SUM	=> "ACK",
		FS_DELETE_FLASH_BLOCK 	=> "ACK",
		FS_READ_REGISTER				=> "ACK",
		FS_WRITE_REGISTER				=> "ACK",
		FS_RAM_TEST							=> "ACK",
		FS_FLASH_TEST						=> "ACK",
		FS_DOWNLOAD_SIB					=> "ACK",
		FS_UPLOAD_SIB						=> "ACK",
		FS_RESET_SIB						=> "ACK",
		FS_HEALTH_STATUS				=> "ACK",
		FS_READ_SENSOR					=> "ACK",

		FS_NO_ERROR 							=> "No error",
		FS_UNDEFINED_CMD 					=> "Undefined command",
		FS_RAM_ERROR 							=> "Ram error",
		FS_FLASH_WRITE_ERROR 			=> "Flash write error",
		FS_FLASH_DELETE_ERROR 		=> "Flash delete error",
		FS_PACKET_LENGTH_ERROR 		=> "Packet length error",
		FS_RAM_ADDRESS_ERROR 			=> "Ram address error",
		FS_FLASH_ADDRESS_ERROR 		=> "Flash address error",
		FS_FLASH_OPERATION_LOCKED => "Flash operation locked",
		FS_ADDRESS_ERROR 					=> "Address error",
		FS_UNKONWN_SENSOR 				=> "Unknown sensor"
	}
end
