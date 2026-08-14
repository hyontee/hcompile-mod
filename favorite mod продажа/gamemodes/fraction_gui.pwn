#if defined _fraction_gui_included
    #endinput
#endif
#define _fraction_gui_included

CMD:fraction(playerid, params[])
{
    new teamid = GetPlayerTeamEx(playerid);

    if(teamid == TEAM_NONE)
    {
        SendClientMessage(playerid, -1, "Вы не состоите во фракции.");
        return 1;
    }

    new playerRank = GetPlayerData(playerid, P_JOB);
    
    if(!(1 <= playerRank <= 10))
        playerRank = 1;

    new Node:json = JSON_Object();
    JSON_SetInt(json, "page", 1); // меню
    JSON_SetInt(json, "fraction_id", teamid);

    JSON_SetInt(json, "fraction_tokens", 1000);
    JSON_SetInt(json, "fraction_add_tokens_price", 50);
    
    //дебаг из-за бага с токеном крч нпдп проверить вообще есть ли они
    printf("=================");
    printf("fraction_tokens=%d", 1000);
    printf("=================");
    //

    new st[10], pr[10];
    for(new i = 0; i < 10; i++)
    {
        new rank = i + 1;

        if(rank < playerRank) st[i] = 4;        // получена
        else if(rank == playerRank) st[i] = 1;  // мой
        else if(rank == playerRank + 1) st[i] = 2; // следущая
        else st[i] = 0;                          // недоступно

        pr[i] = (rank < playerRank) ? 25 : (rank == playerRank ? 5 : 0); // прогресс
    }

    new Node:s1 = JSON_Int(st[0]); new Node:s2 = JSON_Int(st[1]); new Node:s3 = JSON_Int(st[2]); new Node:s4 = JSON_Int(st[3]); new Node:s5 = JSON_Int(st[4]);
    new Node:s6 = JSON_Int(st[5]); new Node:s7 = JSON_Int(st[6]); new Node:s8 = JSON_Int(st[7]); new Node:s9 = JSON_Int(st[8]); new Node:s10 = JSON_Int(st[9]);
    new Node:rank_status = JSON_Array(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10);
    JSON_SetArray(json, "rank_status", rank_status);

    new Node:p1 = JSON_Int(pr[0]); new Node:p2 = JSON_Int(pr[1]); new Node:p3 = JSON_Int(pr[2]); new Node:p4 = JSON_Int(pr[3]); new Node:p5 = JSON_Int(pr[4]);
    new Node:p6 = JSON_Int(pr[5]); new Node:p7 = JSON_Int(pr[6]); new Node:p8 = JSON_Int(pr[7]); new Node:p9 = JSON_Int(pr[8]); new Node:p10 = JSON_Int(pr[9]);
    new Node:rank_progress = JSON_Array(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
    JSON_SetArray(json, "rank_progress", rank_progress);

    ShowPlayerGUI(playerid, 46, json);
    JSON_Cleanup(json);
    JSON_Cleanup(rank_status);
    JSON_Cleanup(rank_progress);
    JSON_Cleanup(s1); JSON_Cleanup(s2); JSON_Cleanup(s3); JSON_Cleanup(s4); JSON_Cleanup(s5); JSON_Cleanup(s6); JSON_Cleanup(s7); JSON_Cleanup(s8); JSON_Cleanup(s9); JSON_Cleanup(s10);
    JSON_Cleanup(p1); JSON_Cleanup(p2); JSON_Cleanup(p3); JSON_Cleanup(p4); JSON_Cleanup(p5); JSON_Cleanup(p6); JSON_Cleanup(p7); JSON_Cleanup(p8); JSON_Cleanup(p9); JSON_Cleanup(p10);

    return 1;
}
