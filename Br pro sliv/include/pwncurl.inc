#if defined _pwncurl_included
    #endinput
#endif
#define _pwncurl_included

// pwncurl 0.1 by DracoBlue.
// Performs a synchronous GET request and writes the response body to result.
native pwncurl_get(const uri[], result[], resultsize);
