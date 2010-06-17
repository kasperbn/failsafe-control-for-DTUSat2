/*
 * Filename:    fs_commands.h  (prev. protocol.h)
 *
 * Description: This file provide the communication interface between ground
 * 				station and the satellite in the fail-safe mode
 *
 * Based on:	cmd_handler.h,	comm.h, fs_cmds.h
 *
 * Author:      Jan Svoboda
 * Date: 		27/3/2010
 * Email:       jansvobodacz@gmail.com
 * Updates:     Hans Henrik Loevengreen
 *
 * TODO:
 * 		- Modify the the health status structure so it corresponds to
 * 		  the actual sensors connected to OBC
 */

#ifndef fs_commands_h
#define fs_commands_h

/* -----------------CONSTANTS------------------------------ */
/* Max size of packet data (both up/down-link) NOT including
 * frame header+checksum
 */
#define FS_MAX_DATA_SIZE 		1024
#define FS_CMD_SIZE 			1
#define FS_DIRECTION 			1
#define FS_DATA_LENGTH_SIZE 	2

/* Packet header size */
#define FS_PACKET_HEADER_SIZE FS_CMD_SIZE + FS_DIRECTION + FS_DATA_LENGTH_SIZE

/* Maximal packet size */
#define FS_MAX_PACKET_SIZE FS_PACKET_HEADER_SIZE + FS_MAX_DATA_SIZE

/* Size of the SIB block*/
#define FS_SIB_SIZE 			32

/* ---------------DIRECTION CODES ------------------------ */
#define FS_UP_LINK          	0
#define FS_DOWN_LINK           	255


/* -----------------PACKAGE FORMAT------------------------- */
typedef struct {
	unsigned char cmd;
	unsigned char direction;
	unsigned short data_length;
	union {
		unsigned char byte[FS_MAX_DATA_SIZE];
		int align;				/* Make sure data field is aligned */
	} data;
} data_packet;

typedef char check_data_packet_size[(sizeof(data_packet) == FS_MAX_PACKET_SIZE) ? 1: -1];


/* ---------------COMMNAND CODES ------------------------- */

#define FS_RESET                   	1
#define FS_EXECUTE                 	2
#define FS_CALL_FUNCTION          	3
#define FS_SET_AUTORESET			4
#define FS_UNLOCK_FLASH 			5

#define FS_COPY_TO_FLASH           	6
#define FS_COPY_TO_RAM             	7
#define FS_UPLOAD                  	8
#define FS_DOWNLOAD                	9
#define FS_CALCULATE_CHECK_SUM     	10
#define FS_DELETE_FLASH_BLOCK     	11
#define FS_READ_REGISTER	       	12
#define FS_WRITE_REGISTER	     	13
#define FS_RAM_TEST			   		14
#define FS_FLASH_TEST			   	15

#define FS_DOWNLOAD_SIB           	16
#define FS_UPLOAD_SIB             	17
#define FS_RESET_SIB				18

#define FS_HEALTH_STATUS          	19
#define FS_READ_SENSOR           	20


/* -----------------SENSOR CODES-------------------------- */
#define FS_OLIMEX_POTENTIOMETER	1



/* -----------------RETURN CODES-------------------------- */
#define FS_NO_ERROR              	0xFF
#define FS_UNDEFINED_CMD          	0xFE
#define FS_RAM_ERROR              	0xFD
#define FS_FLASH_WRITE_ERROR        0xFC
#define FS_FLASH_DELETE_ERROR    	0xFB
#define FS_PACKET_LENGTH_ERROR		0xFA
#define FS_RAM_ADDRESS_ERROR		0xF9
#define FS_FLASH_ADDRESS_ERROR		0xF8
#define FS_FLASH_OPERATION_LOCKED	0xF7
#define FS_ADDRESS_ERROR			0xF6
#define FS_UNKONWN_SENSOR			0xF5

/* -----------------PACKET DATA FORMAT--------------------- */

/************************************************************/
/* -----------------TELECOMMANDS--------------------------- */
/************************************************************/
/*
 * Provide structures are used to handle the commands
 */

/* Command: EXECUTE */
typedef struct {
	unsigned int address;
} TC_execute;

typedef char check_cmd_exe_block_size[(sizeof(TC_execute) == 4) ? 1 : -1];


/* Command: CALL_FUNCTION */
typedef struct {
	unsigned int address;
	int argument;
} TC_call_function;

typedef char check_TC_call_function_size[(sizeof(TC_call_function) == 8) ? 1: -1];


/* Command: SET_AUTORESET */
typedef struct {
	unsigned char set_autoreset;
} TC_set_autoreset;

typedef char check_TC_set_autoreset_size[(sizeof(TC_set_autoreset) == 1) ? 1: -1];


/* Command: COPY_TO_RAM / COPY_TO_FLASH */
typedef struct {
	unsigned int from_address;
	unsigned int to_address;
	unsigned int length;
} TC_copy;

typedef char check_TC_copy_block_size[(sizeof(TC_copy) == 12) ? 1 : -1];


/* Command: UPLOAD */
typedef struct {
	unsigned int  start_address;
	unsigned char data[FS_MAX_DATA_SIZE - sizeof(unsigned int)];
} TC_upload;

