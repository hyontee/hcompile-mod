//ובכאם נן

//28





stock ShowFrac(playerid)
{
    // new shlapa[200];
    new Node:json = JSON_Object(), rang = 1, rangname[] = "Test", number = 9999, acc_id = 88, fcaction_token = 998, level = 1; 

    // JSON_SetInt(json, "account_id", acc_id);
    // JSON_SetInt(json, "rank", rang);
    // JSON_SetString(json, "rank_name", rangname);
    // JSON_SetInt(json, "phone", number);
    // JSON_SetInt(json, "bc_value", fcaction_token); 
    // JSON_SetInt(json, "level", level);
    // JSON_Stringify(Node:node, buf[], len = sizeof(buf)
    // JSON_Stringify(json, shlapa);
    JSON_SetInt(json, "i", 1); 
    ShowPlayerGUI(playerid, 46, json);

    // ShowGui

    //String FRACTION_ADD_TOKENS_BC_VALUE = "bc_value";
    //public static final String FRACTION_ADD_TOKENS_PRICE = "token_price";
   // public static final String FRACTION_ADD_TOKENS_TOKEN_AMOUNT = "token_amount";

    //account_id

    // JSON_SetString(json, "p", rangname);

    //phone

    


}

// CMD:gui(playerid, params[]) 
// {
//     // extract params -> new type, s; else return SendClientMessage(playerid, -1, "/gui [t = type] [s = xz]");
//     new Node:json = JSON_GetObject(); 

//     JSON_SetInt(json, "t", 28); 
//     // JSON_SetString(json, "s", "1"); 
//     JSON_SetInt(json, "s", 1); 
//     // JSON_SetInt(json, "m", 1000);
//     // JSON_
//     ShowPlayerGUI(playerid, GUITuning, json); 
//     return printf("ShowGuiTuning(playerid -> %s)", json); 
    
// }


// return ShowGuiTuning(playerid);



//  int optInt = json.optInt("t");
//         int optInt2 = json.optInt("s");
stock ShowGuiTuning(playerid, testid = -1, testid2 = -1)
{
     new Node:json = JSON_GetObject(); 

    JSON_SetInt(json, "t", testid); 
    // JSON_SetString(json, "s", "1"); 
    JSON_SetInt(json, "s", testid2); 
    // JSON_SetInt(json, "m", 1000);
    
    ShowPlayerGUI(playerid, 28, json);
    printf("json: %s", json);
    return 1; 

}



//JSON_SetInt(json, "o", 1);
	OnPacketIncoming251(playerid, guiid, json);





CMD:gui_test(playerid, params[])
{
    // if(!isnull(params)) return SendClientMessage(playerid, -1, "/gui_test [id] [id2]"); 
    extract params -> new id, id2; 
    ShowGuiTuning(playerid, id, id2);
    
    // ShowGuiTuning(testid,)

}

CMD:frac(playerid) return ShowFrac(playerid);


