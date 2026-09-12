























#if defined PROFILER_PROFILER_INC
	#endinput
#endif
#define PROFILER_PROFILER_INC

enum ProfilerState {
  PROFILER_DISABLED,
  PROFILER_ATTACHING,
  PROFILER_ATTACHED,
  PROFILER_STARTING,
  PROFILER_STARTED,
  PROFILER_STOPPING,
  PROFILER_STOPPED
};

native ProfilerState:Profiler_GetState();
native Profiler_Start();
native Profiler_Stop();
native Profiler_Dump();