typedef char
		check_TC_upload_block_size[(sizeof(TC_upload) == FS_MAX_DATA_SIZE) ? 1 : -1];


/* Command: DOWNLOAD */
typedef struct {
	unsigned int start_address;
	unsigned int length;
}TC_download;

typedef char
		check_TC_download_block_size[(sizeof(TC_download) == 8) ? 1 : -1];


/* Command: CALCULATE_CHECK_SUM */
typedef struct {
	unsigned int start_address;
	unsigned int length;
} TC_calculate_check_sum;

typedef char check_TC_calculate_heck_sum_block_size[(sizeof(TC_calculate_check_sum) == 8) ? 1 : -1];


/* Command: DELETE_FLASH_BLOCK*/
typedef struct {
	unsigned int delete_address;
} TC_delete_flash;

typedef char
		check_TC_delete_flash_block_size[(sizeof(TC_delete_flash) == 4) ? 1 : -1];



/* Command: READ_REGISTER */
typedef struct {
	unsigned int address;
} TC_read_register;

typedef char
		check_TC_read_register_size[(sizeof(TC_read_register) == 4) ? 1 : -1];


/* Command: WRITE_REGISTER */
typedef struct {
	unsigned int address;
	unsigned int data;
} TC_write_register;

typedef char
		check_TC_write_register_size[(sizeof(TC_write_register) == 8) ? 1 : -1];


/* Command: RAM_TEST */
typedef struct {
	unsigned int start_address;
	unsigned int length;
} TC_RAM_test;

typedef char check_cmd_RAM_test_block_size[(sizeof(TC_RAM_test) == 8) ? 1 : -1];


/* Command: FLASH_TEST */
typedef struct {
	unsigned int block_address;
} TC_FLASH_test;

typedef char check_cmd_FLASH_test_block_size[(sizeof(TC_FLASH_test) == 4) ? 1 : -1];


/* Command: UPLOAD_SIB */
typedef struct {
	unsigned char sib[FS_SIB_SIZE-4];
} TC_upload_sib;

typedef char check_TC_upload_sib_block_size[(sizeof(TC_upload_sib)+4 == FS_SIB_SIZE) ? 1 : -1];


/* Command: READ_SENSOR */
typedef struct {
	unsigned char senzor_code;
} TC_read_sensor;

typedef char check_cmd_read_sensor_size[(sizeof(TC_read_sensor) == 1) ? 1 : -1];


/************************************************************/
/* -----------------TELEMETRY------------------------------ */
/************************************************************/
/*
 * Provide structures are used to handle the response on the
 * commands
 */

/* Command: CALL_FUNCTION */
typedef struct {
	int return_value;
} TM_call_function;

typedef char check_return_call_function_size[(sizeof(TM_call_function) == 4) ? 1 : -1];


/* Command: DOWNLOAD */
typedef struct {
	unsigned char data[FS_MAX_DATA_SIZE];
} TM_download;

typedef char
		check_TM_download_block_size[(sizeof(TM_download) == FS_MAX_DATA_SIZE) ? 1 : -1];


/* Command: CALCULATE_CHECK_SUM */
typedef struct {
	unsigned int check_sum;
} TM_check_sum;

typedef char check_TM_check_sum_block_size[(sizeof(TM_check_sum) == 4) ? 1 : -1];


/* Command: READ_REGISTER */
typedef struct {
	unsigned int data;
} TM_read_register;

typedef char
		check_TM_read_register_size[(sizeof(TM_read_register) == 4) ? 1 : -1];


/* Command: RAM/FLASH_TEST */
typedef struct {
	unsigned int address_of_failure;
} TM_memory_test;

typedef char check_return_memory_test_block_size[(sizeof(TM_memory_test) == 4) ? 1: -1];



/* Command: DOWNLOAD_SIB */
typedef struct {
	unsigned char sysinfo[FS_SIB_SIZE];
} TM_download_sib;

typedef char check_return_download_sib_block_size[(sizeof(TM_download_sib) == FS_SIB_SIZE) ? 1 : -1];


/**********************************************************************************/
/**********************************************************************************/
/**********************************************************************************/
/* TODO: Modifie this so it corresponds to avaiable sensors						  */
/* Command: STATUS*/
typedef struct {
	unsigned char auto_reset_status;
	unsigned char boot_count;
	unsigned char fs_error;
	unsigned char number_of_sibs;

	/* Sensors readings */
	unsigned short solar_current;
	unsigned short batt_current;
	unsigned short batt_voltage;
	unsigned short unreg_voltage;
	unsigned short reg_voltage;
	unsigned short reg_current;
} TM_status;

typedef char
		check_TM_status_block_size[(sizeof(TM_status) == 16) ? 1: -1];
/**********************************************************************************/
/**********************************************************************************/
/**********************************************************************************/


/* Command: READ_SENSOR */
typedef struct {
	unsigned int value;
} TM_read_sensor;

typedef char check_TM_read_sensor_size[(sizeof(TM_read_sensor) == 4) ? 1 : -1];


#endif /* fs_commands_h */
