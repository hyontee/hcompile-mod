
// === Добавлено для исправления ошибки undefined symbol "GetPlayerAdminPost" ===

enum e_AdminPost
{
    Post_Name[64],
    Post_Level
};

new post_admin[][e_AdminPost] =
{
    { "Модератор", 1 },
    { "Администратор", 2 },
    { "Главный Админ", 3 },
    { "Разработчик", 4 }
};

stock GetPlayerAdminLevel(playerid)
{
    // ВРЕМЕННАЯ ЗАГЛУШКА: замените на вашу реальную систему определения уровня админа
    return 1; // всегда возвращает уровень 1 (модератор)
}

stock GetPlayerAdminPost(playerid)
{
    new level = GetPlayerAdminLevel(playerid);
    switch(level)
    {
        case 1: return 0; // Модератор
        case 2: return 1; // Админ
        case 3: return 2; // ГА
        case 4: return 3; // Разработчик
        default: return -1;
    }
}

// === Конец добавленного фикса ===



//   (    )
SortDescending(array[], size = sizeof(array), array1[])
{
    new temp;
    for(new i = 0; i < size; i++)
    {
        for(new j = i + 1; j < size; j++)
        {
            if(array[i] < array[j]) //    ,  
            {
                temp = array[i];
                array[i] = array[j];
                array[j] = temp;

                temp = array1[i];
                array1[i] = array1[j];
                array1[j] = temp;
            }
        }
    }
}


#define BR   "{FF6347}"

new spisok[45] = 
{
    38, 39, 0, 40, 41, 1, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 2, 19, 18, 20, 3, 16, 15, 17, 21, 4,
    24, 42, 29, 25, 26, 30, 31, 32, 22, 23, 43, 44, 27, 28, 34, 35, 36, 50
};



cmd:admins(playerid)
{
	new player_admins[24] = {-1, ...}, lvl_post[24] = {-1, ...}, masiv;

	foreach(Player, i)
	{
        if(!GetPlayerAdminEx(i)) continue;

		if(player_admins[23] == -1)
        {
            if(player_admins[masiv] == -1) 
            {
                player_admins[masiv] = i;
                lvl_post[masiv] = GetPlayerAdminPost(i);
                masiv++;
            }
        }
        else break;
	}

    for(new i; i < sizeof(player_admins); i++)
    {
        if(player_admins[i] == -1) break;
        for(new s;s < sizeof spisok;s++) if(spisok[s] == lvl_post[i]) lvl_post[i] = s;
    }

    printf(" :");
    for(new i = 0; i < sizeof(lvl_post); i++)
    {
        printf("%d", lvl_post[i]);
    }
    
    SortDescending(lvl_post, sizeof lvl_post, player_admins);

    new text[184], dialog[sizeof text*10+50] = ""BR"\t"BR"\t"BR"\n";

    
    new c;
    for(new i;i < sizeof player_admins;i ++)
    {
        if(player_admins[i] == -1) continue;
        c++;

        format(text, sizeof text, ""BR"%d.{FFFFFF} %s\t{FFFFFF}%s\t{129700} \n",
        c, GetPlayerNameEx(player_admins[i]), post_admin[GetPlayerAdminPost(player_admins[i])][Post_Name]);
        strcat(dialog, text);
    }

    if(!c) return SendClientMessage(playerid, -1, "()    .");

    printf("\n  ( ):");
    for(new i = 0; i < sizeof(lvl_post); i++)
    {
        printf("%d", lvl_post[i]);
    }

    DialogFix(playerid, -1, DIALOG_STYLE_TABLIST_HEADERS, ""BR"  ", dialog, "", "");
    return 1;
}

CMD:leaders(playerid)
{
    new text[174], dialog[sizeof text*10+35] = "{FFFFFF}\t{FFFFFF}\t{FFFFFF}\t{FFFFFF}\n";

    new c;
    foreach(new i : Player)
    {
		if(!IsPlayerConnected(i)) continue;
		else if(!IsPlayerLogged(i)) continue;
		else if(!GetPlayerTeamEx(i)) continue;
		else if(GetPlayerJob(i) != 10) continue;
        c++;

        format(text, sizeof text, "{FFFFFF}%s\t{FFFFFF}%s\t{FFFFFF}%s[%d]\t{FFFFFF}%d\n",
        GetTeamName(GetPlayerTeamEx(i)), GetPlayerJobAndRankName(i), GetPlayerNameEx(i), i, GetPlayerPhone(i));
        strcat(dialog, text);
    }

    if(!c) return SendClientMessage(playerid, -1, "   .");

    DialogFix(playerid, -1, DIALOG_STYLE_TABLIST_HEADERS, "{FD0000} ", dialog, "", "");
    return 1;
}

stock DialogFix(playerid, dialogid, style, title[], text[], button[], button2[])
{
  if(style == 5)
  {
     ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, "...", "...", "...", ""); 
  }
  ShowPlayerDialog(playerid, dialogid, style, title, text, button, button2);
  return 1;
}

extern g_organization[][OrganizationData];
{
    OrgName[64],
    OrgType
};

