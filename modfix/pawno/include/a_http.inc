 /*  SA-MP threaded HTTP/1.0 client for pawn
 *
 *  (c) Copyright 2010, SA-MP Team
 *
 */


#define HTTP_GET						1
#define HTTP_POST						2
#define HTTP_HEAD						3




#define HTTP_ERROR_BAD_HOST				1
#define HTTP_ERROR_NO_SOCKET			2
#define HTTP_ERROR_CANT_CONNECT			3
#define HTTP_ERROR_CANT_WRITE			4
#define HTTP_ERROR_CONTENT_TOO_BIG		5
#define HTTP_ERROR_MALFORMED_RESPONSE	6

native HTTP(index, type, url[], data[], callback[]);

