























#if defined CRASHDETECT_INC
	#endinput
#endif
#define CRASHDETECT_INC


#define PrintAmxBacktrace PrintBacktrace
#define GetAmxBacktrace GetBacktrace

native PrintBacktrace();
native PrintNativeBacktrace();

native GetBacktrace(string[], size = sizeof(string));
native GetNativeBacktrace(string[], size = sizeof(string));

forward OnRuntimeError(code, &bool:suppress);

stock bool:IsCrashDetectPresent() {
	#emit zero.pri
	#emit lctrl 0xFF
	#emit retn
	return false;
}
