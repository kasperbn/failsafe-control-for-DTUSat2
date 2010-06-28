#include "link_fs.h"

int link_fs_init(char *rw) {
	printf("Init called\n");
}

int link_fs_send_packet(unsigned char *data, unsigned int len) {
	printf("fs_send_packet\n");
}

int link_fs_receive_packet(unsigned char *buffer,
				  unsigned int maxlen,
				  unsigned int timeout) {
	printf("fs_receive_packet\n");
}

void link_fs_close(void) {
	printf("fs_close\n");
}
