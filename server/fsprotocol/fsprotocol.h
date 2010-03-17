/*
 * Filename:    protocol.h
 *
 * Description: XXX
 *
 * Based on:	cmd_handler.h,	comm.h, fs_cmds.h
 *
 * Author:      Jan Svoboda
 * Date: 		27/1/2010
 * Email:       jansvobodacz@gmail.com
 */

#ifndef protocol_h
#define protocol_h


/*
 * TODO:
 * 			DOWNLOAD????
 */

typedef char check_char_size[(sizeof(char) == 1) ? 1 : -1];
typedef char check_unsigned_char_size[(sizeof(unsigned char) == 1) ? 1 : -1];

typedef char check_short_size[(sizeof(short) == 2) ? 1 : -1];
typedef char check_unsigned_short_size[(sizeof(unsigned short) == 2) ? 1 : -1];

typedef char check_int_size[(sizeof(int) == 4) ? 1 : -1];
typedef char check_unsigned_int_size[(sizeof(unsigned int) == 4) ? 1 : -1];




/* -----------------CONSTANTS------------------------------ */

/* Max size of packet data (both up/down-link)
 NOT including frame header+packet header+checksum
 Must be at least 252 to hold sysinfo
 */

#define NUM_TEMP_SENSORS    5
#define NUM_FLASH_BLOCKS    32
#define NUM_DATA_MODULES    16

#define ENABLE				1
#define DISABLE				0

#define MAX_FS_DATA_SIZE 	1024   /* Must be at least 248 to hold sysinfo-block */
#define CMD_SIZE 			1          	/* The length of the cmd field in bytes */
#define ERROR_CODE_SIZE  	1  	// The length off the confirm/error_code_length
#define DATA_LENGTH_SIZE 	2  	// The length of the data_length field in bytes
#define FS_PACKET_HEADER_SIZE CMD_SIZE+ERROR_CODE_SIZE+DATA_LENGTH_SIZE
#define MAX_FS_PACKET_SIZE FS_PACKET_HEADER_SIZE+MAX_FS_DATA_SIZE

#define MAX_FS_FRAME_SIZE (FRAME_HEADER_SIZE+MAX_FS_PACKET_SIZE+FRAME_CHECKSUM_SIZE)

#define TRANSMITTED_SYSINFO_SIZE 252 // Size of a sysinfo block with flag but without crc

/* -----------------PACKAGE FORMAT------------------------- */

typedef struct {
	unsigned char cmd;
	//unsigned char code; // Confirm (uplink) or error (downlink) code??????
	unsigned short data_length; // Unsigned short, little endian
	union { // Make sure data field is aligned
		unsigned char byte[MAX_FS_DATA_SIZE];
		long align;
	} data;
} data_packet;

typedef char check_fs_packet_size[(sizeof(fs_packet) == MAX_FS_PACKET_SIZE) ? 1
		: -1];

/* ---------------COMMNAND CODES ------------------------- */

#define RESET                   1
#define EXECUTE                 2
#define CALL_FUNCTION          	3
#define ENABLE_AUTORESET		4

#define COPY_TO_FLASH           5
#define COPY_TO_RAM             5
#define UPLOAD                  7
#define DOWNLOAD                8
#define GET_CHECK_SUM           9
#define DELETE_FLASH_BLOCK     10

#define DOWNLOAD_SIP           11
#define UPLOAD_SIP             12

#define HELATH_STATUS          13
#define READ_SENSORS           14
#define RAM_TEST			   15

/* -----------------RETURN CODES-------------------------- */

#define NO_ERROR               16 // equivalent to ACK
#define UNDEFINED_CMD          17
#define RAM_ERROR              18
#define FLASH_WRITE_ERROR      19
#define FLASH_DELETE_ERROR     20

/* -----------------PACKET DATA FORMAT--------------------- */

/************************************************************/
/* -----------------TELECOMMANDS--------------------------- */
/************************************************************/

/*
 * Command: EXECUTE
 *
 * Definition of the execute command data format
 */
typedef struct {
	unsigned int addr;
} TC_execute;

typedef char check_cmd_exe_block_size[(sizeof(cmd_exe) == 4) ? 1 : -1];

/*
 * Command: CALL_FUNCTION
 *
 * Definition of the call-function command data format
 */
typedef struct {
	unsigned int addr;
	int arg;
} TC_call_function;

typedef char check_cmd_call_function_size[(sizeof(TC_call_function) == 8) ? 1
		: -1];

/*
 * Command: ENABLE_AUTORESET
 *
 * Definition of the enable/disable autoreset command data format
 */
typedef struct {
	unsigned char set_autoreset;
} TC_enable_autoreset;

typedef char
		check_TC_enable_autoreset_size[(sizeof(TC_enable_autoreset) == 8) ? 1
				: -1];

/*
 * Command: COPY_TO_RAM / COPY_TO_FLASH
 *
 * Definition of the copy_to_ram / copy_to_flash data format
 */
typedef struct {
	unsigned int from_address;
	unsigned int to_address;
//unsigned int length;		//not required
} TC_copy;

