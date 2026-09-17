BLACK-RUSSIA FULL INTEGRATION

Main source:
gamemodes/black-russia.pwn

Integrated includes:
include/system/garages.pwn
include/system/sto.inc

Required garage instruction applied:
#define USE_ZOMENO_OLD_ENGINE 1
P_IN_GARAGE,
P_GARAGE,

black-russia.pwn explicitly includes:
#include "../include/system/garages.pwn"
#include "../include/system/sto.inc"

The original pre-integration AMX is kept as:
gamemodes/black-russia.original.amx

Compile the modified PWN before replacing the server AMX.
