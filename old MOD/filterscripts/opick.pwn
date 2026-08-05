#include <a_samp>
#include "../include/Pawn.RakNet.inc" // Новая версия плагина
#include "../include/Pawn.CMD.inc" // Новая версия плагина
#include "../include/sscanf2.inc" // Новая версия плагина


CMD:gui_open(playerid, params[])
{
   
    return 1;
}


// // String[] split = new String(nicks, "windows-1251").split(Pattern.quote("|"));
//             final JSONObject jSONObject = new JSONObject();
//             JSONArray jSONArray = new JSONArray();
//             if (event == 0) {
//                 jSONObject.put("o", 1);
//             }
//             jSONObject.put("t", event);
//             for (int i = 0; i < ids.length; i++) {
//                 JSONObject jSONObject2 = new JSONObject();
//                 jSONObject2.put(GetKeys.GET_PLAYERS_ID, ids[i]);
//                 jSONObject2.put("nick", split[i]);
//                 jSONObject2.put("level", level[i]);
//                 jSONObject2.put("ping", ping[i]);
//                 jSONArray.put(jSONObject2); 