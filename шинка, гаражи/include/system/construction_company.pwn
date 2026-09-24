// Полная адаптация системы строительной компании из ck.pwn
// Оригинальный функционал сохранён: трудоустройство, прораб, 3 щитка,
// 3 мешка, погрузчик, выгрузка мусора, награда и кулдаун.

#define DIALOG_STROY 2000
#define DIALOG_PRORAB 2001
#define DIALOG_MESHOK 2005
#define DIALOG_MESHOKK 2006
#define DIALOG_MESHOKKK 2007

new stroykomp;
new prorabb;
new stroyka[MAX_PLAYERS];
new electr;
new electr1;
new electr2;
new shit[MAX_PLAYERS];
new shittwo[MAX_PLAYERS];
new shitend[MAX_PLAYERS];
new meshok;
new meshokdva;
new meshoktri;
new meshokv;
new meshokv2;
new meshokv3;
new meshokda[MAX_PLAYERS];
new meshokect[MAX_PLAYERS];
new meshokecttri[MAX_PLAYERS];
new stroykaveh[MAX_PLAYERS];
new meshokcd[MAX_PLAYERS];
new conecstr[MAX_PLAYERS];
new mysor;
new stroy_timer[MAX_PLAYERS];
new stroy_seconds[MAX_PLAYERS];
new PlayerText:StroyTimerTD[MAX_PLAYERS];

