#ifndef TP1_DEFINITIONS_H
#define TP1_DEFINITIONS_H

#define SOCKET_ERROR (-1)
#define closeSocket(s) close(s)
#define shutdownSocket(s) shutdown(s, SHUT_RDWR)

typedef int SOCKET;
typedef struct sockaddr_in SOCKADDR_IN;
typedef struct sockaddr SOCKADDR;

#endif
