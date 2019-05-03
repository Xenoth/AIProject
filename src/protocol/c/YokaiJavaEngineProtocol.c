#include <stdint.h>
#include <netinet/in.h>
#include "YokaiJavaEngineProtocol.h"

int32_t intToInt32bJava(const int something)
{
    int32_t res = (int32_t)htonl(something);
    return res;
}

int byteArrayJavaToIntC(const char *buff)
{
    int res = (buff[3] << 24 | buff[2] << 16 | buff[1] << 8 | buff[0]);
    return res;
}