stock Stroy_ShowTimer(playerid, seconds)
{
    new string[16];
    format(string, sizeof string, "%d", seconds);
    if(StroyTimerTD[playerid] != PlayerText:0xFFFF)
        PlayerTextDrawDestroy(playerid, StroyTimerTD[playerid]);
    StroyTimerTD[playerid] = CreatePlayerTextDraw(playerid, 320.0, 210.0, string);
    PlayerTextDrawLetterSize(playerid, StroyTimerTD[playerid], 2.5, 5.0);
    PlayerTextDrawAlignment(playerid, StroyTimerTD[playerid], 2);
    PlayerTextDrawColor(playerid, StroyTimerTD[playerid], 0xFF0000FF);
    PlayerTextDrawBackgroundColor(playerid, StroyTimerTD[playerid], 0x00000000);
    PlayerTextDrawFont(playerid, StroyTimerTD[playerid], 2);
    PlayerTextDrawSetProportional(playerid, StroyTimerTD[playerid], 1);
    PlayerTextDrawSetShadow(playerid, StroyTimerTD[playerid], 0);
    PlayerTextDrawSetOutline(playerid, StroyTimerTD[playerid], 2);
    PlayerTextDrawShow(playerid, StroyTimerTD[playerid]);
}
stock Stroy_UpdateTimer(playerid, seconds)
{
    new string[16]; format(string, sizeof string, "%d", seconds);
    if(StroyTimerTD[playerid] != PlayerText:0xFFFF) PlayerTextDrawSetString(playerid, StroyTimerTD[playerid], string);
}
stock Stroy_HideTimer(playerid)
{
    if(StroyTimerTD[playerid] != PlayerText:0xFFFF) { PlayerTextDrawDestroy(playerid, StroyTimerTD[playerid]); StroyTimerTD[playerid] = PlayerText:0xFFFF; }
}
stock Stroy_Reset(playerid)
{
    shit[playerid]=0; shittwo[playerid]=0; shitend[playerid]=0;
    meshokda[playerid]=0; meshokect[playerid]=0; meshokecttri[playerid]=0; conecstr[playerid]=0;
    if(stroy_timer[playerid]) { KillTimer(stroy_timer[playerid]); stroy_timer[playerid]=0; }
    if(stroykaveh[playerid]) { DestroyVehicle(stroykaveh[playerid]); stroykaveh[playerid]=0; }
    Stroy_HideTimer(playerid); DisablePlayerCheckpoint(playerid); TogglePlayerControllable(playerid, 1);
}
stock Stroy_StartRepair(playerid, stage)
{
    if(!stroyka[playerid]) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы не работаете на стройке");
    if(stroy_timer[playerid]) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Подождите, вы уже чините щиток");
    if(stage == 1 && shit[playerid]) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы уже починили этот щиток");
    if(stage == 2 && (!shit[playerid] || shittwo[playerid])) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Сначала завершите предыдущий щиток");
    if(stage == 3 && (!shittwo[playerid] || shitend[playerid])) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Сначала завершите предыдущий щиток");
    stroy_seconds[playerid]=10;
    stroy_timer[playerid]=SetTimerEx("Stroy_RepairTimer", 1000, true, "i", playerid);
    Stroy_ShowTimer(playerid, 10); TogglePlayerControllable(playerid, 0);
    new msg[128]; format(msg, sizeof msg, "{FFFF00}| {FFFFFF}Вы начали ремонт щитка #%d. Осталось: {FF0000}10 {FFFFFF}секунд", stage);
    SendClientMessage(playerid, -1, msg);
    return 1;
}
forward Stroy_RepairTimer(playerid);
public Stroy_RepairTimer(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(--stroy_seconds[playerid] > 0) { Stroy_UpdateTimer(playerid, stroy_seconds[playerid]); return 1; }
    KillTimer(stroy_timer[playerid]); stroy_timer[playerid]=0; Stroy_HideTimer(playerid); TogglePlayerControllable(playerid, 1);
    if(!shit[playerid]) { shit[playerid]=1; GivePlayerMoney(playerid,5000); SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Вы успешно починили щиток #1! +{FF0000}5000$"); SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Поднимайтесь на 2-й этаж к щитку #2"); SetPlayerCheckpoint(playerid,18.053916,1875.414550,18.907058,1.0); return 1; }
    if(!shittwo[playerid]) { shittwo[playerid]=1; GivePlayerMoney(playerid,5000); SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Вы успешно починили щиток #2! +{FF0000}5000$"); SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Идите к щитку #3 на 2-м этаже"); SetPlayerCheckpoint(playerid,18.054027,1875.414428,15.407059,1.0); return 1; }
    if(!shitend[playerid]) { shitend[playerid]=1; GivePlayerMoney(playerid,5000); SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Вы успешно починили щиток #3! +{FF0000}5000$"); SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}1 Этап стройки {FFFF00}завершен{FFFFFF}."); SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Отправляйтесь к мешкам с мусором на 1-й этаж"); SetPlayerCheckpoint(playerid,44.907081,1868.700561,15.407059,1.0); }
    return 1;
}
stock Stroy_Init()
{
    for(new i; i<MAX_PLAYERS; i++) { StroyTimerTD[i]=PlayerText:0xFFFF; stroykaveh[i]=0; stroy_timer[i]=0; }
    Create3DTextLabel("{FFDC33}Начальник Андреевич\n\n{FFFFFF}Подойдите ближе, чтобы устроиться в строительную компанию",0xFFFFFFFF,179.305343,391.597808,16.192012,3.0);
    CreateActor(34,179.305297,391.597808,16.195312,92.8); stroykomp=CreateDynamicSphere(179.305343,391.597808,16.192012,1.0);
    CreateActor(228,-9.116186,1807.725463,9.477350,86.516845); Create3DTextLabel("{FFDC33}Прораб - Александр\n\n{FFFFFF}Подойдите для взаимодействия с Александром",0xFFFFFFFF,-9.116186,1807.725463,9.477350,3.0); prorabb=CreateDynamicSphere(-9.116186,1807.725463,9.477350,1.0);
    Create3DTextLabel("{FFDC33}Электрический щиток #1\n\n{FFFFFF}Подойдите ближе для починки щитка",0xFFFFFFFF,18.071474,1875.481445,9.907059,10.0); electr=CreatePickup(1210,23,18.071474,1875.481445,9.907059,-1);
    Create3DTextLabel("{FFDC33}Электрический щиток #2\n\n{FFFFFF}Подойдите ближе для починки щитка",0xFFFFFFFF,18.053916,1875.414550,18.907058,10.0); electr1=CreatePickup(1210,23,18.053916,1875.414550,18.907058,-1);
    Create3DTextLabel("{FFDC33}Электрический щиток #3\n\n{FFFFFF}Подойдите ближе для починки щитка",0xFFFFFFFF,18.054027,1875.414428,15.407059,10.0); electr2=CreatePickup(1210,23,18.054027,1875.414428,15.407059,-1);
    meshok=CreatePickup(1210,23,44.907081,1868.700561,15.407059,-1); Create3DTextLabel("{A9A9A9}Мешок с мусором\n\n{FFFFFF}Подойдите ближе для взятия мешка",0xFFFFFFFF,44.907081,1868.700561,15.407059,10.0); meshokv=CreateDynamicSphere(7.416964,1869.525146,15.407059,1.0);
    meshokdva=CreatePickup(1210,23,39.442390,1868.927612,22.407058,-1); Create3DTextLabel("{A9A9A9}Мешок с мусором\n\n{FFFFFF}Подойдите ближе для взятия мешка",0xFFFFFFFF,39.442390,1868.927612,22.407058,10.0); meshokv2=CreateDynamicSphere(75.329261,1863.635009,18.907058,1.0);
    meshoktri=CreatePickup(1210,23,7.857259,1876.818725,15.407059,-1); Create3DTextLabel("{A9A9A9}Мешок с мусором\n\n{FFFFFF}Подойдите ближе для взятия мешка",0xFFFFFFFF,7.857259,1876.818725,15.407059,10.0); meshokv3=CreateDynamicSphere(7.346275,1869.510864,9.907059,1.0);
    mysor=CreatePickup(1575,23,79.417998,1836.903564,9.408595,-1); Create3DTextLabel("Мусорный бак\n{FFFF00}Подъезжайте для выгрузки мусора",0xFFFFFFFF,79.417998,1836.903564,9.408595,10.0);
    return 1;
}
stock Stroy_HandlePickup(playerid,pickupid)
{
    if(pickupid==electr) return Stroy_StartRepair(playerid,1);
    if(pickupid==electr1) return Stroy_StartRepair(playerid,2);
    if(pickupid==electr2) return Stroy_StartRepair(playerid,3);
    if(pickupid==meshok) { ShowPlayerDialog(playerid,DIALOG_MESHOK,DIALOG_STYLE_MSGBOX,"Склад мешков","Вы желаете взять мешок с мусором?","Взять","Назад"); return 1; }
    if(pickupid==meshokdva) { ShowPlayerDialog(playerid,DIALOG_MESHOKK,DIALOG_STYLE_MSGBOX,"Склад мешков","Вы желаете взять мешок с мусором?","Взять","Назад"); return 1; }
    if(pickupid==meshoktri) { ShowPlayerDialog(playerid,DIALOG_MESHOKKK,DIALOG_STYLE_MSGBOX,"Склад мешков","Вы желаете взять мешок с мусором?","Взять","Назад"); return 1; }
    if(pickupid==mysor) { if(!conecstr[playerid]) return SendClientMessage(playerid,-1,"{FFFF00}|{FFFFFF}Вы не выполнили 2 этап."); SendClientMessage(playerid,-1,"{FFFF00}|{FFFFFF}Вы успешно выгрузили мусор и завершили работу!"); GivePlayerMoney(playerid,150000); meshokcd[playerid]=GetTickCount()+18000000; Stroy_Reset(playerid); SetPlayerSkin(playerid,0); stroyka[playerid]=0; return 1; }
    return 0;
}
stock Stroy_HandleDialog(playerid,dialogid,response,listitem)
{
    if(dialogid==DIALOG_STROY) { if(!response) return 1; if(meshokcd[playerid]>GetTickCount()) return SendClientMessage(playerid,-1,"{FFFF00} | {FFFFFF}Вы уже работали недавно, ожидайте"); stroyka[playerid]=1; Stroy_Reset(playerid); stroyka[playerid]=1; SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Вы успешно устроились в Строительную Компанию. Отправляйтесь на {FFFF00}стройку"); if(listitem==0) SetPlayerCheckpoint(playerid,-3.654715,1815.037353,9.398981,3.0); else if(listitem==1) SetPlayerCheckpoint(playerid,1772.700439,-2505.793457,10.815861,3.0); else SetPlayerCheckpoint(playerid,-2175.430664,-405.804870,29.426282,3.0); return 1; }
    if(dialogid==DIALOG_PRORAB) { if(response && stroyka[playerid]) { SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Следуйте на метку и начинайте работу."); SetPlayerCheckpoint(playerid,18.071474,1875.481445,9.907059,1.0); SetPlayerSkin(playerid,206); } else if(response) SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Вы не работаете на стройке"); return 1; }
    if(dialogid==DIALOG_MESHOK) { if(response) { if(!shitend[playerid]) return SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Вы не закончили 1 этап стройки."); meshokda[playerid]=1; meshokect[playerid]=1; SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Вы взяли мешок с мусором. Отнесите его по указанной метке."); SetPlayerCheckpoint(playerid,7.416964,1869.525146,15.407059,1.0); } return 1; }
    if(dialogid==DIALOG_MESHOKK) { if(response) { if(!meshokect[playerid]) return SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Сначала сдайте первый мешок."); meshokda[playerid]=1; meshokecttri[playerid]=1; SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Вы взяли мешок с мусором. Отнесите его по указанной метке."); SetPlayerCheckpoint(playerid,75.329261,1863.635009,18.907058,1.0); } return 1; }
    if(dialogid==DIALOG_MESHOKKK) { if(response) { if(!meshokecttri[playerid]) return SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Сначала сдайте предыдущий мешок."); meshokda[playerid]=1; SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Вы взяли мешок с мусором. Отнесите его по указанной метке."); SetPlayerCheckpoint(playerid,7.346275,1869.510864,9.907059,1.0); } return 1; }
    return 0;
}
stock Stroy_HandleArea(playerid,areaid)
{
    if(areaid==stroykomp) { if(GetPlayerLevel(playerid)>=8) ShowPlayerDialog(playerid,DIALOG_STROY,DIALOG_STYLE_LIST,"Строительная компания — Андреевич","Арзамас - нажмите для взаимодействия\nЮжный - нажмите для взаимодействия\nЛыткарино - нажмите для взаимодействия","Выбрать","Назад"); else SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Для работы требуется 8 уровень."); return 1; }
    if(areaid==prorabb) { ShowPlayerDialog(playerid,DIALOG_PRORAB,DIALOG_STYLE_MSGBOX,"Прораб {FFFF00}Александр","Вы желаете начать рабочий день?","Да","Нет"); return 1; }
    if(areaid==meshokv) { if(!meshokda[playerid]) return SendClientMessage(playerid,-1,"{FFFF00}|{FFFFFF}У вас нет мешка в руках."); meshokda[playerid]=0; SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Вы успешно сдали мешок с мусором, отправляйтесь за следующим."); SetPlayerCheckpoint(playerid,39.442390,1868.927612,22.407058,1.0); return 1; }
    if(areaid==meshokv2) { if(!meshokda[playerid]) return SendClientMessage(playerid,-1,"{FFFF00}|{FFFFFF}У вас нет мешка в руках."); meshokda[playerid]=0; SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Вы успешно сдали мешок с мусором, отправляйтесь за следующим."); SetPlayerCheckpoint(playerid,7.857259,1876.818725,15.407059,1.0); return 1; }
    if(areaid==meshokv3) { if(!meshokda[playerid]) return SendClientMessage(playerid,-1,"{FFFF00}|{FFFFFF}У вас нет мешка в руках."); meshokda[playerid]=0; conecstr[playerid]=1; SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Вы успешно сдали мешок с мусором."); SendClientMessage(playerid,-1,"{FFFF00}| {FFFFFF}Вы начали работать погрузчиком, после чего езжайте к мусорному баку."); SetPlayerCheckpoint(playerid,79.417998,1836.903564,9.408595,1.5); stroykaveh[playerid]=CreateVehicle(486,-41.542228,1881.632202,4.548228,177.128326,3,3,-1,1); PutPlayerInVehicle(playerid,stroykaveh[playerid],0); return 1; }
    return 0;
}
stock Stroy_OnPlayerDisconnect(playerid)
{
    Stroy_Reset(playerid); stroyka[playerid]=0; meshokcd[playerid]=0; return 1;
}