typedef char check_cmd_copy_block_size[(sizeof(TC_copy) == 12) ? 1 : -1];

/*
 * Command: UPLOAD
 *
 * Definition of the upload data format
 */
typedef struct {
	unsigned int  start_address;
	unsigned char data[MAX_FS_DATA_SIZE - sizeof(unsigned int)];
} TC_upload;

typedef char
		check_TC_upload_block_size[(sizeof(TC_upload) == MAX_FS_DATA_SIZE) ? 1 : -1];

/*
 * Command: DOWNLOAD
 *
 * Definition of the download data format
 */
typedef struct {
	unsigned int start_address;
	unsigned short length;
}__attribute__ ((packed)) TC_download;

typedef char
		check_TC_download_block_size[(sizeof(TC_download) == 6) ? 1 : -1];

/*
 * Command: CHECK_SUM
 *
 * Definition of the CHECK_SUM data format
 */
typedef struct {
	unsigned int start_address;
	unsigned int length;
} TC_check_sum;

typedef char check_TC_check_sum_block_size[(sizeof(TC_check_sum) == 8) ? 1 : -1];


/*
 * Command: DELETE_FLASH_BLOCK
 *
 * Definition of the DELETE_FLASH_BLOCK data format
 */
typedef struct {
	unsigned int delete_address;
} TC_delete_flash;

typedef char
		check_TC_delete_flash_block_size[(sizeof(TC_delete_flash) == 4) ? 1 : -1];

/*
 * Command: UPLOAD_SIP
 *
 * Definition of the upload sip command data format
 */
typedef struct {
	unsigned char sysinfo[TRANSMITTED_SYSINFO_SIZE];
} TC_upload_sip;

typedef char check_TC_upload_sip_block_size[(sizeof(cmd_upload_sysinfo)
		== TRANSMITTED_SYSINFO_SIZE) ? 1 : -1];


/*
 * Command: READ_SENSOR
 *
 * Definition of the read sensor data format
 */
#define READ_SENSORS_ADC    0
#define READ_SENSORS_TEMP   1

typedef struct {
	unsigned int type;
	union {
		unsigned char temp[8];
		struct {
			unsigned char cs;
			unsigned char channel;
		} adc;
	} device;
} TC_read_sensors;

typedef char check_cmd_read_sensors_size[(sizeof(TC_read_sensors) == 12) ? 1 : -1];

/*
 * Command: RAMTEST
 *
 * RAM_TEST telecomand
 */
typedef struct {
	unsigned int start_address;
	unsigned int length;
} TC_ramtest;

typedef char check_cmd_ramtest_block_size[(sizeof(cmd_ramtest) == 8) ? 1 : -1];

/************************************************************/
/* -----------------TELEMETRY------------------------------ */
/************************************************************/

/*
 * Command: CALL_FUNCTION
 *
 * Definition of the call-function return data format
 */
typedef struct {
	int retval;
} TM_call_function;

typedef char
		check_return_call_function_size[(sizeof(return_call_function) == 4) ? 1 : -1];



/*
 * Command: DOWNLOAD_SIP
 *
 * Definition of the get sysinfo command data format
 */
typedef struct {
	unsigned char sysinfo[TRANSMITTED_SYSINFO_SIZE];
} TM_download_sip;

typedef char check_return_get_sysinfo_block_size[(sizeof(TM_download_sip)
		== TRANSMITTED_SYSINFO_SIZE) ? 1 : -1];


/*
 * Command: CHECK_SUM
 *
 * Definition of the checksum return data format
 */
typedef struct {
	unsigned int cs;
} return_check_sum;

typedef char
		check_TM_check_sum_block_size[(sizeof(TM_check_sum) == 4) ? 1 : -1];


/*
 * Command: STATUS
 *
 * Definition of the get status return data format
 */
typedef struct {
	unsigned int sys;

	unsigned char bootcount; /* Count how many times we have rebooted 1 byte */
	unsigned char os_comm; /* the OS can communicate with the boot software
	 using this variable 1 byte */
	unsigned char err; /* Last error 1 byte */
	unsigned char sysinfo_block; /* The number of the current sysinfo block*/

	unsigned short int solar_current;
	unsigned short int batt_current;
	unsigned short int batt_voltage;
	unsigned short int unreg_voltage;
	unsigned short int reg_voltage;
	unsigned short int reg_current;

	short int temp[0];
} TM_status;

typedef char
		check_TM_status_block_size[(sizeof(TM_status) == 20) ? 1
				: -1];

/*
 * Command: DOWNLOAD_SIP
 *
 * Definition of the read-sensors return data format
 */
typedef struct {
	unsigned int value;
} TM_read_sensors;

typedef char check_TM_read_sensors_size[(sizeof(return_TM_sensors)
		== (sizeof(unsigned short) * 2)) ? 1 : -1];

/*
 * Command: RAMTEST
 *
 * RAM_TEST telemetry
 */
typedef struct {
	unsigned int failure; //The address where the ram-failure is
} TM_ramtest;

typedef char check_return_ramtest_block_size[(sizeof(return_ramtest) == 4) ? 1
		: -1];

#endif
