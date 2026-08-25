prod. by. kmonarch
//kmonarch @tg_kmonarch @lilmorphe| @werixtonstudio

//================= В ВАШ ipacket

OFFER_HEAL 

case OFFER_HEAL:
                    {
                        callcmd::mheal(playerid);
                        return 1;
                    }


new PlayerText:healingTextDraw[MAX_PLAYERS];
new healingPlayer[MAX_PLAYERS];
new healingTimer[MAX_PLAYERS];
new currentBedId[MAX_PLAYERS] = {-1, ...};
new Text3D:bedLabel[5];
new Float:bedCoords[5][3] =
{
    {1487.048095, 2496.719238, 2501.641113},
    {1486.824340, 2492.791992, 2501.641113},
    {1482.889892, 2492.481445, 2501.641113},
    {1482.538940, 2496.288574, 2501.641113},
    {0.0, 0.0, 0.0}
    // сюда все палаты
    // встаете на палату и вашу команду для показа координат
};



public OnGameModeInit()
{
    SetTimer("CheckPlayersNearBeds", 1000, 1);
    for(new i = 0; i < 5; i++)
    {
        new text[512];
        format(text, sizeof(text),
             "{FFFF00}« Свободная больничная койка »\n\n\
              {00FF00}| {FFFFFF}Номер койки: {FFFF00}%d\n\
              {00FF00}| {FFFFFF}Пациент: {FFFF00}отсутствует\n\n\
              {AAAAAA}Подойдите ближе для взаимодействия \n с больничной койкой",
              i + 1
        );
        bedLabel[i] = CreateDynamic3DTextLabel(
            text,
            0xFFFFFFFF,
            bedCoords[i][0], bedCoords[i][1], bedCoords[i][2],
            3.0,
            .testlos = 1,
            .streamdistance = 5.0
        );
    }
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        healingTextDraw[i] = PlayerText:INVALID_TEXT_DRAW;
        currentBedId[i] = -1;
        healingPlayer[i] = 0;
        healingTimer[i] = 0;
    }
}








public OnPlayerSpawn(playerid)
{
    if(healingPlayer[playerid])
    {
        StopHealing(playerid);

        new bedId = currentBedId[playerid];
        if(bedId != -1)
        {
            FreeBed(bedId);
            currentBedId[playerid] = -1;
        }
    }
}



public OnPlayerDisconnect(playerid, reason)
{
    StopHealing(playerid);
    new bedId = currentBedId[playerid];
    if(bedId != -1)
    {
        FreeBed(bedId);
        currentBedId[playerid] = -1;
    }
    if(healingTextDraw[playerid] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawDestroy(playerid, healingTextDraw[playerid]);
        healingTextDraw[playerid] = PlayerText:INVALID_TEXT_DRAW;
    }
 }
 




stock TakeBed(bedId, playerid)
{
    new text[512];
    format(text, sizeof(text),
        "{FFFF00}« Занятая больничная койка »\n\n\
        {00FF00}| {FFFFFF}Номер койки: {FFFF00}%d\n\
        {00FF00}| {FFFFFF}Пациент: {FFFF00}%s\n\n\
        {AAAAAA}Подойдите ближе для взаимодействия \n с больничной койкой",
        bedId + 1, GetPlayerNameEx(playerid)
    );

    UpdateDynamic3DTextLabelText(bedLabel[bedId], 0xFFFFFFFF, text);
    return 1;
}
stock FreeBed(bedId)
{
    new text[512];
    format(text, sizeof(text),
        "{FFFF00}« Свободная больничная койка »\n\n\
        {00FF00}| {FFFFFF}Номер койки: {FFFF00}%d\n\
        {00FF00}| {FFFFFF}Пациент: {FFFF00}отсутствует\n\n\
        {AAAAAA}Подойдите ближе для взаимодействия \n с больничной койкой",
        bedId + 1
    );
    UpdateDynamic3DTextLabelText(bedLabel[bedId], 0xFFFFFFFF, text);
    return 1;
}
stock StopHealing(playerid)
{
    if(healingTimer[playerid] != 0)
    {
        KillTimer(healingTimer[playerid]);
        healingTimer[playerid] = 0;
    }
    healingPlayer[playerid] = 0;
    if(healingTextDraw[playerid] != PlayerText:INVALID_TEXT_DRAW)
    {//kmonarch @tg_kmonarch | @werixtonstudio
        PlayerTextDrawHide(playerid, healingTextDraw[playerid]);
    }
    return 1;
}

stock ShowHealingEffect(playerid)
{
    if(healingTextDraw[playerid] == PlayerText:INVALID_TEXT_DRAW)
    {
        healingTextDraw[playerid] = CreatePlayerTextDraw(playerid, 320.0, 300.0, "+1 HP");
        PlayerTextDrawFont(playerid, healingTextDraw[playerid], 3);
        PlayerTextDrawLetterSize(playerid, healingTextDraw[playerid], 0.6, 2.0);
        PlayerTextDrawColor(playerid, healingTextDraw[playerid], 0x33FF33FF);
        PlayerTextDrawAlignment(playerid, healingTextDraw[playerid], 2);
        PlayerTextDrawBackgroundColor(playerid, healingTextDraw[playerid], 0x00000000);
        PlayerTextDrawSetOutline(playerid, healingTextDraw[playerid], 1);
        PlayerTextDrawSetProportional(playerid, healingTextDraw[playerid], 1);
    }
    PlayerTextDrawShow(playerid, healingTextDraw[playerid]);
    SetTimerEx("HideHealingText", 500, false, "i", playerid);
}//kmonarch @tg_kmonarch | @werixtonstudio

