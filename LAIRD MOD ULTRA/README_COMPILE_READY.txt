PAWNO COMPILE READY

This package is prepared for compiling gamemodes/shanyrak.pwn with the bundled Windows Pawn compiler.

Compiler command:
  pawno\compile_ready.bat

Output:
  gamemodes\shanyrak.amx
  logs\compile.log

Compiler-preparation changes:
- Added JSON include to the source because JSON_* natives/types are referenced.
- Added a compatibility declarations include for external runtime plugins referenced by the source.
- Added the missing cache_num_rows declaration.
- Added a Windows batch compiler wrapper that captures the real pawncc output and exit code.
- Preserved the existing server/license-checking code; no licensing bypass was performed.

Important:
The included compatibility declarations are compile-time declarations only. The corresponding runtime plugins are still required when the server runs.

Because this environment cannot execute the bundled Windows PE pawncc.exe, logs/compile.log is a pre-flight log until compile_ready.bat is run on Windows.
