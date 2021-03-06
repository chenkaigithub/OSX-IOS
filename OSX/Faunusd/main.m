// Copyright (c) 2012, Fuji Xerox Co., Ltd.
// All rights reserved.
// Author: Surendar Chandra, FX Palo Alto Laboratory, Inc.

#import "NameServer.h"
#import "WhiteBoard.h"

#include <unistd.h>

	// #define REDIS_SERVER "127.0.0.1"
	// #define REDIS_SERVER "192.168.25.158"	// "redis.xcloud.fxpal.net"
#define REDIS_SERVER "192.168.22.69"	// mac mini i7

#define REDIS_PORT 6379
#define REDIS_DB   6

int main(int argc, char * const argv[]) {
	int ch;
	char *server = REDIS_SERVER;
	int port = REDIS_PORT;
	int db = REDIS_DB;
	
	@autoreleasepool {
		
		while ((ch = getopt(argc, argv, "s:p:d:")) != -1) {
			switch (ch) {
				case 's':
					server = optarg;
					break;
				case 'p':
					port = atoi(optarg);
					if (port <= 0)
						port = REDIS_PORT;
					break;
				case 'd':
					db = atoi(optarg);
					if (db <= 0)
						db = REDIS_DB;
					break;
					
				case '?':
				default:
					fprintf(stderr, "USAGE: %s [-s <redis server>] [-p <redis port>] [-d <redis db>]", argv[0]);
					exit(0);
			}
		}
		
		NameServer *nameServer = [[NameServer alloc] initWithRedisServer:server andPort:port andDB:db];
		[nameServer start];

		WhiteBoard *whiteboardServer = [[WhiteBoard alloc] initWithNameServer:nameServer];
		[whiteboardServer start];
		
		[[NSRunLoop currentRunLoop] run];

		[nameServer release];
		[whiteboardServer release];
	}
    return 0;
}