forward HideHealingText(playerid);
public HideHealingText(playerid)
{
    if(healingTextDraw[playerid] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawHide(playerid, healingTextDraw[playerid]);
    }
    return 1;
}

forward HealPlayerTimer(playerid);
public HealPlayerTimer(playerid)
{
    if(!IsPlayerConnected(playerid) || !healingPlayer[playerid])
    {
        StopHealing(playerid);
        return 1;
    }
    new Float:health;
    GetPlayerHealth(playerid, health);
    if(health >= 100.0)
    {
        StopHealing(playerid);
        new bedId = currentBedId[playerid];
        if(bedId != -1)
        {
            FreeBed(bedId);
            currentBedId[playerid] = -1;
        }
        ShowNotificationNew(playerid, 3, 4, 0, 0, "Вы полностью вылечились!", "");
        SendClientMessage(playerid, 0xFFFFFFFF, "Вы здоровы и можете покинуть больницу!");
        return 1;
    }//kmonarch @tg_kmonarch | @werixtonstudio
    new Float:newHealth = health + 1.0;
    if(newHealth > 100.0) newHealth = 100.0;
    SetPlayerHealth(playerid, newHealth);
    ShowHealingEffect(playerid);
    return 1;
}

CMD:mheal(playerid)
{
    new bedId = -1;
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    for(new i = 0; i < 5; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 2.0, bedCoords[i][0], bedCoords[i][1], bedCoords[i][2]))
        {
            bedId = i;
            break;
        }
    }
    if(bedId == -1)
    {
        ShowNotificationNew(playerid, 2, 4, 0, 0, "Вы не находитесь у больничной койки!", "");
        return 1;
    }//kmonarch @tg_kmonarch | @werixtonstudio
    new text[512];
    GetDynamic3DTextLabelText(bedLabel[bedId], text, sizeof(text));
    if(strfind(text, "Занятая") != -1)
    {
        ShowNotificationNew(playerid, 2, 4, 0, 0, "Эта койка уже занята!", "");
        return 1;
    }
    new Float:health;
    GetPlayerHealth(playerid, health);
    if(health >= 100.0)
    {
        ShowNotificationNew(playerid, 2, 4, 0, 0, "Вы уже полностью здоровы!", "");
        return 1;
    }
    if(healingPlayer[playerid])
    {
        ShowNotificationNew(playerid, 2, 4, 0, 0, "Вы уже проходите лечение!", "");
        return 1;
    }
    TakeBed(bedId, playerid);
    currentBedId[playerid] = bedId;
    healingPlayer[playerid] = 1;
    healingTimer[playerid] = SetTimerEx("HealPlayerTimer", 2000, true, "i", playerid);
    ShowNotificationNew(playerid, 3, 4, 0, 0, "Вы начали лечение!", "");
    return 1;
}
CMD:stopheal(playerid)
{
    if(!healingPlayer[playerid])
    {
        ShowNotificationNew(playerid, 2, 4, 0, 0, "Вы не проходите лечение!", "");
        return 1;
    }
    StopHealing(playerid);
    new bedId = currentBedId[playerid];
    if(bedId != -1)
    {
        FreeBed(bedId);
        currentBedId[playerid] = -1;
    }
    ShowNotificationNew(playerid, 2, 4, 0, 0, "Вы прервали лечение!", "");
    return 1;
}
stock GetBedIdFromCoords(playerid)
{
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);
    for(new i = 0; i < sizeof(bedCoords); i++)  
    {
        if(IsPlayerInRangeOfPoint(playerid, 2.0, bedCoords[i][0], bedCoords[i][1], bedCoords[i][2]))
        {
            return i;
        }
    }
    return -1;
}//kmonarch @tg_kmonarch | @werixtonstudio
forward CheckPlayersNearBeds();
public CheckPlayersNearBeds()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
        new bedId = GetBedIdFromCoords(i);
        new lastBed = GetPVarInt(i, "LastNearBed");
        if(bedId != -1 && lastBed != bedId)
        {
            SetPVarInt(i, "LastNearBed", bedId);
            new text[512];
            GetDynamic3DTextLabelText(bedLabel[bedId], text, sizeof(text));
            if(strfind(text, "Занятая") == -1)
            {
                ShowNotificationNew(i, 4, 6, OFFER_HEAL, 0, "Вы хотите начать лечение?", "Да");
            }
        }
        else if(bedId == -1 && lastBed != -1)
        {
            DeletePVar(i, "LastNearBed");
            if(healingPlayer[i])
            {
                StopHealing(i);
                if(currentBedId[i] != -1)
                {
                    FreeBed(currentBedId[i]);
                    currentBedId[i] = -1;
                }
            }
        }
    }
    return 1;
}


//kmonarch @tg_kmonarch | @werixtonstudio




