// тут подключаются инклуды по принципу api - #include "API/путь/название.inc"

 /* ПРИМЕР:
    // СИСТЕМА АДМИНКИ
   #include "API/admin/admin.inc"
#include "API/admin/cmd.inc"
  */

 //#define ENTER_ENGINE 1  // КОМАНДА /E  - УВЕДЫ ||||||||в джава

new string32[32];//это чтобы каждый раз не писать fmt_str или типо такого
new string64[64];
new string128[128];
new string256[256];
new string512[512];
new string1024[1024];//пон? да, понял

// УВЕДЫ, РАДИАЛКА
#include "API/system/java.inc"


// тестовое, для тестов
#include "API/system/test/test.inc"

// СИСТЕМА: ЗАГСА
#include "API/system/system_wedding.inc"

// СИСТЕМА ГОНОК
#include "API/system/system_race.inc"

// АДМИН СИСТЕМЫ
#include "API/admin/admin_cmd.inc"
#include "API/admin/system_mp.inc"
