



















#if defined JIT_INC
	#endinput
#endif
#define JIT_INC




public const bool:__JIT = false;





forward OnJITCompile();





forward OnJITError();





stock bool:IsJITPresent() {
	#emit zero.pri
	#emit lctrl 7
	#emit retn
	return false;
}







stock bool:IsJITASMJumpCapable() {
	#emit lctrl 6
	#emit move.alt
	#emit lctrl 8
	#emit neq
	#emit retn
	return false;
}

