#include "logging.h"
#include "serial_ports.h"

#include <signal.h>
#include <stdlib.h>
#include <string.h>

int fd;

void signal_handler(int signum)
{
	close_port(fd);
	exit(0);
}

#define BUFFER_SIZE 2048
unsigned char buffer[BUFFER_SIZE];
static int msg_len = 0;

int main(int argc, char** argv)
{
        // create signal handler
	if (signal(SIGINT, signal_handler) == SIG_ERR) {
		puts("Failed to create signal handler");
		return 1;
	}

	// open serial port
	fd = open_port("/dev/ttyTHS1", 115200, "8N1", 0);

	if (fd == 1) {
		puts("failed to open port");
		return 1;
	}

	for (;;) {
		int err = read_port(fd, buffer, BUFFER_SIZE);

		if (err == -1) {
			puts("failed read");
			close_port(fd);
			return 0;
		} else if (err > 0) {
			msg_len += err;
		}
		printf("%s\n", buffer);
	}
}
