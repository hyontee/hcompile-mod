stock InteractionNPCButton1(playerid, bool:skiptext, render, name[], text[], speedtext, textb[], bid)
{
    new Node:JSONObject = JSON_Object();

    JSON_SetInt(JSONObject, "m", render);
    JSON_SetString(JSONObject, "n", name, strlen(name));
    JSON_SetString(JSONObject, "d", text, strlen(text));
    JSON_SetInt(JSONObject, "ts", speedtext);
    JSON_SetBool(JSONObject, "st", skiptext);

    new Node:buttons = JSON_Array(
        JSON_Object(
            "bn", JSON_String(textb),
            "bt", JSON_Int(0),
            "bk", JSON_Int(bid)
        )
    );

    JSON_SetArray(JSONObject, "b", buttons);

    ShowPlayerGUI(playerid, 63, JSONObject);

}

stock InteractionNPCButton2(playerid, bool:skiptext, render, name[], text[], speedtext, textb[], textb2[], bid, bid2)
{
    new Node:JSONObject = JSON_Object();

    JSON_SetInt(JSONObject, "m", render);
    JSON_SetString(JSONObject, "n", name, strlen(name));
    JSON_SetString(JSONObject, "d", text, strlen(text));
    JSON_SetInt(JSONObject, "ts", speedtext);
    JSON_SetBool(JSONObject, "st", skiptext);

    new Node:buttons = JSON_Array(
        JSON_Object(
            "bn", JSON_String(textb),
            "bt", JSON_Int(1),
            "bk", JSON_Int(bid)
        ),
        JSON_Object(
            "bn", JSON_String(textb2),
            "bt", JSON_Int(3),
            "bk", JSON_Int(bid2)
        )
    );

    JSON_SetArray(JSONObject, "b", buttons);

    ShowPlayerGUI(playerid, 63, JSONObject);

}

stock InteractionNPCButton3(playerid, bool:skiptext, render, name[], text[], speedtext, textb[], textb2[], textb3[], bid, bid2, bid3)
{
    new Node:JSONObject = JSON_Object();

    JSON_SetInt(JSONObject, "m", render);
    JSON_SetString(JSONObject, "n", name, strlen(name));
    JSON_SetString(JSONObject, "d", text, strlen(text));
    JSON_SetInt(JSONObject, "ts", speedtext);
    JSON_SetBool(JSONObject, "st", skiptext);

    new Node:buttons = JSON_Array(
        JSON_Object(
            "bn", JSON_String(textb),
            "bt", JSON_Int(1),
            "bk", JSON_Int(bid)
        ),
        JSON_Object(
            "bn", JSON_String(textb2),
            "bt", JSON_Int(2),
            "bk", JSON_Int(bid2)
        ),
        JSON_Object(
            "bn", JSON_String(textb3),
            "bt", JSON_Int(3),
            "bk", JSON_Int(bid3)
        )
    );

    JSON_SetArray(JSONObject, "b", buttons);

    ShowPlayerGUI(playerid, 63, JSONObject);

}

stock HandleInteractionNPCButton(playerid, Node:JSONObject)
{
    new click;
    JSON_GetInt(JSONObject, "bk", click);

    switch(click)
    {
            case 0:
            {
                HidePlayerGUI(playerid, 63);
            }
            case 1:
            {
                InteractionNPCButton1(playerid, true, 6881, "Даня", "Если ты нашел баг или у тебя есть идея по улучшению мода — пиши мне в <font color='#00BFFF'>Telegram: t.me/xhatw.</font><br> Всегда рад рассмотреть предложения и ответить.", 7, "Закрыть", 0);
            }
    }
    return 1;
}