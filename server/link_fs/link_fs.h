/*******************************************************************
 *
 * link_fs.h
 *
 * DTUsat: Ground side interface to link layer of failsafe protocol
 *
 * Author:
 *    Hans Henrik Løvengreen
 *
 *******************************************************************/

#ifndef _link_fs_h_
#define _link_fs_h_

//#include "protocol/pro_common.h"

/* link_init initilizes the datalink protocol layer.
   Parameters:
     rw            string with an 'r' for read, and 'w' for write
   Returns:
     PRO_OK        Initialization successfull
     PRO_FAILURE   Could not intialize
*/
extern int link_fs_init(char *rw);


/* link_fs_send_packet sends an AX.25 packet (headers and checksum will be added)
   Parameters:
     data          Address of packet data area
     length        Length of packet (must be <= PRO_MAX_FS_DATA_SIZE)
     timeout       Timeout value in 1/100 seconds
   Returns:
     PRO_OK        The packet was successfully sent
     PRO_FAILURE   Otherwise
*/
extern int link_fs_send_packet(unsigned char *data, unsigned int len);

/* link_fs_receive_packet   receives an AX.25 packet
                            (without header and checkesum)
   Parameters:
     buffer        Address of buffer area to receive packet
     length        Length of packet (must be >= PRO_MAX_FS_DATA_SIZE)
     timeout       Timeout value in 1/100 seconds
   Returns:
     result > 0    Length of successfully received packet
     PRO_TIMEOUT   No packet received within timeout period
     PRO_NOT_FAILSAFE
                   Packet recieved, but other station not in failsafe mode
*/
extern int link_fs_receive_packet(unsigned char *buffer,
				  unsigned int maxlen,
				  unsigned int timeout);


/* Close failsafe link */
extern void link_fs_close(void);

#endif
