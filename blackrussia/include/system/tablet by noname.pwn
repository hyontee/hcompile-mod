//1Строка
CMD:tablet(playerid)
{
    new Node:tablet_json = JSON_Object();

    JSON_SetInt(tablet_json, "a", 1);

    new Node:ac_array = JSON_Array(
        JSON_Object("id", JSON_Int(17)),
        JSON_Object("id", JSON_Int(24))
    );
    JSON_SetArray(tablet_json, "ac", ac_array);

    new  exp = GetPlayerExp(playerid);
    new  lvl = GetPlayerLevel(playerid);
    new exps = GetExpToNextLevel(playerid);
  
    new Node:d_obj = JSON_Object();
    JSON_SetInt(d_obj, "ar", 3);
    JSON_SetInt(d_obj, "av", 9);
    JSON_SetInt(d_obj, "bg", 2);
    JSON_SetInt(d_obj, "exm", exp);
    JSON_SetInt(d_obj, "exp", exps);
    JSON_SetString(d_obj, "fn", "Отсутствует");
    JSON_SetInt(d_obj, "lv", lvl);
    JSON_SetInt(d_obj, "v", 0);
    JSON_SetObject(tablet_json, "d", d_obj);

    JSON_SetInt(tablet_json, "i", 1);

    new Node:n_array = JSON_Array();
    JSON_SetArray(tablet_json, "n", n_array);

    JSON_SetInt(tablet_json, "o", 1);

    SendPacketToClient(playerid, 113, tablet_json);

    JSON_Cleanup(tablet_json);
    return 1;
}

//2сторка
stock SendTabletInfoList113(playerid) 
{
    new Node:list = JSON_Array(
        JSON_Object(
            "id",  JSON_Int(1),
            "nm",  JSON_String(""),
            "nn",  JSON_String(""),
            "dsc", JSON_String(""),
            "tm",  JSON_Object(
                "dt", JSON_String(""),
                "h",  JSON_Int(14),
                "m",  JSON_Int(40)
            )
        ),
        JSON_Object(
            "id",  JSON_Int(2),
            "nm",  JSON_String(""),
            "nn",  JSON_String(""),
            "dsc", JSON_String(""),
            "tm",  JSON_Object(
                "dt", JSON_String(""),
                "h",  JSON_Int(14),
                "m",  JSON_Int(25)
            )
        )
    );

    new Node:json = JSON_Object(
        "a", JSON_Int(APPLET_INFO),
        "o", JSON_Int(1),
        "d", list
    );

    SendPacketToClient(playerid, 113, json);
    JSON_Cleanup(json);
}