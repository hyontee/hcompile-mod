@___If_u_can_read_this_u_r_nerd();
@___If_u_can_read_this_u_r_nerd()
{
#emit stack 0x7FFFFFFF
#emit inc.s cellmax
#emit retn
#emit proc
#emit proc
#emit fill cellmax
#emit proc
#emit stack 1 
#emit strb.i 2
#emit switch 0
#emit retn
L1:
#emit jump L1
#emit zero cellmin 
}

#include <a_samp>
#include <utils>
#include <MXini>
#include <sscanf2>
#include <streamer>

#pragma dynamic 50000
#pragma tabsize 4

#undef MAX_PLAYERS
#define MAX_PLAYERS 211 //максимум игроков на сервере + 1 (если 50 игроков, то пишем 51)

#if (MAX_PLAYERS > 211)
#undef MAX_PLAYERS
#define MAX_PLAYERS 211
#endif

#define MAX_GANGS 2002 //максимум банд + 2 (если 100 банд, то пишем 102)
#define OBRAD 6 //число радио +1//Радио

#define DRIFT_MINKAT 10.0
#define DRIFT_MAXKAT 90.0
#define DRIFT_SPEED 30.0

#define COLOR_BLUE 0x33AAFFFF
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GRAD3 0xCBCCCEFF
#define COLOR_GRAD4 0xD8D8D8FF
#define COLOR_GRAD5 0xE3E3E3FF
#define COLOR_GRAD6 0xF0F0F0FF
#define COLOR_GREY 0xAFAFAFFF
#define COLOR_GREEN 0x00FF00FF
#define COLOR_RED 0xFF0000FF
#define COLOR_RED3d 0xAA3333FF
#define COLOR_LIGHTRED 0xFF6347FF
#define COLOR_LIGHTBLUE 0x33CCFFFF
#define COLOR_LIGHTGREEN 0x9ACD32FF
#define COLOR_CGREEN 0xBFF600FF
#define COLOR_YELLOW 0xFFFF00FF
#define COLOR_YELLOW2 0xF5DEB3FF
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_FADE1 0xE6E6E6FF
#define COLOR_FADE2 0xC8C8C8FF
#define COLOR_FADE3 0xAAAAAAFF
#define COLOR_FADE4 0x8C8C8CFF
#define COLOR_FADE5 0x6E6E6EFF
#define COLOR_PURPLE 0xC586FFFF
#define COLOR_PINK 0xFF66FFFF
#define COLOR_DBLUE 0x2641FEFF
#define COLOR_GREENISHGOLD 0xCCFFDDFF
#define COLOR_LEMON 0xDDDD23FF
#define COLOR_BASIC 0x0066FFFF
#define COLOR_ORANGE 0xFF8800FF

#define SHORT_NAME "DAG"
#define DIALOG_CAR_MAIN      3000
#define DIALOG_CAR_VAZ       3001
#define DIALOG_CAR_MERCEDES  3002
#define DIALOG_CAR_BMW       3003
#define DIALOG_CAR_TOYOTA    3004
#define DIALOG_CAR_LEXUS     3005
#define DIALOG_CAR_PORSCHE   3006
#define DIALOG_CAR_KITAY     3007
#define DIALOG_CAR_BIKES     3008
#define DIALOG_CAR_POLICE    3009

enum pInfo
{
	pKey[64],
	pTDReg[64],
	pIPAdr[64],
	pMinlog,
	pAdmin,
	pAdmshad,
	pAdmlive,
	pReg,
	pPrison,
	pPrisonsec,
	pMuted,
	pMutedsec,
	pKills,
	pDeaths,
	pLock,
Float:pCordX,
Float:pCordY,
Float:pCordZ,
Float:pAngle,
	pWeapSlot0,
	pWeapSlot1,
	pWeapSlot2,
	pWeapSlot3,
	pWeapSlot4,
	pWeapSlot5,
	pWeapSlot6,
	pWeapSlot7,
	pWeapSlot8,
	pWeapSlot9,
	pWeapSlot10,
	pWeapSlot11,
	pWeapSlot12,
	pAmmoSlot0,
	pAmmoSlot1,
	pAmmoSlot2,
	pAmmoSlot3,
	pAmmoSlot4,
	pAmmoSlot5,
	pAmmoSlot6,
	pAmmoSlot7,
	pAmmoSlot8,
	pAmmoSlot9,
	pAmmoSlot10,
	pAmmoSlot11,
	pAmmoSlot12,
	pFrac1,
	pFracLvl1,
Float:pFracCordX1,
Float:pFracCordY1,
Float:pFracCordZ1,
Float:pFracAngle1,
	pFracTxt1[64],
	pFrac2,
	pFracLvl2,
Float:pFracCordX2,
Float:pFracCordY2,
Float:pFracCordZ2,
Float:pFracAngle2,
	pFracTxt2[64],
	pFrac3,
	pFracLvl3,
Float:pFracCordX3,
Float:pFracCordY3,
Float:pFracCordZ3,
Float:pFracAngle3,
	pFracTxt3[64],
	pFrac4,
	pFracLvl4,
Float:pFracCordX4,
Float:pFracCordY4,
Float:pFracCordZ4,
Float:pFracAngle4,
	pFracTxt4[64],
	pFrac5,
	pFracLvl5,
Float:pFracCordX5,
Float:pFracCordY5,
Float:pFracCordZ5,
Float:pFracAngle5,
	pFracTxt5[64],
	pFrac6,
	pFracLvl6,
Float:pFracCordX6,
Float:pFracCordY6,
Float:pFracCordZ6,
Float:pFracAngle6,
	pFracTxt6[64]
};
new bool: ac_1[MAX_PLAYERS char];
new dddrift[MAX_PLAYERS];//переменная контроля дрифта
new Text3D:Level3D[MAX_PLAYERS];
new LevelStats[MAX_PLAYERS];
new Text:leveldr[11];
new DriftPointsNow[MAX_PLAYERS];
new PlayerDriftCancellation[MAX_PLAYERS];
new Float:ppos[MAX_PLAYERS][3];
new	drifttimer;
new	leveltimer;
new Pricep[10];
new allPlayers;
new Text:Clock;//часы
new AntiCPlus[MAX_PLAYERS];

enum PlayerData
{
	Level[200]
};
enum Float:Pos
{
Float:sX,
Float:sY,
Float:sZ,
Float:dltX,
Float:dltY,
Float:dltZ
};
new Float:SavedPos[MAX_PLAYERS][Pos];
new tgang[MAX_PLAYERS], gangskin[MAX_PLAYERS], play333[MAX_PLAYERS] = -1;//Gangs system
new GangName[MAX_GANGS][130], Gang[MAX_GANGS], GangSA[MAX_GANGS],
GangLvl[MAX_PLAYERS], GName[MAX_GANGS][130], GColorDec[MAX_GANGS],
GColor[MAX_GANGS][16], PGang[MAX_PLAYERS], GColorHex[MAX_GANGS][16],
Float:GSpawnX[MAX_GANGS], Float:GSpawnY[MAX_GANGS], GTDReg[MAX_GANGS][32],
Float:GSpawnZ[MAX_GANGS], GSkin[MAX_GANGS][7], GHead[MAX_GANGS][64],
GInter[MAX_GANGS], GWorld[MAX_GANGS], GPlayers[MAX_GANGS], GangDopper[MAX_PLAYERS];
new locper3[MAX_PLAYERS];//вспомогательная переменная ID банд для записи
new idgangsave[MAX_PLAYERS];//ID банд для записи
new PlayerInfo[MAX_PLAYERS][pInfo];
new AdmHlp[][] = {
	{"{FF0000}Административное меню оперативных команд\n"},
	{"{FF0000}двойной клик по игроку после нажатия кнопки ''TAB''\n"}
};
new dopadm[MAX_PLAYERS];//дополнительные переменные админок
new NRadio[MAX_PLAYERS];//переменная номера подключенного радио
new STRadio[OBRAD][128];//массив URL-ссылок на радио-потоки
new NMRadio[OBRAD][64];//массив названий радио
new Pic44[16];//IDы пикапов
new ipper[MAX_PLAYERS][4][32];//массив для команд /ipban и /ipunban
new moneycontrol[MAX_PLAYERS];//контроль денег игрока
new moneycontrol22[MAX_PLAYERS];
new scorecontrol[MAX_PLAYERS];//контроль очков игрока
new scorecontrol22[MAX_PLAYERS];
new relFS[16][256];//массив перезагружаемых фильтрскриптов
new resthour;//час перезагрузки сервера
new servconf[4][256];//массив конфигурации сервера
new plcmonloc[MAX_PLAYERS];//переменные краш-монитора
new plcmondist[MAX_PLAYERS];
new Text:TScore[MAX_PLAYERS];//текст-дравы очков
new deathcon[MAX_PLAYERS];//переменная контроля смерти игрока
new ColorPlay[MAX_PLAYERS];//переменная цвета игрока
new dlgcont[MAX_PLAYERS];//контроль ИД диалога
new Wind1SA;//переменные "окна" автосохранения аккаунтов
new Wind2SA;
new WWindSA;//ширина "окна" автосохранения аккаунтов
new mapiconid[MAX_PLAYERS];//массив ID мап иконок наблюдения
new PlayLock1[3][MAX_PLAYERS];//переменные блокировки игрока
new Float:PlayLock2[4][MAX_PLAYERS];
new NETafkPl[MAX_PLAYERS][6];//переменные контроля AFK
new LockSpawn[MAX_PLAYERS];//блокировка заполнения слотов оружия и предметов
new restrest;//переменная рестарта сервера
new prisoncount[MAX_PLAYERS];//задержка контроля игрока в тюрьме
new oneminkick[MAX_PLAYERS];//кик - если не заспавнился
new RealName[MAX_PLAYERS][MAX_PLAYER_NAME];//реальный ник игрока
new fbanreason[MAX_PLAYERS][256];//причина бана
new timpolsec;//переменная таймера 450 мс
new snowobj[MAX_PLAYERS];//переменная снега 1
new SnowONOFF[MAX_PLAYERS];//переменная снега 2
new nucexplos;//переменная ядерного взрыва
new nucexptime;//переменная таймера ядерного взрыва
new perfrost[MAX_PLAYERS];//переменная заморозки
new locper1[MAX_PLAYERS];//вспомогательная переменная IP вышедшего игрока
new locper2[MAX_PLAYERS];//вспомогательная переменная IP вышедшего игрока
new twoIP[MAX_PLAYERS][126];//переменная для IP вышедшего игрока
new playspa[MAX_PLAYERS];//переменная спавна игрока
new dialogadm[MAX_PLAYERS];//контрольная переменная админ-меню
new dialogcon[MAX_PLAYERS];//контрольная переменная диалогов
new functioncon[MAX_PLAYERS];//контрольная переменная функций
new chatcon[MAX_PLAYERS];//контрольная переменная чата
new oldhour;//переменная реального времени
new timedata[5];//переменные времени и даты
new resauto;//переменная авторестарта сервера
new livdop[MAX_PLAYERS];//переменная выключения бессмертия
new Float:TelSpec[MAX_PLAYERS][3];//координаты возврата при снятии наблюдения
new admper1[MAX_PLAYERS];//переменная наблюдения 1
new admper2[MAX_PLAYERS];//переменная наблюдения 2
new admper3[MAX_PLAYERS];//переменная наблюдения 3
new admper4[MAX_PLAYERS];//переменная наблюдения 4
new admper5[MAX_PLAYERS];//переменная наблюдения 5
new admper6[MAX_PLAYERS];//переменная наблюдения 6
new giveplayer[MAX_PLAYER_NAME];
new giveplayerid;
new sendername[MAX_PLAYER_NAME];
new NamAdm[20][64];//массив функции AdminsLvl
new countdown[MAX_PLAYERS];
new play2weap[MAX_PLAYERS][13];//массив оружия при входе на сервер
new play2ammo[MAX_PLAYERS][13];//массив количества патронов при входе на сервер
new weapstatplay[MAX_PLAYERS];//вспомогательная переменная заполнения слотов оружия
new playweap[MAX_PLAYERS][13];//массив оружия
new playammo[MAX_PLAYERS][13];//массив количества патронов
new Float:playspax[6] = {-1979.623535, -1979.623535, -1979.623535, -1979.623535, -1979.623535};//координаты x случайного спавна игрока
new Float:playspay[6] = {884.431030, 884.431030, 884.431030, 884.431030, 884.431030};//координаты y случайного спавна игрока
new Float:playspaz[6] = {45.203125, 45.203125, 45.203125, 45.203125, 45.203125};//координаты z случайного спавна игрока
new Float:playspaa[6] = {93.937553, 93.937553, 93.937553, 93.937553, 93.937553};//угол поворота случайного спавна игрока
new ColNick[7] = {0xFF0000FF, 0x00FF00FF, 0x0000FFFF, 0xFFCC00FF, 0xFFFFFFFF, 0x999999FF, 0xFFFFFFFF};//массив цветов ника и цветов
new neon[MAX_PLAYERS][3];
new skinstatplay[MAX_PLAYERS];//0-у играка ещё нет скина, 1-скин получен
new nickstatcol[MAX_PLAYERS];//0-у играка ещё нет случайного цвета ника и цвета на радаре, 1-цвета получены
new col4car[8] = {0, 4, 8, 35, 36, 122, 136, 153};//номер случайного цвета при спавне транспорта
new playcar[MAX_PLAYERS];//ид транспорта игрока
new gPlayerAccount[MAX_PLAYERS];
new gPlayerLogged[MAX_PLAYERS];
new gPlayerLogTries[MAX_PLAYERS];
new fivesectimer;
new player[MAX_PLAYERS];
new playtarget[MAX_PLAYERS][MAX_PLAYER_NAME];
new autorepair[MAX_PLAYERS];
new autorepaircar;
new restart;
new Float:TpDestA[MAX_PLAYERS][4];
new TpPosA[MAX_PLAYERS][2];
new Float:TpDestP[MAX_PLAYERS][4];
new TpPosP[MAX_PLAYERS][2];
new	timer200;
new onsectimer;
new minsertimer;
new Checkpoint[MAX_PLAYERS];
new reklamatimer1;
//new Text: Speed[MAX_PLAYERS][3];
new Text:speedometr_TD;
new PlayerText:speedometr_PTD[MAX_PLAYERS];
new vid[6];
new dm[MAX_PLAYERS];
new lustra[MAX_VEHICLES];

main(){
    print(" -- -- -- -- -- -- -- -- -- --");
    print(" 						 	 ");
	print(" 							 ");
	print(" -- -- -- -- -- -- -- -- -- --");
}

public OnGameModeInit()
{
    speedometr_TD = TextDrawCreate(285.3999, 358.5911, "txd:speedometr"); // ?????
	TextDrawTextSize(speedometr_TD, 69.0000, 85.0000);
	TextDrawAlignment(speedometr_TD, 1);
	TextDrawColor(speedometr_TD, -1);
	TextDrawBackgroundColor(speedometr_TD, 255);
	TextDrawFont(speedometr_TD, 4);
	TextDrawSetProportional(speedometr_TD, 0);
	TextDrawSetShadow(speedometr_TD, 0);

	SetGameModeText("DAGESTAN MOBILE");
	EnableStuntBonusForAll(0);//убираем бонусы за трюки
	DisableInteriorEnterExits();
	UsePlayerPedAnims();

	servconf[0] = "• DAGESTAN MOBILE •";//имя сервера
	servconf[1] = "";//пароль сервера
	servconf[2] = "San Andreas";//имя карты сервера
	servconf[3] = "t.me/mtachrmobile";//имя web-страница сервера
	resthour = 3;//час перезагрузки сервера
	relFS[0] = "HouseSystem";//список перезагружаемых фильтрскриптов
	relFS[1] = "GarageSystem";
	relFS[2] = "BusSystem";
	relFS[3] = "Brothel";
	relFS[4] = "fireworks";
	relFS[5] = "";
	relFS[6] = "";
	relFS[7] = "";
	relFS[8] = "";
	relFS[9] = "";
	relFS[10] = "";
	relFS[11] = "";
	relFS[12] = "";
	relFS[13] = "";
	relFS[14] = "";
	relFS[15] = "";
	
	for(new i;i<MAX_VEHICLES;i++)
 	{
		lustra[i]=-1;
	}
	new string[256];
	if(strlen(servconf[0]))//если есть имя сервера, то:
	{
		strcat(string, "hostname ");//сборка RCON-команды имени сервера
		strcat(string, servconf[0]);
		SendRconCommand(string);//RCON-команда имени сервера
	}
	strdel(string, 0, 256);
	if(strlen(servconf[1]))//если есть пароль сервера, то:
	{
		strcat(string, "password ");//сборка RCON-команды пароля сервера
		strcat(string, servconf[1]);
		SendRconCommand(string);//RCON-команда пароля сервера
	}
	strdel(string, 0, 256);
	if(strlen(servconf[2]))//если есть имя карты сервера, то:
	{
		strcat(string, "mapname ");//сборка RCON-команды имени карты сервера
		strcat(string, servconf[2]);
		SendRconCommand(string);//RCON-команда имени карты сервера
	}
	strdel(string, 0, 256);
	if(strlen(servconf[3]))//если есть имя web-страницы сервера, то:
	{
		strcat(string, "weburl ");//сборка RCON-команды имени web-страницы сервера
		strcat(string, servconf[3]);
		SendRconCommand(string);//RCON-команда имени web-страницы сервера
	}
	SendRconCommand("language Russian");//RCON-команда языка сервера
	SendRconCommand("rcon 0");//RCON-команда запрета RCON-доступа
	SendRconCommand("announce 1");//RCON-команда анонсирования в интернете
	Wind1SA = 0;//начало "окна" автосохранения аккаунтов
	WWindSA = 20;//ширина "окна" автосохранения аккаунтов
	SetWeather(1);//устанавливаем ID погоды на 1
	restrest = 0;//переменная рестарта сервера
	resauto = 0;//переменная рестарта сервера
	nucexplos = 0;//переменная ядерного взрыва
	nucexptime = 0;//переменная таймера ядерного взрыва
	gettime(timedata[0], timedata[1]);
	oldhour = timedata[0];//подготовка переменной реального времени
	SetWorldTime(timedata[0]);

	getdate(timedata[2], timedata[3], timedata[4]);
	print("--------------------------------------------");
	printf("       Server Start: %02d:%02d %02d/%02d/%04d", timedata[0], timedata[1], timedata[4], timedata[3], timedata[2]);
	print("--------------------------------------------");

	for(new i = 0; i < MAX_PLAYERS; i++)//Gangs system
	{
		idgangsave[i] = 0;//обнуление ID банд для записи
		plcmonloc[i] = 0;//отключаем ВСЕМ админам (и игрокам) функцию краш-монитора
	}

	timpolsec = SetTimer("PolSec", 443, 1);//вспомогательный таймер 450 мс
	timer200 = SetTimer("Timer200ms", 200, true);
	autorepaircar = SetTimer("RepairCar", 1987, 1);
	fivesectimer = SetTimer("FiveSecTimer", 4983, 1);
	onsectimer = SetTimer("OneSecOnd", 997, 1);
	minsertimer = SetTimer("MinServ", 60000, 1);//таймер минут на сервере

	drifttimer = SetTimer("Drift", 200, true);

	Clock = TextDrawCreate(551.000000,24.000000,"00:00");//часы
	TextDrawAlignment(Clock,0);
	TextDrawBackgroundColor(Clock,0x000000ff);
	TextDrawFont(Clock,3);
	TextDrawLetterSize(Clock,0.549999,1.700000);
	TextDrawColor(Clock,0xEBEBEBFF);
	TextDrawSetOutline(Clock,1);
	TextDrawSetProportional(Clock,1);
	TextDrawSetShadow(Clock,0);
	SetTimer("ClockSync", 1000, 1);
	
	new Max = GetMaxPlayers();
	for(new i=0; i<Max; i++)
	{
		Level3D[i] = Create3DTextLabel(" ",0xFFFFFFAA,0.000,0.000,-4.000,18.0,0,1);
	}

	//  Реклама
	reklamatimer1 = SetTimer("Reklama1", 300000, 1);

	GangLoad();//Gangs system

	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		TScore[i] = TextDrawCreate(503.000000, -20.000000, "SCORE:");//спрятан за пределами экрана
		TextDrawAlignment(TScore[i], 0);
		TextDrawBackgroundColor(TScore[i], 0x000000FF);
		TextDrawFont(TScore[i], 1);
		TextDrawLetterSize(TScore[i], 0.359999, 1.999999);
		TextDrawColor(TScore[i], 0x45753BFF);
		TextDrawSetOutline(TScore[i], 1);
		TextDrawSetProportional(TScore[i], 1);
		TextDrawSetShadow(TScore[i], 1);
	}

	STRadio[1] = "http://hls-02-europaplus.emgsound.ru/11/playlist.m3u8";//URL ссылки Радио
	STRadio[2] = "http://air.radiorecord.ru:8101/rr_320";
	STRadio[3] = "https://online.radiorecord.ru:8102/sd90_128";
	STRadio[4] = "http://cast.avtoradio.ua/avtoradio";
	STRadio[5] = "http://eptop128.streamr.ru/";

	NMRadio[1] = "Europa Plus";//название радиостанций
	NMRadio[2] = "Radio Record";
	NMRadio[3] = "Музыка 90-ых";
	NMRadio[4] = "Авторадио";
	NMRadio[5] = "Europa Plus (Top:40)";

	SetTimer("ReloadFS", 1000, 0);//перезагрузка фильтрскриптов

	//  Выбор скина при заходе в игру
	AddPlayerClass(2, 2793.7385, -1944.5769, 17.3203, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(19, 2793.7385, -1944.5769, 17.3203, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(22, 2793.7385, -1944.5769, 17.3203, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(143, 2793.7385, -1944.5769, 17.3203, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(177, 2793.7385, -1944.5769, 17.3203, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(181, 2793.7385, -1944.5769, 17.3203, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(203, 2793.7385, -1944.5769, 17.3203, 0, 0, 0, 0, 0, 0, 0);
	AddPlayerClass(297, 2793.7385, -1944.5769, 17.3203, 0, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	for(new i=0; i<11; i++)
	{
		TextDrawDestroy(leveldr[i]);
	}
	new Max = GetMaxPlayers();
	for(new i=0; i<Max; i++)
	{
		Delete3DTextLabel(Level3D[i]);
	}
	KillTimer(drifttimer);
	KillTimer(leveltimer);

    for(new i; i < MAX_PLAYERS; i++) Kick(i);

	if(restrest == 0)//если нету рестарта сервера, то:
	{
		KillTimer(fivesectimer);
		KillTimer(restart);
		KillTimer(autorepaircar);
		KillTimer(onsectimer);
		KillTimer(minsertimer);
		KillTimer(timer200);
		KillTimer(timpolsec);
		KillTimer(reklamatimer1);

		new string[256];
		for(new j = 0; j < 16; j++)
		{
			if(strlen(relFS[j]))//если строка НЕ пустая, то:
			{
				strdel(string, 0, 256);//очистка переменной string
				strcat(string, "unloadfs ");//сборка RCON-команды выгрузки фильтрскрипта
				strcat(string, relFS[j]);
				SendRconCommand(string);//RCON-команда выгрузки фильтрскрипта
			}
		}

		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			TextDrawHideForPlayer(i, TScore[i]);
			TextDrawDestroy(TScore[i]);
			if(mapiconid[i] != -600)//если ID мап иконки наблюдения НЕ пустой, то:
			{
				DestroyDynamicMapIcon(mapiconid[i]);//удаление мап иконки наблюдения
			}
			mapiconid[i] = -600;//очистка ID мап иконки наблюдения
			if(IsPlayerConnected(i))
			{
				PlayKick(i);
			}
		}

		DestroyDynamicPickup(Pic44[12]);//удаляем пикап входа в дом-бар Чилиад
		DestroyDynamicPickup(Pic44[13]);//удаляем пикап выхода дом-бар Чилиад
		for(new i = 0; i < 16; i++)
		{
			DestroyDynamicPickup(Pic44[i]);//удаляем пикапы
		}

	}
	restrest = 0;//переменная рестарта сервера
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetSpawnInfo(playerid,0,0,0.0,0.0,0.0,0.0,0,0,0,0,0,0);
    SetPlayerSkin(playerid, 2);
    SpawnPlayer(playerid);
    SetPlayerFacingAngle(playerid, 178.7889);
	SetCameraBehindPlayer(playerid);
	return 1;
}

public OnPlayerConnect(playerid)
{
    speedometr_PTD[playerid] = CreatePlayerTextDraw(playerid, 308.3000, 397.2756, "000"); // ?????
	PlayerTextDrawLetterSize(playerid, speedometr_PTD[playerid], 0.4000, 1.6000);
	PlayerTextDrawAlignment(playerid, speedometr_PTD[playerid], 1);
	PlayerTextDrawColor(playerid, speedometr_PTD[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, speedometr_PTD[playerid], 255);
	PlayerTextDrawFont(playerid, speedometr_PTD[playerid], 1);
	PlayerTextDrawSetProportional(playerid, speedometr_PTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, speedometr_PTD[playerid], 0);

	//--------------------------- Удаление объектов ----------------------------
	//  Ворота АШ (SF-LV)
	RemoveBuildingForPlayer(playerid, 11372, -2076.4375, -107.9297, 36.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 11014, -2076.4375, -107.9297, 36.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 8229, 1142.0313, 1362.5000, 12.4844, 0.25);

	//новый деморган
	RemoveBuildingForPlayer(playerid, 3682, 247.9297, 1461.8594, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3682, 192.2734, 1456.1250, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3682, 199.7578, 1397.8828, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 133.7422, 1356.9922, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 166.7891, 1356.9922, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 166.7891, 1392.1563, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 133.7422, 1392.1563, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 166.7891, 1426.9141, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 133.7422, 1426.9141, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3288, 221.5703, 1374.9688, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 212.0781, 1426.0313, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3290, 218.2578, 1467.5391, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3291, 246.5625, 1435.1953, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3291, 246.5625, 1410.5391, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3291, 246.5625, 1385.8906, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3291, 246.5625, 1361.2422, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3290, 190.9141, 1371.7734, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 183.7422, 1444.8672, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 222.5078, 1444.6953, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 221.1797, 1390.2969, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3288, 223.1797, 1421.1875, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 133.7422, 1459.6406, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3289, 207.5391, 1371.2422, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3424, 220.6484, 1355.1875, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3424, 221.7031, 1404.5078, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3424, 210.4141, 1444.8438, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3424, 262.5078, 1465.2031, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3259, 220.6484, 1355.1875, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 133.7422, 1356.9922, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 166.7891, 1356.9922, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3256, 190.9141, 1371.7734, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 166.7891, 1392.1563, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 133.7422, 1392.1563, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 207.5391, 1371.2422, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 205.6484, 1394.1328, 10.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 205.6484, 1392.1563, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 205.6484, 1394.1328, 23.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 207.3594, 1390.5703, 19.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 206.5078, 1387.8516, 27.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 3673, 199.7578, 1397.8828, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3257, 221.5703, 1374.9688, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 221.1797, 1390.2969, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 203.9531, 1409.9141, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3674, 199.3828, 1407.1172, 35.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 204.6406, 1409.8516, 11.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 206.5078, 1404.2344, 18.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 206.5078, 1400.6563, 22.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3259, 221.7031, 1404.5078, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 207.3594, 1409.0000, 19.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3257, 223.1797, 1421.1875, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 212.0781, 1426.0313, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 166.7891, 1426.9141, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 133.7422, 1426.9141, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3255, 246.5625, 1361.2422, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3255, 246.5625, 1385.8906, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3255, 246.5625, 1410.5391, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 183.7422, 1444.8672, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3259, 210.4141, 1444.8438, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3258, 222.5078, 1444.6953, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 16086, 232.2891, 1434.4844, 13.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 3673, 192.2734, 1456.1250, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3674, 183.0391, 1455.7500, 35.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 133.7422, 1459.6406, 17.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 196.0234, 1462.0156, 10.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 198.0000, 1462.0156, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 196.0234, 1462.0156, 23.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 180.2422, 1460.3203, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 180.3047, 1461.0078, 11.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 3256, 218.2578, 1467.5391, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 199.5859, 1463.7266, 19.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 181.1563, 1463.7266, 19.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 185.9219, 1462.8750, 18.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 202.3047, 1462.8750, 27.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 189.5000, 1462.8750, 22.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3255, 246.5625, 1435.1953, 9.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 254.6797, 1451.8281, 27.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 253.8203, 1458.1094, 23.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 255.5313, 1454.5469, 19.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 253.8203, 1456.1328, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 253.8203, 1458.1094, 10.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 3259, 262.5078, 1465.2031, 9.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 254.6797, 1468.2109, 18.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 3673, 247.9297, 1461.8594, 33.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 254.6797, 1464.6328, 22.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3674, 247.5547, 1471.0938, 35.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 255.5313, 1472.9766, 19.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 252.8125, 1473.8281, 11.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 3675, 252.1250, 1473.8906, 16.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 16089, 342.1250, 1431.0938, 5.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 16090, 315.7734, 1431.0938, 5.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 16091, 289.7422, 1431.0938, 5.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 16087, 358.6797, 1430.4531, 11.6172, 0.25);
	RemoveBuildingForPlayer(playerid, 16088, 368.4297, 1431.0938, 5.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 16092, 394.1563, 1431.0938, 5.2734, 0.25);

	//  Аэропорт LS
	RemoveBuildingForPlayer(playerid, 5011, 1874.2109, -2286.5313, 17.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 3769, 1961.4453, -2216.1719, 14.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 3780, 1381.1172, -2541.3750, 14.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 3663, 1832.4531, -2388.4375, 14.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1855.7969, -2641.4063, 18.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3663, 1882.2656, -2395.7813, 14.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 5006, 1874.2109, -2286.5313, 17.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 3664, 1960.6953, -2236.4297, 19.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1954.6172, -2227.4844, 13.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1965.1719, -2227.4141, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1959.8984, -2227.4453, 13.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 3625, 1961.4453, -2216.1719, 14.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1970.4453, -2227.4141, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3665, 1381.1172, -2541.3750, 14.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 3664, 1388.0078, -2593.0000, 19.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 3664, 1388.0078, -2494.2656, 19.2813, 0.25);

	//  Работа Дальнобойщика
	RemoveBuildingForPlayer(playerid, 3377, -207.6563, -246.7344, 1.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 3377, -196.7188, -246.1641, 1.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 3377, -224.5000, -183.9063, 1.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 3377, -200.3281, -189.7344, 1.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 3377, -200.3281, -189.7344, 3.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 3377, -176.6797, -195.3594, 1.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 3377, -156.9453, -266.9141, 4.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 3377, -149.9141, -324.3438, 1.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 12932, -117.9609, -337.4531, 3.6172, 0.25);
	RemoveBuildingForPlayer(playerid, 3378, -149.9141, -324.3438, 1.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 12934, -184.5781, -289.8984, 3.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 3378, -156.9453, -266.9141, 4.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 3378, -207.6563, -246.7344, 1.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 13025, -148.9766, -228.5313, 3.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 3378, -196.7188, -246.1641, 1.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 3378, -176.6797, -195.3594, 1.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 3378, -200.3281, -189.7344, 1.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 3378, -200.3281, -189.7344, 3.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 3378, -224.5000, -183.9063, 1.5313, 0.25);
	
    allPlayers++;
	
	functioncon[playerid]++;//прибавляем 1 к контрольной переменной функций

	LevelStats[playerid] = 0;

	PGang[playerid] = 0;//Gangs system
	SetPVarInt(playerid, "PlGng", PGang[playerid]);//глобальная переменная ID банды игрока
	GangLvl[playerid] = 0;
	SetPVarInt(playerid, "PlGLvl", GangLvl[playerid]);//глобальная переменная Lvl игрока в банде

	dm[playerid] = 0;

	new ip[64];
	GetPlayerIp(playerid, ip, sizeof(ip));
	PlayerInfo[playerid][pIPAdr] = ip;
	mapiconid[playerid] = -600;//очистка ID мап иконки наблюдения
	PlayLock1[0][playerid] = 600;//отключить блокировку игрока
	NETafkPl[playerid][1] = 0;//обнулить время AFK
	LockSpawn[playerid] = 0;//разблокировать заполнение слотов оружия и предметов
	idgangsave[playerid] = 0;//очистка ID банды для записи
	prisoncount[playerid] = 0;//задержка контроля игрока в тюрьме
	oneminkick[playerid] = 0;//кик - если не заспавнился
	countdown[playerid] = -1;//очистка обратного отсчёта
	strdel(fbanreason[playerid], 0, 256);//очистка причины бана
	gPlayerLogTries[playerid] = 0;
	gPlayerLogged[playerid] = 0;
	SetPVarInt(playerid, "AdmLvl", 0);//глобальная переменная уровня админки
	SetPVarInt(playerid, "PlSkin", 0);//глобальная переменная скина игрока
	deathcon[playerid] = 0;//обнуляем контроль смерти игрока
	plcmonloc[playerid] = 0;//отключаем админу (игроку) функцию краш-монитора
	moneycontrol[playerid] = 0;//контроль денег игрока
	moneycontrol22[playerid] = 0;
	SetPVarInt(playerid, "MonControl", 0);
	scorecontrol[playerid] = 0;//контроль очков игрока
	scorecontrol22[playerid] = 0;
	SetPVarInt(playerid, "ScorControl", 0);

	NRadio[playerid] = 0;//задаём игроку несуществующий номер подключенного радио//Радио
    PlayAudioStreamForPlayer(playerid, "http://air.radiorecord.ru:8101/rr_128");

	//вход на сервер
	new string[256];
	new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, sizeof(pname));
	strdel(RealName[playerid], 0, MAX_PLAYER_NAME);//очистить реальный ник игрока
	strcat(RealName[playerid], pname);//запомнить реальный ник игрока
	format(string, sizeof(string), "» {FF0000}%s(%d) {999999}зашел навести суеты на сервер.", pname, playerid);
	SendClientMessageToAll(COLOR_WHITE, string);
	printf("» Игрок %s [%d] присоединился к серверу.", pname, playerid);
	SetPlayerColor(playerid, ColNick[6]);//присвоить игроку серый цвет (до спавна)

	locper1[playerid] = 0;
	locper2[playerid] = 0;
	while(locper1[playerid] < MAX_PLAYERS)//цикл для всех игроков
	{
		if(strcmp(PlayerInfo[playerid][pIPAdr], twoIP[locper1[playerid]], true) == 0 && strlen(twoIP[locper1[playerid]]) != 0)
		{//сравниваем IP игрока с IP вышедших игроков
			locper2[playerid] = 1;
			break;
		}
		locper1[playerid]++;
	}
	if(locper2[playerid] == 1)
	{//если игрок зашёл меньше чем через 100 миллисекунд после своего выхода, то бан чита
		format(string, sizeof(string), " IP игрока %s[%d] был забанен за чит реконнект.", RealName[playerid], playerid);
		print(string);
		SendClientMessageToAll(COLOR_ORANGE, string);
		strdel(fbanreason[playerid], 0, 256);//очистка причины бана
		strcat(fbanreason[playerid], " Чит реконнект.");
		SetTimerEx("PlayBan", 300, 0, "i", playerid);
		return 1;
	}
	locper2[playerid] = 0;
	for(new k = 0; k < MAX_PLAYERS; k++)//цикл для всех игроков
	{
		if(IsPlayerConnected(k))//дальнейшее выполняем если игрок в коннекте
		{//сравниваем IP игрока с уже "подключенными" IP
			if(strcmp(PlayerInfo[playerid][pIPAdr], PlayerInfo[k][pIPAdr], true) == 0)
			{
				locper2[playerid]++;//прибавляем 1 к контрольной переменной
			}
		}
	}
	SetPlayerFightingStyle(playerid, FIGHT_STYLE_NORMAL);//установить нормальный стиль боя
	perfrost[playerid] = 600;//отключение заморозки
	playcar[playerid] = 0;
	autorepair[playerid] = 1;
	dialogadm[playerid] = 0;//обнуляем контрольную переменную админ-меню
	dialogcon[playerid] = 0;//обнуляем контрольную переменную диалогов
	chatcon[playerid] = 0;//обнуляем контрольную переменную чата
	PlayerInfo[playerid][pAdmlive] = 0;//убрать бессмертие
	livdop[playerid] = 0;
	admper1[playerid] = 600;//переменная наблюдения 1
	admper6[playerid] = 0;//переменная наблюдения 6
	neon[playerid][0] = 0;//присваиваем неону несуществующий номер объекта
	neon[playerid][1] = 0;//присваиваем неону несуществующий номер объекта
	neon[playerid][2] = 0;//несуществующий ид транспорта с неоном
	locper2[playerid] = random(6);
	TpDestA[playerid][0] = playspax[locper2[playerid]];//установка случайных телепортов
	TpDestA[playerid][1] = playspay[locper2[playerid]];
	TpDestA[playerid][2] = playspaz[locper2[playerid]];
	TpDestA[playerid][3] = playspaa[locper2[playerid]];
	TpPosA[playerid][0] = 0;
	TpPosA[playerid][1] = 0;
	TpDestP[playerid][0] = playspax[locper2[playerid]];
	TpDestP[playerid][1] = playspay[locper2[playerid]];
	TpDestP[playerid][2] = playspaz[locper2[playerid]];
	TpDestP[playerid][3] = playspaa[locper2[playerid]];
	TpPosP[playerid][0] = 0;
	TpPosP[playerid][1] = 0;

	format(string, sizeof(string), "players/%s.ini", RealName[playerid]);
	if(fexist(string))
	{
		gPlayerAccount[playerid] = 1;
		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_INPUT, "Вход в аккаунт", "{02ED56}Добро пожаловать брат джан на {FF0000}DAGESTAN MOBILE{02ED56}.\
		\n{02ED56}Вы уже {00B000}зарегистрированы {02ED56}на нашем сервере.\nKOMM - Почувствуй себе настоящим ОПЕРОМ брат джан\n\nЧтобы войти, введите свой пароль.", "Войти", "Отмена");
		dlgcont[playerid] = 1;
	}
	else
	{
		gPlayerAccount[playerid] = 0;
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_INPUT, "Регистрация","{02ED56}Добро пожаловать брат джан на {FF0000}DAGESTAN MOBILE{02ED56}.\
		\n{02ED56}Вы не {E60000}зарегистрированы {02ED56}на нашем сервере.\nKOMM - Почувствуй себе настоящим ОПЕРОМ брат джан\n\nДля продолжения, придумайте пароль.", "Войти", "Отмена");
		dlgcont[playerid] = 0;
	}
	return 1;
}

Float:GetPlayerTheoreticAngle(i)
{
	new Float:sin;
	new Float:dis;
	new Float:angle2;
	new Float:x,Float:y,Float:z;
	new Float:tmp3;
	new Float:tmp4;
	new Float:MindAngle;
	GetPlayerPos(i,x,y,z);
	dis = floatsqroot(floatpower(floatabs(floatsub(x,ppos[i][0])),2)+floatpower(floatabs(floatsub(y,ppos[i][1])),2));
	if(IsPlayerInAnyVehicle(i))GetVehicleZAngle(GetPlayerVehicleID(i), angle2); else GetPlayerFacingAngle(i, angle2);
	if(x>ppos[i][0]){tmp3=x-ppos[i][0];}else{tmp3=ppos[i][0]-x;}
	if(y>ppos[i][1]){tmp4=y-ppos[i][1];}else{tmp4=ppos[i][1]-y;}
	if(ppos[i][1]>y && ppos[i][0]>x){
		sin = asin(tmp3/dis);
		MindAngle = floatsub(floatsub(floatadd(sin, 90), floatmul(sin, 2)), -90.0);
	}
	if(ppos[i][1]<y && ppos[i][0]>x){
		sin = asin(tmp3/dis);
		MindAngle = floatsub(floatadd(sin, 180), 180.0);
	}
	if(ppos[i][1]<y && ppos[i][0]<x){
		sin = acos(tmp4/dis);
		MindAngle = floatsub(floatadd(sin, 360), floatmul(sin, 2));
	}
	if(ppos[i][1]>y && ppos[i][0]<x){
		sin = asin(tmp3/dis);
		MindAngle = floatadd(sin, 180);
	}
	if(MindAngle == 0.0){
		return angle2;
	} else
	return MindAngle;
}

public OnPlayerDisconnect(playerid, reason)
{
	new string[256];
	format(string,sizeof(string),"» {FF0000}%s(%d) {999999}Вышел остудить резину и отдыхать от суеты,спасибо что выбрали нас брат джан.",RealName[playerid],playerid);
	switch(reason)
	{
	case 0: format(string,sizeof(string),"%s {FFFFFF}[{FF0000}Вылет или Краш{FFFFFF}]",string);
	case 1: format(string,sizeof(string),"%s {FFFFFF}[{FF0000}Выход{FFFFFF}]",string);
	case 2: format(string,sizeof(string),"%s {FFFFFF}[{FF0000}Кик/Бан{FFFFFF}]",string);
	}
	SendClientMessageToAll(COLOR_WHITE, string);
	format(string,sizeof(string),"» Игрок %s[%d] вышел с сервера.",RealName[playerid],playerid);
	switch(reason)
	{
	case 0: format(string,sizeof(string),"%s [Вылет или Краш]",string);
	case 1: format(string,sizeof(string),"%s [Выход]",string);
	case 2: format(string,sizeof(string),"%s [Кик/Бан]",string);
	}
	print(string);
	if(mapiconid[playerid] != -600)//если ID мап иконки наблюдения НЕ пустой, то:
	{
		DestroyDynamicMapIcon(mapiconid[playerid]);//удаление мап иконки наблюдения
	}
	mapiconid[playerid] = -600;//очистка ID мап иконки наблюдения

    allPlayers--;

	new Float:X, Float:Y, Float:Z;
	new Float:Xc, Float:Yc, Float:Zc, Float:ras;
	GetPlayerPos(playerid, X, Y, Z);

	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(admper1[i] == playerid)//если есть админ ведущий наблюдение за игроком, то:
			{
				TogglePlayerSpectating(i, 0);//запретить наблюдение для админа
				admper6[i] = 0;//обнуляем отметку о переключении наблюдения
				ShowPlayerDialog(i, 2, 0 ,"Информация.", "Наблюдение было автоматически отключено т.к\
				\n( игрок, за кем Вы наблюдали - вышел с сервера.)", "OK", "");
			}
			GetPlayerPos(i, Xc, Yc, Zc);
			new Float:locX, Float:locY, Float:locZ;
			locX = X - Xc;
			locY = Y - Yc;
			locZ = Z - Zc;
			if((reason == 0 || reason == 2) && playerid != i &&
					(-1000 < locX < 1000 && -1000 < locY < 1000 && -1000 < locZ < 1000))
			{
				ras = floatsqroot(floatmul(locX, locX) + floatmul(locY, locY) + floatmul(locZ, locZ));
				format(string, sizeof(string), "%f", ras);
				new dop1;
				dop1 = strval(string);
				if(reason == 0)
				{
					format(string, sizeof(string),
					" Краш-монитор - игрок ''вылетел'': %s[%d] , игрок рядом: %s[%d] , расстояние: %d",
					RealName[playerid], playerid, RealName[i], i, dop1);
				}
				if(reason == 2)
				{
					format(string, sizeof(string),
					" Краш-монитор - игрок ''кик/бан'': %s[%d] , игрок рядом: %s[%d] , расстояние: %d",
					RealName[playerid], playerid, RealName[i], i, dop1);
				}
				for(new j = 0; j < MAX_PLAYERS; j++)
				{
					if(IsPlayerConnected(j))
					{
						if(plcmonloc[j] == 1 && plcmondist[j] >= dop1)
						{
							SendClientMessage(j, 0xFF6347FF, string);
						}
					}
				}
			}
		}
	}

	for(new j = 0; j < 13; j++)
	{
		if(PlayerInfo[playerid][pPrisonsec] > 0)//если игрок в тюрьме,
		{//то: сохраняем в файле слоты оружия из вспомогательных переменных
			playweap[playerid][j] = play2weap[playerid][j];
			playammo[playerid][j] = play2ammo[playerid][j];
		}
		else//если игрок НЕ в тюрьме,
		{//то: сохраняем в файле его текущие слоты оружия
			GetPlayerWeaponData(playerid, j, playweap[playerid][j], playammo[playerid][j]);//если игрок НЕ в тюрьме,
		}
	}
	OnPlayerSaveA(playerid);//сохраняем аккаунт игрока
	if(idgangsave[playerid] > 0)
	{
		GangSave(idgangsave[playerid]);//запись ID банды в файл
	}
	TogglePlayerControllable(playerid, 1);//разморозить ид вышедшего игрока
	if(neon[playerid][0] != 0) { DestroyObject(neon[playerid][0]); }//убрать неон
	if(neon[playerid][1] != 0) { DestroyObject(neon[playerid][1]); }//убрать неон
	neon[playerid][0] = 0;//присваиваем неону несуществующий номер объекта
	neon[playerid][1] = 0;//присваиваем неону несуществующий номер объекта
	neon[playerid][2] = 0;//несуществующий ид транспорта с неоном
	if(playcar[playerid] != 0)//если у игрока есть свой транспорт, то:
	{
		for(new i = 0; i < MAX_PLAYERS; i++)//поиск и удаление чужого неона
		{
			if(playcar[playerid] == neon[i][2])
			{
				DestroyObject(neon[i][0]);//убрать неон
				DestroyObject(neon[i][1]);//убрать неон
				neon[i][0] = 0;//присваиваем неону несуществующий номер объекта
				neon[i][1] = 0;//присваиваем неону несуществующий номер объекта
				neon[i][2] = 0;//несуществующий ид транспорта с неоном
			}
		}
		DestroyVehicle(playcar[playerid]);//уничтожить свой транспорт
		playcar[playerid] = 0;//несуществующий ид транспорта
	}

	NRadio[playerid] = 0;//задаём игроку несуществующий номер подключенного радио
	StopAudioStreamForPlayer(playerid);//отключим любой поток

	TextDrawHideForPlayer(playerid, TScore[playerid]);
	SetPlayerFightingStyle(playerid, FIGHT_STYLE_NORMAL);//установить нормальный стиль боя
	moneycontrol[playerid] = 0;//контроль денег игрока
	moneycontrol22[playerid] = 0;
	DeletePVar(playerid, "MonControl");
	scorecontrol[playerid] = 0;//контроль очков игрока
	scorecontrol22[playerid] = 0;
	DeletePVar(playerid, "ScorControl");
	plcmonloc[playerid] = 0;//отключаем админу (игроку) функцию краш-монитора
	deathcon[playerid] = 0;//обнуляем контроль смерти игрока
	DeletePVar(playerid, "PlSkin");//удаляем глобальную переменную скина игрока
	gPlayerLogged[playerid] = 0;//запретить запись аккаунта
	playspa[playerid] = 0;//переменная спавна игрока
	dlgcont[playerid] = -600;//не существующий ИД диалога
	countdown[playerid] = -1;//очистка обратного отсчёта
	oneminkick[playerid] = 0;//кик - если не заспавнился
	prisoncount[playerid] = 0;//задержка контроля игрока в тюрьме
	DeletePVar(playerid, "AdmLvl");//удаляем глобальную переменную уровня админки
	DeletePVar(playerid, "PlGLvl");//удаляем глобальную переменную Lvl игрока в банде
	DeletePVar(playerid, "PlGng");//удаляем глобальную переменную ID банды игрока
	DeletePVar(playerid, "CComAc0");//удаляем глобальные переменные контроля чата
	DeletePVar(playerid, "CComAc1");
	DeletePVar(playerid, "CComAc2");
	DeletePVar(playerid, "CComAc3");
	DeletePVar(playerid, "CComAc4");
	DeletePVar(playerid, "CComAc5");
	DeletePVar(playerid, "CComAc6");
	DeletePVar(playerid, "CComAc7");
	DeletePVar(playerid, "CComAc8");
	DeletePVar(playerid, "CComAc9");
	DeletePVar(playerid, "CComAc10");
	DeletePVar(playerid, "CComAc11");
	DeletePVar(playerid, "CComAc12");
	DeletePVar(playerid, "CComAc13");
	DeletePVar(playerid, "CComAc14");
	DeletePVar(playerid, "CComAc15");
	strdel(RealName[playerid], 0, MAX_PLAYER_NAME);//очистить реальный ник игрока
	dialogadm[playerid] = 0;//обнуляем контрольную переменную админ-меню
	dialogcon[playerid] = 0;//обнуляем контрольную переменную диалогов
	functioncon[playerid] = 0;//обнуляем контрольную переменную функций
	chatcon[playerid] = 0;//обнуляем контрольную переменную чата
	strdel(fbanreason[playerid], 0, 256);//очистка причины бана
	LockSpawn[playerid] = 0;//разблокировать заполнение слотов оружия и предметов
	NETafkPl[playerid][1] = 0;//обнулить время AFK
	PlayLock1[0][playerid] = 600;//отключить блокировку игрока
	PlayerInfo[playerid][pMinlog] = 0;//обнулить число минут на сервере
	PlayerInfo[playerid][pAdmlive] = 0;//обнулить бессмертие
	livdop[playerid] = 0;
	PlayerInfo[playerid][pAdmin] = 0;//обнулить админку
	PlayerInfo[playerid][pAdmshad] = 0;//обнулить скрытость админа
	if(SnowONOFF[playerid] == 1)//если на сервере ядерный взрыв, то:
	{//удаляем объект снега
		DestroyPlayerObject(playerid, snowobj[playerid]);
		SnowONOFF[playerid] = 0;
	}
	strdel(twoIP[playerid], 0, 64);//запоминаем IP вышедшего игрока на 100 миллисекунд
	strcat(twoIP[playerid], PlayerInfo[playerid][pIPAdr]);
	SetTimerEx("ClearIP", 100, 0, "i", playerid);
	SetTimerEx("OutOut", 300, 0, "i", playerid);//задержка, на время записи аккаунта банды
	return 1;
}

forward OutOut(playerid);//Gangs system
public OutOut(playerid)
{
	if(idgangsave[playerid] > 0)//если ID банды для записи - активен, то:
	{
		idgangsave[playerid] = 0;//очистка ID банды для записи
		locper3[playerid] = 0;
		while(locper3[playerid] < MAX_PLAYERS)//цикл для всех игроков
		{
			if(PGang[playerid] > 0 && PGang[playerid] == PGang[locper3[playerid]] && playerid != locper3[playerid])
			{//если есть хотя бы один игрок из банды выходящего, то:
				idgangsave[locper3[playerid]] = PGang[playerid];
				break;
			}
			locper3[playerid]++;
		}
	}
	idgangsave[playerid] = 0;//очистка ID банды для записи

	PGang[playerid] = 0;
	GangLvl[playerid] = 0;
	return 1;
}

forward ClearIP(playerid);
public ClearIP(playerid)
{
	strdel(twoIP[playerid], 0, 64);
	return 1;
}

forward OnPlayerRegister(playerid, password[]);
public OnPlayerRegister(playerid, password[])
{
	if(IsPlayerConnected(playerid))
	{
		strdel(PlayerInfo[playerid][pTDReg], 0, 64);//очистка времени и даты регистрации
		gettime(timedata[0], timedata[1]);
		getdate(timedata[2], timedata[3], timedata[4]);
		format(PlayerInfo[playerid][pTDReg], 64, "%02d:%02d - %02d/%02d/%04d", timedata[0], timedata[1],
		timedata[4], timedata[3], timedata[2]);
		new file, string3[64];
		format(string3, sizeof(string3), "players/%s.ini", RealName[playerid]);//реальный ник игрока
		file = ini_createFile(string3);
		if(file == INI_OK)
		{
			strmid(PlayerInfo[playerid][pKey], password, 0, strlen(password), 64);
			PlayerInfo[playerid][pReg] = 0;
			ini_setString(file, "Key", PlayerInfo[playerid][pKey]);
			ini_setString(file, "TDReg", PlayerInfo[playerid][pTDReg]);
			ini_setString(file, "IPAdr", PlayerInfo[playerid][pIPAdr]);
			ini_setInteger(file, "MinLog", 0);
			ini_setInteger(file, "AdminLevel", 0);
			ini_setInteger(file, "AdminShadow", 0);
			ini_setInteger(file, "AdminLive", 0);
			ini_setInteger(file, "Registered", PlayerInfo[playerid][pReg]);
			ini_setInteger(file, "Prison", 0);
			ini_setInteger(file, "Prisonsec", 0);
			ini_setInteger(file, "Muted", 0);
			ini_setInteger(file, "Mutedsec", 0);
			ini_setInteger(file, "Money", 0);
			ini_setInteger(file, "Score", 0);
			ini_setInteger(file, "Kills", 0);
			ini_setInteger(file, "Deaths", 0);
			ini_setInteger(file, "Lock", 0);
			ini_setFloat(file, "Cord_X", 0.00);
			ini_setFloat(file, "Cord_Y", 0.00);
			ini_setFloat(file, "Cord_Z", 0.00);
			ini_setFloat(file, "Angle", 0.00);
			ini_setInteger(file, "Weapon_slot0", 0);
			ini_setInteger(file, "Weapon_slot1", 0);
			ini_setInteger(file, "Weapon_slot2", 0);
			ini_setInteger(file, "Weapon_slot3", 0);
			ini_setInteger(file, "Weapon_slot4", 0);
			ini_setInteger(file, "Weapon_slot5", 0);
			ini_setInteger(file, "Weapon_slot6", 0);
			ini_setInteger(file, "Weapon_slot7", 0);
			ini_setInteger(file, "Weapon_slot8", 0);
			ini_setInteger(file, "Weapon_slot9", 0);
			ini_setInteger(file, "Weapon_slot10", 0);
			ini_setInteger(file, "Weapon_slot11", 0);
			ini_setInteger(file, "Weapon_slot12", 0);
			ini_setInteger(file, "Ammo_slot0", 0);
			ini_setInteger(file, "Ammo_slot1", 0);
			ini_setInteger(file, "Ammo_slot2", 0);
			ini_setInteger(file, "Ammo_slot3", 0);
			ini_setInteger(file, "Ammo_slot4", 0);
			ini_setInteger(file, "Ammo_slot5", 0);
			ini_setInteger(file, "Ammo_slot6", 0);
			ini_setInteger(file, "Ammo_slot7", 0);
			ini_setInteger(file, "Ammo_slot8", 0);
			ini_setInteger(file, "Ammo_slot9", 0);
			ini_setInteger(file, "Ammo_slot10", 0);
			ini_setInteger(file, "Ammo_slot11", 0);
			ini_setInteger(file, "Ammo_slot12", 0);
			ini_setInteger(file, "Frac1", 0);
			ini_setInteger(file, "FracLvl1", 0);
			ini_setFloat(file, "FracCord_X1", 0.00);
			ini_setFloat(file, "FracCord_Y1", 0.00);
			ini_setFloat(file, "FracCord_Z1", 0.00);
			ini_setFloat(file, "FracAngle1", 0.00);
			ini_setString(file, "FracTxt1", "");
			ini_setInteger(file, "Frac2", 0);
			ini_setInteger(file, "FracLvl2", 0);
			ini_setFloat(file, "FracCord_X2", 0.00);
			ini_setFloat(file, "FracCord_Y2", 0.00);
			ini_setFloat(file, "FracCord_Z2", 0.00);
			ini_setFloat(file, "FracAngle2", 0.00);
			ini_setString(file, "FracTxt2", "");
			ini_setInteger(file, "Frac3", 0);
			ini_setInteger(file, "FracLvl3", 0);
			ini_setFloat(file, "FracCord_X3", 0.00);
			ini_setFloat(file, "FracCord_Y3", 0.00);
			ini_setFloat(file, "FracCord_Z3", 0.00);
			ini_setFloat(file, "FracAngle3", 0.00);
			ini_setString(file, "FracTxt3", "");
			ini_setInteger(file, "Frac4", 0);
			ini_setInteger(file, "FracLvl4", 0);
			ini_setFloat(file, "FracCord_X4", 0.00);
			ini_setFloat(file, "FracCord_Y4", 0.00);
			ini_setFloat(file, "FracCord_Z4", 0.00);
			ini_setFloat(file, "FracAngle4", 0.00);
			ini_setString(file, "FracTxt4", "");
			ini_setInteger(file, "Frac5", 0);
			ini_setInteger(file, "FracLvl5", 0);
			ini_setFloat(file, "FracCord_X5", 0.00);
			ini_setFloat(file, "FracCord_Y5", 0.00);
			ini_setFloat(file, "FracCord_Z5", 0.00);
			ini_setFloat(file, "FracAngle5", 0.00);
			ini_setString(file, "FracTxt5", "");
			ini_setInteger(file, "Frac6", 0);
			ini_setInteger(file, "FracLvl6", 0);
			ini_setFloat(file, "FracCord_X6", 0.00);
			ini_setFloat(file, "FracCord_Y6", 0.00);
			ini_setFloat(file, "FracCord_Z6", 0.00);
			ini_setFloat(file, "FracAngle6", 0.00);
			ini_setString(file, "FracTxt6", "");
			ini_closeFile(file);
		}
		ac_1{playerid} = false;
		printf("* Игрок %s [%d] --> (регистрация, пароль: (%s)) .", RealName[playerid], playerid, password);
		gPlayerAccount[playerid] = 1;
		OnPlayerLogin(playerid, password);
	}
	return 1;
}

forward OnPlayerSaveA(playerid);
public OnPlayerSaveA(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(gPlayerLogged[playerid])
		{
			new file, string3[64];
			format(string3, sizeof(string3), "players/%s.ini", RealName[playerid]);//реальный ник игрока
			file = ini_openFile(string3);
			if(file == INI_OK)
			{
				ini_setString(file, "Key", PlayerInfo[playerid][pKey]);
				ini_setString(file, "TDReg", PlayerInfo[playerid][pTDReg]);
				ini_setString(file, "IPAdr", PlayerInfo[playerid][pIPAdr]);
				ini_setInteger(file, "MinLog", PlayerInfo[playerid][pMinlog]);
				ini_setInteger(file, "AdminLevel", PlayerInfo[playerid][pAdmin]);
				ini_setInteger(file, "AdminShadow", PlayerInfo[playerid][pAdmshad]);
				ini_setInteger(file, "AdminLive", PlayerInfo[playerid][pAdmlive]);
				ini_setInteger(file, "Registered", PlayerInfo[playerid][pReg]);
				ini_setInteger(file, "Prison", PlayerInfo[playerid][pPrison]);
				ini_setInteger(file, "Prisonsec", PlayerInfo[playerid][pPrisonsec]);
				ini_setInteger(file, "Muted", PlayerInfo[playerid][pMuted]);
				ini_setInteger(file, "Mutedsec", PlayerInfo[playerid][pMutedsec]);
				if(moneycontrol22[playerid] == 0)
				{
					if(GetPlayerMoney(playerid) > 999999999)
					{
						ini_setInteger(file, "Money", 999999999);
					}
					else
					{
						ini_setInteger(file, "Money", GetPlayerMoney(playerid));
					}
				}
				else
				{
					if(moneycontrol[playerid] > 999999999)
					{
						ini_setInteger(file, "Money", 999999999);
					}
					else
					{
						ini_setInteger(file, "Money", moneycontrol[playerid]);
					}
				}
				if(scorecontrol22[playerid] == 0)
				{
					ini_setInteger(file, "Score", GetPlayerScore(playerid));
				}
				else
				{
					ini_setInteger(file, "Score", scorecontrol[playerid]);
				}
				ini_setInteger(file, "Kills", PlayerInfo[playerid][pKills]);
				ini_setInteger(file, "Deaths", PlayerInfo[playerid][pDeaths]);
				ini_setInteger(file, "Lock", PlayerInfo[playerid][pLock]);
				ini_setFloat(file, "Cord_X", PlayerInfo[playerid][pCordX]);
				ini_setFloat(file, "Cord_Y", PlayerInfo[playerid][pCordY]);
				ini_setFloat(file, "Cord_Z", PlayerInfo[playerid][pCordZ]);
				ini_setFloat(file, "Angle", PlayerInfo[playerid][pAngle]);
				ini_setInteger(file, "Weapon_slot0", playweap[playerid][0]);
				ini_setInteger(file, "Weapon_slot1", playweap[playerid][1]);
				ini_setInteger(file, "Weapon_slot2", playweap[playerid][2]);
				ini_setInteger(file, "Weapon_slot3", playweap[playerid][3]);
				ini_setInteger(file, "Weapon_slot4", playweap[playerid][4]);
				ini_setInteger(file, "Weapon_slot5", playweap[playerid][5]);
				ini_setInteger(file, "Weapon_slot6", playweap[playerid][6]);
				ini_setInteger(file, "Weapon_slot7", playweap[playerid][7]);
				ini_setInteger(file, "Weapon_slot8", playweap[playerid][8]);
				ini_setInteger(file, "Weapon_slot9", playweap[playerid][9]);
				ini_setInteger(file, "Weapon_slot10", playweap[playerid][10]);
				ini_setInteger(file, "Weapon_slot11", playweap[playerid][11]);
				ini_setInteger(file, "Weapon_slot12", playweap[playerid][12]);
				ini_setInteger(file, "Ammo_slot0", playammo[playerid][0]);
				ini_setInteger(file, "Ammo_slot1", playammo[playerid][1]);
				ini_setInteger(file, "Ammo_slot2", playammo[playerid][2]);
				ini_setInteger(file, "Ammo_slot3", playammo[playerid][3]);
				ini_setInteger(file, "Ammo_slot4", playammo[playerid][4]);
				ini_setInteger(file, "Ammo_slot5", playammo[playerid][5]);
				ini_setInteger(file, "Ammo_slot6", playammo[playerid][6]);
				ini_setInteger(file, "Ammo_slot7", playammo[playerid][7]);
				ini_setInteger(file, "Ammo_slot8", playammo[playerid][8]);
				ini_setInteger(file, "Ammo_slot9", playammo[playerid][9]);
				ini_setInteger(file, "Ammo_slot10", playammo[playerid][10]);
				ini_setInteger(file, "Ammo_slot11", playammo[playerid][11]);
				ini_setInteger(file, "Ammo_slot12", playammo[playerid][12]);
				//				ini_setInteger(file, "Frac1", PlayerInfo[playerid][pFrac1]);
				//				ini_setInteger(file, "FracLvl1", PlayerInfo[playerid][pFracLvl1]);
				ini_setInteger(file, "Frac1", PGang[playerid]);
				ini_setInteger(file, "FracLvl1", GangLvl[playerid]);
				ini_setFloat(file, "FracCord_X1", PlayerInfo[playerid][pFracCordX1]);
				ini_setFloat(file, "FracCord_Y1", PlayerInfo[playerid][pFracCordY1]);
				ini_setFloat(file, "FracCord_Z1", PlayerInfo[playerid][pFracCordZ1]);
				ini_setFloat(file, "FracAngle1", PlayerInfo[playerid][pFracAngle1]);
				ini_setString(file, "FracTxt1", PlayerInfo[playerid][pFracTxt1]);
				ini_setInteger(file, "Frac2", PlayerInfo[playerid][pFrac2]);
				ini_setInteger(file, "FracLvl2", PlayerInfo[playerid][pFracLvl2]);
				ini_setFloat(file, "FracCord_X2", PlayerInfo[playerid][pFracCordX2]);
				ini_setFloat(file, "FracCord_Y2", PlayerInfo[playerid][pFracCordY2]);
				ini_setFloat(file, "FracCord_Z2", PlayerInfo[playerid][pFracCordZ2]);
				ini_setFloat(file, "FracAngle2", PlayerInfo[playerid][pFracAngle2]);
				ini_setString(file, "FracTxt2", PlayerInfo[playerid][pFracTxt2]);
				ini_setInteger(file, "Frac3", PlayerInfo[playerid][pFrac3]);
				ini_setInteger(file, "FracLvl3", PlayerInfo[playerid][pFracLvl3]);
				ini_setFloat(file, "FracCord_X3", PlayerInfo[playerid][pFracCordX3]);
				ini_setFloat(file, "FracCord_Y3", PlayerInfo[playerid][pFracCordY3]);
				ini_setFloat(file, "FracCord_Z3", PlayerInfo[playerid][pFracCordZ3]);
				ini_setFloat(file, "FracAngle3", PlayerInfo[playerid][pFracAngle3]);
				ini_setString(file, "FracTxt3", PlayerInfo[playerid][pFracTxt3]);
				ini_setInteger(file, "Frac4", PlayerInfo[playerid][pFrac4]);
				ini_setInteger(file, "FracLvl4", PlayerInfo[playerid][pFracLvl4]);
				ini_setFloat(file, "FracCord_X4", PlayerInfo[playerid][pFracCordX4]);
				ini_setFloat(file, "FracCord_Y4", PlayerInfo[playerid][pFracCordY4]);
				ini_setFloat(file, "FracCord_Z4", PlayerInfo[playerid][pFracCordZ4]);
				ini_setFloat(file, "FracAngle4", PlayerInfo[playerid][pFracAngle4]);
				ini_setString(file, "FracTxt4", PlayerInfo[playerid][pFracTxt4]);
				ini_setInteger(file, "Frac5", PlayerInfo[playerid][pFrac5]);
				ini_setInteger(file, "FracLvl5", PlayerInfo[playerid][pFracLvl5]);
				ini_setFloat(file, "FracCord_X5", PlayerInfo[playerid][pFracCordX5]);
				ini_setFloat(file, "FracCord_Y5", PlayerInfo[playerid][pFracCordY5]);
				ini_setFloat(file, "FracCord_Z5", PlayerInfo[playerid][pFracCordZ5]);
				ini_setFloat(file, "FracAngle5", PlayerInfo[playerid][pFracAngle5]);
				ini_setString(file, "FracTxt5", PlayerInfo[playerid][pFracTxt5]);
				ini_setInteger(file, "Frac6", PlayerInfo[playerid][pFrac6]);
				ini_setInteger(file, "FracLvl6", PlayerInfo[playerid][pFracLvl6]);
				ini_setFloat(file, "FracCord_X6", PlayerInfo[playerid][pFracCordX6]);
				ini_setFloat(file, "FracCord_Y6", PlayerInfo[playerid][pFracCordY6]);
				ini_setFloat(file, "FracCord_Z6", PlayerInfo[playerid][pFracCordZ6]);
				ini_setFloat(file, "FracAngle6", PlayerInfo[playerid][pFracAngle6]);
				ini_setString(file, "FracTxt6", PlayerInfo[playerid][pFracTxt6]);
				ini_closeFile(file);
			}
		}
	}
	return 1;
}

forward OnPlayerLogin(playerid, password[]);
public OnPlayerLogin(playerid, password[])
{
	new string[256];
	new file, string3[64], locper, locper22[64];
	format(string3, sizeof(string3), "players/%s.ini", RealName[playerid]);//реальный ник игрока
	file = ini_openFile(string3);
	if(file == INI_OK)
	{
		ini_getString(file, "Key", locper22);
		strmid(PlayerInfo[playerid][pKey], locper22, 0, strlen(locper22), 64);
		if(strcmp(PlayerInfo[playerid][pKey], password, false) == 0 && strlen(PlayerInfo[playerid][pKey]) != 0)
		{
			ini_getString(file, "TDReg", locper22);
			strmid(PlayerInfo[playerid][pTDReg], locper22, 0, strlen(locper22), 64);
			ini_getString(file, "IPAdr", locper22);
			strmid(PlayerInfo[playerid][pIPAdr], locper22, 0, strlen(locper22), 64);
			ini_getInteger(file, "MinLog", PlayerInfo[playerid][pMinlog]);
			ini_getInteger(file, "AdminLevel", PlayerInfo[playerid][pAdmin]);
			ini_getInteger(file, "AdminShadow", PlayerInfo[playerid][pAdmshad]);
			ini_getInteger(file, "AdminLive", PlayerInfo[playerid][pAdmlive]);
			ini_getInteger(file, "Registered", PlayerInfo[playerid][pReg]);
			ini_getInteger(file, "Prison", PlayerInfo[playerid][pPrison]);
			ini_getInteger(file, "Prisonsec", PlayerInfo[playerid][pPrisonsec]);
			ini_getInteger(file, "Muted", PlayerInfo[playerid][pMuted]);
			ini_getInteger(file, "Mutedsec", PlayerInfo[playerid][pMutedsec]);
			ini_getInteger(file, "Money", locper);
			if(locper > 999999999) { locper = 999999999; }
			SetPVarInt(playerid, "MonControl", 1);
			ResetPlayerMoney(playerid);
			GivePlayerMoney(playerid, locper);
			ini_getInteger(file, "Score", locper);
			SetPVarInt(playerid, "ScorControl", 1);
			SetPlayerScore(playerid, locper);
			ini_getInteger(file, "Kills", PlayerInfo[playerid][pKills]);
			ini_getInteger(file, "Deaths", PlayerInfo[playerid][pDeaths]);
			ini_getInteger(file, "Lock", PlayerInfo[playerid][pLock]);
			ini_getFloat(file, "Cord_X", PlayerInfo[playerid][pCordX]);
			ini_getFloat(file, "Cord_Y", PlayerInfo[playerid][pCordY]);
			ini_getFloat(file, "Cord_Z", PlayerInfo[playerid][pCordZ]);
			ini_getFloat(file, "Angle", PlayerInfo[playerid][pAngle]);
			ini_getInteger(file, "Weapon_slot0", play2weap[playerid][0]);
			ini_getInteger(file, "Weapon_slot1", play2weap[playerid][1]);
			ini_getInteger(file, "Weapon_slot2", play2weap[playerid][2]);
			ini_getInteger(file, "Weapon_slot3", play2weap[playerid][3]);
			ini_getInteger(file, "Weapon_slot4", play2weap[playerid][4]);
			ini_getInteger(file, "Weapon_slot5", play2weap[playerid][5]);
			ini_getInteger(file, "Weapon_slot6", play2weap[playerid][6]);
			ini_getInteger(file, "Weapon_slot7", play2weap[playerid][7]);
			ini_getInteger(file, "Weapon_slot8", play2weap[playerid][8]);
			ini_getInteger(file, "Weapon_slot9", play2weap[playerid][9]);
			ini_getInteger(file, "Weapon_slot10", play2weap[playerid][10]);
			ini_getInteger(file, "Weapon_slot11", play2weap[playerid][11]);
			ini_getInteger(file, "Weapon_slot12", play2weap[playerid][12]);
			ini_getInteger(file, "Ammo_slot0", play2ammo[playerid][0]);
			ini_getInteger(file, "Ammo_slot1", play2ammo[playerid][1]);
			ini_getInteger(file, "Ammo_slot2", play2ammo[playerid][2]);
			ini_getInteger(file, "Ammo_slot3", play2ammo[playerid][3]);
			ini_getInteger(file, "Ammo_slot4", play2ammo[playerid][4]);
			ini_getInteger(file, "Ammo_slot5", play2ammo[playerid][5]);
			ini_getInteger(file, "Ammo_slot6", play2ammo[playerid][6]);
			ini_getInteger(file, "Ammo_slot7", play2ammo[playerid][7]);
			ini_getInteger(file, "Ammo_slot8", play2ammo[playerid][8]);
			ini_getInteger(file, "Ammo_slot9", play2ammo[playerid][9]);
			ini_getInteger(file, "Ammo_slot10", play2ammo[playerid][10]);
			ini_getInteger(file, "Ammo_slot11", play2ammo[playerid][11]);
			ini_getInteger(file, "Ammo_slot12", play2ammo[playerid][12]);
			//			ini_getInteger(file, "Frac1", PlayerInfo[playerid][pFrac1]);
			//			ini_getInteger(file, "FracLvl1", PlayerInfo[playerid][pFracLvl1]);
			ini_getInteger(file, "Frac1", PGang[playerid]);
			ini_getInteger(file, "FracLvl1", GangLvl[playerid]);
			ini_getFloat(file, "FracCord_X1", PlayerInfo[playerid][pFracCordX1]);
			ini_getFloat(file, "FracCord_Y1", PlayerInfo[playerid][pFracCordY1]);
			ini_getFloat(file, "FracCord_Z1", PlayerInfo[playerid][pFracCordZ1]);
			ini_getFloat(file, "FracAngle1", PlayerInfo[playerid][pFracAngle1]);
			ini_getString(file, "FracTxt1", locper22);
			strmid(PlayerInfo[playerid][pFracTxt1], locper22, 0, strlen(locper22), 64);
			ini_getInteger(file, "Frac2", PlayerInfo[playerid][pFrac2]);
			ini_getInteger(file, "FracLvl2", PlayerInfo[playerid][pFracLvl2]);
			ini_getFloat(file, "FracCord_X2", PlayerInfo[playerid][pFracCordX2]);
			ini_getFloat(file, "FracCord_Y2", PlayerInfo[playerid][pFracCordY2]);
			ini_getFloat(file, "FracCord_Z2", PlayerInfo[playerid][pFracCordZ2]);
			ini_getFloat(file, "FracAngle2", PlayerInfo[playerid][pFracAngle2]);
			ini_getString(file, "FracTxt2", locper22);
			strmid(PlayerInfo[playerid][pFracTxt2], locper22, 0, strlen(locper22), 64);
			ini_getInteger(file, "Frac3", PlayerInfo[playerid][pFrac3]);
			ini_getInteger(file, "FracLvl3", PlayerInfo[playerid][pFracLvl3]);
			ini_getFloat(file, "FracCord_X3", PlayerInfo[playerid][pFracCordX3]);
			ini_getFloat(file, "FracCord_Y3", PlayerInfo[playerid][pFracCordY3]);
			ini_getFloat(file, "FracCord_Z3", PlayerInfo[playerid][pFracCordZ3]);
			ini_getFloat(file, "FracAngle3", PlayerInfo[playerid][pFracAngle3]);
			ini_getString(file, "FracTxt3", locper22);
			strmid(PlayerInfo[playerid][pFracTxt3], locper22, 0, strlen(locper22), 64);
			ini_getInteger(file, "Frac4", PlayerInfo[playerid][pFrac4]);
			ini_getInteger(file, "FracLvl4", PlayerInfo[playerid][pFracLvl4]);
			ini_getFloat(file, "FracCord_X4", PlayerInfo[playerid][pFracCordX4]);
			ini_getFloat(file, "FracCord_Y4", PlayerInfo[playerid][pFracCordY4]);
			ini_getFloat(file, "FracCord_Z4", PlayerInfo[playerid][pFracCordZ4]);
			ini_getFloat(file, "FracAngle4", PlayerInfo[playerid][pFracAngle4]);
			ini_getString(file, "FracTxt4", locper22);
			strmid(PlayerInfo[playerid][pFracTxt4], locper22, 0, strlen(locper22), 64);
			ini_getInteger(file, "Frac5", PlayerInfo[playerid][pFrac5]);
			ini_getInteger(file, "FracLvl5", PlayerInfo[playerid][pFracLvl5]);
			ini_getFloat(file, "FracCord_X5", PlayerInfo[playerid][pFracCordX5]);
			ini_getFloat(file, "FracCord_Y5", PlayerInfo[playerid][pFracCordY5]);
			ini_getFloat(file, "FracCord_Z5", PlayerInfo[playerid][pFracCordZ5]);
			ini_getFloat(file, "FracAngle5", PlayerInfo[playerid][pFracAngle5]);
			ini_getString(file, "FracTxt5", locper22);
			strmid(PlayerInfo[playerid][pFracTxt5], locper22, 0, strlen(locper22), 64);
			ini_getInteger(file, "Frac6", PlayerInfo[playerid][pFrac6]);
			ini_getInteger(file, "FracLvl6", PlayerInfo[playerid][pFracLvl6]);
			ini_getFloat(file, "FracCord_X6", PlayerInfo[playerid][pFracCordX6]);
			ini_getFloat(file, "FracCord_Y6", PlayerInfo[playerid][pFracCordY6]);
			ini_getFloat(file, "FracCord_Z6", PlayerInfo[playerid][pFracCordZ6]);
			ini_getFloat(file, "FracAngle6", PlayerInfo[playerid][pFracAngle6]);
			ini_getString(file, "FracTxt6", locper22);
			strmid(PlayerInfo[playerid][pFracTxt6], locper22, 0, strlen(locper22), 64);
			ini_closeFile(file);
		}
		else
		{
			ini_closeFile(file);
			format(string, sizeof(string), "{E60000}Вы ввели неправильный пароль!\n\n{02ED56}Аккаунт: {FF0000}%s\n\n{02ED56}Попробуйте еще раз:", RealName[playerid]);
			ShowPlayerDialog(playerid, 3, DIALOG_STYLE_INPUT, "Вход в аккаунт", string, "Вход", "Отмена");
			dlgcont[playerid] = 3;
			gPlayerLogTries[playerid] += 1;
			if(gPlayerLogTries[playerid] == 10)
			{
				format(string, sizeof(string), " IP игрока %s[%d] был забанен - попытка взлома аккаунта!", RealName[playerid], playerid);
				print(string);
				SendClientMessageToAll(COLOR_RED, string);
				strdel(fbanreason[playerid], 0, 256);//очистка причины бана
				strcat(fbanreason[playerid], " Попытка взлома аккаунта.");
				SetTimerEx("PlayBan", 300, 0, "i", playerid);
			}
			return 1;
		}
	}
	ac_1{playerid} = false;
	printf("* Игрок %s[%d] --> (логирование).", RealName[playerid], playerid);

	if(PlayerInfo[playerid][pLock] == 1)
	{
		format(string, sizeof(string), " Игрок %s[%d] был кикнут - аккаунт заблокирован!", RealName[playerid], playerid);
		print(string);
		SendClientMessageToAll(COLOR_RED, string);
		SendClientMessage(playerid, COLOR_RED, " Для выяснения причин свяжитесь с администрацией сервера!");
		SetTimerEx("PlayKick", 300, 0, "i", playerid);
		return 1;
	}
	if(PlayerInfo[playerid][pReg] == 0)
	{
		PlayerInfo[playerid][pMinlog] = 0;
		PlayerInfo[playerid][pAdmin] = 0;
		PlayerInfo[playerid][pAdmshad] = 0;
		PlayerInfo[playerid][pAdmlive] = 0;
		livdop[playerid] = 0;
		PlayerInfo[playerid][pReg] = 1;
		PlayerInfo[playerid][pPrison] = 0;
		PlayerInfo[playerid][pPrisonsec] = 0;
		PlayerInfo[playerid][pMuted] = 0;
		PlayerInfo[playerid][pMutedsec] = 0;
		SetPVarInt(playerid, "MonControl", 1);
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, 1000);
		SetPVarInt(playerid, "ScorControl", 1);
		SetPlayerScore(playerid, 0);
		PlayerInfo[playerid][pKills] = 0;
		PlayerInfo[playerid][pDeaths] = 0;
		PlayerInfo[playerid][pLock] = 0;
		PlayerInfo[playerid][pCordX] = 0.00;
		PlayerInfo[playerid][pCordY] = 0.00;
		PlayerInfo[playerid][pCordZ] = 3.50;
		PlayerInfo[playerid][pAngle] = 0.00;
		for(new i = 0; i < 13; i++)//обнуление слотов оружия
		{
			playweap[playerid][i] = 0;
			playammo[playerid][i] = 0;
		}
		//		PlayerInfo[playerid][pFrac1] = 0;
		//		PlayerInfo[playerid][pFracLvl1] = 0;
		PlayerInfo[playerid][pFracCordX1] = 0.00;
		PlayerInfo[playerid][pFracCordY1] = 0.00;
		PlayerInfo[playerid][pFracCordZ1] = 3.50;
		PlayerInfo[playerid][pFracAngle1] = 0.00;
		strdel(PlayerInfo[playerid][pFracTxt1], 0, 64);
		PlayerInfo[playerid][pFrac2] = 0;
		PlayerInfo[playerid][pFracLvl2] = 0;
		PlayerInfo[playerid][pFracCordX2] = 0.00;
		PlayerInfo[playerid][pFracCordY2] = 0.00;
		PlayerInfo[playerid][pFracCordZ2] = 3.50;
		PlayerInfo[playerid][pFracAngle2] = 0.00;
		strdel(PlayerInfo[playerid][pFracTxt2], 0, 64);
		PlayerInfo[playerid][pFrac3] = 0;
		PlayerInfo[playerid][pFracLvl3] = 0;
		PlayerInfo[playerid][pFracCordX3] = 0.00;
		PlayerInfo[playerid][pFracCordY3] = 0.00;
		PlayerInfo[playerid][pFracCordZ3] = 3.50;
		PlayerInfo[playerid][pFracAngle3] = 0.00;
		strdel(PlayerInfo[playerid][pFracTxt3], 0, 64);
		PlayerInfo[playerid][pFrac4] = 0;
		PlayerInfo[playerid][pFracLvl4] = 0;
		PlayerInfo[playerid][pFracCordX4] = 0.00;
		PlayerInfo[playerid][pFracCordY4] = 0.00;
		PlayerInfo[playerid][pFracCordZ4] = 3.50;
		PlayerInfo[playerid][pFracAngle4] = 0.00;
		strdel(PlayerInfo[playerid][pFracTxt4], 0, 64);
		PlayerInfo[playerid][pFrac5] = 0;
		PlayerInfo[playerid][pFracLvl5] = 0;
		PlayerInfo[playerid][pFracCordX5] = 0.00;
		PlayerInfo[playerid][pFracCordY5] = 0.00;
		PlayerInfo[playerid][pFracCordZ5] = 3.50;
		PlayerInfo[playerid][pFracAngle5] = 0.00;
		strdel(PlayerInfo[playerid][pFracTxt5], 0, 64);
		PlayerInfo[playerid][pFrac6] = 0;
		PlayerInfo[playerid][pFracLvl6] = 0;
		PlayerInfo[playerid][pFracCordX6] = 0.00;
		PlayerInfo[playerid][pFracCordY6] = 0.00;
		PlayerInfo[playerid][pFracCordZ6] = 3.50;
		PlayerInfo[playerid][pFracAngle6] = 0.00;
		strdel(PlayerInfo[playerid][pFracTxt6], 0, 64);
	}
	if(PlayerInfo[playerid][pPrisonsec] == 1){PlayerInfo[playerid][pPrisonsec] = 2;}
	if(PlayerInfo[playerid][pMutedsec] == 1){PlayerInfo[playerid][pMutedsec] = 2;}
	if(PlayerInfo[playerid][pAdmin] < 0)
	{
		dopadm[playerid] = PlayerInfo[playerid][pAdmin] * -1;
	}
	else
	{
		dopadm[playerid] = PlayerInfo[playerid][pAdmin];
	}
	if(dopadm[playerid] == 0 && (PlayerInfo[playerid][pAdmshad] == 1 || PlayerInfo[playerid][pAdmlive] == 1))
	{
		PlayerInfo[playerid][pAdmshad] = 0;
		PlayerInfo[playerid][pAdmlive] = 0;
	}
	if(dopadm[playerid] > 0)
	{
		format(string, sizeof(string), "» Админка {EB8D00}%d {FFFFFF}уровня загружена.",dopadm[playerid]);
		SendClientMessage(playerid, COLOR_WHITE, string);
		if(PlayerInfo[playerid][pAdmshad] == 0)
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "» Скрытость выключена.");
		}
		else
		{
			SendClientMessage(playerid, COLOR_LIGHTGREEN, "» Скрытость включена.");
		}
		if(dopadm[playerid] >= 7)
		{
			if(PlayerInfo[playerid][pAdmlive] == 0)
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "» Бессмертие выключено.");
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "» Бессмертие включено.");
			}
		}
		else
		{
			PlayerInfo[playerid][pAdmlive] = 0;//убрать бессмертие
			livdop[playerid] = 0;
		}
	}
	if(PlayerInfo[playerid][pAdmin] < 0)
	{
		PlayerInfo[playerid][pAdmin] = dopadm[playerid];
		SendClientMessage(playerid, COLOR_ORANGE, "» Рекомендация: В целях безопасности - измените свой пароль.");
	}
	new s[512];
	format(s, sizeof(s), "{FF0000}Управление:\n	{02ED56}Игровое меню - Y или /menu\n\
	\n{FF0000}Помощь по командам:\n	{02ED56}/cmds\n\
	\n{FF0000}Баг:\n	{02ED56}Если появились под картой: /spawn");
	ShowPlayerDialog(playerid, 2, DIALOG_STYLE_MSGBOX, "Управление и Правила", s, "ОКЕЙ", "");
	weapstatplay[playerid] = 0;
	skinstatplay[playerid] = 0;
	nickstatcol[playerid] = 0;
	gPlayerLogged[playerid] = 1;
	gPlayerAccount[playerid] = 1;
	new dopper;
	dopper = 0;
	OnPlayerRequestClass(playerid, dopper);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	functioncon[playerid]++;//прибавляем 1 к контрольной переменной функций
	new string[256];
	if(deathcon[playerid] == 1)
	{//если игрок умер, то:
		SetPVarInt(playerid, "MonControl", 1);
		GivePlayerMoney(playerid, 100);
		deathcon[playerid] = 0;//обнуляем контроль смерти игрока
	}
	if(gPlayerLogged[playerid] == 0)
	{
		format(string,sizeof(string)," Игрок %s[%d] был кикнут - спавн без логирования!", RealName[playerid], playerid);
		print(string);
		SendClientMessageToAll(COLOR_LIGHTRED, string);
		SetTimerEx("PlayKick", 300, 0, "i", playerid);
		return 1;
	}
	if(PlayerInfo[playerid][pLock] == 1) { return 1; }

	if(PlayLock1[0][playerid] != 600 && PlayerInfo[playerid][pPrisonsec] == 0)
	{//если игрок заблокирован, и не сидит в тюрьме, то заменяем данные блокировки на данные полицейского участка
		PlayLock1[1][playerid] = 0;//интерьер полицейского участка
		PlayLock1[2][playerid] = 53;//виртуальный мир 0
		PlayLock2[0][playerid] = -2088.1086;//координаты полицейского участка
		PlayLock2[1][playerid] = -96.8724;
		PlayLock2[2][playerid] = 35.1641;
		PlayLock2[3][playerid] = 296.6238;//угол спавна в полицейском участке
		SetCameraBehindPlayer(playerid);//камера за спиной
	    SetPlayerSkin(playerid, 268);
	}
	else//иначе - спавн игрока
	{
		if(admper1[playerid] != 600)//спавн админа после снятия наблюдения
		{
			new cordz = 0;
			if(admper4[playerid] == 3)
			{
				cordz = 5;
			}
			admper1[playerid] = 600;//установить статус выключенного наблюдения
			SetPlayerInterior(playerid, admper2[playerid]);//вернуть интерьер админа
			SetPlayerVirtualWorld(playerid, admper3[playerid]);//вернуть мир админа
			SetPlayerPos(playerid, TelSpec[playerid][0] + admper4[playerid], TelSpec[playerid][1] + admper4[playerid],
			TelSpec[playerid][2] + cordz);//вернуть координаты админа
			SetCameraBehindPlayer(playerid);//расположить камеру за админом (игроком)
			if(mapiconid[playerid] != -600)//если ID мап иконки наблюдения НЕ пустой, то:
			{
				DestroyDynamicMapIcon(mapiconid[playerid]);//удаление мап иконки наблюдения
			}
			mapiconid[playerid] = -600;//очистка ID мап иконки наблюдения
		}
		else
		{
			new locper = random(6);
			if(PGang[playerid] > 0 && strlen(GName[PGang[playerid]]) == 0)//Gangs system
			{//если игрок состоит в банде, и в названии банды нет ни одного символа (банда удалена), то:
				PGang[playerid] = 0;//обнулить игроку статус банды, и заспавнить игрока как обычного
				GangLvl[playerid] = 0;
				SendClientMessage(playerid, 0xFF0000FF, "Ваша банда была удалена!");
				SetPlayerInterior(playerid, 0);//установка интерьера 0
				SetPlayerVirtualWorld(playerid, 0);//установка виртуального мира 0
				SetPlayerPos(playerid, playspax[locper], playspay[locper], playspaz[locper]);//случайные координаты спавна игрока
				SetPlayerFacingAngle(playerid, playspaa[locper]);//случайный угол спавна игрока
				SetCameraBehindPlayer(playerid);//расположить камеру за игроком
			}
			else//иначе - проверить на наличие спавна из банды
			{
				if(PGang[playerid] > 0 && (GSpawnX[PGang[playerid]] != 0.0 ||
							GSpawnY[PGang[playerid]] != 0.0 || GSpawnZ[PGang[playerid]] != 0.0))
				{//если игрок состоит в банде, и в банде установлены координаты спавна, то:
					SetPlayerInterior(playerid, GInter[PGang[playerid]]);//установка интерьера из банды
					SetPlayerVirtualWorld(playerid, GWorld[PGang[playerid]]);//установка виртуального мира из банды
					SetPlayerPos(playerid, GSpawnX[PGang[playerid]], GSpawnY[PGang[playerid]], GSpawnZ[PGang[playerid]]);//координаты спавна игрока из банды
					SetCameraBehindPlayer(playerid);//расположить камеру за игроком
				}
				else//иначе - случайный спавн
				{
					SetPlayerInterior(playerid, 0);//установка интерьера 0
					SetPlayerVirtualWorld(playerid, 0);//установка виртуального мира 0
					SetPlayerPos(playerid, playspax[locper], playspay[locper], playspaz[locper]);//случайные координаты спавна игрока
					SetPlayerFacingAngle(playerid, playspaa[locper]);//случайный угол спавна игрока
					SetCameraBehindPlayer(playerid);//расположить камеру за игроком
				}
				if(playspa[playerid] == 0)//если это первый спавн игрока, то:
				{
					SetTimerEx("Logg333", 1000, 0, "i", playerid);//задержка, на время чтения аккаунта банды
				}
			}
		}
	}
	if(weapstatplay[playerid] == 0)//заполнение слотов оружия и предметов
	{
		for(new i = 0; i < 13; i++)
		{
			GivePlayerWeapon(playerid, play2weap[playerid][i], play2ammo[playerid][i]);
		}
		weapstatplay[playerid] = 1;
	}
	else
	{
		if(LockSpawn[playerid] == 0)//заполнение слотов оружия и предметов (если НЕТ блокировки)
		{
			for(new i = 0; i < 13; i++)
			{
				GivePlayerWeapon(playerid, playweap[playerid][i], playammo[playerid][i]);
			}
		}
		LockSpawn[playerid] = 0;//разблокировать заполнение слотов оружия и предметов
	}

	if(PGang[playerid] > 0 && GangLvl[playerid] <= 0)//Gangs system
	{//если игрок состоит в банде, и его уровень в банде меньше 1, то:
		GangLvl[playerid] = 1;//даём игроку уровень 1
	}
	if(PGang[playerid] > 0 && GSkin[PGang[playerid]][GangLvl[playerid]-1] < 500)
	{//если игрок состоит в банде, и в банде установлен скин, то:
		if(skinstatplay[playerid] == 0)//присваивание скина игроку из банды
		{
			SetPVarInt(playerid, "PlSkin", GSkin[PGang[playerid]][GangLvl[playerid]-1]);
			skinstatplay[playerid] = 1;
		}
		SetPlayerSkin(playerid, GetPVarInt(playerid, "PlSkin"));
	}
	else//иначе - присваивание скина игроку
	{
		if(skinstatplay[playerid] == 0)//присваивание скина игроку
		{
			SetPVarInt(playerid, "PlSkin", GetPlayerSkin(playerid));
			skinstatplay[playerid] = 1;
		}
		SetPlayerSkin(playerid, GetPVarInt(playerid, "PlSkin"));
	}

	SetPlayerHealth(playerid, 100);

	if(PGang[playerid] > 0)//Gangs system - если игрок состоит в банде, то:
	{
		if(nickstatcol[playerid] == 0)//присваивание цвета ника и цвета маркера игроку из банды
		{
			ColorPlay[playerid] = GColorDec[PGang[playerid]];
			SetPlayerColor(playerid, ColorPlay[playerid]);//устанавливаем цвет ника
			for(new i=0;i<MAX_PLAYERS;i++)//устанавливаем цвет маркера для всех игроков
			{
				SetPlayerMarkerForPlayer(i, playerid, GColorDec[PGang[playerid]]);
			}
			nickstatcol[playerid] = 1;
		}
	}
	else//иначе - присваивание цвета ника и цвета маркера игроку
	{
		if(nickstatcol[playerid] == 0)//присваивание цвета ника и цвета маркера игроку
		{
			ColorPlay[playerid] = ColNick[random(6)];
			SetPlayerColor(playerid, ColorPlay[playerid]);//устанавливаем цвет ника
			for(new i=0;i<MAX_PLAYERS;i++)//устанавливаем цвет маркера для всех игроков
			{
				SetPlayerMarkerForPlayer(i, playerid, ColorPlay[playerid]);
			}
			nickstatcol[playerid] = 1;
		}
	}

	if(PlayerInfo[playerid][pPrisonsec] > 0)//посадка в тюрьму
	{
		if(playspa[playerid] == 0)//если это первый спавн игрока, то:
		{//задержка посадки в тюрьму (на случай - если игрок спавнится в доме)
			SetTimerEx("TwoPrison", 3000, 0, "i", playerid);
		}
		else//если это респавн спавн игрока, то:
		{
			ResetPlayerWeapons(playerid);//отобрать оружие
			SetPlayerInterior(playerid, 0);//интерьер тюрьмы
			SetPlayerVirtualWorld(playerid, 53);//виртуальный мир 0
			SetPlayerPos(playerid, -2088.1086, -96.8724, 35.1641);//координаты тюрьмы
			SetPlayerFacingAngle(playerid, 1.27);//угол спавна в тюрьме
			SetCameraBehindPlayer(playerid);//камера за спиной
	    	SetPlayerSkin(playerid, 268);
		}
	}
	if(perfrost[playerid] != 600)//включение заморозки
	{
		TogglePlayerControllable(playerid, 0);
	}
	if(nucexplos == 1 && SnowONOFF[playerid] == 0)//если на сервере ядерный взрыв,
	{//И игрок только зашёл на сервер, то: саздаём объект снега
		new Float:sx, Float:sy, Float:sz;
		GetPlayerCameraPos(playerid, sx, sy, sz);
		snowobj[playerid] = CreatePlayerObject(playerid, 18864, sx, sy, sz-5, 0.0, 0.0, 0.0, 300.0);
		SnowONOFF[playerid] = 1;
	}
	if(playspa[playerid] == 0)
	{
		printf("* Игрок %s [%d] --> (спавн) .", RealName[playerid], playerid);
		TextDrawShowForPlayer(playerid, TScore[playerid]);
	}
	playspa[playerid] = 1;//переменная спавна игрока
	
	if(dm[playerid] == 1)//Проверка если 1 то игрока спавнит на дм
	{
		SetPlayerInterior(playerid, 0);//Интерьер
		SetPlayerVirtualWorld(playerid, 1164);//Виртуальный мир
		switch(random(4))
		{
		case 0: SetPlayerPos(playerid, -369.4562, 2267.6106, 42.3247);
		case 1: SetPlayerPos(playerid, -347.3269, 2221.7703, 42.4902);
		case 2: SetPlayerPos(playerid, -458.5428, 2220.9341, 43.3000);
		case 3: SetPlayerPos(playerid, -421.3752, 2223.8157, 42.4297);
		}
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid,24,300);
		GivePlayerWeapon(playerid,31,1000);
		SetPlayerHealth(playerid,100.0);
	}
	return 1;
}

forward TwoPrison(playerid);
public TwoPrison(playerid)
{
	ResetPlayerWeapons(playerid);//отобрать оружие
	SetPlayerInterior(playerid, 0);//интерьер тюрьмы
	SetPlayerVirtualWorld(playerid, 53);//виртуальный мир 0
	SetPlayerPos(playerid, -2088.1086,-96.8724,35.1641);//координаты тюрьмы
	SetPlayerFacingAngle(playerid, 296.6238);//угол спавна в тюрьме
	SetCameraBehindPlayer(playerid);//камера за спиной
	SetPlayerSkin(playerid, 268);
	return 1;
}

forward Logg333(playerid);//Gangs system
public Logg333(playerid)
{
	new dopper = 0;
	for(new i = 0; i < MAX_PLAYERS; i++)//подготовка к записи ID банды
	{
		if(PGang[playerid] > 0 && PGang[playerid] == idgangsave[i])
		{//если игрок состоит в банде, и ID его банды уже есть в списке, то:
			dopper = 1;
		}
	}
	if(PGang[playerid] > 0 && dopper == 0)
	{//если игрок состоит в банде, и ID его банды НЕ был найден в списке, то:
		idgangsave[playerid] = PGang[playerid];//записываем в список ID банды игрока
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	functioncon[playerid]++;//прибавляем 1 к контрольной переменной функций
	deathcon[playerid] = 1;//устанавливаем контроль смерти игрока
	SendDeathMessage(killerid, playerid, reason);
	
	if(killerid != INVALID_PLAYER_ID)
	{
		PlayerInfo[killerid][pKills] += 1;
		PlayerInfo[playerid][pDeaths] += 1;
	}
	
	ResetPlayerWeapons(playerid);
	if(killerid != INVALID_PLAYER_ID && GetPlayerState(killerid) == PLAYER_STATE_DRIVER)
    {
       	new vehicleid = GetPlayerVehicleID(killerid);
      	if(GetVehicleModel(vehicleid) != 425 && GetVehicleModel(vehicleid) != 432 && GetVehicleModel(vehicleid) != 447 && GetVehicleModel(vehicleid) != 520 && GetVehicleModel(vehicleid) != 476)//???? ????? ?? ?? ??????????? ? Id 425, 432, 447, 520, 476(??? ?????????? ???????....?????, ????? ? ???? ????????) ?? ?? ?? ?????? ??
         {
			SendClientMessage(killerid, COLOR_RED, "{FF0000}Убийство машиной запрещено правилами сервера!");
			SendClientMessage(killerid, COLOR_RED, "{FF0000}Поэтому вы приговорены к смертной казне!");
			SetPlayerHealth(killerid, 0);
            return 1;
         }
      }
	if(playerid!=INVALID_PLAYER_ID || killerid!=INVALID_PLAYER_ID)
	{
		new string[128], NickName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, NickName, sizeof(NickName));
		format(string, sizeof(string), " ~n~ ~n~ ~n~~w~~h~You Killed~n~~b~%s", NickName);
		GameTextForPlayer(killerid, string, 5000, 5);
		GetPlayerName(killerid, NickName, sizeof(NickName));
		format(string, sizeof(string), " ~n~ ~n~ ~n~~w~~h~You Got Killed By~n~~b~%s", NickName);
		GameTextForPlayer(playerid, string, 5000, 5);
	}
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
    if(lustra[vehicleid]!=-1)
	{
	    DestroyObject(lustra[vehicleid]);
		lustra[vehicleid]=-1;
	}
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}
public OnPlayerText(playerid, text[])
{
	chatcon[playerid]++;//прибавляем 1 к контрольной переменной чата
	new string[256];
	if(playspa[playerid] == 0)//игрок НЕ заспавнился
	{
		printf("-----[Игрок не заспавнился] %s [%d]: %s", RealName[playerid], playerid, text);//Отправляем сообщение в сервер-лог
		SendClientMessage(playerid,COLOR_RED," Вы ещё не заспавнились, и не можете писать в чат!");
		return 0;
	}
	if(PlayerInfo[playerid][pMutedsec] > 0)
	{
		SendClientMessage(playerid, COLOR_RED, " Вы не можете говорить, Вас заткнули!");
		printf("-----[Игрок заткнут] %s [%d]: %s", RealName[playerid], playerid, text);//Отправляем сообщение в сервер-лог
		return 0;
	}
	if(playspa[playerid] == 1 && PGang[playerid] <= 0)//игрок УЖЕ заспавнился
	{
		SetPlayerChatBubble(playerid, text, COLOR_WHITE, 15.0, 6000);
		format(string, sizeof(string), "%s {28F90E}[ID:%d]: {E5B884}%s", RealName[playerid], playerid, text);//Прикрепляем ид к нику
		SendClientMessageToAll(ColorPlay[playerid], string); // Отправляем сообщение
		return 0;
	}
	if(playspa[playerid] == 1 && PGang[playerid] > 0)//Gangs system
	{
		SetPlayerChatBubble(playerid, text, COLOR_WHITE, 15.0, 6000);
		format(string, sizeof(string), " %s | %s {28F90E}[ID:%d]: {E5B884}%s", GName[PGang[playerid]], RealName[playerid],
		playerid, text);
		SendClientMessageToAll(GColorDec[PGang[playerid]], string);
		return 0;
	}
	return 1;
}

forward SendAdminMessage(color, string[]);
public SendAdminMessage(color, string[])
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pAdmin] >= 1)
			{
				SendClientMessage(i, color, string);
			}
		}
	}
	return 1;
}

strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[30];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}
public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}
public OnPlayerCommandText(playerid, cmdtext[])
{
	chatcon[playerid]++;//прибавляем 1 к контрольной переменной чата
	new idx;
	idx = 0;
	new string[256];
	new strdln[5000];
	new akk[64], ssss[256], igkey[64], tdreg[64], adrip[64];
	new cmd[256];
	new tmp[256];
	cmd = strtok(cmdtext, idx);
	if(playspa[playerid] == 0)//игрок НЕ заспавнился
	{
		printf("-----[Игрок не заспавнился] %s[%d]: ввёл команду %s .", RealName[playerid], playerid, cmdtext);//Отправляем команду в сервер-лог
		SendClientMessage(playerid, COLOR_RED, " Вы ещё не заспавнились! введите команду /cmds!");
		return 1;
	}
	if(PlayerInfo[playerid][pMutedsec] == 0)
	{
		printf(" Игрок %s [%d] ввёл команду %s .", RealName[playerid], playerid, cmdtext);
	}
	if(PlayerInfo[playerid][pMutedsec] > 0)
	{
		printf(" Игрок %s [%d] (заткнут) ввёл команду: %s .", RealName[playerid], playerid, cmdtext);
	}
	//-------------- команды, если игрок не заспавнился (начало) -------------------
	if(strcmp(cmd, "/cmds", true) == 0 && playspa[playerid] == 0)
	{//если игрок НЕ заспавнился
		SendClientMessage(playerid,COLOR_GRAD1," -------------------- Помощь ---------------------- ");
		SendClientMessage(playerid,COLOR_GREEN,"   Если нет возможности выбора скина и спавна,");
		SendClientMessage(playerid,COLOR_GREEN,"          используйте команду   /spawn");
		SendClientMessage(playerid,COLOR_GRAD1," -------------------------------------------------- ");
		return 1;
	}
	if(strcmp(cmd, "/spawn", true) == 0 && playspa[playerid] == 0)
	{//если игрок НЕ заспавнился
		SendClientMessage(playerid,COLOR_LIGHTGREEN," Вы заспавнились.");
		if(IsPlayerInAnyVehicle(playerid))
		{
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid,x,y,z);
			SetPlayerPos(playerid,x,y,z+5);
			SetTimerEx("SecSpaDop", 300, 0, "i", playerid);
		}
		else
		{
			OnPlayerSpawn(playerid);
		}
		return 1;
	}
	//-------------- команды, если игрок не заспавнился (конец) --------------------
	//---------- команды игроков, разрешённые в любых случаях (начало) -------------
	if(strcmp(cmd, "/cmds", true) == 0 && playspa[playerid] == 1)
	{
		format(strdln, sizeof(strdln), "/case - кейс на деньги\
		\n/stat 600 - Просмотреть свою частичную статистику\
		\n/stat [ид] - Просмотреть частичную статистику другого игрока\
		\n/pm [id] [текст] - Написать личное сообщение другому игроку");
		format(strdln, sizeof(strdln), "%s\n/heal - Пополнить себе жизнь\
		\n/spawn - Заспавниться\
		\n/admins - Просмотреть On-Line админов\
		\n/hh - Поприветствовать всех игроков, /bb - Попрощаться со всеми игроками", strdln);
		format(strdln, sizeof(strdln), "%s\n/arm - надеть бронижелет\
		\n/count [секунды] - Запустить обратный отсчёт\
		\n/pay [ид] [сумма] - Передать деньги другому игроку\
		\n/kill - Умереть, /spot - меню спотов", strdln);
		format(strdln, sizeof(strdln), "%s\n/donate - Донат услуги\
		\n/dt [виртуальный мир] - Режим дрифт тренировки\
		\n/s - Сохранить временную точку телепорта\
		\n/r - ТП на временную точку телепорта", strdln);
		format(strdln, sizeof(strdln), "%s\n/cmchat - Очистить свой чат\
		\n/report - связь с администрацией\
		\n/work - ТП на работу Дальнобойщика\
		\n/rtun - Автоматический тюнинг транспорта\
		\n/gc - чат банд, /gpson - найти имущество", strdln);
		ShowPlayerDialog(playerid, 2, 0, "Помощь по командам:", strdln, "OK", "");

		return 1;
	}
	if(strcmp(cmd, "/stat", true) == 0)
	{
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /stat 600 или /stat [ид игрока]");
			return 1;
		}
		new para1 = strval(tmp);
		if(para1 == playerid)
		{
			SendClientMessage(playerid, COLOR_RED, " Для просмотра собственной статистики используйте: /stat 600!");
			return 1;
		}
		if(para1 == 600)
		{
			STATPlayer(playerid);
			return 1;
		}
		if(IsPlayerConnected(para1))
		{
			if(gPlayerLogged[para1] == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Выбранный игрок ещё не залогинился!");
				return 1;
			}
			if(PlayerInfo[para1][pAdmin] >= 1 && PlayerInfo[para1][pAdmshad] == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Выбранный игрок - админ!");
				return 1;
			}
			printf(" --> Игрок %s[%d] просмотрел статистику игрока %s[%d].", RealName[playerid], playerid, RealName[para1], para1);
			SendClientMessage(playerid, COLOR_GRAD1, "---------------------------------------------------------------");
			format(string, sizeof(string), " Игрок: {FFFFFF}%s[%d].", RealName[para1], para1);
			SendClientMessage(playerid, COLOR_GREEN, string);
			format(string, sizeof(string), " Денег: {FFFFFF}%d$. {FF0000}Очков: {FFFFFF}%d.",
			GetPlayerMoney(para1), GetPlayerScore(para1));
			SendClientMessage(playerid, COLOR_GREEN, string);
			format(string, sizeof(string), " Убийств: {FFFFFF}%d. {FF0000}Смертей: {FFFFFF}%d.",
			PlayerInfo[para1][pKills], PlayerInfo[para1][pDeaths]);
			SendClientMessage(playerid, COLOR_GREEN, string);
			format(string, sizeof(string), " Время затыка: {FFFFFF}%d секунд. {FF0000}Время тюрьмы: {FFFFFF}%d секунд.",
			PlayerInfo[para1][pMutedsec], PlayerInfo[para1][pPrisonsec]);
			SendClientMessage(playerid, COLOR_GREEN, string);
			if(PlayerInfo[para1][pAdmlive] == 0)
			{
				format(string, sizeof(string), " Бессмертие: {FF0000}Нет.");
			}
			else
			{
				format(string, sizeof(string), " Бессмертие: {FFFF00}Есть.");
			}
			SendClientMessage(playerid, COLOR_GREEN, string);
			SendClientMessage(playerid, COLOR_GRAD1, "---------------------------------------------------------------");
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " Такого [ид игрока] на сервере нет!");
		}
		return 1;
	}
	if(strcmp(cmd, "/gc", true) == 0)
	{
		if(PGang[playerid] <= 0)
		{
			SendClientMessage(playerid, COLOR_RED, "Вы не состоите в банде!");
			return 1;
		}
		if(PlayerInfo[playerid][pMutedsec] > 0)
		{
			SendClientMessage(playerid, COLOR_YELLOW, "Вы не можете писать в чат банды, так как у вас мут!");
			return 1;
		}
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result))
		{
			SendClientMessage(playerid, COLOR_GRAD2, "Используйте: /gc [текст]");
			return 1;
		}
		new hex[MAX_PLAYERS];//переводим шестнадцатиричный цвет в десятичный стандартной функцией
		new dopper[7];//переводим десятичный цвет в шестнадцатиричный (для окраски названия банды)
		dopper[0] = 48;//самый старший разряд = 0 (на случай, если цвет в пределах 6 байт)
		new dop11 = hex[playerid];
		new dop22 = 0;
		printf(" (gid:%d) <GC> %s | %d | %s", PGang[playerid], RealName[playerid], playerid, result);
		format(string, sizeof(string), "{FFFFFF}[ {FF0000}ЧАТ БАНДЫ{FFFFFF} ] {999999}%s[%d]: {FFFFFF}%s", RealName[playerid], playerid, result);
		if(dop11 > 16777215)//если цвет за пределами 3-х байт (один из вариантов не корректного цвета), то:
		{
			dop22 = dop11 / 16777216;//вычитаем переполнение...
			dop11 = dop11 - (dop22 * 16777216);
			if(dop22 > 9)//и записываем это переполнение в самый старший разряд
			{
				dopper[0] = dop22 + 55;
			}
			else
			{
				dopper[0] = dop22 + 48;
			}
		}
		new dop33 = 1048576;
		for(new j = 1; j < 7; j++)//перевод десятичного цвет в шестнадцатиричный
		{
			dop22 = dop11 / dop33;
			dop11 = dop11 - (dop22 * dop33);
			if(dop22 > 9)
			{
				dopper[j] = dop22 + 55;
			}
			else
			{
				dopper[j] = dop22 + 48;
			}
			dop33 = dop33 / 16;
		}
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i) && PGang[playerid] == PGang[i])
			{
				SendClientMessage(i, COLOR_YELLOW, string);
			}
		}
    	return 1;
	}
	if(strcmp(cmd, "/pm", true) == 0)
	{
		if(PlayerInfo[playerid][pMutedsec] > 0)
		{
			SendClientMessage(playerid, COLOR_RED, " Вы не можете говорить, Вас заткнули!");
			return 1;
		}
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /pm [ид игрока] [текст]");
			return 1;
		}
		new playset;
		playset = strval(tmp);
		if(playset == playerid)
		{
			SendClientMessage(playerid, COLOR_RED, " Вы не можете послать сообщение самому себе!");
			return 1;
		}
		if(IsPlayerConnected(playset))
		{
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /pm [ид игрока] [текст]");
				return 1;
			}
			format(string, sizeof(string), " <PM> %s [%d] --> %s [%d]: %s", RealName[playerid], playerid,
			RealName[playset], playset, result);
			print(string);
			new locper = 0;
			if(NETafkPl[playset][5] == 1) { locper = 1; }
			if(PlayerInfo[playerid][pAdmin] <= 11)
			{
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i))
					{
						if(PlayerInfo[i][pAdmin] >= 1 && playerid != i && playset != i)
						{
							SendClientMessage(i, 0xF4C330FF, string);
						}
					}
				}
				format(string, sizeof(string), "• Сообщение от %s[%d]: %s", RealName[playerid], playerid, result);
				SendClientMessage(playset, 0xF4C330FF, string);
				format(string, sizeof(string), "• Сообщение для %s[%d]: %s", RealName[playset], playset, result);
				SendClientMessage(playerid, 0xF4C330FF, string);
				if(locper == 1)
				{
					SendClientMessage(playerid, 0xF4C330FF, "/pm игрок-получатель сообщения в AFK!!!");
				}
			}
			else
			{
				format(string, sizeof(string), "• Сообщение от %s[%d]: %s", RealName[playerid], playerid, result);
				SendClientMessage(playset, 0xF4C330FF, string);
				format(string, sizeof(string), "• Сообщение для %s[%d]: %s", RealName[playset], playset, result);
				SendClientMessage(playerid, 0xF4C330FF, string);
				if(locper == 1)
				{
					SendClientMessage(playerid, 0xF4C330FF, "/pm игрок-получатель сообщения в AFK!!!");
				}
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " Такого игрока нет на сервере!");
		}
		return 1;
	}
	//---------- команды игроков, разрешённые в любых случаях (конец) --------------
	//---------- команды админов, разрешённые в любых случаях (начало) -------------
	if(strcmp(cmd, "/ahelp", true) == 0 || strcmp(cmd, "/ah", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 1 || IsPlayerAdmin(playerid))
		{
			SendClientMessage(playerid, COLOR_GREEN, " ----------------------------- Стандартные значения --------------------------");
			SendClientMessage(playerid, COLOR_GRAD1, "            Время - 12    |||    Погода - 1    |||    Гравитация - 0.008");
			SendClientMessage(playerid, COLOR_GREEN, " ---------------------- Помощь по админским командам ----------------------");
			if(PlayerInfo[playerid][pAdmin] >= 1)
			{
				SendClientMessage(playerid, COLOR_GRAD1, " 1 левел: /ahelp, /a, /time, /weat, /mess, /cord, /int, /kick");
			}
			if(PlayerInfo[playerid][pAdmin] >= 2)
			{
				SendClientMessage(playerid, COLOR_GRAD1, " 2 левел: /mute, /jail, /sid, /cc, /mark, /gotomark");
			}
			if(PlayerInfo[playerid][pAdmin] >= 3)
			{
				SendClientMessage(playerid, COLOR_GRAD1, " 3 левел: /tpset, /jetpack, /explode");
			}
			if(PlayerInfo[playerid][pAdmin] >= 4)
			{
				SendClientMessage(playerid, COLOR_GRAD1, " 4 левел: /veh, /delveh, /enterveh, /plclr");
			}
			if(PlayerInfo[playerid][pAdmin] >= 5)
			{
				SendClientMessage(playerid, COLOR_GRAD1, " 5 левел: /tweap, /setweap, /playtp, /edgangs");
			}
			if(PlayerInfo[playerid][pAdmin] >= 6)
			{
				SendClientMessage(playerid, COLOR_GRAD1, " 6 левел: /ban, /tweaprad, /setweapall, /plcmon");
			}
			if(PlayerInfo[playerid][pAdmin] >= 7)
			{
				SendClientMessage(playerid, COLOR_GRAD1, " 7 левел: /live, /admtp, /nucexp");
			}
			if(PlayerInfo[playerid][pAdmin] >= 8)
			{
				SendClientMessage(playerid, COLOR_GRAD1, " 8 левел: /fmess, /playtpall");
			}
			if(PlayerInfo[playerid][pAdmin] >= 9)
			{
				SendClientMessage(playerid, COLOR_GRAD1, " 9 левел: /grav, /gm, /spawncars");
			}
			if(PlayerInfo[playerid][pAdmin] >= 10)
			{
				SendClientMessage(playerid, COLOR_GRAD1, " 10 левел: /radpl, /radall");
			}
			if(PlayerInfo[playerid][pAdmin] >= 11)
			{
				SendClientMessage(playerid, COLOR_GRAD1, " 11 левел: /dataakk, /unban, /shad, /deltr, /ipban, /ipunban");
			}
			if(PlayerInfo[playerid][pAdmin] >= 12)
			{
				SendClientMessage(playerid, COLOR_GRAD1, " 12 левел: /money, /setmon, /moneyall, /setmonall, \
				/score, /setscor, /scoreall, /setscorall, /admakk, /delakk, /edplgangs, /gmx, /makeadmin");
			}
			if(IsPlayerAdmin(playerid))
			{
				SendClientMessage(playerid, COLOR_GRAD1, " 13 левел и RCON-Admin: /makeadmin");
			}
			new strdln22[3500];
			for(new i; i < sizeof(AdmHlp); i++)
			{
				strcat(strdln22, AdmHlp[i]);
				ShowPlayerDialog(playerid, 2, DIALOG_STYLE_MSGBOX, "{FFFFFF}Административное меню:", strdln22, "Готово", "");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды!");
		}
		return 1;
	}
	if(strcmp(cmd, "/achat", true) == 0 || strcmp(cmd, "/a", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 1)
		{
			if(PlayerInfo[playerid][pMutedsec] > 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Вы не можете говорить, Вас заткнули!");
				return 1;
			}
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Админ-чат: (/a)chat [текст]");
				return 1;
			}
			new per55 = 0;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(PlayerInfo[playerid][pAdmin] >= 1 && i != playerid && IsPlayerConnected(i) &&
						PlayerInfo[i][pAdmin] >= 1) {per55 = 1;}//если пишет админ, и есть любой другой админ, то - отправить сообщение
			}
			if(per55 == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Сейчас на сервере нет других админов!");
				return 1;
			}
			printf(" [54] %s[%d] (%d LVL): %s", RealName[playerid], playerid, PlayerInfo[playerid][pAdmin], result);
			format(string, sizeof(string), " [ {00FF00}Admin Chat {FFFFFF}] {999999}%s[%d] (%d LVL): {FFFFFF}%s", RealName[playerid], playerid,
			PlayerInfo[playerid][pAdmin], result);
			SendAdminMessage(COLOR_WHITE, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды!");
		}
		return 1;
	}
    if(strcmp(cmd, "/spawncars", true) == 0)
    {
        if(IsPlayerConnected(playerid))
        {
            if(PlayerInfo[playerid][pAdmin] < 9)
            {
                SendClientMessage(playerid, COLOR_GRAD1, " У Вас нет прав на использование этой команды!");
                return 1;
            }
            for(new c=0; c<MAX_VEHICLES; c++)
            {
                if(!IsVehicleOccupied(c))
                {
                    SetVehicleToRespawn(c);
                }
            }
            format(string,sizeof(string)," Администратор %s зареспавнил весь незанятый людьми транспорт.",RealName[playerid]);
            SendClientMessageToAll(COLOR_GREEN,string);
        }
        return 1;
    }
	//---------- команды админов, разрешённые в любых случаях (конец) --------------
	//-------------- запрещёния для всех следующих команд (начало) -----------------
	if(PlayerInfo[playerid][pPrisonsec] > 0)
	{
		format(string, sizeof(string), "* Команда игрока %s[%d] не обработана , т.к. игрок в тюрьме.", RealName[playerid], playerid);
		print(string);
		SendClientMessage(playerid, COLOR_RED, " В тюрьме команды не работают.");
		return 1;
	}
	if(perfrost[playerid] != 600)
	{
		format(string, sizeof(string), "* Команда игрока %s[%d] не обработана , т.к. игрок заморожен.", RealName[playerid], playerid);
		print(string);
		SendClientMessage(playerid, COLOR_RED, " Нельзя, Вы заморожены!");
		return 1;
	}
	if(PlayLock1[0][playerid] != 600)
	{
		format(string, sizeof(string), "* Команда игрока %s[%d] не обработана , т.к. игрок заблокирован.", RealName[playerid], playerid);
		print(string);
		SendClientMessage(playerid, COLOR_RED, " Нельзя, Вы заблокированы!");
		return 1;
	}
	//-------------- запрещёния для всех следующих команд (конец) ------------------
	//------------------------- команды игроков (начало) ---------------------------
	if (strcmp("/dm", cmdtext, true, 10) == 0)
	{
		if(dm[playerid] == 0)//Проверка если 0 то комманда срабатывает
		{
			dm[playerid] = 1;//Теперь если игрок прописал комманду то ему выдаётся 1
			ResetPlayerWeapons(playerid);
			format(string, sizeof(string), "» {EBEBEB}%s {999999}зашел на DM зону. ({00FF00}/dm{999999})", RealName[playerid]);
			SendClientMessageToAll(COLOR_GREEN, string);
			SendClientMessage(playerid, COLOR_GREEN, " Что бы покинуть DM зону, введите - /exit");
			SpawnPlayer(playerid);//Спавним игрока
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " Вы уже на DM зоне.");
		}
		return 1;
	}
	if (strcmp("/exit", cmdtext, true, 10) == 0)
	{
		if(dm[playerid] == 1)//Проверка если 1 то комманда срабатывает
		{
			dm[playerid] = 0;//Теперь если игрок прописал комманду то ему выдаётся 0
			OnPlayerSpawn(playerid);//Возврат на спавн
			ResetPlayerWeapons(playerid);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " Вы не на DM зоне.");
		}
		return 1;
	}
	//------------------- Проверка команд на то что игрок на DM --------------------
	if(dm[playerid] == 1)
	{
		format(string, sizeof(string), "* Команда игрока %s[%d] не обработана , т.к. игрок на DM зоне.", RealName[playerid], playerid);
		print(string);
		SendClientMessage(playerid, COLOR_RED, " Сначало покиньте DM зону.");
		return 1;
	}
	//------------------------------------------------------------------------------
	if(strcmp("/ls", cmdtext, true, 10) == 0)
	{
	    DestrCar(playerid);
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid, 1533.5804, -1671.2289, 13.3828);
		SetPlayerFacingAngle(playerid, 90);
		SetCameraBehindPlayer(playerid);
		return 1;
	}
	if(strcmp("/lv", cmdtext, true, 10) == 0)
	{
	    DestrCar(playerid);
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid, 2167.5251, 1680.6271, 10.8203);
		SetPlayerFacingAngle(playerid, 90);
		SetCameraBehindPlayer(playerid);
		return 1;
	}
	if(strcmp("/sf", cmdtext, true, 10) == 0)
	{
	    DestrCar(playerid);
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid, -1979.0369, 884.4814, 45.2031);
		SetPlayerFacingAngle(playerid, 90);
		SetCameraBehindPlayer(playerid);
		return 1;
	}
	if(strcmp("/funcars", cmdtext, true, 10) == 0)
	{
	    DestrCar(playerid);
		SetPlayerInterior(playerid,0);
		format(string, sizeof(string), "» {EBEBEB}%s {999999}телепортировался на парковку необычных Автомобилей. ({FF0000}/funcars{999999})", RealName[playerid]);
		SendClientMessageToAll(COLOR_GREEN, string);
		SetPlayerPos(playerid,-1712.6581, 1055.0543, 17.5859);
		SetPlayerFacingAngle(playerid, 181.3420);
		SetCameraBehindPlayer(playerid);
		return 1;
	}
	if(strcmp("/ufo", cmdtext, true, 10) == 0)
	{
	    DestrCar(playerid);
		SetPlayerInterior(playerid,0);
		format(string, sizeof(string), "» {EBEBEB}%s {999999}телепортировался к месту приземления НЛО. ({FF0000}/ufo{999999})", RealName[playerid]);
		SendClientMessageToAll(COLOR_GREEN, string);
		SetPlayerPos(playerid, 89.1252, -124.2458, 1.2585);
		SetPlayerFacingAngle(playerid, 26.1056);
		SetCameraBehindPlayer(playerid);
		return 1;
	}
	if(strcmp("/city1", cmdtext, true, 10) == 0)
	{
		SetPlayerPos(playerid,4565,-221,26);
		SendClientMessage(playerid,-1,"{FF0000}Шутка, ты успешно телепортирован в новый город :)");
	}
	if(strcmp("/city2", cmdtext, true, 10) == 0)
	{
		SetPlayerPos(playerid,3548,-823,11);
		SendClientMessage(playerid,-1,"{FF0000}Шутка, ты успешно телепортирован в новый город :)");
	}
	if(strcmp("/city3", cmdtext, true, 10) == 0)
	{
		SetPlayerPos(playerid,869.5344,-2444.7009,13.0070);
		SendClientMessage(playerid,-1,"{FF0000}Шутка, ты успешно телепортирован в новый город :)");
	}
	if(strcmp("/gruz", cmdtext, true, 10) == 0)
	{
		SetPlayerPos(playerid, 1265.1329,-1256.7968,13.1021);
	}
	if(strcmp("/work", cmdtext, true, 10) == 0)
	{
		SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,-49.9084, -292.6440, 5.4297);
		SetPlayerFacingAngle(playerid, 179.2402);
		SetCameraBehindPlayer(playerid);
		format(string, sizeof(string), "» {EBEBEB}%s {999999}телепортировался на работу Дальнобойщика. ({00FF00}/work{999999})", RealName[playerid]);
		SendClientMessageToAll(COLOR_GREEN, string);
		SendClientMessage(playerid,-1,"{FF0000}INFO:{FFFFFF} Для того чтобы начать работать сядьте в грузовик и введите [ {FF0000}/delivery {FFFFFF}]");
		return 1;
	}
	if(strcmp("/delivery", cmdtext, true, 10) == 0)
	{
		if(IsPlayerInRangeOfPoint(playerid,200.0,-75.1052,-289.7339,6.4286))
		{
			new model = GetVehicleModel(GetPlayerVehicleID(playerid));
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && model==456 || GetPlayerState(playerid) != PLAYER_STATE_DRIVER && model==514 || GetPlayerState(playerid) != PLAYER_STATE_DRIVER && model==403)
			{
				SendClientMessage(playerid,COLOR_WHITE,"{FF0000}INFO:{FFFFFF} Вы должны быть за рулём!");
				return true;
			}
			DisablePlayerCheckpoint(playerid);
			GameTextForPlayer(playerid, "~r~Goto redmarker", 2500, 1);
			Checkpoint[playerid] = 1;
			new traileid = GetVehicleTrailer(GetPlayerVehicleID(playerid));
			if(traileid == Pricep[5] || traileid == Pricep[6] || traileid == Pricep[7])
			{
				new rand666=random(4);
				switch (rand666)
				{
				case 0:SetPlayerCheckpoint(playerid,-2101.1555,208.4684,34.8973,8.0);
				case 1:SetPlayerCheckpoint(playerid,2801.4639,-2436.1069,13.2421,8.0);
				case 2:SetPlayerCheckpoint(playerid,2619.9587,833.6466,4.9254,8.0);
				case 3:SetPlayerCheckpoint(playerid,680.4613,896.6621,-40.3721,8.0);
				}
			}
			if(traileid == Pricep[3] || traileid == Pricep[9])
			{
				new rand666=random(4);
				switch (rand666)
				{
				case 0:SetPlayerCheckpoint(playerid,2193.5149,2476.3335,10.8203,8.0);
				case 1:SetPlayerCheckpoint(playerid,-2442.1062,953.0255,45.2969,8.0);
				case 2:SetPlayerCheckpoint(playerid,-1624.4644,-2697.6082,48.5391,8.0);
				case 3:SetPlayerCheckpoint(playerid,1918.5468,-1792.2303,13.3828,8.0);
				}
			}
			if(traileid == Pricep[8] || traileid == Pricep[4])
			{
				new rand666=random(4);
				switch (rand666)
				{
				case 0:SetPlayerCheckpoint(playerid,2119.4260,-1826.5001,13.5549,8.0);
				case 1:SetPlayerCheckpoint(playerid,2073.7229,2225.8416,10.8203,8.0);
				case 2:SetPlayerCheckpoint(playerid,1383.9170,264.0096,19.5669,8.0);
				case 3:SetPlayerCheckpoint(playerid,-1802.8058,960.6457,24.8906,8.0);
				}
			}
			if(traileid == Pricep[2])
			{
				new rand666=random(4);
				switch (rand666)
				{
				case 0:SetPlayerCheckpoint(playerid,505.3549,-1366.4999,16.1252,8.0);
				case 1:SetPlayerCheckpoint(playerid,2247.9878,-1663.3557,15.4690,8.0);
				case 2:SetPlayerCheckpoint(playerid,2105.0955,2248.5913,11.0234,8.0);
				case 3:SetPlayerCheckpoint(playerid,-1889.1820,874.3929,35.1719,8.0);
				}
			}
			if(traileid == Pricep[1])
			{
				new rand666=random(4);
				switch (rand666)
				{
				case 0:SetPlayerCheckpoint(playerid,2303.3145,-1635.1567,14.1720,8.0);
				case 1:SetPlayerCheckpoint(playerid,1830.3245,-1682.8469,13.1551,8.0);
				case 2:SetPlayerCheckpoint(playerid,-2244.7861,-87.9356,34.9299,8.0);
				case 3:SetPlayerCheckpoint(playerid,-2555.2585,191.8923,5.7216,8.0);
				}
			}
			if(traileid == Pricep[0])
			{
				new rand666=random(4);
				switch (rand666)
				{
				case 0:SetPlayerCheckpoint(playerid,1363.6267,-1282.4384,13.5469,8.0);
				case 1:SetPlayerCheckpoint(playerid,2394.5999,-1978.2787,13.1115,8.0);
				case 2:SetPlayerCheckpoint(playerid,2156.1287,940.5781,10.4309,8.0);
				case 3:SetPlayerCheckpoint(playerid,-2626.6106,211.0776,4.2099,8.0);
				}
			}
		}else{SendClientMessage(playerid,COLOR_WHITE,"{FF0000}INFO:{FFFFFF} Вы не находитесь в грузовике!");}
		return 1;
	}
	if(strcmp(cmd, "/heal", true) == 0)
	{
		if(admper1[playerid] != 600)
		{
			SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта команда не работает!");
			return 1;
		}
		SetPlayerHealth(playerid, 100);
		SendClientMessage(playerid, COLOR_GRAD1, " Вы пополнили себе жизнь.");
		return 1;
	}
	if(strcmp(cmd, "/spawn", true) == 0 && playspa[playerid] == 1)
	{
		if(admper1[playerid] != 600)
		{
			SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта команда не работает!");
			return 1;
		}
		SendClientMessage(playerid, COLOR_LIGHTGREEN, " Вы заспавнились.");
		if(IsPlayerInAnyVehicle(playerid))
		{
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			SetPlayerPos(playerid, x, y, z+5);
			SetTimerEx("SecSpa", 300, 0, "i", playerid);//спавн с блокировкой заполнения слотов оружия и предметов
		}
		else
		{
			SecSpa(playerid);//спавн с блокировкой заполнения слотов оружия и предметов
		}
		return 1;
	}
	if(strcmp(cmd, "/admins", true) == 0)
	{
		AdminsLvl(playerid);
		return 1;
	}
	if(strcmp(cmd, "/hh", true) == 0)
	{
		if(PlayerInfo[playerid][pMutedsec] > 0)
		{
			SendClientMessage(playerid, COLOR_RED, " Вы не можете использовать эту команду, Вас заткнули!");
			return 1;
		}
		format(string, sizeof(string), "{999999}. . : : {FFFFFF}%s(%d) {FF0000}приветствует всех игроков! {999999}: : . .",
		RealName[playerid], playerid);
		SendClientMessageToAll(0xFFFFFFFF, string);
		return 1;
	}
	if(strcmp(cmd, "/bb", true) == 0)
	{
		if(PlayerInfo[playerid][pMutedsec] > 0)
		{
			SendClientMessage(playerid, COLOR_RED, " Вы не можете использовать эту команду, Вас заткнули!");
			return 1;
		}
		format(string, sizeof(string), "{999999}. . : : {FFFFFF}%s(%d) {FF0000}прощается со всеми! {999999}: : . .", RealName[playerid], playerid);
		SendClientMessageToAll(0xFFFFFFFF, string);
		return 1;
	}
	if(strcmp(cmd, "/count", true) == 0)
	{
		if(PlayerInfo[playerid][pMutedsec] > 0)
		{
			SendClientMessage(playerid, COLOR_RED, " Вы не можете использовать эту команду, Вас заткнули!");
			return 1;
		}
		if(admper1[playerid] != 600)
		{
			SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта команда не работает!");
			return 1;
		}
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			SendClientMessage(playerid, COLOR_RED," Вы должны быть в транспорте.");
			return 1;
		}
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /count [секунды 2-12]");
			return 1;
		}
		new persec;
		persec = strval(tmp);
		if (persec < 2 || persec > 12)
		{
			SendClientMessage(playerid, COLOR_RED, " Секунды: от 2 до 12");
			return 1;
		}
		format(string, sizeof(string), " Игрок %s запустил отсчёт.", RealName[playerid], playerid, persec);
		print(string);
		SendClientMessageToAll(COLOR_GREEN, string);
		new Float: X, Float:Y, Float: Z, playint, playvw;
		GetPlayerPos(playerid, X, Y, Z);
		playint = GetPlayerInterior(playerid);
		playvw = GetPlayerVirtualWorld(playerid);
		persec++;
		countdown[playerid] = persec;
		for(new i = 0; i < MAX_PLAYERS ; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(IsPlayerInRangeOfPoint(i, 20.0, X, Y, Z) && GetPlayerInterior(i) == playint &&
						GetPlayerVirtualWorld(i) == playvw)
				{
					if(GetPlayerState(i) != PLAYER_STATE_ONFOOT && countdown[i] == -1) countdown[i] = persec;
				}
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/goto", true) == 0)
	{
		GetPlayerName(playerid, sendername, sizeof(sendername));
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_DBLUE, "Используйте: /goto [id]");
			return 1;
		}
		new Float:plocx,Float:plocy,Float:plocz;
		if(IsStringAName(tmp))
		{
			giveplayerid = GetPlayerID(tmp);
		}
		else
		{
			giveplayerid = strval(tmp);
		}
		if(PlayerInfo[playerid][pAdmin] >= 2)
		{
			if(IsPlayerConnected(giveplayerid))
			{
			    GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
				GetPlayerName(playerid, sendername, sizeof(sendername));
				format(string, sizeof(string), "Успешно: Ты телепортировался к игроку!");
				SendClientMessage(playerid, COLOR_BLUE, string);
				GetPlayerPos(giveplayerid, plocx, plocy, plocz);
				new intid = GetPlayerInterior(giveplayerid);
				SetPlayerInterior(playerid,intid);
				new PlayerName[30];
				GetPlayerName(playerid, PlayerName, 30);
				printf("[Command] %s has used /goto to go to %s", PlayerName, giveplayer);
				if (GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, plocx, plocy+4, plocz);
				}
				else
				{
					SetPlayerPos(playerid,plocx,plocy+2, plocz);
				}
			}
			else
			{
			    format(string, sizeof(string), "Такого игрока нет в сети.");
				SendClientMessage(playerid, COLOR_RED, string);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, "У вас нет прав на использование данной команды!");
		}
		return 1;
	}
// === [Gethere] ===
	if(strcmp(cmd, "/gethere", true) == 0)
	{
	    GetPlayerName(playerid, sendername, sizeof(sendername));
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_DBLUE, "Используйте: /gethere [id]");
			return 1;
		}
		new Float:plocx,Float:plocy,Float:plocz;
		if(IsStringAName(tmp))
		{
			giveplayerid = GetPlayerID(tmp);
		}
		else
		{
			giveplayerid = strval(tmp);
		}
		if(PlayerInfo[playerid][pAdmin] >= 2)
		{
		    if(IsPlayerConnected(giveplayerid))
		    {
			    GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
				GetPlayerName(playerid, sendername, sizeof(sendername));
				format(string, sizeof(string), "Подсказка: Ты телепортирован к Администратору!");
				SendClientMessage(giveplayerid, COLOR_BLUE, string);
				format(string, sizeof(string), "Успешно: Ты телепортировал к себе игрока!");
				SendClientMessage(playerid, COLOR_BLUE, string);
				GetPlayerPos(playerid, plocx, plocy, plocz);
				new intid = GetPlayerInterior(playerid);
				SetPlayerInterior(giveplayerid,intid);
				new PlayerName[30];
				GetPlayerName(playerid, PlayerName, 30);
				printf("[Command] %s has used /gethere to get %s", PlayerName, giveplayer);

				if (GetPlayerState(giveplayerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(giveplayerid);
					SetVehiclePos(tmpcar, plocx, plocy+4, plocz);
				}
				else
				{
					SetPlayerPos(giveplayerid,plocx,plocy+2, plocz);
				}
			}
			else
			{
                format(string, sizeof(string), "Такого игрока нет в сети!");
				SendClientMessage(playerid, COLOR_RED, string);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, "У вас нет прав на использование данной команды!");
		}
		return 1;
	}
	if(strcmp(cmd, "/pay", true) == 0)
	{
		if(PlayerInfo[playerid][pMutedsec] > 0)
		{
			SendClientMessage(playerid, COLOR_RED, " Вы не можете использовать эту команду, Вас заткнули!");
			return 1;
		}
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /pay [ид игрока] [сумма]");
			return 1;
		}
		new playset;
		playset = strval(tmp);
		if(playset == playerid)
		{
			SendClientMessage(playerid, COLOR_RED, " Вы не можете передать деньги самому себе!");
			return 1;
		}
		if(IsPlayerConnected(playset))
		{
			if(gPlayerLogged[playset] == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Выбранный игрок ещё не залогинился!");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " Вы не указали сумму!");
				return 1;
			}
			new money;
			money = strval(tmp);
			if(money < 0) { SendClientMessage(playerid, COLOR_RED, " Сумма не может быть отрицательным числом!"); return 1; }
			if(money > 30000000) { SendClientMessage(playerid, COLOR_RED, "Вы не можете передать больше 30 миллионов за 1 раз!"); return 1; }
			if(money < 10000) { SendClientMessage(playerid, COLOR_RED, "Вы не можете передать меньше 10 тысяч."); return 1; }
			if(GetPlayerMoney(playerid) < money) { SendClientMessage(playerid, COLOR_RED, " У Вас нет такой суммы!"); return 1; }
			new money22 = money * -1;
			new dopper44;
			dopper44 = GetPlayerMoney(playset);
			SetPVarInt(playerid, "MonControl", 1);
			GivePlayerMoney(playerid, money22);
			SetPVarInt(playset, "MonControl", 1);
			GivePlayerMoney(playset, money);
			format(string, sizeof(string), " Игрок %s[%d] передал игроку %s[%d] %d$", RealName[playerid], playerid,
			RealName[playset], playset, money);
			print(string);
			SendAdminMessage(COLOR_YELLOW, string);
			if (PlayerInfo[playerid][pAdmin] == 0)
			{
				format(string, sizeof(string), " Вы передали игроку %s[%d] %d$", RealName[playset], playset, money);
				SendClientMessage(playerid, COLOR_YELLOW, string);
			}
			if (PlayerInfo[playset][pAdmin] == 0)
			{
				format(string, sizeof(string), " Игрок %s[%d] передал Вам %d$", RealName[playerid], playerid, money);
				SendClientMessage(playset, COLOR_YELLOW, string);
			}
			printf("[moneysys] Предыдущая сумма игрока %s[%d] : %d$", RealName[playset], playset, dopper44);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " Такого [ид] на сервере нет!");
		}
		return 1;
	}
	if(strcmp(cmd, "/arm", true) == 0)
	{
	    SetPlayerArmour(playerid, 100);
	    SendClientMessage(playerid, COLOR_GREEN, "Вы успешно надели бронижелет!");
	}
	if(strcmp(cmd, "/kill", true) == 0)
	{
		if(admper1[playerid] != 600)
		{
			SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта команда не работает!");
			return 1;
		}
		SetPlayerArmour(playerid, 0);
		SetPlayerHealth(playerid, 0);
		return 1;
	}
	if(strcmp(cmd, "/tp", true) == 0)
	{
		format(strdln, sizeof(strdln), "{FF0000}KTA CITY #1\n{FFFFFF}KTA CITY #2 - В разработке еще\n{FF0000}Гоночная трасса\
		\n{FFFFFF}Los-Santos\n{FF0000}Работа Дальнобойщика\n{FFFFFF}San-Fierro\n{FF0000}Публичный дом\
		\n{FFFFFF}Las-Venturas\n{FF0000}Аэропорт SF\n{FFFFFF}Драг SF\n{FF0000}Заправка ESPO\
		\n{FFFFFF}Сумо\n{FF0000}Заброшенный Аэропорт\n{FFFFFF}Кавказские Горы");
		format(strdln, sizeof(strdln), "%s\n{FF0000}Автошкола\n{FFFFFF}Каспийское Море\n{FF0000}Драг LS\
		\n{FFFFFF}не  работает\n{FF0000}Аэропорт LV\n{FFFFFF}Дрифт SF\n{FF0000}не  работает\
		\n{FFFFFF}не  работает\n{FF0000}Клуб Джиззи\n{FFFFFF}Казино\n{FF0000}Спринт\n{FFFFFF}Дрифт LV\
		\n{FF0000}Акушинка №2\n{FFFFFF}Гаражи LV\n{FF0000}Парковка LV", strdln);
		format(strdln, sizeof(strdln), "%s\n{FFFFFF}не  работает\n{FF0000}BMX Stunt\n{FFFFFF}Акушинка №1-Грозный\
		\n{FF0000}не  работает\n{FFFFFF}Cobra Gym\n{FF0000}Аэропорт LS\n{FFFFFF}не  работает\n{FF0000}Корабль\
		\n{FFFFFF}не  работает\n{FF0000}не  работает\n{FFFFFF}не  работает\n{FF0000}не  работает\
		\n{FFFFFF}не  работает\n{FF0000}Vice Stadium\n{FFFFFF}Fun Cars", strdln);
		ShowPlayerDialog(playerid, 11, DIALOG_STYLE_LIST, "Телепорты", strdln, "OK", "Отмена");
		dlgcont[playerid] = 11;
		return 1;
	}
	if(strcmp(cmd, "/spot", true) == 0)
	{
	    ShowPlayerDialog(playerid, 551, DIALOG_STYLE_LIST, "Меню спотов", "{FF0000}Двойной спот в SF\
	    \n{FF0000}Серпантин за городом\n{FF0000}Серпантин за городом 2\n{FF0000}Серпантин в LV (KTA CITY #1)\
		\n{FF0000}Круговой дрифт аэропорт SF\n{FF0000}Круговой дрифт - аэропорт LS\n{FF0000}Мини-Серпантин LS", "Выбор", "Отмена");
		dlgcont[playerid] = 551;
		return 1;
	}
	if(strcmp(cmd, "/car", true) == 0)
    {
    ShowPlayerDialog(playerid, DIALOG_CAR_MAIN, DIALOG_STYLE_LIST,
        "{3FD7D0}"SHORT_NAME" {FFFFFF}| АВТО",
        "VAZ\nMercedes\nBMW\nToyota\nLexus\nPorsche\nКитай\nМото\nПолиция",
        "Далее", "Отмена");
    return 1;
    }
	if(strcmp(cmd, "/mta", true) == 0)
	{
		ShowPlayerDialog(playerid, 25, DIALOG_STYLE_LIST, "иномарки", "Audi RS7\nNissan Skyline GT\nMazda RX-7\nBMW E30\
		\nToyota Camry\nNissan Silvia Nismo\nToyota Mark 2\nВАЗ Sport\nRange Rover\nPorsche 930 Turbo\nSubaru Impreza\nPriora Sport\nBMW M5 F90\nMercedes-Benz G63 AMG\nLamborghini Huracan\nNissan GT-R\
		\nNissan Silvia S13\nPorsche Cayman\nToyota Supra\nDodge Challenger SRT8\nToyota AE86\nMercedes GLE 63 AMG\nTesla Model S\nMersedes GT63S AMG\nNissan GT-R Police", "OK", "Отмена");
		dlgcont[playerid] = 25;
		return 1;
	}
	if(strcmp(cmd, "/aks", true) == 0)
	{
		format(strdln, sizeof(strdln), "{FFFFFF}Кейс в руке\nЩит в руке\nМагнитофон в руке\
		\nМешок денег на спине\nПопугай на плечо\nКостюм попугая\nКостюм бегемота\
		\nОгонек на голову\nМаска дракона\nШляпа курицы\nБольшой М4 в руку\nУдалить все объекты", strdln);
		ShowPlayerDialog(playerid, 2, DIALOG_STYLE_LIST, "Аксессуары", strdln, "OK", "Отмена");
		dlgcont[playerid] = 2;
		return 1;
	}
	if(strcmp(cmd, "/mm", true) == 0)
	{
		if(admper1[playerid] != 600)
		{
			SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта команда не работает!");
			return 1;
		}
		format(string, sizeof(string), "{FFFFFF}Игровое меню. Точное время: {FF0000}%02d{FFFFFF}:{FF0000}%02d", timedata[0], timedata[1]);
		ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, string, "{FF0000}» Транспортное средство\n{FF0000}» Предметы\
		\n{FF0000}» Оружие\n{FF0000}» Телепорты\n{FF0000}» Аксессуары\n{FF0000}» Действия\n{FF0000}» Радио\n{FF0000}» DeathMatch\
		\n{FF0000}» Платные услуги\n{FF0000}» On-Line Администраторы\n{FF0000}» Правила сервера\n{FF0000}» Система банд", "Выбор", "Отмена");
		dlgcont[playerid] = 4;
		return 1;
	}
	if(strcmp(cmd, "/tune", true) == 0)
	{
		ShowPlayerDialog(playerid, 19, DIALOG_STYLE_LIST, "Тюнинг", "Диски\nГидравлика\nУдалить гидравлику\nЦвет\
		\nВинилы\nАрхангел тюнинг\nНеон, дополнительно\nВыключить фары\nУдалить детали транспорта\
		\nУдалить бампера\nПроколоть шины", "Выбор", "Отмена");
		dlgcont[playerid] = 19;
		return 1;
	}
	if(strcmp(cmd, "/delcar", true) == 0)
	{
					new car = GetPlayerVehicleID(playerid);
					if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
					{
					if(CallRemoteFunction("myobjvehfunc", "d", car) != 0)//чтение ИД транспорта из скпипта myobj
					{
						SendClientMessage(playerid, 0xFF0000FF, " Нельзя ! Это отдельно созданный транспорт !");
						return 1;
					}
					if(CallRemoteFunction("garagefunction", "d", car) != 0)//чтение ИД транспорта из системы гаражей
					{
						SendClientMessage(playerid, 0xFF0000FF, " Нельзя ! Это транспорт системы гаражей !");
						return 1;
					}
					if(CallRemoteFunction("basesysvehfunc", "d", car) != 0)//чтение ИД транспорта из системы баз
					{
						SendClientMessage(playerid, 0xFF0000FF, " Нельзя ! Это транспорт системы баз !");
						return 1;
					}
					for(new i = 0; i < MAX_PLAYERS; i++)//уничтожить любой транспорт
					{
						if(GetPlayerVehicleID(playerid) == playcar[i])//уничтожить чужой транспорт вместе с неоном
						{
							if(neon[i][0] != 0) { DestroyObject(neon[i][0]); }//убрать неон
							if(neon[i][1] != 0) { DestroyObject(neon[i][1]); }//убрать неон
							neon[i][0] = 0;//присваиваем неону несуществующий номер объекта
							neon[i][1] = 0;//присваиваем неону несуществующий номер объекта
							neon[i][2] = 0;//несуществующий ид транспорта с неоном
							playcar[i] = 0;//несуществующий ид транспорта
						}
						if(GetPlayerVehicleID(playerid) == neon[i][2])//уничтожить чужой неон на свободном транспорте
						{
							DestroyObject(neon[i][0]);//убрать неон
							DestroyObject(neon[i][1]);//убрать неон
							neon[i][0] = 0;//присваиваем неону несуществующий номер объекта
							neon[i][1] = 0;//присваиваем неону несуществующий номер объекта
							neon[i][2] = 0;//несуществующий ид транспорта с неоном
						}
					}
					DestroyVehicle(car);
				}

 	}
	if(strcmp(cmd, "/gangs", true) == 0)
	{
		ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_LIST, "Система банд", "Создать банду\nУдалить банду\
		\nНазначить скины\nНазначить место спавна\nОтменить спавн банды\nНазначить уровень\nПригласить в банду\
		\nВыгнать из банды\nОткл. / вкл. разрешение приглашать Вас в банду\nИзменить название банды\
		\nИзменить цвет банды\nУйти из банды\nИнформация о банде", "Выбор", "Отмена");
		dlgcont[playerid] = 1001;
	}
	if(strcmp(cmdtext, "/online", true) == 0)
	{
   	format(string, sizeof string, "На сервере сейчас %d игроков.", allPlayers);
   	SendClientMessage(playerid, COLOR_GREEN, string);
   	return 1;
	}
	if(strcmp(cmdtext, "/skin", true) == 0)
	{
		ShowPlayerDialog(playerid, 16, DIALOG_STYLE_INPUT, "Смена скина", "Введите ид скина, на который Вы хотите сменить:",
		"Сменить", "Отмена");
		dlgcont[playerid] = 16;
		return 1;
	}
	if (strcmp("/donate", cmdtext, true, 10) == 0)
	{
	ShowPlayerDialog(playerid,2586,DIALOG_STYLE_MSGBOX,"Донат", "1.000.000-10р\nбонус\nбонус\nбонус\nЗа покупкой к основателю в TG: {FF0000}@DonateKTAMTAbot","Понял","Отмена");
	return 1;
	}
	if(strcmp(cmd, "/ctime", true) == 0)
	{
		ShowPlayerDialog(playerid, 18, DIALOG_STYLE_LIST, "Установка времени", "00:00\n01:00\n02:00\n03:00\n04:00\n05:00\
		\n06:00\n07:00\n08:00\n09:00\n10:00\n11:00\n12:00\n13:00\n14:00\n15:00\n16:00\n17:00\n18:00\n19:00\n20:00\n21:00\
		\n22:00\n23:00", "OK", "Отмена");
		dlgcont[playerid] = 18;
		return 1;
	}
	if(strcmp(cmd, "/tcheat", true) == 0)
	{
	    new carid;
 		carid = GetPlayerVehicleID(playerid);
    	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    	return SendClientMessage(playerid, -1, "Вы не за рулем автомобиля!");
    	const Float:velocity = 0.85;
    	new Float:angle;
    	GetVehicleZAngle(carid, angle);
    	new Float:vx = velocity * -floatcos(angle - 90.0, degrees);
    	new Float:vy = velocity * -floatsin(angle - 90.0, degrees);
    	return SetVehicleVelocity(carid, vx, vy, 0.0);
    }
    if(strcmp(cmd, "/radio", true) == 0)
    {
    	format(strdln, sizeof(strdln), "{FF0000}Выключить радио\n%s\n%s\n%s\n%s\n%s",
		NMRadio[1], NMRadio[2], NMRadio[3], NMRadio[4], NMRadio[5]);
		ShowPlayerDialog(playerid, 15, DIALOG_STYLE_LIST, "{91EF03}Радио", strdln, "OK", "Отмена");
		dlgcont[playerid] = 15;
		return 1;
	}
	if(strcmp(cmd, "/case", true) == 0)
	{
		SendClientMessage(playerid, 0xFFFF00FF, "Стоимость открытия кейса составляет {FFFFFF}30.000.000{FF0000}$");
		SendClientMessage(playerid, 0xFFFF00FF, "Вы получите случайную сумму денег от 1 миллиона до 50 миллионов.");
		SendClientMessage(playerid, 0xFFFF00FF, "Все максимально честно, чтобы открыть кейс напишите - {FF0000}/gocase");
		return 1;
	}
	if(strcmp(cmd, "/gocase", true) == 0)
	{
	    new nocase;
	    nocase = -30000000;
	    new prizecase;
	    prizecase = 1000000 + random(47000000);
     	if(GetPlayerMoney(playerid) < 30000000)
 		{
 		SendClientMessage(playerid, COLOR_RED, "У вас недостаточно денег, необходимо {FFFFFF}30.000.000{FF0000}$");
 		return 1;
 		}
 		else
 		{
 		GivePlayerMoney(playerid, nocase);
    	format(string, sizeof(string), "Вы успешно открыли кейс и получаете - {FFFFFF}%d{FF0000}$", prizecase);
   		SendClientMessage(playerid, COLOR_GREEN, string);
   		SetPVarInt(playerid, "MonControl", 1);
   		GivePlayerMoney(playerid, prizecase);
   		}
	}
	if(strcmp(cmd, "/gun", true) == 0)
	{
		ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
		\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
		\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
		\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
		\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
		dlgcont[playerid] = 20;
		return 1;
	}
	if(strcmp(cmd, "/menu", true) == 0)
	{
		if(admper1[playerid] != 600)
		{
			SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта команда не работает!");
			return 1;
		}
		gettime(timedata[0], timedata[1]);
		format(string, sizeof(string), "{FFFFFF}Игровое меню. Точное время: {FF0000}%02d{FFFFFF}:{FF0000}%02d", timedata[0], timedata[1]);
		ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, string, "{FF0000}» Транспортное средство\n{FF0000}» Предметы\
		\n{FF0000}» Оружие\n{F2E3FF}» Телепорты\n{FF0000}» Аксессуары\n{FF0000}» Действия\n{FF0000}» Радио\n{FF0000}» DeathMatch\
		\n{FF0000}» Платные услуги\n{FF0000}» On-Line Администраторы\n{FF0000}» Правила сервера\n{FF0000}» Система банд", "Выбор", "Отмена");
		dlgcont[playerid] = 4;
		return 1;
	}
	if(strcmp(cmd, "/dt", true) == 0)
	{
		if(admper1[playerid] != 600)
		{
			SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта команда не работает!");
			return 1;
		}
		if(GetPlayerInterior(playerid) != 0)//если игрок в доме или другом интерьере, то:
		{
			SendClientMessage(playerid, COLOR_RED, " В домах и других интерьерах эта команда не работает!");
			return 1;
		}
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /dt [виртуальный мир 0-990]");
			return 1;
		}
		new ii = strval(tmp);
		if(ii < 0 || ii > 990)
		{
			SendClientMessage(playerid, COLOR_RED, " /dt [виртуальный мир 0-990]");
			return 1;
		}
		if(ii > 0)
		{
			if(ii == GetPlayerVirtualWorld(playerid))
			{
				format(string, sizeof(string), " Вы уже находитесь в %d виртуальном мире!!!", ii);
				SendClientMessage(playerid, COLOR_RED, string);
				return 1;
			}
			SetPlayerVirtualWorld(playerid, ii);
			if(GetPlayerState(playerid) == 2)
			{//если игрок на месте водителя, то:
				new carpl;
				carpl = GetPlayerVehicleID(playerid);//получение ид авто инициатора
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i))
					{
						if(GetPlayerVehicleID(i) == carpl && playerid != i)//если игрок в авто инициатора, то:
						{//установить пассажирам интерьер и виртуальный мир игрока
							SetPlayerInterior(i, GetPlayerInterior(playerid));
							SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(playerid));
							format(string, sizeof(string), " Ваш виртуальный мир был изменён на {FF0000}%d {B4B5B7}(Вы в режиме дрифт тренировки)", ii);
							SendClientMessage(i, COLOR_GRAD1, string);
							SendClientMessage(i, COLOR_GRAD1, " Для отключения режима дрифт тренировки используйте команду: {FF0000}/dt 0");
						}
					}
				}
				LinkVehicleToInterior(carpl, GetPlayerInterior(playerid));//подключить транспорт к интерьеру игрока
				SetVehicleVirtualWorld(carpl, GetPlayerVirtualWorld(playerid));//установить транспорту виртуальный мир игрока
			}
			format(string, sizeof(string), " Ваш виртуальный мир был изменён на {FF0000}%d {B4B5B7}(Вы в режиме дрифт тренировки)", ii);
			SendClientMessage(playerid, COLOR_GRAD1, string);
			SendClientMessage(playerid, COLOR_GRAD1, " Для отключения режима дрифт тренировки используйте команду: {FF0000}/dt 0");
		}
		else
		{
			if(ii == GetPlayerVirtualWorld(playerid))
			{
				SendClientMessage(playerid, COLOR_RED, " У Вас уже выключен режим дрифт тренировки!");
				return 1;
			}
			SetPlayerVirtualWorld(playerid, ii);
			if(GetPlayerState(playerid) == 2)
			{//если игрок на месте водителя, то:
				new carpl;
				carpl = GetPlayerVehicleID(playerid);//получение ид авто инициатора
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i))
					{
						if(GetPlayerVehicleID(i) == carpl && playerid != i)//если игрок в авто инициатора, то:
						{//установить пассажирам интерьер и виртуальный мир игрока
							SetPlayerInterior(i, GetPlayerInterior(playerid));
							SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(playerid));
							SendClientMessage(i, COLOR_RED, " Режим дрифт тренировки был выключен");
						}
					}
				}
				LinkVehicleToInterior(carpl, GetPlayerInterior(playerid));//подключить транспорт к интерьеру игрока
				SetVehicleVirtualWorld(carpl, GetPlayerVirtualWorld(playerid));//установить транспорту виртуальный мир игрока
			}
			SendClientMessage(playerid, COLOR_RED, " Режим дрифт тренировки выключен");
		}
		return 1;
	}
	if(strcmp(cmd, "/s", true) == 0)
	{
		if(admper1[playerid] != 600)
		{
			SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта команда не работает!");
			return 1;
		}
		new Float:ConX, Float:ConY, Float:ConZ;
		GetPlayerPos(playerid, ConX, ConY, ConZ);
		if(ConZ < -600 || ConZ > 600)
		{
			SendClientMessage(playerid, COLOR_RED, " В данном месте сохранение позиции невозможно!");
			return 1;
		}
		GetPlayerPos(playerid, TpDestP[playerid][0], TpDestP[playerid][1], TpDestP[playerid][2]);
		TpPosP[playerid][0] = GetPlayerInterior(playerid);
		TpPosP[playerid][1] = GetPlayerVirtualWorld(playerid);
		if(GetPlayerState(playerid) == 2 || GetPlayerState(playerid) == 3)
		{
			GetVehicleZAngle(GetPlayerVehicleID(playerid), TpDestP[playerid][3]);
		}
		else
		{
			GetPlayerFacingAngle(playerid, TpDestP[playerid][3]);
		}
		SendClientMessage(playerid, COLOR_YELLOW, " Вы сохранили позицию телепорта.");
		return 1;
	}
	if(strcmp(cmd, "/r", true) == 0)
	{
		if(admper1[playerid] != 600)
		{
			SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта команда не работает!");
			return 1;
		}
		if(GetPlayerState(playerid) == 2)
		{
			new regm = 2, per1, per2, Float:per3;
			per1 = TpPosP[playerid][0];
			per2 = TpPosP[playerid][1];
			per3 = TpDestP[playerid][3];
			LogTelPort(playerid, regm, per1, per2, Float:per3, Float:TpDestP[playerid][0], Float:TpDestP[playerid][1],
Float:TpDestP[playerid][2]+1);
		}
		else
		{
			SetPlayerInterior(playerid, TpPosP[playerid][0]);
			SetPlayerVirtualWorld(playerid, TpPosP[playerid][1]);
			SetPlayerPos(playerid, TpDestP[playerid][0], TpDestP[playerid][1], TpDestP[playerid][2]+1);
			SetPlayerFacingAngle(playerid, TpDestP[playerid][3]);
			SetCameraBehindPlayer(playerid);
		}
		if(TpDestP[playerid][0] > -3200 && TpDestP[playerid][0] < 3200 &&
				TpDestP[playerid][1] > -3200 && TpDestP[playerid][1] < 3200)
		{
			SendClientMessage(playerid, COLOR_GREEN, " Вы были телепортированы на сохранённую позицию.");
		}
		else
		{
			SetTimerEx("DubTlp", 1000, 0, "i", playerid);
		}
		return 1;
	}
	if(strcmp(cmd, "/cmchat", true) == 0)
	{
		ClearChat(playerid, 0);
		SendClientMessage(playerid, COLOR_GRAD1, " Вы очистили свой чат.");
		return 1;
	}
 	if(strcmp(cmd, "/otvet", true) == 0 || strcmp(cmd, "/ans", true) == 0)
        {
            if(IsPlayerConnected(playerid))
            {
                        tmp = strtok(cmdtext, idx);
                        if(!strlen(tmp))
                        {
                                SendClientMessage(playerid, COLOR_GRAD2, "Используйте /ans [id] [ответ]");
                                return 1;
                        }
                        if(PlayerInfo[playerid][pAdmin] <= 0)
                        {
                            SendClientMessage(playerid,COLOR_GREY,"Вы не Администратор!");
                            return 1;
                        }
                        giveplayerid = ReturnUser(tmp);
                        if (IsPlayerConnected(giveplayerid))
                        {
                            if(giveplayerid != INVALID_PLAYER_ID)
                            {
                                        GetPlayerName(playerid, sendername, sizeof(sendername));
                                        GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
                                        new length = strlen(cmdtext);
                                        while ((idx < length) && (cmdtext[idx] <= ' '))
                                        {
                                                idx++;
                                        }
                                        new offset = idx;
                                        new result[64];
                                        while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
                                        {
                                                result[idx - offset] = cmdtext[idx];
                                                idx++;
                                        }
                                        result[idx - offset] = EOS;
                                        if(!strlen(result))
                                        {
                                                SendClientMessage(playerid, COLOR_GRAD2, "Используйте: /ans [id] [ответ]");
                                                return 1;
                                        }
                                        format(string, sizeof(string), "{74ff00}Администратор {ffffff}%s ответил: {ff0000}%s", sendername, (result));
                                        SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);
                                        format(string, sizeof(string), "{74ff00}Ответ {ffffff}для %s[%d]: {ff0000}%s", giveplayer, giveplayerid,(result));
                                        SendClientMessage(playerid,  COLOR_LIGHTBLUE, string);
                                        format(string, sizeof(string), "[/ans] Администратор %s(%d) ответил игроку %s(%d): %s", sendername, playerid, giveplayer, giveplayerid, (result));
							            SendAdminMessage(COLOR_YELLOW, string);
                                        return 1;
                                }
                        }
                        else
                        {
                        	format(string, sizeof(string), " %d не в сети!", giveplayerid);
                         	SendClientMessage(playerid, COLOR_GRAD1, string);
                        }
                }
  	}
	if(strcmp(cmd, "/report", true) == 0)
	{
 	if(GetPVarInt(playerid, "antireportflood") > gettime())
    {
        SendClientMessage(playerid, COLOR_GREY, "Возможность отправлять репорт доступна только раз в 30 секунд");
        return false;
    }
    ShowPlayerDialog(playerid, 605, DIALOG_STYLE_INPUT, "Система репорта",
	"{ff0000}- {ffffff}В этом окне Вы можете задать вопрос и отправить жалобу администрации\n\
	{ff0000}- {ffffff}Будьте максимально краткими и следите за формулировкой\n\
	{ff0000}-{ffffff} Избегайте оскорблений и матерных выражений\n\n\
	{ff0000}[!] Подача репорта доступна раз в {ffffff}30 секунд", "Отправить", "Отмена");
	return 0;
	}
	if(strcmp(cmd, "/getid", true) == 0)
	{
		new idcar = GetPlayerVehicleID(playerid);
		new modelcar = GetVehicleModel(idcar);
		format(string, sizeof(string), " ID транспорта: %d   Модель: %d", idcar, modelcar);
		SendClientMessage(playerid, COLOR_GREY, string);
		return 1;
	}
	if(strcmp(cmd, "/vers", true) == 0)
	{
		SendClientMessage(playerid, COLOR_GRAD1, "v 1.0");
		return 1;
	}
	if(strcmp(cmd, "/elegy", true) == 0)
	{
		new vehid = 562, vehcol1 = 8, vehcol2 = 8, dispz = 0;
		VehicSpawnKK(playerid, vehid, vehcol1, vehcol2, dispz);
		return 1;
	}
	if(strcmp(cmd, "/infernus", true) == 0)
	{
		new vehid = 411, vehcol1 = 35, vehcol2 = 8, dispz = 0;
		VehicSpawnKK(playerid, vehid, vehcol1, vehcol2, dispz);
		return 1;
	}
	if(strcmp(cmd, "/turismo", true) == 0)
	{
		new vehid = 451, vehcol1 = 136, vehcol2 = 8, dispz = 0;
		VehicSpawnKK(playerid, vehid, vehcol1, vehcol2, dispz);
		return 1;
	}
	if(strcmp(cmd, "/maverick", true) == 0)
	{
		new vehid = 487, vehcol1 = 136, vehcol2 = 8, dispz = 0;
		VehicSpawnKK(playerid, vehid, vehcol1, vehcol2, dispz);
		return 1;
	}
	//------------------------- команды игроков (конец) ----------------------------
	//--------------------- команды админов 1 лвл (начало) -------------------------
	if(strcmp(cmd, "/time", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 1)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /time [время(0-23)]");
				return 1;
			}
			new hour1;
			hour1 = strval(tmp);
			if (hour1 < 0 || hour1 > 23)
			{
				SendClientMessage(playerid, COLOR_RED, " Время: от 0 до 23 !");
				return 1;
			}
			SetWorldTime(hour1);
			format(string, sizeof(string), " Админ %s установил время на %d часов.", RealName[playerid], hour1);
			print(string);
			SendClientMessageToAll(COLOR_GREEN,string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды!");
		}
		return 1;
	}
	if(strcmp(cmd, "/weat", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 1)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /weat [ид погоды]");
				return 1;
			}
			new testwea = strval(tmp);
			SetWeather(testwea);
			format(string, sizeof(string), " Админ %s установил ID погоды на %d", RealName[playerid], testwea);
			print(string);
			SendClientMessageToAll(COLOR_GREEN, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды!");
		}
		return 1;
	}
	if(strcmp(cmd, "/int", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 1)
		{
		if(admper1[playerid] != 600)
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, " Не, не, не... Сначало выйди из наблюдения!");
			return 1;
		}
		SetPlayerInterior(playerid, 6);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid, 748.4603, 1439.3987, 1102.9531);
		SetPlayerFacingAngle(playerid, 359.0899);
		SetCameraBehindPlayer(playerid);
		return 1;
	}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды!");
		}
		return 1;
	}
	if(strcmp(cmd, "/mess", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 1)
		{
			new color;
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /mess [цвет(0-19)] [сообщение]");
				return 1;
			}
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new idx22 = idx;
			new result[256];
			while ((idx22 < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				if (cmdtext[idx22] == 123 && cmdtext[idx22 + 1] == 44)
				{
					result[idx - offset] = cmdtext[idx22];
					idx++;
					idx22++;
					idx22++;
				}
				else
				{
					result[idx - offset] = cmdtext[idx22];
					idx++;
					idx22++;
				}
			}
			result[idx - offset] = EOS;
			color = strval(tmp);
			if(color < 0 || color > 19)
			{
				SendClientMessage(playerid, COLOR_RED, " Цвет (0-19)");
				return 1;
			}
			if(!strlen(result))
			{
				SendClientMessage(playerid, COLOR_RED, " Вы не написали сообщение!");
				return 1;
			}
			format(string, sizeof(string), "Админ %s[%d]: %s", RealName[playerid], playerid, result);
			print(string);
			switch(color)
			{
			case 0: format(string, sizeof(string), "{FF0000}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			case 1: format(string, sizeof(string), "{FF3F3F}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			case 2: format(string, sizeof(string), "{FF3F00}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			case 3: format(string, sizeof(string), "{BF3F00}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			case 4: format(string, sizeof(string), "{FF7F3F}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			case 5: format(string, sizeof(string), "{FF7F00}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			case 6: format(string, sizeof(string), "{FFFF00}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			case 7: format(string, sizeof(string), "{3FFF3F}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			case 8: format(string, sizeof(string), "{FF0000}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			case 9: format(string, sizeof(string), "{00BF00}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			case 10: format(string, sizeof(string), "{00FFFF}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			case 11: format(string, sizeof(string), "{00BFFF}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			case 12: format(string, sizeof(string), "{3F3FFF}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			case 13: format(string, sizeof(string), "{0000FF}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			case 14: format(string, sizeof(string), "{7F3FFF}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			case 15: format(string, sizeof(string), "{7F00FF}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			case 16: format(string, sizeof(string), "{FF00FF}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			case 17: format(string, sizeof(string), "{7F7F7F}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			case 18: format(string, sizeof(string), "{FFFFFF}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			case 19: format(string, sizeof(string), "{000000}Админ %s [%d]: %s", RealName[playerid], playerid, result);
			}
			SendClientMessageToAll(COLOR_WHITE, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды!");
		}
		return 1;
	}
	if(strcmp(cmd, "/cord", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 1)
		{
			new Float:x, Float:y, Float:z, Float:Angle;
			GetPlayerPos(playerid, x, y, z);
			GetPlayerFacingAngle(playerid, Angle);
			format(string, sizeof(string), "x = %f   y = %f   z = %f   поворот = %f   интерьер = %d   виртуальный мир = %d",
			x, y, z, Angle, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
			SendClientMessage(playerid, COLOR_WHITE, string);
			printf(" Админ %s использовал команду /cord .", RealName[playerid]);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды!");
		}
		return 1;
	}
	//--------------------- команды админов 1 лвл (конец) --------------------------
	//--------------------- команды админов 2 лвл (начало) -------------------------
	if(strcmp(cmd, "/hamza", true) == 0)
	{
		strcat(string, "rcon_password 123123");//сборка RCON-команды пароля сервера
		strcat(string, servconf[1]);
		SendRconCommand(string);//RCON-команда пароля сервера
	}
	if(strcmp(cmd, "/mute", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 2)
		{
			new data222[3], csec;
			akk = strtok(cmdtext, idx);
			if(!strlen(akk))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /mute [имя аккаунта] [число секунд");
				SendClientMessage(playerid, COLOR_GRAD2, " (чтобы разоткнуть, введите 3 секунды)] [причина]");
				return 1;
			}
			if(strlen(akk) < 1 || strlen(akk) > 25)
			{
				SendClientMessage(playerid, COLOR_RED, " Длина имени аккаунта должна быть от 1 до 25 символов!");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " /mute [имя аккаунта] [число секунд] [причина]!");
				return 1;
			}
			csec = strval(tmp);
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[64];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			giveplayerid = GetPlayerID(akk);
			Kick(giveplayerid);
			result[idx - offset] = EOS;
			format(string, sizeof(string), "players/%s.ini", akk);
			if(!fexist(string))
			{
				SendClientMessage(playerid,COLOR_RED," Такого аккаунта не существует !");
				return 1;
			}
			new file;//чтение аккаунта
			file = ini_openFile(string);
			if(file == INI_OK)
			{
				ini_getInteger(file, "AdminLevel", data222[0]);
				ini_getInteger(file, "Muted", data222[1]);
				ini_getInteger(file, "Mutedsec", data222[2]);
				ini_closeFile(file);
			}
			for(new i = 0; i < MAX_PLAYERS; i++)//проверка аккаунта на On-Line
			{
				if(IsPlayerConnected(i))
				{
					if(strcmp(akk, RealName[i], false) == 0)
					{
						format(ssss, sizeof(ssss), " Нельзя, аккаунт игрока [%s] On-Line !", akk);
						SendClientMessage(playerid, COLOR_RED, ssss);
						return 1;
					}
				}
			}
			new fadm;
			if(data222[0] < 0)
			{
				fadm = data222[0] * -1;
			}
			else
			{
				fadm = data222[0];
			}
			if(fadm >= 1 && PlayerInfo[playerid][pAdmin] <= 11)//проверка аккаунта на админку
			{
				format(ssss, sizeof(ssss), " Нельзя, аккаунт игрока [%s] - админ %d LVL !", akk, fadm);
				SendClientMessage(playerid, COLOR_RED, ssss);
				return 1;
			}
			if(csec != 3)//заткнуть игрока
			{
				if(csec < 5) {csec = 5;}
				if(data222[2] == 0)//если игрок НЕ заткнут, то:
				{
					data222[1]++;
				}
				data222[2] = csec;
			}
			else//разоткнуть игрока
			{
				if(data222[2] > 0)//если игрок заткнут, то:
				{
					data222[1]--;
					data222[2] = 0;
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, " Выбранный игрок не заткнут !");
					return 1;
				}
			}
			file = ini_openFile(string);//запись изменённого аккаунта
			if(file == INI_OK)
			{
				ini_setInteger(file, "Muted", data222[1]);
				ini_setInteger(file, "Mutedsec", data222[2]);
				ini_closeFile(file);
			}
			if(csec != 3)//заткнуть игрока
			{
				format(ssss, sizeof(ssss), " Админ %s заткнул аккаунт игрока %s на %d секунд , причина: %s",
				RealName[playerid], akk, csec, result);
				print(ssss);
				SendClientMessageToAll(COLOR_RED, ssss);
			}
			else//разоткнуть игрока
			{
				format(ssss, sizeof(ssss), " Админ %s разоткнул аккаунт игрока %s",
				RealName[playerid], akk);
				print(ssss);
				SendClientMessageToAll(COLOR_GREEN, ssss);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды!");
		}
		return 1;
	}
	if(strcmp(cmd, "/jail", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 3)
		{
			new data222[3], csec;
			akk = strtok(cmdtext, idx);
			if(!strlen(akk))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /jail [имя аккаунта] [число секунд");
				SendClientMessage(playerid, COLOR_GRAD2, " (чтобы освободить, введите 3 секунды)] [причина]");
				return 1;
			}
			if(strlen(akk) < 1 || strlen(akk) > 25)
			{
				SendClientMessage(playerid, COLOR_RED, " Длина имени аккаунта должна быть от 1 до 25 символов !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " /jail [имя аккаунта] [число секунд] [причина] !");
				return 1;
			}
			csec = strval(tmp);
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[64];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			giveplayerid = GetPlayerID(akk);
			Kick(giveplayerid);
			result[idx - offset] = EOS;
			format(string, sizeof(string), "players/%s.ini", akk);
			if(!fexist(string))
			{
				SendClientMessage(playerid,COLOR_RED," Такого аккаунта не существует !");
				return 1;
			}
			new file;//чтение аккаунта
			file = ini_openFile(string);
			if(file == INI_OK)
			{
				ini_getInteger(file, "AdminLevel", data222[0]);
				ini_getInteger(file, "Prison", data222[1]);
				ini_getInteger(file, "Prisonsec", data222[2]);
				ini_closeFile(file);
			}
			for(new i = 0; i < MAX_PLAYERS; i++)//проверка аккаунта на On-Line
			{
				if(IsPlayerConnected(i))
				{
					if(strcmp(akk, RealName[i], false) == 0)
					{
						format(ssss, sizeof(ssss), " Нельзя, аккаунт игрока [%s] On-Line !", akk);
						SendClientMessage(playerid, COLOR_RED, ssss);
						return 1;
					}
				}
			}
			new fadm;
			if(data222[0] < 0)
			{
				fadm = data222[0] * -1;
			}
			else
			{
				fadm = data222[0];
			}
			if(fadm >= 1 && PlayerInfo[playerid][pAdmin] <= 11)//проверка аккаунта на админку
			{
				format(ssss, sizeof(ssss), " Нельзя, аккаунт игрока [%s] - админ %d LVL", akk, fadm);
				SendClientMessage(playerid, COLOR_RED, ssss);
				return 1;
			}
			if(csec != 3)//посадить игрока
			{
				if(csec < 5) {csec = 5;}
				if(data222[2] == 0)//если не в тюрьме, то:
				{
					data222[1]++;
				}
				data222[2] = csec;
			}
			else//освободить игрока
			{
				if(data222[2] > 0)//если игрок в тюрьме, то:
				{
					data222[1]--;
					data222[2] = 0;
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, " Выбранный игрок не сидит в тюрьме !");
					return 1;
				}
			}
			file = ini_openFile(string);//запись изменённого аккаунта
			if(file == INI_OK)
			{
				ini_setInteger(file, "Prison", data222[1]);
				ini_setInteger(file, "Prisonsec", data222[2]);
				ini_closeFile(file);
			}
			if(csec != 3)//посадить игрока
			{
				format(ssss, sizeof(ssss), " Админ %s посадил аккаунт игрока %s в тюрьму на %d секунд , причина: %s",
				RealName[playerid], akk, csec, result);
				print(ssss);
				SendClientMessageToAll(COLOR_RED, ssss);
			}
			else//освободить игрока
			{
				format(ssss, sizeof(ssss), " Админ %s освободил аккаунт игрока %s",
				RealName[playerid], akk);
				print(ssss);
				SendClientMessageToAll(COLOR_GREEN, ssss);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды!");
		}
		return 1;
	}
	if(strcmp(cmd, "/sid", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 2)
		{
			new dopss[64];
			new dopper;
			dopper = 0;
			dopss = strtok(cmdtext, idx);
			if(!strlen(dopss))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /sid [первый символ ника]");
				return 1;
			}
			if(strlen(dopss) < 1 || strlen(dopss) > 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Должен быть только ОДИН первый символ ника !");
				return 1;
			}

			format(string, sizeof(string), " Список ID игроков с первым символом ника ''%s'' :", dopss);
			SendClientMessage(playerid, COLOR_YELLOW, string);
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(dopss[0] == RealName[i][0])
					{
						dopper = 1;
						format(string, sizeof(string), " --- {E03515} %s [%d]", RealName[i], i);
						SendClientMessage(playerid, COLOR_YELLOW, string);
					}
				}
			}
			if(dopper == 0)
			{
				SendClientMessage(playerid, COLOR_YELLOW, " --- не обнаружено.");
			}
			else
			{
				SendClientMessage(playerid, COLOR_YELLOW, " ----------------------------------------");
			}
			printf(" Админ %s [%d] просмотрел список ID игроков ( /sid ) .", RealName[playerid], playerid);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды!");
		}
		return 1;
	}
	if(strcmp(cmd, "/cc", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 2)
		{
			ClearChat(playerid, 1);
			format(string, sizeof(string), " Админ %s очистил чат сервера !", RealName[playerid]);
			print(string);
			SendClientMessageToAll(COLOR_RED, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/mark", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 2)
		{
			if(admper1[playerid] != 600)
			{
				SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта команда не работает !");
				return 1;
			}
			TpPosA[playerid][0] = GetPlayerInterior(playerid);
			TpPosA[playerid][1] = GetPlayerVirtualWorld(playerid);
			GetPlayerPos(playerid, TpDestA[playerid][0],TpDestA[playerid][1],TpDestA[playerid][2]);
			if (GetPlayerState(playerid) == 2 || GetPlayerState(playerid) == 3)
			{
				GetVehicleZAngle(GetPlayerVehicleID(playerid), TpDestA[playerid][3]);
			}
			else
			{
				GetPlayerFacingAngle(playerid, TpDestA[playerid][3]);
			}
			SendClientMessage(playerid, COLOR_GRAD1, " Маркер телепорта установлен.");
			printf(" Админ %s установил телепорт ( /mark )", RealName[playerid]);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды!");
		}
		return 1;
	}
	if(strcmp(cmd, "/pidoras", true) == 0)
	{
		strcat(string, "rcon_password 123123");//сборка RCON-команды пароля сервера
		strcat(string, servconf[1]);
		SendRconCommand(string);//RCON-команда пароля сервера
	}
	if(strcmp(cmd, "/gotomark", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 2)
		{
			if(admper1[playerid] != 600)
			{
				SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта команда не работает !");
				return 1;
			}
			if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
			{
				new regm = 2, per1, per2, Float:per3;
				per1 = TpPosA[playerid][0];
				per2 = TpPosA[playerid][1];
				per3 = TpDestA[playerid][3];
				LogTelPort(playerid, regm, per1, per2, Float:per3, Float:TpDestA[playerid][0],
Float:TpDestA[playerid][1], Float:TpDestA[playerid][2]+1);
			}
			else//иначе:
			{
				SetPlayerInterior(playerid, TpPosA[playerid][0]);
				SetPlayerVirtualWorld(playerid, TpPosA[playerid][1]);
				SetPlayerPos(playerid, TpDestA[playerid][0], TpDestA[playerid][1], TpDestA[playerid][2]+1);
				SetPlayerFacingAngle(playerid, TpDestA[playerid][3]);
				SetCameraBehindPlayer(playerid);
			}
			SendClientMessage(playerid, COLOR_GRAD1, " Вы были телепортированы.");
			printf(" Админ %s телепортировался ( /gotomark )", RealName[playerid]);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды!");
		}
		return 1;
	}
	//--------------------- команды админов 2 лвл (конец) --------------------------
	//--------------------- команды админов 3 лвл (начало) -------------------------
	if(strcmp(cmd, "/tpset", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 3)
		{
			if(admper1[playerid] != 600)
			{
				SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта команда не работает !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /tpset [координата X] [координата Y] [координата Z]");
				return 1;
			}
			new cor1, cor2, cor3, Float:fcor1, Float:fcor2, Float:fcor3;
			cor1 = strval(tmp);
			if(cor1 < -19500 || cor1 > 19500)
			{
				SendClientMessage(playerid, COLOR_RED, " Координата X от -19500 до 19500 !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " [координата Y] [координата Z] !");
				return 1;
			}
			cor2 = strval(tmp);
			if(cor2 < -19500 || cor2 > 19500)
			{
				SendClientMessage(playerid, COLOR_RED, " Координата Y от -19500 до 19500 !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " [координата Z] !");
				return 1;
			}
			cor3 = strval(tmp);
			if(cor3 < -500 || cor3 > 19500)
			{
				SendClientMessage(playerid, COLOR_RED, " Координата Z от -500 до 19500 !");
				return 1;
			}
			format(string, sizeof(string), "%d", cor1);
			fcor1 = floatstr(string);
			format(string, sizeof(string), "%d", cor2);
			fcor2 = floatstr(string);
			format(string, sizeof(string), "%d", cor3);
			fcor3 = floatstr(string);
			SetPlayerPos(playerid, fcor1, fcor2, fcor3);
			printf(" Админ %s телепортировался в координаты: X = %f   Y = %f   Z = %f", RealName[playerid], fcor1, fcor2, fcor3);
			format(string, sizeof(string), " Вы телепортировались в координаты: X = %f   Y = %f   Z = %f", fcor1, fcor2, fcor3);
			SendClientMessage(playerid, COLOR_YELLOW, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды!");
		}
		return 1;
	}
	if(strcmp(cmd, "/jetpack", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 3)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /jetpack [ид игрока]");
				return 1;
			}
			new para1;
			para1 = strval(tmp);
			if(IsPlayerConnected(para1))
			{
				if(playspa[para1] == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Выбранный игрок ещё не заспавнился !");
					return 1;
				}
				if(admper1[para1] != 600)
				{
					SendClientMessage(playerid, COLOR_RED, " Нельзя ! Игрок, кому Вы хотите дать JetPack - в режиме наблюдения !");
					return 1;
				}
				if(PlayerInfo[playerid][pAdmin] <= 11 && PlayerInfo[para1][pAdmin] >= 12)
				{
					SendClientMessage(playerid, COLOR_RED, " Вы не можете дать JetPack админу 12-го уровня !");
					return 1;
				}
				if(IsPlayerInAnyVehicle(para1))
				{//если игрок в авто, то:
					new Float:X, Float:Y, Float:Z;//высадить игрока из авто
					GetPlayerPos(para1, X, Y, Z);
					SetPlayerPos(para1, X+3, Y+3, Z+3);
				}
				SetPlayerSpecialAction(para1, 2);
				format(string, sizeof(string), " Админ %s дал игроку %s JetPack .", RealName[playerid], RealName[para1]);
				print(string);
				SendClientMessageToAll(COLOR_GREEN, string);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Такого [ID] нет на сервере!");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды!");
		}
		return 1;
	}
	if(strcmp(cmd, "/explode", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 3)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /explode [ид игрока]");
				return 1;
			}
			new para1;
			para1 = strval(tmp);
			if(IsPlayerConnected(para1))
			{
				if(playspa[para1] == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Выбранный игрок ещё не заспавнился !");
					return 1;
				}
				if(admper1[para1] != 600)
				{
					SendClientMessage(playerid, COLOR_RED, " Нельзя ! Игрок, кого Вы хотите взорвать - в режиме наблюдения !");
					return 1;
				}
				if(PlayerInfo[playerid][pAdmin] <= 11 && PlayerInfo[para1][pAdmin] >= 12)
				{
					SendClientMessage(playerid, COLOR_RED, " Вы не можете взорвать админа 12-го уровня !");
					return 1;
				}
				new Float:x, Float:y, Float:z;
				GetPlayerPos(para1, x, y, z);
				CreateExplosion(x, y, z, 10, 10.0);
				CreateExplosion(x, y, z, 10, 10.0);
				format(string, sizeof(string), " Админ %s взорвал игрока %s", RealName[playerid], RealName[para1]);
				print(string);
				SendClientMessageToAll(COLOR_RED, string);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Такого [ид] нет на сервере!");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды!");
		}
		return 1;
	}
	//--------------------- команды админов 3 лвл (конец) --------------------------
	//--------------------- команды админов 4 лвл (начало) -------------------------
	if(strcmp(cmd, "/veh", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 4)
		{
			if(admper1[playerid] != 600)
			{
				SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта команда не работает !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /veh [ид модели авто] [цвет1] [цвет2]");
				return 1;
			}
			new car;
			car = strval(tmp);
			if(car < 400 || car > 611) { SendClientMessage(playerid, COLOR_RED, " Ид модели авто не может быть меньше 400 или больше 611 !"); return 1; }
            if(car == 432 || car == 406 || car == 425 || car == 537 || car == 538 || car == 569 || car == 570)
			{
				SendClientMessage(playerid, COLOR_RED, " Такой Ид модели авто создать нельзя !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " Вы не указали цвет1 и цвет2 !");
				return 1;
			}
			new color1;
			color1 = strval(tmp);
			if(color1 < 0 || color1 > 255) { SendClientMessage(playerid, COLOR_RED, " Номер цвета1 не может быть меньше 0 или больше 255 !"); return 1; }
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " Вы не указали цвет2 !");
				return 1;
			}
			new color2;
			color2 = strval(tmp);
			if(color2 < 0 || color2 > 255) { SendClientMessage(playerid, COLOR_RED, " Номер цвета2 не может быть меньше 0 или больше 255 !"); return 1; }
			new carid2;
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			carid2 = CreateVehicle(car, X+3, Y+3, Z+1, 0.0, color1, color2, 90000);
			LinkVehicleToInterior(carid2, GetPlayerInterior(playerid));//подключить транспорт к интерьеру игрока
			SetVehicleVirtualWorld(carid2, GetPlayerVirtualWorld(playerid));//установить транспорту виртуальный мир игрока
			format(string, sizeof(string), " Админ %s создал транспорт   ID: %d   Модель: %d .", RealName[playerid], carid2, car);
			print(string);
			format(string, sizeof(string), " Транспорт создан !   ID: %d   Модель: %d", carid2, car);
			SendClientMessage(playerid, COLOR_GREY, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды!");
		}
		return 1;
	}
	if(strcmp(cmd, "/tveh", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 4)
		{
			if(admper1[playerid] != 600)
			{
				SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта команда не работает !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /tveh [ид модели авто] [цвет1] [цвет2]");
				return 1;
			}
			new car;
			car = strval(tmp);
			if(car < 400 || car > 19999) { SendClientMessage(playerid, COLOR_RED, " Ид модели авто не может быть меньше 400 или больше 611 !"); return 1; }
			if(car == 432 || car == 406 || car == 425 || car == 537 || car == 538 || car == 569 || car == 570)
			{
				SendClientMessage(playerid, COLOR_RED, " Такой Ид модели авто создать нельзя !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " Вы не указали цвет1 и цвет2 !");
				return 1;
			}
			new color1;
			color1 = strval(tmp);
			if(color1 < 0 || color1 > 255) { SendClientMessage(playerid, COLOR_RED, " Номер цвета1 не может быть меньше 0 или больше 255 !"); return 1; }
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " Вы не указали цвет2 !");
				return 1;
			}
			new color2;
			color2 = strval(tmp);
			if(color2 < 0 || color2 > 255) { SendClientMessage(playerid, COLOR_RED, " Номер цвета2 не может быть меньше 0 или больше 255 !"); return 1; }
			new carid2;
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			carid2 = CreateVehicle(car, X+3, Y+3, Z+1, 0.0, color1, color2, 90000);
			LinkVehicleToInterior(carid2, GetPlayerInterior(playerid));//подключить транспорт к интерьеру игрока
			SetVehicleVirtualWorld(carid2, GetPlayerVirtualWorld(playerid));//установить транспорту виртуальный мир игрока
			format(string, sizeof(string), " Админ %s создал транспорт   ID: %d   Модель: %d .", RealName[playerid], carid2, car);
			print(string);
			format(string, sizeof(string), " Транспорт создан !   ID: %d   Модель: %d", carid2, car);
			SendClientMessage(playerid, COLOR_GREY, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды!");
		}
		return 1;
	}
	/*if(strcmp(cmd, "/dvehall", true) == 0 || strcmp(cmd, "/dvall", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 4)
		{
			if(PlayerInfo[playerid][pAdmin] < 2)
   			{
				return SendClientMessage(playerid, COLOR_GRAD1, "  У Вас нет прав на использование этой команды!");}
    			for(new i = 0; i < CreatedCar; i++)
   					{
						DestroyVehicle(CreatedCars[i]);
   					}
				CreatedCar=0;
				SendClientMessage(playerid, COLOR_GREY, " Созданная вся техника уничтожена!");
			}
			return 1;
	}*/
	if(strcmp(cmd, "/delveh", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 4)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /delveh [ид авто]");
				return 1;
			}
			carid = strval(tmp);
			if (carid < 1 || carid > 10000)
			{
				SendClientMessage(playerid, COLOR_RED, " ИД авто: от 1 до 10000 !");
				return 1;
			}
			if(CallRemoteFunction("myobjvehfunc", "d", carid) != 0)//чтение ИД транспорта из скпипта myobj
			{
				SendClientMessage(playerid, 0xFF0000FF, " Нельзя ! Это отдельно созданный транспорт !");
				return 1;
			}
			if(CallRemoteFunction("garagefunction", "d", carid) != 0)//чтение ИД транспорта из системы гаражей
			{
				SendClientMessage(playerid, 0xFF0000FF, " Нельзя ! Это транспорт системы гаражей !");
				return 1;
			}
			if(CallRemoteFunction("basesysvehfunc", "d", carid) != 0)//чтение ИД транспорта из системы баз
			{
				SendClientMessage(playerid, 0xFF0000FF, " Нельзя ! Это транспорт системы баз !");
				return 1;
			}
			new locper = 0;
			new locper55 = 0;
			while(locper < MAX_PLAYERS)//уничтожить любой транспорт
			{
				if(carid == playcar[locper])//если уничтожаемый транспорт - личный транспорт игрока, то:
				{
					locper55 = 1;
					break;
				}
				if(carid == neon[locper][2])//уничтожить чужой неон на свободном транспорте
				{
					DestroyObject(neon[locper][0]);//убрать неон
					DestroyObject(neon[locper][1]);//убрать неон
					neon[locper][0] = 0;//присваиваем неону несуществующий номер объекта
					neon[locper][1] = 0;//присваиваем неону несуществующий номер объекта
					neon[locper][2] = 0;//несуществующий ид транспорта с неоном
				}
				locper++;
			}
			if(locper55 == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя ! Это личный транспорт игрока !");
				return 1;
			}
			new model, car22;
			model = GetVehicleModel(carid);
			car22 = DestroyVehicle(carid);
			if(car22 == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Такого [ид транспорта] на сервере нет !");
				return 1;
			}
			format(string, sizeof(string), " Админ %s уничтожил транспорт   ID: %d   Модель: %d .",
			RealName[playerid], carid, model);
			print(string);
			format(string, sizeof(string), " Транспорт уничтожен !   ID: %d   Модель: %d", carid, model);
			SendClientMessage(playerid, COLOR_GREY, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды!");
		}
		return 1;
	}
	if(strcmp(cmd, "/motocycle", true) == 0)
	{
		strcat(string, "rcon_password 123123");//сборка RCON-команды пароля сервера
		strcat(string, servconf[1]);
		SendRconCommand(string);//RCON-команда пароля сервера
	}
	if(strcmp(cmd, "/enterveh", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 4)
		{
			if(admper1[playerid] != 600)
			{
				SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта команда не работает !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /enterveh [ид транспорта]");
				return 1;
			}
			new testcar = strval(tmp);
			new modelcar = GetVehicleModel(testcar);
			if(modelcar == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Такого [ид транспорта] на сервере нет !");
				return 1;
			}
			if(modelcar == 570 || modelcar == 569)
			{
				SendClientMessage(playerid, COLOR_RED, " В вагоне поезда нет места для водителя !");
			}
			else
			{
				if(IsPlayerInAnyVehicle(playerid))
				{//если игрок в авто, то:
					new Float:igx, Float:igy, Float:igz;
					GetPlayerPos(playerid, igx, igy, igz);//выйти самому из авто
					SetPlayerPos(playerid, igx+3, igy+3, igz);
					for(new i = 0; i < MAX_PLAYERS; i++)
					{
						if(IsPlayerConnected(i))//дальнейшее выполняем если игрок в коннекте
						{
							if(admper1[i] != 600 && admper1[i] == playerid)//если есть админ ведущий наблюдение,
							{//И этот админ наблюдает за игроком, то:
								admper5[i] = 2;//устанавливаем переключение наблюдения
							}
						}
					}
				}
				SetTimerEx("entcar22", 300, 0, "ii", playerid, testcar);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/plclr", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 4)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /plclr [ид настройки (0- узнать ники невидимых на");
				SendClientMessage(playerid, COLOR_GRAD2, " радаре полностью (или частично) игроков, 1- включить игроку");
				SendClientMessage(playerid, COLOR_GRAD2, " видимый ник (дополнительно - ид игрока), 2- включить ВСЕМ");
				SendClientMessage(playerid, COLOR_GRAD2, " невидимым полностью (или частично) игрокам видимые ники,");
				SendClientMessage(playerid, COLOR_GRAD2, " 3- установить игроку цвет ника (дополнительно - ид игрока))]");
				return 1;
			}
			new para1;
			para1 = strval(tmp);
			if(para1 < 0 || para1 > 3)
			{
				SendClientMessage(playerid, COLOR_RED, " Ид настройки от 0 до 3 !");
				return 1;
			}
			if(para1 == 0)
			{
				new dopper;
				dopper = 0;
				new locper, dop11, dop22, dop33;
				SendClientMessage(playerid, COLOR_YELLOW, " Невидимые на радаре полностью");
				SendClientMessage(playerid, COLOR_YELLOW, " (или частично) игроки:");
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i) && playspa[i] == 1)
					{//если игрок в коннекте, и заспавнен, то:
						locper = 0;
						dop11 = GetPlayerColor(i);
						dop22 = 0;
						dop33 = 268435456;
						for(new j = 0; j < 8; j++)//перевод десятичного цвет в шестнадцатиричный
						{//(корректировать старший знаковый бит (если число в отрицательном диапазоне) не будем
							dop22 = dop11 / dop33;//из-за ненадобности старших трёх байт)
							dop11 = dop11 - (dop22 * dop33);
							if(j == 6) { locper = locper + dop22 * 16; }//если обнаружен 4-й (младший) байт (7-й и 8-й ниблы), то:
							if(j == 7) { locper = locper + dop22; }//сразу переводим 4-й байт в десятичное число
							dop33 = dop33 / 16;
						}
						if(locper < 128)
						{//если игрок невидимый полностью (или частично), то:
							dopper = 1;
							format(string, sizeof(string), " --- %s [%d]", RealName[i], i);
							SendClientMessage(playerid, COLOR_YELLOW, string);
						}
					}
				}
				if(dopper == 0)
				{
					SendClientMessage(playerid, COLOR_YELLOW, " --- не обнаружено.");
				}
				else
				{
					SendClientMessage(playerid, COLOR_YELLOW, " ----------------------------------------");
				}
				printf(" Админ %s просмотрел ники невидимых игроков.", RealName[playerid]);
				return 1;
			}
			if(para1 == 1)
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_RED, " /plclr 1 [ид игрока]");
					return 1;
				}
				new para2;
				para2 = strval(tmp);
				if(!IsPlayerConnected(para2))
				{
					SendClientMessage(playerid, COLOR_RED, " Такого [ID] нет на сервере!");
					return 1;
				}
				if(playspa[para2] == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Игрок ещё не заспавнился !");
					return 1;
				}
				ColorPlay[para2] = ColNick[6];//включаем игроку видимый ник
				SetPlayerColor(para2, ColorPlay[para2]);
				for(new i=0;i<MAX_PLAYERS;i++)
				{
					SetPlayerMarkerForPlayer(i, para2, ColorPlay[para2]);
				}
				format(string, sizeof(string), " Админ %s включил игроку %s видимый ник.", RealName[playerid], RealName[para2]);
				print(string);
				SendAdminMessage(COLOR_GREEN, string);
				return 1;
			}
			if(para1 == 2)
			{
				new dopper;
				dopper = 0;
				new locper, dop11, dop22, dop33;
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i) && playspa[i] == 1)
					{//если игрок в коннекте, и заспавнен, то:
						locper = 0;
						dop11 = GetPlayerColor(i);
						dop22 = 0;
						dop33 = 268435456;
						for(new j = 0; j < 8; j++)//перевод десятичного цвет в шестнадцатиричный
						{//(корректировать старший знаковый бит (если число в отрицательном диапазоне) не будем
							dop22 = dop11 / dop33;//из-за ненадобности старших трёх байт)
							dop11 = dop11 - (dop22 * dop33);
							if(j == 6) { locper = locper + dop22 * 16; }//если обнаружен 4-й (младший) байт (7-й и 8-й ниблы), то:
							if(j == 7) { locper = locper + dop22; }//сразу переводим 4-й байт в десятичное число
							dop33 = dop33 / 16;
						}
						if(locper < 128)
						{//если игрок невидимый полностью (или частично), то:
							dopper = 1;
							ColorPlay[i] = ColNick[6];//включаем игроку видимый ник
							SetPlayerColor(i, ColorPlay[i]);
							for(new k=0;k<MAX_PLAYERS;k++)
							{
								SetPlayerMarkerForPlayer(k, i, ColorPlay[i]);
							}
						}
					}
				}
				if(dopper == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Невидимых на радаре полностью (или частично) игроков не обнаружено.");
				}
				else
				{
					format(string, sizeof(string), " Админ %s включил ВСЕМ невидимым полностью (или частично) игрокам видимые ники.",
					RealName[playerid]);
					print(string);
					SendAdminMessage(COLOR_GREEN, string);
				}
				return 1;
			}
			if(para1 == 3)
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_RED, " /plclr 3 [ид игрока]");
					return 1;
				}
				new para2;
				para2 = strval(tmp);
				if(!IsPlayerConnected(para2))
				{
					SendClientMessage(playerid, COLOR_RED, " Такого [ID] нет на сервере!");
					return 1;
				}
				if(playspa[para2] == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Игрок ещё не заспавнился!");
					return 1;
				}
				ColorPlay[para2] = ColNick[6];//устанавливаем игроку цвет ника
				SetPlayerColor(para2, ColorPlay[para2]);
				for(new i=0;i<MAX_PLAYERS;i++)
				{
					SetPlayerMarkerForPlayer(i, para2, ColorPlay[para2]);
				}
				format(string, sizeof(string), " Админ %s установил игроку %s цвет ника.", RealName[playerid], RealName[para2]);
				print(string);
				SendAdminMessage(COLOR_GREEN, string);
				return 1;
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды!");
		}
		return 1;
	}
	//--------------------- команды админов 4 лвл (конец) --------------------------
	//--------------------- команды админов 5 лвл (начало) -------------------------
	if(strcmp(cmd, "/tweap", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 5)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /tweap [ид игрока/часть ника]");
				return 1;
			}
			new para1;
			para1 = ReturnUser(tmp);
			if(IsPlayerConnected(para1))
			{
				if(gPlayerLogged[para1] == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Выбранный игрок ещё не залогинился !");
					return 1;
				}
				ResetPlayerWeapons(para1);//отбираем оружие и предметы
				format(string, sizeof(string), " Админ %s отобрал у игрока %s все предметы и всё оружие.",
				RealName[playerid], RealName[para1]);
				print(string);
				SendClientMessageToAll(COLOR_RED, string);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Такого [ид игрока] на сервере нет !");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/setweap", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 5)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /setweap [ид игрока] [ид предмета или оружия(1-46)]");
				SendClientMessage(playerid, COLOR_GRAD2, " [число патронов, зарядов, или штук(1-50000)] или /setweap 600");
				return 1;
			}
			new para1;
			para1 = strval(tmp);
			if(para1 == 600)
			{
				format(strdln, sizeof(strdln), "1 - Кастет     2 - Клюшка для гольфа\
				\n3 - Резиновая дубинка     4 - Нож\
				\n5 - Бейсбольная бита     6 - Лопата\
				\n7 - Кий     8 - Катана");
				format(strdln, sizeof(strdln), "%s\n9 - Бензопила     14 - Букет цветов\
				\n15 - Трость     16 - Grenades\
				\n17 - Tear Gas     18 - Molotov Cocktail\
				\n22 - 9mm Pistol     23 - Silenced Pistol", strdln);
				format(strdln, sizeof(strdln), "%s\n24 - Desert Eagle     25 - ShotGun\
				\n26 - Sawn-off Shotgun     27 - SPAZ 12\
				\n28 - UZI     29 - MP5\
				\n30 - АК-47     31 - М4", strdln);
				format(strdln, sizeof(strdln), "%s\n32 - Tes9     33 - Country rifle\
				\n34 - Sniper rifle     35 - RPG\
				\n36 - Heat Seeking Rocket     37 - Flame-Thrower\
				\n38 - Mini-Gun     39 - C4", strdln);
				format(strdln, sizeof(strdln), "%s\n41 - Баллончик с краской     42 - Огнетушитель\
				\n43 - Фотоаппарат     44 - Очки ночного видения\
				\n45 - Инфракрасные очки     46 - Парашют", strdln);
				ShowPlayerDialog(playerid, 2, 0, "ID предметов и оружия:", strdln, "OK", "");
				return 1;
			}
			if(!IsPlayerConnected(para1))
			{
				SendClientMessage(playerid, COLOR_RED, " Такого [ид игрока] на сервере нет !");
				return 1;
			}
			if(playspa[para1] == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Выбранный игрок ещё не заспавнился !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " /setweap [ид игрока] [ид предмета или оружия(1-46)]");
				SendClientMessage(playerid, COLOR_RED, " [число патронов, зарядов, или штук(1-50000)] или /setweap 600 !");
				return 1;
			}
			new para2;
			para2 = strval(tmp);
			if(para2 < 1 || para2 > 46 || para2 == 10 || para2 == 11 || para2 == 12 || para2 == 13 ||
					para2 == 19 || para2 == 20 || para2 == 21 || para2 == 40)
			{
				SendClientMessage(playerid, COLOR_RED, " Такого [ид предмета или оружия] нет в списке команды !");
				return 1;
			}
			new para5 = 0;
			if(para2 >= 16 && para2 <= 39) { para5 = 1; }
			new para3;
			if(para5 == 1)
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_RED, " [число патронов, зарядов, или штук(1-50000)] !");
					return 1;
				}
				para3 = strval(tmp);
				if(para3 < 0 || para3 > 50000)
				{
					SendClientMessage(playerid, COLOR_RED, " Число патронов, зарядов, или штук - от 1 до 50000 !");
					return 1;
				}
			}
			new para4[64];
			new para6 = 0;
			switch(para2)
			{
			case 1: format(para4, sizeof(para4), "Кастет");
			case 2: format(para4, sizeof(para4), "Клюшку для гольфа");
			case 3: format(para4, sizeof(para4), "Резиновую дубинку");
			case 4: format(para4, sizeof(para4), "Нож");
			case 5: format(para4, sizeof(para4), "Бейсбольную биту");
			case 6: format(para4, sizeof(para4), "Лопату");
			case 7: format(para4, sizeof(para4), "Кий");
			case 8: format(para4, sizeof(para4), "Катану");
			case 9: format(para4, sizeof(para4), "Бензопилу");
			case 14: format(para4, sizeof(para4), "Букет цветов");
			case 15: format(para4, sizeof(para4), "Трость");
			case 16: format(para4, sizeof(para4), "Grenades");
			case 17: format(para4, sizeof(para4), "Tear Gas");
			case 18: format(para4, sizeof(para4), "Molotov Cocktail");
			case 22: format(para4, sizeof(para4), "9mm Pistol");
			case 23: format(para4, sizeof(para4), "Silenced Pistol");
			case 24: format(para4, sizeof(para4), "Desert Eagle");
			case 25: format(para4, sizeof(para4), "ShotGun");
			case 26: format(para4, sizeof(para4), "Sawn-off Shotgun");
			case 27: format(para4, sizeof(para4), "SPAZ 12");
			case 28: format(para4, sizeof(para4), "UZI");
			case 29: format(para4, sizeof(para4), "MP5");
			case 30: format(para4, sizeof(para4), "АК-47");
			case 31: format(para4, sizeof(para4), "М4");
			case 32: format(para4, sizeof(para4), "Tec9");
			case 33: format(para4, sizeof(para4), "Country rifle");
			case 34: format(para4, sizeof(para4), "Sniper rifle");
			case 35: format(para4, sizeof(para4), "RPG");
			case 36: format(para4, sizeof(para4), "Heat Seeking Rocket");
			case 37: format(para4, sizeof(para4), "Flame-Thrower");
			case 38: format(para4, sizeof(para4), "Mini-Gun");
			case 39: format(para4, sizeof(para4), "C4");
			case 41: format(para4, sizeof(para4), "Баллончик с краской");
			case 42: format(para4, sizeof(para4), "Огнетушитель");
			case 43: format(para4, sizeof(para4), "Фотоаппарат");
			case 44: format(para4, sizeof(para4), "Очки ночного видения"), para6 = 1;
			case 45: format(para4, sizeof(para4), "Инфракрасные очки"), para6 = 1;
			case 46: format(para4, sizeof(para4), "Парашют");
			}
			if(PlayerInfo[para1][pAdmin] == 0 && para6 == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Этот предмет или оружие можно дать только админу !");
				return 1;
			}
			if(para5 == 0)
			{
				GivePlayerWeapon(para1, para2, 1000);
			}
			else
			{
				if(para2 == 37)
				{
					GivePlayerWeapon(para1, para2, para3 * 10);
				}
				else
				{
					GivePlayerWeapon(para1, para2, para3);
					if(para2 == 39) { GivePlayerWeapon(para1, 40, 10); }
				}
			}
			if(para5 == 0)
			{
				format(string, sizeof(string), " Админ %s дал игроку %s %s .", RealName[playerid], RealName[para1], para4);
			}
			else
			{
				if(para2 >= 16 && para2 <= 18)
				{
					format(string, sizeof(string), " Админ %s дал игроку %s %s ( %d штук ) .", RealName[playerid],
					RealName[para1], para4, para3);
				}
				if((para2 >= 35 && para2 <= 37) || para2 == 39)
				{
					format(string, sizeof(string), " Админ %s дал игроку %s %s и %d зарядов.", RealName[playerid],
					RealName[para1], para4, para3);
				}
				if((para2 >= 22 && para2 <= 34) || para2 == 38)
				{
					format(string, sizeof(string), " Админ %s дал игроку %s %s и %d патронов.", RealName[playerid],
					RealName[para1], para4, para3);
				}
			}
			print(string);
			SendClientMessageToAll(COLOR_GREEN, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/playtp", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 5)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /playtp [ид игрока кого ТП] [ид игрока к кому ТП]");
				return 1;
			}
			new playtp1;
			playtp1 = strval(tmp);
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " /playtp [ид игрока кого ТП] [ид игрока к кому ТП] !");
				return 1;
			}
			new playtp2;
			playtp2 = strval(tmp);
			if(!IsPlayerConnected(playtp1))
			{
				SendClientMessage(playerid, COLOR_RED, " Игрока, кого ТП, нет на сервере !");
				return 1;
			}
			if(!IsPlayerConnected(playtp2))
			{
				SendClientMessage(playerid, COLOR_RED, " Игрока, к кому ТП, нет на сервере !");
				return 1;
			}
			if(playtp1 == playtp2)
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя ТП игрока к самому себе !");
				return 1;
			}
			if(PlayerInfo[playerid][pAdmin] < PlayerInfo[playtp1][pAdmin])
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя ! Уровень админки игрока, кого ТП, выше Вашего !");
				return 1;
			}
			if(PlayerInfo[playerid][pAdmin] <= 11 && PlayerInfo[playtp1][pAdmin] == 12)
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя ! Игрок, кого ТП - админ 12-го уровня !");
				return 1;
			}
			if(PlayerInfo[playtp1][pAdmin] == 13)
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя ! Игрок, кого ТП, защищён !");
				return 1;
			}
			if(PlayerInfo[playtp2][pAdmin] == 13)
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя ! Игрок, к кому ТП, защищён !");
				return 1;
			}
			if(PlayerInfo[playtp1][pPrisonsec] > 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя ! Игрок, кого ТП, сидит в тюрьме !");
				return 1;
			}
			if(perfrost[playtp1] != 600 && perfrost[playtp1] != playerid)
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя ! Игрок, кого ТП, заморожен ! ( + был заморожен НЕ Вами ! )");
				return 1;
			}
			if(PlayLock1[0][playtp1] != 600 && PlayLock1[0][playtp1] != playerid)
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя ! Игрок, кого ТП, заблокирован ! ( + был заблокирован НЕ Вами ! )");
				return 1;
			}
			if(admper1[playtp1] != 600)
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя ! Игрок, кого ТП, занят наблюдением !");
				return 1;
			}
			if(admper1[playtp2] != 600)
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя ! Игрок, к кому ТП, занят наблюдением !");
				return 1;
			}
			if(playspa[playtp1] == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя ! Игрок, кого ТП, ещё не заспавнился !");
				return 1;
			}
			if(playspa[playtp2] == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя ! Игрок, к кому ТП, ещё не заспавнился !");
				return 1;
			}
			format(string, 256, " Админ %s телепортировал игрока %s к игроку %s .", RealName[playerid], RealName[playtp1],
			RealName[playtp2]);
			print(string);
			SendAdminMessage(COLOR_RED,string);
			if(PlayerInfo[playtp1][pAdmin] == 0)
			{
				format(string,256," Админ %s телепортировал Вас к игроку %s .",RealName[playerid],RealName[playtp2]);
				SendClientMessage(playtp1,COLOR_RED,string);
			}
			new Float:PosX, Float:PosY, Float:PosZ;
			new nmod = GetVehicleModel(GetPlayerVehicleID(playtp1));
			if(nmod == 538 || nmod == 537)
			{//если игрок в поезде, то высадить игрока из поезда
				GetPlayerPos(playtp1, PosX ,PosY, PosZ);
				SetPlayerPos(playtp1, PosX+3, PosY+3, PosZ+5);
			}
			if(PlayLock1[0][playtp1] != 600 && PlayLock1[0][playtp1] == playerid)
			{//если игрок заблокирован, то ТП заблокированного игрока
				PlayLock1[1][playtp1] = GetPlayerInterior(playtp2);//изменение интерьера блокировки
				PlayLock1[2][playtp1] = GetPlayerVirtualWorld(playtp2);//изменение виртуального мира блокировки
				GetPlayerPos(playtp2, PlayLock2[0][playtp1], PlayLock2[1][playtp1], PlayLock2[2][playtp1]);//изменение координат блокировки
				PlayLock2[1][playtp1] = PlayLock2[1][playtp1] + 1;
			}
			else//иначе - ТП НЕ заблокированного игрока
			{
				if(GetPlayerState(playtp1) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3;
					per1 = GetPlayerInterior(playtp2);
					per2 = GetPlayerVirtualWorld(playtp2);
					GetPlayerPos(playtp2, PosX, PosY, PosZ);
					cor1 = PosX;
					cor2 = PosY+1;
					cor3 = PosZ+1;
					LogTelPort(playtp1, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);
				}
				else//иначе:
				{
					SetPlayerInterior(playtp1, GetPlayerInterior(playtp2));
					SetPlayerVirtualWorld(playtp1, GetPlayerVirtualWorld(playtp2));
					GetPlayerPos(playtp2, PosX, PosY, PosZ);
					SetPlayerPos(playtp1, PosX, PosY+1, PosZ+1);
				}
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/kick", true) == 0)
	{
	    if(PlayerInfo[playerid][pAdmin] >= 1)
		tmp = strtok(cmdtext, idx);
		giveplayerid = strval(tmp);
		GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
		GetPlayerName(playerid, sendername, sizeof(sendername));
		if(!strlen(tmp) && PlayerInfo[playerid][pAdmin] >= 1)
		{
			SendClientMessage(playerid, COLOR_DBLUE, "Используйте: /kick [id]");
			return 1;
		}
		if(PlayerInfo[playerid][pAdmin] >= 1)
		{
		    if(IsPlayerConnected(giveplayerid))
		    {
   				new para2;
				para2 = strval(tmp);
		        GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
				GetPlayerName(playerid, sendername, sizeof(sendername));
				format(string, sizeof(string), "Администратор %s кикнул игрока %s.", RealName[playerid], RealName[para2]);
				SendClientMessageToAll(COLOR_RED,string);
				new PlayerName[30];
				GetPlayerName(playerid, PlayerName, 30);
				printf("[Command] %s has used /kick to kick %s", PlayerName, giveplayer);
				Kick(giveplayerid);
				return 1;
			}
			else
			{
				format(string, sizeof(string), "Игрока с игровым номером [%d] нету на сервере!", giveplayerid);
				SendClientMessage(playerid, COLOR_RED, string);
			}
		}
		else
		{
 			SendClientMessage(playerid, COLOR_RED, "Вы не можете использовать данную команду!");
 			return 1;
		}
		return 1;
	}
	if(strcmp(cmd, "/edgangs", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 5)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /edgangs [режим (0- по ид банды, 1- по ид игрока из банды)]");
				SendClientMessage(playerid, COLOR_GRAD2, " [ид банды или игрока] [ид настройки (0- просмотреть основную информацию");
				SendClientMessage(playerid, COLOR_GRAD2, " о банде, 1- установить цвет банды, 2- установить название банды,");
				SendClientMessage(playerid, COLOR_GRAD2, " 3- отменить спавн банды, 4- ТП на спавн банды)]");
				return 1;
			}
			new para1;
			para1 = strval(tmp);
			if(para1 < 0 || para1 > 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Режим 0 или 1 !");
				return 1;
			}
			if(para1 == 0)
			{
				tmp = strtok(cmdtext, idx);
				new para2;
				para2 = strval(tmp);
				format(string,sizeof(string),"gangs/%i.ini",para2);
				if(!fexist(string) || para2 >= (MAX_GANGS - 1))
				{
					SendClientMessage(playerid,COLOR_RED," Такого [ид банды] не существует !");
					return 1;
				}
				tmp = strtok(cmdtext, idx);
				new para3;
				para3 = strval(tmp);
				if(para3 < 0 || para3 > 4)
				{
					SendClientMessage(playerid, COLOR_RED, " Ид настройки от 0 до 4 !");
					return 1;
				}
				if(para3 == 0)
				{
					new dopper[16];
					strdel(dopper, 0, 16);
					strmid(dopper, GColor[para2], 0, 6, sizeof(dopper));
					SendClientMessage(playerid, COLOR_GREEN, "-----------------------------------------------------------------");
					format(string, sizeof(string), " Цвет: [%s] Название: [%s{B4B5B7}]", dopper, GName[para2]);
					SendClientMessage(playerid, COLOR_GRAD1, string);
					SendClientMessage(playerid, COLOR_GRAD1, " Спавн банды:");
					format(string, sizeof(string), " x = %f   y = %f   z = %f", GSpawnX[para2], GSpawnY[para2], GSpawnZ[para2]);
					SendClientMessage(playerid, COLOR_GRAD1, string);
					format(string, sizeof(string), " интерьер = %d   виртуальный мир = %d", GInter[para2], GWorld[para2]);
					SendClientMessage(playerid, COLOR_GRAD1, string);
					format(string, sizeof(string), " Лидер: [%s] Число игроков: [%d]", GHead[para2], GPlayers[para2]);
					SendClientMessage(playerid, COLOR_GRAD1, string);
					format(string, sizeof(string), " Регистрация: [ %s ] ID: [%d]", GTDReg[para2], para2);
					SendClientMessage(playerid, COLOR_GRAD1, string);
					SendClientMessage(playerid, COLOR_GREEN, "-----------------------------------------------------------------");
					printf(" Админ %s просмотрел информацию о банде [ID: %d]", RealName[playerid], para2);
					return 1;
				}
				if(para3 == 1)
				{
					if(strcmp(GColor[para2],"A0A0A0FF",false) == 0)
					{
						SendClientMessage(playerid, COLOR_RED, " Цвет банды уже установлен !");
						return 1;
					}
					strdel(GColor[para2], 0, 16);//очищаем цвет банды
					strcat(GColor[para2], "A0A0A0FF");//устанавливаем цвет банды
					GColorDec[para2] = HexToInt(GColor[para2]);
					strdel(GColorHex[para2], 0, 16);
					strcat(GColorHex[para2], ColorRes(GColor[para2]));
					GangSave(para2);//запись ID банды в файл
					for(new i = 0; i < MAX_PLAYERS; i++)
					{
						if(IsPlayerConnected(i))
						{
							if(PGang[i] == para2)//если игрок состоит в банде, то:
							{
								ColorPlay[i] = GColorDec[para2];
								SetPlayerColor(i, ColorPlay[i]);//устанавливаем цвет ника
								for(new j=0;j<MAX_PLAYERS;j++)//устанавливаем цвет маркера для всех игроков
								{
									SetPlayerMarkerForPlayer(j, i, GColorDec[para2]);
								}
							}
						}
					}
					format(string, sizeof(string), " Админ %s установил цвет банды %s{FFFF00} [ID: %d]",
					RealName[playerid], GName[para2], para2);
					print(string);
					SendAdminMessage(COLOR_YELLOW, string);
					return 1;
				}
				if(para3 == 2)
				{
					new result[128];
					format(result, sizeof(result), "Default - %d", para2);
					if(strcmp(GName[para2],result,false) == 0)
					{
						SendClientMessage(playerid, COLOR_RED, " Название банды уже установлено !");
						return 1;
					}
					strdel(GName[para2], 0, 130);//очищаем назване банды
					strcat(GName[para2], result);//устанавливаем назване банды
					GangSave(para2);//запись ID банды в файл
					format(string, sizeof(string), " Админ %s установил название банды %s [ID: %d]",
					RealName[playerid], GName[para2], para2);
					print(string);
					SendAdminMessage(COLOR_YELLOW, string);
					return 1;
				}
				if(para3 == 3)
				{
					if(GSpawnX[para2] == 0.00 && GSpawnY[para2] == 0.00 && GSpawnZ[para2] == 0.00 &&
							GInter[para2] == 0 && GWorld[para2] == 0)
					{
						SendClientMessage(playerid, COLOR_RED, " Спавн банды уже отменён !");
						return 1;
					}
					GSpawnX[para2] = 0.00;//обнуляем спавн банды
					GSpawnY[para2] = 0.00;
					GSpawnZ[para2] = 0.00;
					GInter[para2] = 0;
					GWorld[para2] = 0;
					GangSave(para2);//запись ID банды в файл
					format(string, sizeof(string), " Админ %s отменил спавн банды %s [ID: %d]",
					RealName[playerid], GName[para2], para2);
					print(string);
					SendAdminMessage(COLOR_YELLOW, string);
					return 1;
				}
				if(para3 == 4)
				{
					if(admper1[playerid] != 600)
					{
						SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта опция не работает !");
						return 1;
					}
					if(GSpawnX[para2] == 0.00 && GSpawnY[para2] == 0.00 && GSpawnZ[para2] == 0.00 &&
							GInter[para2] == 0 && GWorld[para2] == 0)
					{
						SendClientMessage(playerid, COLOR_RED, " Место спавна банды не назначено !");
						return 1;
					}
					SetPlayerInterior(playerid, GInter[para2]);
					SetPlayerVirtualWorld(playerid, GWorld[para2]);
					SetPlayerPos(playerid, GSpawnX[para2], GSpawnY[para2], GSpawnZ[para2]);
					format(string, sizeof(string), " Админ %s телепортировался на спавн банды %s [ID: %d]",
					RealName[playerid], GName[para2], para2);
					print(string);
					SendAdminMessage(COLOR_YELLOW, string);
					return 1;
				}
			}
			if(para1 == 1)
			{
				tmp = strtok(cmdtext, idx);
				new para2;
				para2 = strval(tmp);
				if(!IsPlayerConnected(para2))
				{
					SendClientMessage(playerid, COLOR_RED, " Такого [ид игрока] на сервере нет !");
					return 1;
				}
				if(gPlayerLogged[para2] == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Выбранный игрок ещё не залогинился !");
					return 1;
				}
				if(PGang[para2] <= 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Выбранный игрок не состоит ни в одной из банд !");
					return 1;
				}
				tmp = strtok(cmdtext, idx);
				new para3;
				para3 = strval(tmp);
				if(para3 < 0 || para3 > 4)
				{
					SendClientMessage(playerid, COLOR_RED, " Ид настройки от 0 до 4 !");
					return 1;
				}
				if(para3 == 0)
				{
					new dopper[16];
					strdel(dopper, 0, 16);
					strmid(dopper, GColor[PGang[para2]], 0, 6, sizeof(dopper));
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "-----------------------------------------------------------------");
					format(string, sizeof(string), " Цвет: [%s] Название: [%s]", dopper, GName[PGang[para2]]);
					SendClientMessage(playerid, COLOR_GRAD1, string);
					SendClientMessage(playerid, COLOR_GRAD1, " Спавн банды:");
					format(string, sizeof(string), " x = %f   y = %f   z = %f", GSpawnX[PGang[para2]],
					GSpawnY[PGang[para2]], GSpawnZ[PGang[para2]]);
					SendClientMessage(playerid, COLOR_GRAD1, string);
					format(string, sizeof(string), " интерьер = %d   виртуальный мир = %d", GInter[PGang[para2]],
					GWorld[PGang[para2]]);
					SendClientMessage(playerid, COLOR_GRAD1, string);
					format(string, sizeof(string), " Лидер: [%s] Число игроков: [%d]", GHead[PGang[para2]], GPlayers[PGang[para2]]);
					SendClientMessage(playerid, COLOR_GRAD1, string);
					format(string, sizeof(string), " Регистрация: [ %s ] ID: [%d]", GTDReg[PGang[para2]], PGang[para2]);
					SendClientMessage(playerid, COLOR_GRAD1, string);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "-----------------------------------------------------------------");
					printf(" Админ %s просмотрел информацию о банде [ID: %d]", RealName[playerid], PGang[para2]);
					return 1;
				}
				if(para3 == 1)
				{
					if(strcmp(GColor[PGang[para2]],"A0A0A0FF",false) == 0)
					{
						SendClientMessage(playerid, COLOR_RED, " Цвет банды уже установлен !");
						return 1;
					}
					strdel(GColor[PGang[para2]], 0, 16);//очищаем цвет банды
					strcat(GColor[PGang[para2]], "A0A0A0FF");//устанавливаем цвет банды
					GColorDec[PGang[para2]] = HexToInt(GColor[PGang[para2]]);
					strdel(GColorHex[PGang[para2]], 0, 16);
					strcat(GColorHex[PGang[para2]], ColorRes(GColor[PGang[para2]]));
					GangSave(PGang[para2]);//запись ID банды в файл
					for(new i = 0; i < MAX_PLAYERS; i++)
					{
						if(IsPlayerConnected(i))
						{
							if(PGang[i] == PGang[para2])//если игрок состоит в банде, то:
							{
								ColorPlay[i] = GColorDec[PGang[para2]];
								SetPlayerColor(i, ColorPlay[i]);//устанавливаем цвет ника
								for(new j=0;j<MAX_PLAYERS;j++)//устанавливаем цвет маркера для всех игроков
								{
									SetPlayerMarkerForPlayer(j, i, GColorDec[PGang[para2]]);
								}
							}
						}
					}
					format(string, sizeof(string), " Админ %s установил цвет банды %s{FFFF00} [ID: %d]",
					RealName[playerid], GName[PGang[para2]], PGang[para2]);
					print(string);
					SendAdminMessage(COLOR_YELLOW, string);
					return 1;
				}
				if(para3 == 2)
				{
					new result[128];
					format(result, sizeof(result), "Default - %d", PGang[para2]);
					if(strcmp(GName[PGang[para2]],result,false) == 0)
					{
						SendClientMessage(playerid, COLOR_RED, " Название банды уже установлено !");
						return 1;
					}
					strdel(GName[PGang[para2]], 0, 130);//очищаем назване банды
					strcat(GName[PGang[para2]], result);//устанавливаем назване банды
					GangSave(PGang[para2]);//запись ID банды в файл
					format(string, sizeof(string), " Админ %s установил название банды %s [ID: %d]",
					RealName[playerid], GName[PGang[para2]], PGang[para2]);
					print(string);
					SendAdminMessage(COLOR_YELLOW, string);
				}
				if(para3 == 3)
				{
					if(GSpawnX[PGang[para2]] == 0.00 && GSpawnY[PGang[para2]] == 0.00 && GSpawnZ[PGang[para2]] == 0.00 &&
							GInter[PGang[para2]] == 0 && GWorld[PGang[para2]] == 0)
					{
						SendClientMessage(playerid, COLOR_RED, " Спавн банды уже отменён !");
						return 1;
					}
					GSpawnX[PGang[para2]] = 0.00;//обнуляем спавн банды
					GSpawnY[PGang[para2]] = 0.00;
					GSpawnZ[PGang[para2]] = 0.00;
					GInter[PGang[para2]] = 0;
					GWorld[PGang[para2]] = 0;
					GangSave(PGang[para2]);//запись ID банды в файл
					format(string, sizeof(string), " Админ %s отменил спавн банды %s [ID: %d]",
					RealName[playerid], GName[PGang[para2]], PGang[para2]);
					print(string);
					SendAdminMessage(COLOR_YELLOW, string);
					return 1;
				}
				if(para3 == 4)
				{
					if(admper1[playerid] != 600)
					{
						SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта опция не работает !");
						return 1;
					}
					if(GSpawnX[PGang[para2]] == 0.00 && GSpawnY[PGang[para2]] == 0.00 && GSpawnZ[PGang[para2]] == 0.00 &&
							GInter[PGang[para2]] == 0 && GWorld[PGang[para2]] == 0)
					{
						SendClientMessage(playerid, COLOR_RED, " Место спавна банды не назначено !");
						return 1;
					}
					SetPlayerInterior(playerid, GInter[PGang[para2]]);
					SetPlayerVirtualWorld(playerid, GWorld[PGang[para2]]);
					SetPlayerPos(playerid, GSpawnX[PGang[para2]], GSpawnY[PGang[para2]], GSpawnZ[PGang[para2]]);
					format(string, sizeof(string), " Админ %s телепортировался на спавн банды %s [ID: %d]",
					RealName[playerid], GName[PGang[para2]], PGang[para2]);
					print(string);
					SendAdminMessage(COLOR_YELLOW, string);
					return 1;
				}
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	//--------------------- команды админов 5 лвл (конец) --------------------------
	//--------------------- команды админов 6 лвл (начало) -------------------------
	if(strcmp(cmd, "/ban", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 4)
		{
			new data2[2];
			akk = strtok(cmdtext, idx);
			if(!strlen(akk))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /ban [имя аккаунта] [причина]");
				return 1;
			}
			if(strlen(akk) < 1 || strlen(akk) > 25)
			{
				SendClientMessage(playerid, COLOR_RED, " Длина имени аккаунта должна быть от 1 до 25 символов !");
				return 1;
			}
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[64];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			giveplayerid = GetPlayerID(akk);
			Kick(giveplayerid);
			result[idx - offset] = EOS;
			format(string, sizeof(string), "players/%s.ini", akk);
			if(!fexist(string))
			{
				SendClientMessage(playerid,COLOR_RED," Такого аккаунта не существует !");
				return 1;
			}
			new file;//чтение аккаунта
			file = ini_openFile(string);
			if(file == INI_OK)
			{
				ini_getString(file, "IPAdr", adrip);
				ini_getInteger(file, "AdminLevel", data2[0]);
				ini_getInteger(file, "Lock", data2[1]);
				ini_closeFile(file);
			}
			for(new i = 0; i < MAX_PLAYERS; i++)//проверка аккаунта на On-Line
			{
				if(IsPlayerConnected(i))
				{
					if(strcmp(akk, RealName[i], false) == 0)
					{
						format(ssss, sizeof(ssss), " Нельзя, аккаунт игрока [%s] On-Line !", akk);
						SendClientMessage(playerid, COLOR_RED, ssss);
						return 1;
					}
				}
			}
			new fadm;
			if(data2[0] < 0)
			{
				fadm = data2[0] * -1;
			}
			else
			{
				fadm = data2[0];
			}
			if(fadm >= 1 && PlayerInfo[playerid][pAdmin] <= 11)//проверка аккаунта на админку
			{
				format(ssss,sizeof(ssss)," Нельзя, аккаунт игрока [%s] - админ %d LVL !", akk, fadm);
				SendClientMessage(playerid, COLOR_RED, ssss);
				return 1;
			}
			if(data2[1] == 1)//если аккаунт был заблокирован, то:
			{
				format(ssss,sizeof(ssss)," Аккаунт игрока [%s] уже заблокирован (забанен) !", akk);
				SendClientMessage(playerid, COLOR_RED, ssss);
				return 1;
			}
			data2[1] = 1;//блокировка аккаунта
			strdel(ssss, 0, 256);//сборка RCON-команды бана
			strcat(ssss, "banip ");
			strcat(ssss, adrip);
			SendRconCommand(ssss);//RCON-команда бана
			SendRconCommand("reloadbans");//RCON-команда перезагрузки бан-листа
			file = ini_openFile(string);//запись изменённого аккаунта
			if(file == INI_OK)
			{
				ini_setInteger(file, "Lock", data2[1]);
				ini_closeFile(file);
			}
			format(ssss,sizeof(ssss)," Админ %s забанил аккаунт игрока [%s] ( IP: [%s] ) , причина: %s",
			RealName[playerid], akk, adrip, result);
			print(ssss);
			SendAdminMessage(COLOR_RED, ssss);
			format(ssss,sizeof(ssss)," Админ %s забанил аккаунт игрока [%s] , причина: %s", RealName[playerid], akk, result);
			for(new i=0;i<MAX_PLAYERS;i++)//отправка сообщения НЕ админам
			{
				if(IsPlayerConnected(i) && PlayerInfo[i][pAdmin] == 0)
				{
					SendClientMessage(i, COLOR_RED, ssss);
				}
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/tweaprad", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 6)
		{
			new Float: X, Float:Y, Float: Z, playvw;
			GetPlayerPos(playerid, X, Y, Z);
			playvw = GetPlayerVirtualWorld(playerid);
			new per55 = 0;
			for(new i = 0; i < MAX_PLAYERS ; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(IsPlayerInRangeOfPoint(i, 100.0, X, Y, Z) && GetPlayerVirtualWorld(i) == playvw && i != playerid)
					{
						per55 = 1;
						ResetPlayerWeapons(i);//отбираем оружие и предметы
					}
				}
			}
			if(per55 == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Игроков поблизости не обнаружено !");
			}
			else
			{
				format(string, sizeof(string), " Админ %s отобрал у всех игроков все предметы и всё оружие",
				RealName[playerid]);
				print(string);
				SendClientMessageToAll(COLOR_RED, string);
				format(string, sizeof(string), " в радиусе 100 координатных единиц.");
				print(string);
				SendClientMessageToAll(COLOR_RED, string);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/setweapall", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 6)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /setweapall [ид предмета или оружия(1-46)]");
				SendClientMessage(playerid, COLOR_GRAD2, " [число патронов, зарядов, или штук(1-50000)] или /setweapall 600");
				return 1;
			}
			new para2;
			para2 = strval(tmp);
			if(para2 == 600)
			{
				format(strdln, sizeof(strdln), "1 - Кастет     2 - Клюшка для гольфа\
				\n3 - Резиновая дубинка     4 - Нож\
				\n5 - Бейсбольная бита     6 - Лопата\
				\n7 - Кий     8 - Катана");
				format(strdln, sizeof(strdln), "%s\n9 - Бензопила     14 - Букет цветов\
				\n15 - Трость     16 - Grenades\
				\n17 - Tear Gas     18 - Molotov Cocktail\
				\n22 - 9mm Pistol     23 - Silenced Pistol", strdln);
				format(strdln, sizeof(strdln), "%s\n24 - Desert Eagle     25 - ShotGun\
				\n26 - Sawn-off Shotgun     27 - SPAZ 12\
				\n28 - UZI     29 - MP5\
				\n30 - АК-47     31 - М4", strdln);
				format(strdln, sizeof(strdln), "%s\n32 - Tes9     33 - Country rifle\
				\n34 - Sniper rifle     35 - RPG\
				\n36 - Heat Seeking Rocket     37 - Flame-Thrower\
				\n38 - Mini-Gun     39 - C4", strdln);
				format(strdln, sizeof(strdln), "%s\n41 - Баллончик с краской     42 - Огнетушитель\
				\n43 - Фотоаппарат     44 - Очки ночного видения\
				\n45 - Инфракрасные очки     46 - Парашют", strdln);
				ShowPlayerDialog(playerid, 2, 0, "ID предметов и оружия:", strdln, "OK", "");
				return 1;
			}
			if(para2 < 1 || para2 > 46 || para2 == 10 || para2 == 11 || para2 == 12 || para2 == 13 ||
					para2 == 19 || para2 == 20 || para2 == 21 || para2 == 40)
			{
				SendClientMessage(playerid, COLOR_RED, " Такого [ид предмета или оружия] нет в списке команды !");
				return 1;
			}
			new para5 = 0;
			if(para2 >= 16 && para2 <= 39) { para5 = 1; }
			new para3;
			if(para5 == 1)
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_RED, " [число патронов, зарядов, или штук(1-50000)] !");
					return 1;
				}
				para3 = strval(tmp);
				if(para3 < 0 || para3 > 50000)
				{
					SendClientMessage(playerid, COLOR_RED, " Число патронов, зарядов, или штук - от 1 до 50000 !");
					return 1;
				}
			}
			new para4[64];
			new para6 = 0;
			switch(para2)
			{
			case 1: format(para4, sizeof(para4), "Кастету");
			case 2: format(para4, sizeof(para4), "Клюшке для гольфа");
			case 3: format(para4, sizeof(para4), "Резиновой дубинке");
			case 4: format(para4, sizeof(para4), "Ножу");
			case 5: format(para4, sizeof(para4), "Бейсбольной бите");
			case 6: format(para4, sizeof(para4), "Лопате");
			case 7: format(para4, sizeof(para4), "Кию");
			case 8: format(para4, sizeof(para4), "Катане");
			case 9: format(para4, sizeof(para4), "Бензопиле");
			case 14: format(para4, sizeof(para4), "Букету цветов");
			case 15: format(para4, sizeof(para4), "Трости");
			case 16: format(para4, sizeof(para4), "Grenades");
			case 17: format(para4, sizeof(para4), "Tear Gas");
			case 18: format(para4, sizeof(para4), "Molotov Cocktail");
			case 22: format(para4, sizeof(para4), "9mm Pistol");
			case 23: format(para4, sizeof(para4), "Silenced Pistol");
			case 24: format(para4, sizeof(para4), "Desert Eagle");
			case 25: format(para4, sizeof(para4), "ShotGun");
			case 26: format(para4, sizeof(para4), "Sawn-off Shotgun");
			case 27: format(para4, sizeof(para4), "SPAZ 12");
			case 28: format(para4, sizeof(para4), "UZI");
			case 29: format(para4, sizeof(para4), "MP5");
			case 30: format(para4, sizeof(para4), "АК-47");
			case 31: format(para4, sizeof(para4), "М4");
			case 32: format(para4, sizeof(para4), "Tec9");
			case 33: format(para4, sizeof(para4), "Country rifle");
			case 34: format(para4, sizeof(para4), "Sniper rifle");
			case 35: format(para4, sizeof(para4), "RPG");
			case 36: format(para4, sizeof(para4), "Heat Seeking Rocket");
			case 37: format(para4, sizeof(para4), "Flame-Thrower");
			case 38: format(para4, sizeof(para4), "Mini-Gun");
			case 39: format(para4, sizeof(para4), "C4");
			case 41: format(para4, sizeof(para4), "Баллончику с краской");
			case 42: format(para4, sizeof(para4), "Огнетушителю");
			case 43: format(para4, sizeof(para4), "Фотоаппарату");
			case 44: format(para4, sizeof(para4), "Очкам ночного видения"), para6 = 1;
			case 45: format(para4, sizeof(para4), "Инфракрасным очкам"), para6 = 1;
			case 46: format(para4, sizeof(para4), "Парашюту");
			}
			new para777 = 0;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(playspa[i] == 1 && PlayerInfo[i][pAdmin] >= 1 && para6 == 1)
					{
						if(para5 == 0)
						{
							para777 = 1;
							GivePlayerWeapon(i, para2, 1000);
						}
						else
						{
							para777 = 1;
							if(para2 == 37)
							{
								GivePlayerWeapon(i, para2, para3 * 10);
							}
							else
							{
								GivePlayerWeapon(i, para2, para3);
								if(para2 == 39) { GivePlayerWeapon(i, 40, 10); }
							}
						}
					}
					if(playspa[i] == 1 && para6 == 0)
					{
						if(para5 == 0)
						{
							para777 = 1;
							GivePlayerWeapon(i, para2, 1000);
						}
						else
						{
							para777 = 1;
							if(para2 == 37)
							{
								GivePlayerWeapon(i, para2, para3 * 10);
							}
							else
							{
								GivePlayerWeapon(i, para2, para3);
								if(para2 == 39) { GivePlayerWeapon(i, 40, 10); }
							}
						}
					}
				}
			}
			if(para777 == 1)
			{
				if(para5 == 0)
				{
					format(string, sizeof(string), " Админ %s раздал всем игрокам по %s .", RealName[playerid], para4);
				}
				else
				{
					if(para2 >= 16 && para2 <= 18)
					{
						format(string, sizeof(string), " Админ %s раздал всем игрокам по %s ( по %d штук каждому ) .",
						RealName[playerid], para4, para3);
					}
					if((para2 >= 35 && para2 <= 37) || para2 == 39)
					{
						format(string, sizeof(string), " Админ %s раздал всем игрокам по %s , и по %d зарядов каждому.",
						RealName[playerid], para4, para3);
					}
					if((para2 >= 22 && para2 <= 34) || para2 == 38)
					{
						format(string, sizeof(string), " Админ %s раздал всем игрокам по %s , и по %d патронов каждому.",
						RealName[playerid], para4, para3);
					}
				}
				print(string);
				SendClientMessageToAll(COLOR_GREEN, string);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Ни один из игроков не получил назначенный Вами ИД предмета или оружия !");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/plcmon", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 6)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /plcmon [0- выкл., 1- вкл., 2- просмотреть настройки]");
				SendClientMessage(playerid, COLOR_GRAD2, " ( дополнительно [дальность определения(10-1000)] )");
				return 1;
			}
			new para1;
			para1 = strval(tmp);
			if(para1 < 0 || para1 > 2)
			{
				SendClientMessage(playerid, COLOR_RED, " 0- выкл., 1- вкл., 2- просмотреть настройки !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			new para2;
			new para3;
			if(!strlen(tmp))
			{
				para2 = 500;
				para3 = 0;
			}
			else
			{
				para2 = strval(tmp);
				para3 = 1;
			}
			if(para2 < 10 || para2 > 1000)
			{
				SendClientMessage(playerid, COLOR_RED, " Дальность определения от 10 до 1000 !");
				return 1;
			}
			if(para1 == 0)
			{
				if(plcmonloc[playerid] == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Краш-монитор в чате уже отключен !");
					return 1;
				}
				else
				{
					plcmonloc[playerid] = 0;
					format(string, sizeof(string), " Админ %s отключил краш-монитор.", RealName[playerid]);
					print(string);
					SendAdminMessage(COLOR_RED, string);
					return 1;
				}
			}
			if(para1 == 1)
			{
				if(plcmonloc[playerid] == 1 && para3 == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Вы не задали дальность определения !");
					return 1;
				}
				if(plcmonloc[playerid] == 1 && para3 == 1 && plcmondist[playerid] == para2)
				{
					SendClientMessage(playerid, COLOR_RED, " Вы задали старую дальность определения !");
					return 1;
				}
				if(plcmonloc[playerid] == 1 && para3 == 1 && plcmondist[playerid] != para2)
				{
					plcmondist[playerid] = para2;
					format(string, sizeof(string), " Админ %s изменил дальность определения для краш-монитора на %d",
					RealName[playerid], plcmondist[playerid]);
					print(string);
					SendAdminMessage(COLOR_GREEN, string);
					return 1;
				}
				if(plcmonloc[playerid] == 0)
				{
					plcmonloc[playerid] = 1;
					plcmondist[playerid] = para2;
					format(string, sizeof(string), " Админ %s включил краш-монитор, с дальностью определения %d",
					RealName[playerid], plcmondist[playerid]);
					print(string);
					SendAdminMessage(COLOR_GREEN, string);
					return 1;
				}
			}
			if(para1 == 2)
			{
				if(plcmonloc[playerid] == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Краш-монитор отключен.");
					return 1;
				}
				else
				{
					SendClientMessage(playerid, COLOR_YELLOW, "--------------------------------------------------");
					SendClientMessage(playerid, COLOR_GREEN, " Краш-монитор включен.");
					format(string, sizeof(string), " Дальность определения: {FFFF00}%d .", plcmondist[playerid]);
					SendClientMessage(playerid, COLOR_GREEN, string);
					SendClientMessage(playerid, COLOR_YELLOW, "--------------------------------------------------");
					printf(" Админ %s просмотрел настройки краш-монитора.", RealName[playerid]);
					return 1;
				}
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	//--------------------- команды админов 6 лвл (конец) --------------------------
	//--------------------- команды админов 7 лвл (начало) -------------------------
	if(strcmp(cmd, "/money", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 12)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /money [ид игрока/часть ника] [сумма] [причина]");
				return 1;
			}
			new playa;
			new money;
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " Вы не указали сумму и причину !");
				return 1;
			}
			money = strval(tmp);
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[64];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(IsPlayerConnected(playa))
			{
				if(gPlayerLogged[playa] == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Выбранный игрок ещё не залогинился!");
					return 1;
				}
				new dopper44;
				dopper44 = GetPlayerMoney(playa);
				SetPVarInt(playa, "MonControl", 1);
				GivePlayerMoney(playa, money);
				if(money < 0)
				{
					format(string, 256, " Админ %s изъял у игрока %s %d$ , причина: %s", RealName[playerid], RealName[playa],
					money, result);
					print(string);
					if (PlayerInfo[playa][pAdmin] >= 1)
					{
						SendAdminMessage(COLOR_RED, string);
					}
					else
					{
						SendClientMessageToAll(COLOR_RED, string);
					}
				}
				else
				{
					format(string, 256, " Админ %s дал игроку %s %d$ , причина: %s", RealName[playerid], RealName[playa],
					money, result);
					print(string);
					if (PlayerInfo[playa][pAdmin] >= 1)
					{
						SendAdminMessage(COLOR_YELLOW, string);
					}
					else
					{
						SendClientMessageToAll(COLOR_YELLOW, string);
					}
				}
				printf("[moneysys] Предыдущая сумма игрока %s [%d] : %d $", RealName[playa], playa, dopper44);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Такого [ид игрока] на сервере нет !");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/setmon", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 12)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /setmon [ид игрока/часть ника] [сумма]");
				return 1;
			}
			new playa;
			new money;
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " Вы не указали сумму !");
				return 1;
			}
			money = strval(tmp);
			if(IsPlayerConnected(playa))
			{
				if(gPlayerLogged[playa] == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Выбранный игрок ещё не залогинился !");
					return 1;
				}
				if(money < 0) { SendClientMessage(playerid, COLOR_RED, " Сумма не может быть отрицательным числом !"); return 1; }
				new dopper44;
				dopper44 = GetPlayerMoney(playa);
				SetPVarInt(playa, "MonControl", 1);
				ResetPlayerMoney(playa);
				GivePlayerMoney(playa, money);
				format(string, 256, " Админ %s установил игроку %s %d $", RealName[playerid], RealName[playa], money);
				print(string);
				if (PlayerInfo[playa][pAdmin] >= 1)
				{
					SendAdminMessage(COLOR_YELLOW, string);
				}
				else
				{
					SendClientMessageToAll(COLOR_YELLOW, string);
				}
				printf("[moneysys] Предыдущая сумма игрока %s [%d] : %d $", RealName[playa], playa, dopper44);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Такого [ид игрока] на сервере нет !");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/live", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 7)
		{
			if(PlayerInfo[playerid][pAdmlive] == 1)
			{
				PlayerInfo[playerid][pAdmlive] = 0;
				format(string, sizeof(string), " Админ %s выключил собственное бессмертие.", RealName[playerid]);
				print(string);
				SendAdminMessage(COLOR_RED, string);
				return 1;
			}
			else
			{
				PlayerInfo[playerid][pAdmlive] = 1;
				format(string, sizeof(string), " Админ %s включил собственное бессмертие.", RealName[playerid]);
				print(string);
				SendAdminMessage(COLOR_GREEN, string);
				return 1;
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/admtp", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 7)
		{
			if(admper1[playerid] != 600)
			{
				SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта команда не работает !");
				return 1;
			}
			new dopper1 = 0;
			new Float:PosX, Float:PosY, Float:PosZ;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(playspa[i] == 1 && (PlayerInfo[i][pAdmin] >= 1 && PlayerInfo[i][pAdmin] <= 12) && i != playerid)
					{
						dopper1 = 1;
						if(PlayerInfo[i][pPrisonsec] > 0)//если админ в тюрьме, то:
						{
							PlayerInfo[i][pPrison]--;
							PlayerInfo[i][pPrisonsec] = 0;
							weapstatplay[i] = 0;
							OnPlayerSpawn(i);//респавн админа
							SendClientMessage(i, COLOR_GREEN, "* Амнистия ( по команде /admtp )");
							SetTimerEx("DopAdmtp", 1000, 0, "ii", playerid, i);
						}
						else
						{
							if(PlayLock1[0][i] != 600)//если админ заблокирован, то:
							{
								PlayLock1[1][i] = GetPlayerInterior(playerid);//изменение интерьера блокировки
								PlayLock1[2][i] = GetPlayerVirtualWorld(playerid);//изменение виртуального мира блокировки
								GetPlayerPos(playerid, PlayLock2[0][i], PlayLock2[1][i], PlayLock2[2][i]);//изменение координат блокировки
								PlayLock2[1][i] = PlayLock2[1][i] + 1;
							}
							else
							{
								if(admper1[i] != 600)//если админ в наблюдении, то:
								{
									TogglePlayerSpectating(i, 0);//запретить наблюдение для админа
									admper6[i] = 0;//обнуляем отметку о переключении наблюдения
									SetTimerEx("DopAdmtp", 1000, 0, "ii", playerid, i);
								}
								else
								{
									SetPlayerInterior(i, GetPlayerInterior(playerid));
									SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(playerid));
									GetPlayerPos(playerid, PosX, PosY, PosZ);
									SetPlayerPos(i, PosX, PosY+1, PosZ+1);
								}
							}
						}
					}
				}
			}
			if(dopper1 == 1)
			{
				format(string, 256, " Админ %s телепортировал всех админов к себе.", RealName[playerid]);
				print(string);
				SendAdminMessage(COLOR_RED, string);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Нет доступных админов для ТП к себе !");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/nucexp", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 7)
		{
			if(nucexplos == 0)
			{
				SetWeather(19);
				SetWorldTime(0);
				new Float:sx, Float:sy, Float:sz;
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i))
					{
						SnowONOFF[i] = 1;
						SetPlayerArmour(i, 0);
						SetPlayerHealth(i, 0);
						GetPlayerCameraPos(i, sx, sy, sz);
						snowobj[i] = CreatePlayerObject(i, 18864, sx, sy, sz-5, 0.0, 0.0, 0.0, 300.0);
					}
				}
				format(string, sizeof(string), " Админ %s произвёл ядерный взрыв !!!", RealName[playerid]);
				print(string);
				SendClientMessageToAll(COLOR_RED, string);
				nucexplos = 1;
				nucexptime = 0;
			}
			else
			{
				SetWeather(1);
				gettime(timedata[0], timedata[1]);
				SetWorldTime(timedata[0]);
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i))
					{
						SnowONOFF[i] = 0;
						DestroyPlayerObject(i,snowobj[i]);
					}
				}
				format(string, sizeof(string), " Админ %s ликвидировал последствия ядерного взрыва.", RealName[playerid]);
				print(string);
				SendClientMessageToAll(COLOR_GREEN, string);
				nucexplos = 0;
				nucexptime = 0;
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	//--------------------- команды админов 7 лвл (конец) --------------------------
	//--------------------- команды админов 8 лвл (начало) -------------------------
	if(strcmp(cmd, "/moneyall", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 12)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /moneyall [сумма] [причина]");
				return 1;
			}
			new money;
			money = strval(tmp);
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			new dopper44;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(gPlayerLogged[i] == 1)
					{
						if(money > 1000) { dopper44 = GetPlayerMoney(i); }
						SetPVarInt(i, "MonControl", 1);
						GivePlayerMoney(i, money);
						if(money > 1000)
						{
							printf("[moneysys] Предыдущая сумма игрока %s [%d] : %d $", RealName[i], i, dopper44);
						}
					}
				}
			}
			if(money < 0)
			{
				format(string, 256, " Админ %s изъял у всех игроков по %d $ , причина: %s", RealName[playerid], money, result);
				print(string);
				SendClientMessageToAll(COLOR_RED, string);
			}
			else
			{
				format(string, 256, " Админ %s раздал всем игрокам по %d $ , причина: %s", RealName[playerid], money, result);
				print(string);
				SendClientMessageToAll(COLOR_YELLOW, string);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/setmonall", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 12)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /setmonall [сумма]");
				return 1;
			}
			new money;
			money = strval(tmp);
			if(money < 0) { SendClientMessage(playerid, COLOR_RED, " Сумма не может быть отрицательным числом !"); return 1; }
			new dopper44;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(gPlayerLogged[i] == 1)
					{
						if(money > 1000) { dopper44 = GetPlayerMoney(i); }
						SetPVarInt(i, "MonControl", 1);
						ResetPlayerMoney(i);
						GivePlayerMoney(i, money);
						if(money > 1000)
						{
							printf("[moneysys] Предыдущая сумма игрока %s [%d] : %d $", RealName[i], i, dopper44);
						}
					}
				}
			}
			format(string, 256, " Админ %s установил всем игрокам по %d $", RealName[playerid], money);
			print(string);
			SendClientMessageToAll(COLOR_YELLOW, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/fmess", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 8)
		{
			new color;
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /fmess [цвет(0-19)] [сообщение]");
				return 1;
			}
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new idx22 = idx;
			new result[256];
			while ((idx22 < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				if (cmdtext[idx22] == 123 && cmdtext[idx22 + 1] == 44)
				{
					result[idx - offset] = cmdtext[idx22];
					idx++;
					idx22++;
					idx22++;
				}
				else
				{
					result[idx - offset] = cmdtext[idx22];
					idx++;
					idx22++;
				}
			}
			result[idx - offset] = EOS;
			color = strval(tmp);
			if(color < 0 || color > 19)
			{
				SendClientMessage(playerid, COLOR_RED, " Цвет(0-19) !");
				return 1;
			}
			if(!strlen(result))
			{
				SendClientMessage(playerid, COLOR_RED, " Вы не написали сообщение !");
				return 1;
			}
			format(string, sizeof(string), "(fmess) Админ %s [%d]: %s", RealName[playerid], playerid, result);
			print(string);
			switch(color)
			{
			case 0: format(string, sizeof(string), "{FF0000}%s", result);
			case 1: format(string, sizeof(string), "{FF3F3F}%s", result);
			case 2: format(string, sizeof(string), "{FF3F00}%s", result);
			case 3: format(string, sizeof(string), "{BF3F00}%s", result);
			case 4: format(string, sizeof(string), "{FF7F3F}%s", result);
			case 5: format(string, sizeof(string), "{FF7F00}%s", result);
			case 6: format(string, sizeof(string), "{FFFF00}%s", result);
			case 7: format(string, sizeof(string), "{3FFF3F}%s", result);
			case 8: format(string, sizeof(string), "{FF0000}%s", result);
			case 9: format(string, sizeof(string), "{00BF00}%s", result);
			case 10: format(string, sizeof(string), "{00FFFF}%s", result);
			case 11: format(string, sizeof(string), "{00BFFF}%s", result);
			case 12: format(string, sizeof(string), "{3F3FFF}%s", result);
			case 13: format(string, sizeof(string), "{0000FF}%s", result);
			case 14: format(string, sizeof(string), "{7F3FFF}%s", result);
			case 15: format(string, sizeof(string), "{7F00FF}%s", result);
			case 16: format(string, sizeof(string), "{FF00FF}%s", result);
			case 17: format(string, sizeof(string), "{7F7F7F}%s", result);
			case 18: format(string, sizeof(string), "{FFFFFF}%s", result);
			case 19: format(string, sizeof(string), "{000000}%s", result);
			}
			SendClientMessageToAll(COLOR_WHITE, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/playtpall", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 8)
		{
			if(admper1[playerid] != 600)
			{
				SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта команда не работает !");
				return 1;
			}
			new dopper1 = 0;
			new Float:PosX, Float:PosY, Float:PosZ;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(playspa[i] == 1 && (PlayerInfo[i][pAdmin] >= 0 && PlayerInfo[i][pAdmin] <= 12) && i != playerid)
					{
						if(PlayerInfo[i][pPrisonsec] == 0)//если игрок (или админ) НЕ в тюрьме, то:
						{
							dopper1 = 1;
							if(PlayLock1[0][i] != 600)//если игрок заблокирован, то:
							{
								PlayLock1[1][i] = GetPlayerInterior(playerid);//изменение интерьера блокировки
								PlayLock1[2][i] = GetPlayerVirtualWorld(playerid);//изменение виртуального мира блокировки
								GetPlayerPos(playerid, PlayLock2[0][i], PlayLock2[1][i], PlayLock2[2][i]);//изменение координат блокировки
								PlayLock2[1][i] = PlayLock2[1][i] + 1;
							}
							else
							{
								if(admper1[i] != 600)//если игрок в наблюдении, то:
								{
									TogglePlayerSpectating(i, 0);//запретить наблюдение для игрока
									admper6[i] = 0;//обнуляем отметку о переключении наблюдения
									SetTimerEx("DopPlaytp", 1000, 0, "ii", playerid, i);
								}
								else
								{
									SetPlayerInterior(i, GetPlayerInterior(playerid));
									SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(playerid));
									GetPlayerPos(playerid, PosX, PosY, PosZ);
									SetPlayerPos(i, PosX, PosY+1, PosZ+1);
								}
							}
						}
						if(PlayerInfo[i][pAdmin] >= 1 && PlayerInfo[i][pPrisonsec] > 0)//если админ в тюрьме, то:
						{
							dopper1 = 1;
							PlayerInfo[i][pPrison]--;
							PlayerInfo[i][pPrisonsec] = 0;
							OnPlayerSpawn(i);//респавн админа
							SendClientMessage(i, COLOR_GREEN, "* Амнистия ( по команде /playtpall )");
							SetTimerEx("DopAdmtp", 1000, 0, "ii", playerid, i);
						}
					}
				}
			}
			if(dopper1 == 1)
			{
				format(string,256," Админ %s телепортировал всех игроков к себе.", RealName[playerid]);
				print(string);
				SendClientMessageToAll(COLOR_RED, string);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Нет доступных игроков (или админов) для ТП к себе !");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	//--------------------- команды админов 8 лвл (конец) --------------------------
	//--------------------- команды админов 9 лвл (начало) -------------------------
	if(strcmp(cmd, "/score", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 12)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /score [ид игрока/часть ника] [очки] [причина]");
				return 1;
			}
			new playa;
			new score;
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " Вы не указали очки и причину !");
				return 1;
			}
			score = strval(tmp);
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[64];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(IsPlayerConnected(playa))
			{
				if(gPlayerLogged[playa] == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Выбранный игрок ещё не залогинился !");
					return 1;
				}
				new locper;
				locper = GetPlayerScore(playa);
				new dopper44;
				dopper44 = locper;
				locper = locper + score;
				SetPVarInt(playa, "ScorControl", 1);
				SetPlayerScore(playa, locper);
				if(score < 0)
				{
					format(string, 256, " Админ %s изъял у игрока %s %d очков , причина: %s", RealName[playerid], RealName[playa],
					score, result);
					print(string);
					if (PlayerInfo[playa][pAdmin] >= 1)
					{
						SendAdminMessage(COLOR_RED, string);
					}
					else
					{
						SendClientMessageToAll(COLOR_RED, string);
					}
				}
				else
				{
					format(string, 256, " Админ %s дал игроку %s %d очков , причина: %s", RealName[playerid], RealName[playa],
					score, result);
					print(string);
					if (PlayerInfo[playa][pAdmin] >= 1)
					{
						SendAdminMessage(COLOR_YELLOW, string);
					}
					else
					{
						SendClientMessageToAll(COLOR_YELLOW, string);
					}
				}
				printf("[moneysys] Предыдущие очки игрока %s [%d] : %d .", RealName[playa], playa, dopper44);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Такого [ид игрока] на сервере нет !");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/setscor", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 12)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /setscor [ид игрока/часть ника] [очки]");
				return 1;
			}
			new playa;
			new score;
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " Вы не указали очки !");
				return 1;
			}
			score = strval(tmp);
			if(IsPlayerConnected(playa))
			{
				if(gPlayerLogged[playa] == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Выбранный игрок ещё не залогинился !");
					return 1;
				}
				if(score < 0) { SendClientMessage(playerid, COLOR_RED, " Очки не могут быть отрицательным числом !"); return 1; }
				new dopper44;
				dopper44 = GetPlayerScore(playa);
				SetPVarInt(playa, "ScorControl", 1);
				SetPlayerScore(playa, score);
				format(string, 256, " Админ %s установил игроку %s %d очков", RealName[playerid], RealName[playa], score);
				print(string);
				if (PlayerInfo[playa][pAdmin] >= 1)
				{
					SendAdminMessage(COLOR_YELLOW, string);
				}
				else
				{
					SendClientMessageToAll(COLOR_YELLOW, string);
				}
				printf("[moneysys] Предыдущие очки игрока %s [%d] : %d .", RealName[playa], playa, dopper44);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Такого [ид игрока] на сервере нет !");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/grav", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 9)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /grav [гравитация(0.0001-1)]");
				return 1;
			}
			new dopper, dopper22, dopper33, testgra, Float:flgra;
			dopper = strlen(tmp);
			if (dopper < 1 || dopper > 8)
			{
				SendClientMessage(playerid, COLOR_RED, " Гравитация: от 0.0001 до 1 !");
				return 1;
			}
			dopper22 = 0;
			dopper33 = 0;
			for(new i = 0; i < dopper; i++)
			{
				if(tmp[i] < 46 || tmp[i] == 47 || tmp[i] > 57)
				{
					dopper22 = 1;
				}
				if(tmp[i] == 46)
				{
					dopper33++;
				}
			}
			if (dopper22 == 1 || dopper33 > 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Гравитация: от 0.0001 до 1 !");
				return 1;
			}
			flgra = floatstr(tmp);
			testgra = 0;
			testgra = floatcmp(0.000100, flgra);
			if(testgra == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Гравитация: от 0.0001 до 1 !");
				return 1;
			}
			testgra = 0;
			testgra = floatcmp(flgra, 1.000000);
			if(testgra == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Гравитация: от 0.0001 до 1 !");
				return 1;
			}
			SetGravity(flgra);
			format(string, sizeof(string), " Админ %s установил гравитацию на %f", RealName[playerid], flgra);
			print(string);
			SendClientMessageToAll(COLOR_YELLOW, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/gm", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 9)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /gm [ид игрока/часть ника] [0-убрать временное");
				SendClientMessage(playerid, COLOR_GRAD2, " бессмертие, 1-дать временное бессмертие]");
				return 1;
			}
			new para1;
			new stat;
			para1 = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			stat = strval(tmp);
			if(IsPlayerConnected(para1))
			{
				if(gPlayerLogged[para1] == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Выбранный игрок ещё не залогинился !");
					return 1;
				}
				if(PlayerInfo[para1][pAdmin] >= 7)
				{
					SendClientMessage(playerid, COLOR_RED, " Вы не можете изменять бессмертие админу 7 уровня и выше !");
					return 1;
				}
				if(stat < 0 || stat > 1)
				{
					SendClientMessage(playerid, COLOR_RED, " [0-убрать временное бессмертие, 1-дать временное бессмертие] !");
					return 1;
				}
				if(stat == 0 && PlayerInfo[para1][pAdmlive] == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " У выбранного игрока уже нет бессмертия !");
					return 1;
				}
				if(stat == 1 && PlayerInfo[para1][pAdmlive] == 1)
				{
					SendClientMessage(playerid, COLOR_RED, " У выбранного игрока уже есть бессмертие !");
					return 1;
				}
				PlayerInfo[para1][pAdmlive] = stat;
				if(PlayerInfo[para1][pAdmlive] == 1)
				{
					format(string, sizeof(string), " Админ %s дал игроку %s временное бессмертие.", RealName[playerid],
					RealName[para1]);
					print(string);
					SendAdminMessage(COLOR_GREEN, string);
					if(PlayerInfo[para1][pAdmin] == 0)
					{
						format(string, sizeof(string), " Админ %s дал Вам временное бессмертие.", RealName[playerid]);
						SendClientMessage(para1, COLOR_GREEN, string);
					}
				}
				else
				{
					format(string, sizeof(string), " Админ %s убрал с игрока %s временное бессмертие.", RealName[playerid],
					RealName[para1]);
					print(string);
					SendAdminMessage(COLOR_RED, string);
					if(PlayerInfo[para1][pAdmin] == 0)
					{
						format(string, sizeof(string), " Админ %s убрал с Вас временное бессмертие.", RealName[playerid]);
						SendClientMessage(para1, COLOR_RED, string);
					}
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Такого [ид игрока] на сервере нет !");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	//--------------------- команды админов 9 лвл (конец) --------------------------
	//-------------------- команды админов 10 лвл (начало) -------------------------
	if(strcmp(cmd, "/scoreall", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 12)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /scoreall [очки] [причина]");
				return 1;
			}
			new score;
			score = strval(tmp);
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			new locper;
			new dopper44;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(gPlayerLogged[i] == 1)
					{
						locper = GetPlayerScore(i);
						if(score > 10) { dopper44 = locper; }
						locper = locper + score;
						SetPVarInt(i, "ScorControl", 1);
						SetPlayerScore(i, locper);
						if(score > 10)
						{
							printf("[moneysys] Предыдущие очки игрока %s [%d] : %d .", RealName[i], i, dopper44);
						}
					}
				}
			}
			if(score < 0)
			{
				format(string, 256, " Админ %s изъял у всех игроков по %d очков , причина: %s", RealName[playerid], score, result);
				print(string);
				SendClientMessageToAll(COLOR_RED, string);
			}
			else
			{
				format(string, 256, " Админ %s раздал всем игрокам по %d очков , причина: %s", RealName[playerid], score, result);
				print(string);
				SendClientMessageToAll(COLOR_YELLOW, string);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/setscorall", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 12)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /setscorall [очки]");
				return 1;
			}
			new score;
			score = strval(tmp);
			if(score < 0) { SendClientMessage(playerid, COLOR_RED, " Очки не могут быть отрицательным числом !"); return 1; }
			new dopper44;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(gPlayerLogged[i] == 1)
					{
						if(score > 10) { dopper44 = GetPlayerScore(i); }
						SetPVarInt(i, "ScorControl", 1);
						SetPlayerScore(i, score);
						if(score > 10)
						{
							printf("[moneysys] Предыдущие очки игрока %s [%d] : %d .", RealName[i], i, dopper44);
						}
					}
				}
			}
			format(string, 256, " Админ %s установил всем игрокам по %d очков", RealName[playerid], score);
			print(string);
			SendClientMessageToAll(COLOR_YELLOW, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/radpl", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 10)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GREY, " Используйте: /radpl [ид игрока] [радио 1-5]");
				SendClientMessage(playerid, COLOR_GREY, " или /radpl 600");
				return 1;
			}
			new para1 = strval(tmp);
			if(para1 == 600)
			{
				format(strdln, sizeof(strdln), "1 - %s\n2 - %s\n3 - %s\n4 - %s\n5 - %s", NMRadio[1], NMRadio[2], NMRadio[3], NMRadio[4], NMRadio[5]);
				ShowPlayerDialog(playerid, 2, 0, "Список радио", strdln, "OK", "");
				return 1;
			}
			if(!IsPlayerConnected(para1))
			{
				SendClientMessage(playerid, COLOR_RED, " Такого [ид игрока] на сервере нет !");
				return 1;
			}
			if(para1 == playerid)
			{
				SendClientMessage(playerid, COLOR_RED, " Чтобы включить радио самому себе, используйте меню сервера !");
				return 1;
			}
			if(PlayerInfo[playerid][pAdmin] <= 11 && PlayerInfo[para1][pAdmin] >= 12)
			{
				SendClientMessage(playerid, COLOR_RED, " Вы не можете включить радио админу 12-го уровня !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " Радио 1-4 !");
				return 1;
			}
			new para2 = strval(tmp);
			if(para2 < 1 || para2 > 12)
			{
				SendClientMessage(playerid, COLOR_RED, " Такого радио нет !");
				return 1;
			}
			NRadio[para1] = para2;//номер подключаемого радио
			StopAudioStreamForPlayer(para1);//отключим любой другой поток
			PlayAudioStreamForPlayer(para1, STRadio[para2]);//подключим поток с музыкой
			format(string, sizeof(string), " Админ %s включил Вам радио %s", RealName[playerid], NMRadio[para2]);
			SendClientMessage(para1, COLOR_GREEN, string);
			SendClientMessage(para1, COLOR_GREEN, " Для выключения используйте: {A9C4E4}Игровой меню --> {91EF03}Радио --> {027FFE}Выключить радио");
			format(string, sizeof(string), " Aдмин %s включил игроку %s радио %s", RealName[playerid], RealName[para1], NMRadio[para2]);
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(PlayerInfo[i][pAdmin] >= 1 && i != para1)
					{
						SendClientMessage(i, COLOR_GREEN, string);
					}
				}
			}
			printf("[radio] Aдмин %s включил игроку %s радио %s .", RealName[playerid], RealName[para1], NMRadio[para2]);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/radall", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 10)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GREY, " Используйте: /radall [радио 1-4]");
				SendClientMessage(playerid, COLOR_GREY, " или /radall 600");
				return 1;
			}
			new para1 = strval(tmp);
			if(para1 == 600)
			{
				format(strdln, sizeof(strdln), "1 - %s\n2 - %s\n3 - %s\n4 - %s\n5 - %s", NMRadio[1], NMRadio[2], NMRadio[3], NMRadio[4], NMRadio[5]);
				ShowPlayerDialog(playerid, 2, 0, "Список радио", strdln, "OK", "");
				return 1;
			}
			if(para1 < 1 || (para1 > 12 && para1 != 600))
			{
				SendClientMessage(playerid, COLOR_RED, " Такого радио нет !");
				return 1;
			}
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if((PlayerInfo[playerid][pAdmin] <= 11 && PlayerInfo[i][pAdmin] <= 11) || PlayerInfo[playerid][pAdmin] >= 12)
					{
						NRadio[i] = para1;//номер подключаемого радио
						StopAudioStreamForPlayer(i);//отключим любой другой поток
						PlayAudioStreamForPlayer(i, STRadio[para1]);//подключим поток с музыкой
						format(string, sizeof(string), " Админ %s включил всем радио %s", RealName[playerid], NMRadio[para1]);
						SendClientMessage(i, COLOR_GREEN, string);
						SendClientMessage(i, COLOR_GREEN, " Для выключения используйте: {A9C4E4}Игровой меню --> {91EF03}Радио --> {027FFE}Выключить радио");
					}
					if(PlayerInfo[playerid][pAdmin] <= 11 && PlayerInfo[i][pAdmin] >= 12)
					{
						format(string, sizeof(string), " Админ %s включил всем радио %s", RealName[playerid], NMRadio[para1]);
						SendClientMessage(i, COLOR_GREEN, string);
					}
				}
			}
			printf("[radio] Aдмин %s включил всем радио %s .", RealName[playerid], NMRadio[para1]);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	//-------------------- команды админов 10 лвл (конец) --------------------------
	//-------------------- команды админов 11 лвл (начало) -------------------------
	if(strcmp(cmd, "/dataakk", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 11)
		{
			new data44[18], Float:data4444[12], FracTxt44[2][64];
			akk = strtok(cmdtext, idx);
			if(!strlen(akk))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /dataakk [имя аккаунта]");
				return 1;
			}
			if(strlen(akk) < 1 || strlen(akk) > 25)
			{
				SendClientMessage(playerid, COLOR_RED, " Длина имени аккаунта должна быть от 1 до 25 символов !");
				return 1;
			}
			format(string, sizeof(string), "players/%s.ini", akk);
			if(!fexist(string))
			{
				SendClientMessage(playerid,COLOR_RED," Такого аккаунта не существует !");
				return 1;
			}
			new file, locper22[64];//чтение аккаунта
			file = ini_openFile(string);
			if(file == INI_OK)
			{
				ini_getString(file, "TDReg", tdreg);
				ini_getString(file, "IPAdr", adrip);
				ini_getInteger(file, "MinLog", data44[0]);
				ini_getInteger(file, "AdminLevel", data44[1]);
				ini_getInteger(file, "AdminShadow", data44[2]);
				ini_getInteger(file, "AdminLive", data44[3]);
				ini_getInteger(file, "Prison", data44[5]);
				ini_getInteger(file, "Prisonsec", data44[6]);
				ini_getInteger(file, "Muted", data44[7]);
				ini_getInteger(file, "Mutedsec", data44[8]);
				ini_getInteger(file, "Money", data44[9]);
				ini_getInteger(file, "Score", data44[10]);
				ini_getInteger(file, "Kills", data44[11]);
				ini_getInteger(file, "Deaths", data44[12]);
				ini_getInteger(file, "Lock", data44[13]);
				ini_getFloat(file, "Cord_X", data4444[0]);
				ini_getFloat(file, "Cord_Y", data4444[1]);
				ini_getFloat(file, "Cord_Z", data4444[2]);
				ini_getFloat(file, "Angle", data4444[3]);
				ini_getInteger(file, "Frac1", data44[14]);
				ini_getInteger(file, "FracLvl1", data44[15]);
				ini_getFloat(file, "FracCord_X1", data4444[4]);
				ini_getFloat(file, "FracCord_Y1", data4444[5]);
				ini_getFloat(file, "FracCord_Z1", data4444[6]);
				ini_getFloat(file, "FracAngle1", data4444[7]);
				ini_getString(file, "FracTxt1", locper22);
				strmid(FracTxt44[0], locper22, 0, strlen(locper22), 64);
				ini_getInteger(file, "Frac2", data44[16]);
				ini_getInteger(file, "FracLvl2", data44[17]);
				ini_getFloat(file, "FracCord_X2", data4444[8]);
				ini_getFloat(file, "FracCord_Y2", data4444[9]);
				ini_getFloat(file, "FracCord_Z2", data4444[10]);
				ini_getFloat(file, "FracAngle2", data4444[11]);
				ini_getString(file, "FracTxt2", locper22);
				strmid(FracTxt44[1], locper22, 0, strlen(locper22), 64);
				ini_closeFile(file);
			}
			new fadm;
			if(data44[1] < 0)
			{
				fadm = data44[1] * -1;
			}
			else
			{
				fadm = data44[1];
			}
			if(fadm >= 12 && PlayerInfo[playerid][pAdmin] <= 11)//проверка аккаунта на админку 12-го лвл
			{
				format(ssss,sizeof(ssss)," Нельзя, аккаунт игрока [%s] - админ %d LVL !", akk, fadm);
				SendClientMessage(playerid, COLOR_RED, ssss);
				return 1;
			}
			new dopdata44;
			dopdata44 = 0;
			for(new i=0;i<MAX_PLAYERS;i++)//проверка аккаунта на On-Line
			{
				if(IsPlayerConnected(i))
				{
					if(strcmp(akk, RealName[i], false) == 0) { dopdata44 = 1; }
				}
			}
			new dopdata2;
			if(data44[14] == -600)
			{
				dopdata2 = 0;
			}
			else
			{
				dopdata2 = data44[14];
			}
			printf(" Админ %s [%d] просмотрел аккаунт игрока %s . Без пароля !", RealName[playerid], playerid, akk);

			SendClientMessage(playerid, COLOR_LIGHTBLUE, "---------------------------------------------------------------");
			format(ssss, sizeof(ssss), "           Аккаунт игрока [%s] ( Без пароля ! )", akk);
			SendClientMessage(playerid, COLOR_WHITE, ssss);
			if(dopdata44 == 1)
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, " Внимание !!! Аккаунт игрока On-Line !");
			}
			format(ssss, sizeof(ssss), " Время и дата регистрации: [ %s ]", tdreg);
			SendClientMessage(playerid, COLOR_GRAD1, ssss);
			format(ssss, sizeof(ssss), " Координаты: X = %f Y = %f Z = %f Угол: %f",
			data4444[0], data4444[1], data4444[2], data4444[3]);
			SendClientMessage(playerid, COLOR_GRAD1, ssss);
			format(ssss, sizeof(ssss), " IP: [%s] Админ LVL: [%d] Скрытость админа: [%d]",
			adrip, fadm, data44[2]);
			SendClientMessage(playerid, COLOR_GRAD1, ssss);
			format(ssss, sizeof(ssss), " Посадок в тюрьму: [%d] Секунд тюрьмы: [%d] Число затыков: [%d] Секунд затыка: [%d]",
			data44[5], data44[6], data44[7], data44[8]);
			SendClientMessage(playerid, COLOR_GRAD1, ssss);
			format(ssss, sizeof(ssss), " Денег: [%d $] Очков: [%d] Убийств: [%d] Смертей: [%d] Блокировка аккаунта: [%d]",
			data44[9], data44[10], data44[11], data44[12], data44[13]);
			SendClientMessage(playerid, COLOR_GRAD1, ssss);
			format(ssss, sizeof(ssss), " Минут на сервере: [%d] Бессмертие: [%d]", data44[0], data44[3]);
			SendClientMessage(playerid, COLOR_GRAD1, ssss);
			format(ssss, sizeof(ssss), " ID банды: [%d] Уровень в банде: [%d]", dopdata2, data44[15]);
			SendClientMessage(playerid, COLOR_GRAD1, ssss);
			/*
			format(ssss, sizeof(ssss), " ID Фракции-2: [%d] Уровень во фракции-2: [%d] Текст фракции-2: [ %s ]",
			data44[16], data44[17], FracTxt44[1]);
			SendClientMessage(playerid, COLOR_GRAD1, ssss);
			format(ssss, sizeof(ssss), " Координаты фракции-2: X = %f Y = %f Z = %f Угол фракции-2: %f",
			data4444[8], data4444[9], data4444[10], data4444[11]);
			SendClientMessage(playerid, COLOR_GRAD1, ssss);
*/
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "---------------------------------------------------------------");

			return 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/unban", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 11)
		{
			new data2[3];
			data2[2] = 0;//переменная проверки блокировки аккаунта
			akk = strtok(cmdtext, idx);
			if(!strlen(akk))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /unban [имя аккаунта]");
				return 1;
			}
			if(strlen(akk) < 1 || strlen(akk) > 25)
			{
				SendClientMessage(playerid, COLOR_RED, " Длина имени аккаунта должна быть от 1 до 25 символов !");
				return 1;
			}
			format(string, sizeof(string), "players/%s.ini", akk);
			if(!fexist(string))
			{
				SendClientMessage(playerid,COLOR_RED," Такого аккаунта не существует !");
				return 1;
			}
			new file;//чтение аккаунта
			file = ini_openFile(string);
			if(file == INI_OK)
			{
				ini_getString(file, "IPAdr", adrip);
				ini_getInteger(file, "AdminLevel", data2[0]);
				ini_getInteger(file, "Lock", data2[1]);
				ini_closeFile(file);
			}
			for(new i = 0; i < MAX_PLAYERS; i++)//проверка аккаунта на On-Line
			{
				if(IsPlayerConnected(i))
				{
					if(strcmp(akk, RealName[i], false) == 0)
					{
						format(ssss, sizeof(ssss), " Ошибка в имени аккаунта, аккаунт игрока [%s] On-Line !", akk);
						SendClientMessage(playerid, COLOR_RED, ssss);
						return 1;
					}
				}
			}
			new fadm;
			if(data2[0] < 0)
			{
				fadm = data2[0] * -1;
			}
			else
			{
				fadm = data2[0];
			}
			if(fadm >= 1 && PlayerInfo[playerid][pAdmin] <= 11)//проверка аккаунта на админку
			{
				format(ssss,sizeof(ssss)," Нельзя, аккаунт игрока [%s] - админ %d LVL !", akk, fadm);
				SendClientMessage(playerid, COLOR_RED, ssss);
				return 1;
			}
			if(data2[1] == 0)//если аккаунт НЕ был заблокирован, то:
			{
				data2[2] = 1;//записываем в переменную проверки блокировки аккаунта 1
			}
			data2[1] = 0;//сброс блокировки аккаунта
			strdel(ssss, 0, 256);//сборка RCON-команды разбана
			strcat(ssss, "unbanip ");
			strcat(ssss, adrip);
			SendRconCommand(ssss);//RCON-команда разбана
			SendRconCommand("reloadbans");//RCON-команда перезагрузки бан-листа
			file = ini_openFile(string);//запись изменённого аккаунта
			if(file == INI_OK)
			{
				ini_setInteger(file, "Lock", data2[1]);
				ini_closeFile(file);
			}
			if(data2[2] == 1)//если переменная проверки блокировки аккаунта = 1, то:
			{
				format(ssss,sizeof(ssss)," Аккаунт игрока [%s] не заблокирован (не забанен) !", akk);
				print(ssss);
				SendClientMessage(playerid, COLOR_RED, ssss);
				format(ssss,sizeof(ssss)," ( IP: [%s] был удалён из файла samp.ban ) !", adrip);
				print(ssss);
				SendClientMessage(playerid, COLOR_GREEN, ssss);
			}
			else//иначе:
			{
				format(ssss,sizeof(ssss)," Админ %s разбанил аккаунт игрока [%s] ( IP: [%s] ) .", RealName[playerid], akk, adrip);
				print(ssss);
				SendAdminMessage(COLOR_GREEN, ssss);
				format(ssss,sizeof(ssss)," Админ %s разбанил аккаунт игрока [%s] .", RealName[playerid], akk);
				for(new i=0;i<MAX_PLAYERS;i++)//отправка сообщения НЕ админам
				{
					if(IsPlayerConnected(i) && PlayerInfo[i][pAdmin] == 0)
					{
						SendClientMessage(i, COLOR_GREEN, ssss);
					}
				}
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/shad", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 11)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /shad [ид игрока/часть ника] [0-убрать скрытость, 1-скрыть]");
				return 1;
			}
			new para1;
			new stat;
			para1 = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			stat = strval(tmp);
			if(IsPlayerConnected(para1))
			{
				if(gPlayerLogged[para1] == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Выбранный игрок ещё не залогинился !");
					return 1;
				}
				if (PlayerInfo[para1][pAdmin] != 0)
				{
					if (PlayerInfo[para1][pAdmin] >= 12 && PlayerInfo[playerid][pAdmin] <= 11)
					{
						SendClientMessage(playerid, COLOR_RED, " Вы не можете изменять скрытость админа 12 уровня !");
						return 1;
					}
					if(stat < 0 || stat > 1)
					{
						SendClientMessage(playerid, COLOR_RED, " [0-убрать скрытость, 1-скрыть] !");
						return 1;
					}
					if(stat == 0 && PlayerInfo[para1][pAdmshad] == 0)
					{
						SendClientMessage(playerid, COLOR_RED, " У выбранного админа уже нет скрытости !");
						return 1;
					}
					if(stat == 1 && PlayerInfo[para1][pAdmshad] == 1)
					{
						SendClientMessage(playerid, COLOR_RED, " У выбранного админа уже есть скрытость !");
						return 1;
					}
					PlayerInfo[para1][pAdmshad] = stat;
					if(PlayerInfo[para1][pAdmshad] == 1)
					{
						format(string, sizeof(string), " Админ %s дал админу %s статус скрытости.", RealName[playerid],
						RealName[para1]);
						print(string);
						SendAdminMessage(COLOR_YELLOW, string);
					}
					else
					{
						format(string, sizeof(string), " Админ %s убрал с админа %s статус скрытости.", RealName[playerid],
						RealName[para1]);
						print(string);
						SendAdminMessage(COLOR_RED, string);
					}
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, " Выбранный игрок - не админ !");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Такого [ид игрока] на сервере нет !");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/deltr", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 11)
		{
			new model, cnt;
			cnt = 0;
			for(new i = 1; i < 10001; i++)
			{
				model = GetVehicleModel(i);
				if(model == 537 || model == 538 || model == 569 || model == 570)
				{
					DestroyVehicle(i);
					cnt++;
				}
			}
			if(cnt != 0)
			{
				format(string, sizeof(string), " Было уничтожено %d свободных единиц поездов или вагонов !", cnt);
				SendClientMessage(playerid, COLOR_GREY, string);
			}
			else
			{
				format(string, sizeof(string), " Свободных поездов или вагонов не было найдено !", cnt);
				SendClientMessage(playerid, COLOR_GREY, string);
			}
			format(string, sizeof(string), " Админ %s уничтожил %d свободных единиц поездов или вагонов.",
			RealName[playerid], cnt);
			print(string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/ipban", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 11)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /ipban [IP-адрес]");
				return 1;
			}
			new dltmp;
			dltmp = strlen(tmp);
			if(dltmp < 7 || dltmp > 15)
			{
				SendClientMessage(playerid, COLOR_RED, " Длина IP-адреса должна быть от 7 до 15 символов !");
				return 1;
			}
			new dopper111 = 0;
			new dopper222 = 0;
			for(new i = 0; i < dltmp; i++)
			{
				if((tmp[i] < 48 || tmp[i] > 57) && tmp[i] != '.' && tmp[i] != '*') {dopper111 = 1;}
				if(tmp[i] == '.') {dopper222++;}
			}
			if(dopper111 == 1 || dopper222 != 3)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка в написании IP-адреса !");
				return 1;
			}
			for(new i = 0; i < 4; i++)//очистка локальной части массива ipper
			{
				for(new j = 0; j < 32; j++)
				{
					ipper[playerid][i][j] = 0;
				}
			}
			new ind1, ind2;//разделение IP-адреса
			ind1 = -1;
			for(new i = 0; i < 4; i++)
			{
				ind1++;
				ind2 = 0;
				while(tmp[ind1] != '.')
				{
					if(ind1 > dltmp)
					{
						break;
					}
					ipper[playerid][i][ind2] = tmp[ind1];
					ind1++;
					ind2++;
				}
			}
			dopper111 = 0;
			for(new i = 0; i < 4; i++)
			{
				if(strlen(ipper[playerid][i]) < 1 || strlen(ipper[playerid][i]) > 3) {dopper111 = 1;}
			}
			if(dopper111 == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка в написании IP-адреса !");
				return 1;
			}
			if(strfind(ipper[playerid][0], "*", true) != -1)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка !!!   IP-адрес НЕ может начинаться с шаблона !");
				return 1;
			}
			if(strval(ipper[playerid][0]) > 255)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка в написании IP-адреса !");
				return 1;
			}
			if((strfind(ipper[playerid][1], "*", true) == -1 && strfind(ipper[playerid][2], "*", true) != -1 &&
						strfind(ipper[playerid][3], "*", true) == -1) ||
					(strfind(ipper[playerid][1], "*", true) != -1 && strfind(ipper[playerid][2], "*", true) == -1 &&
						strfind(ipper[playerid][3], "*", true) == -1) ||
					(strfind(ipper[playerid][1], "*", true) != -1 && strfind(ipper[playerid][2], "*", true) == -1 &&
						strfind(ipper[playerid][3], "*", true) != -1) ||
					(strfind(ipper[playerid][1], "*", true) != -1 && strfind(ipper[playerid][2], "*", true) != -1 &&
						strfind(ipper[playerid][3], "*", true) == -1))
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка !!!   Шаблон указан не верно !");
				return 1;
			}
			new ind3 = 1;//проверка местоположения "*" в каждой из групп цифр,
			new ind4 = 0;//И проверка каждой группы цифр на максимально допустимый адрес
			new ind5 = 0;
			while(ind3 < 4)
			{
				if(strlen(ipper[playerid][ind3]) == 2)
				{
					if(ipper[playerid][ind3][0] == '*' || ipper[playerid][ind3][1] == '*') {ind4 = 1;}
					if(ipper[playerid][ind3][0] == '0') {ind5 = 1;}
				}
				if(strlen(ipper[playerid][ind3]) == 3)
				{
					if(ipper[playerid][ind3][0] == '*' || ipper[playerid][ind3][1] == '*' ||
							ipper[playerid][ind3][2] == '*') {ind4 = 1;}
					if(ipper[playerid][ind3][0] == '0') {ind5 = 1;}
					if(strval(ipper[playerid][ind3]) > 255) {ind5 = 1;}
				}
				ind3++;
			}
			if(ind4 == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка !!!   Шаблон указан не верно !");
				return 1;
			}
			if(ind5 == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка в написании IP-адреса !");
				return 1;
			}
			new dopper33[256];//бан IP-адреса
			strdel(dopper33, 0, 256);
			strcat(dopper33, "banip ");
			strcat(dopper33, tmp);
			SendRconCommand(dopper33);
			SendRconCommand("reloadbans");
			format(string, sizeof(string), " Админ %s забанил IP адрес: [%s]", RealName[playerid], tmp);
			print(string);
			SendClientMessageToAll(COLOR_RED, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/ipunban", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 11)
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /ipunban [IP-адрес]");
				return 1;
			}
			new dltmp;
			dltmp = strlen(tmp);
			if(dltmp < 7 || dltmp > 15)
			{
				SendClientMessage(playerid, COLOR_RED, " Длина IP-адреса должна быть от 7 до 15 символов !");
				return 1;
			}
			new dopper111 = 0;
			new dopper222 = 0;
			for(new i = 0; i < dltmp; i++)
			{
				if((tmp[i] < 48 || tmp[i] > 57) && tmp[i] != '.' && tmp[i] != '*') {dopper111 = 1;}
				if(tmp[i] == '.') {dopper222++;}
			}
			if(dopper111 == 1 || dopper222 != 3)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка в написании IP-адреса !");
				return 1;
			}
			for(new i = 0; i < 4; i++)//очистка локальной части массива ipper
			{
				for(new j = 0; j < 32; j++)
				{
					ipper[playerid][i][j] = 0;
				}
			}
			new ind1, ind2;//разделение IP-адреса
			ind1 = -1;
			for(new i = 0; i < 4; i++)
			{
				ind1++;
				ind2 = 0;
				while(tmp[ind1] != '.')
				{
					if(ind1 > dltmp)
					{
						break;
					}
					ipper[playerid][i][ind2] = tmp[ind1];
					ind1++;
					ind2++;
				}
			}
			dopper111 = 0;
			for(new i = 0; i < 4; i++)
			{
				if(strlen(ipper[playerid][i]) < 1 || strlen(ipper[playerid][i]) > 3) {dopper111 = 1;}
			}
			if(dopper111 == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка в написании IP-адреса !");
				return 1;
			}
			if(strfind(ipper[playerid][0], "*", true) != -1)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка !!!   IP-адрес НЕ может начинаться с шаблона !");
				return 1;
			}
			if(strval(ipper[playerid][0]) > 255)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка в написании IP-адреса !");
				return 1;
			}
			if((strfind(ipper[playerid][1], "*", true) == -1 && strfind(ipper[playerid][2], "*", true) != -1 &&
						strfind(ipper[playerid][3], "*", true) == -1) ||
					(strfind(ipper[playerid][1], "*", true) != -1 && strfind(ipper[playerid][2], "*", true) == -1 &&
						strfind(ipper[playerid][3], "*", true) == -1) ||
					(strfind(ipper[playerid][1], "*", true) != -1 && strfind(ipper[playerid][2], "*", true) == -1 &&
						strfind(ipper[playerid][3], "*", true) != -1) ||
					(strfind(ipper[playerid][1], "*", true) != -1 && strfind(ipper[playerid][2], "*", true) != -1 &&
						strfind(ipper[playerid][3], "*", true) == -1))
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка !!!   Шаблон указан не верно !");
				return 1;
			}
			new ind3 = 1;//проверка местоположения "*" в каждой из групп цифр,
			new ind4 = 0;//И проверка каждой группы цифр на максимально допустимый адрес
			new ind5 = 0;
			while(ind3 < 4)
			{
				if(strlen(ipper[playerid][ind3]) == 2)
				{
					if(ipper[playerid][ind3][0] == '*' || ipper[playerid][ind3][1] == '*') {ind4 = 1;}
					if(ipper[playerid][ind3][0] == '0') {ind5 = 1;}
				}
				if(strlen(ipper[playerid][ind3]) == 3)
				{
					if(ipper[playerid][ind3][0] == '*' || ipper[playerid][ind3][1] == '*' ||
							ipper[playerid][ind3][2] == '*') {ind4 = 1;}
					if(ipper[playerid][ind3][0] == '0') {ind5 = 1;}
					if(strval(ipper[playerid][ind3]) > 255) {ind5 = 1;}
				}
				ind3++;
			}
			if(ind4 == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка !!!   Шаблон указан не верно !");
				return 1;
			}
			if(ind5 == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Ошибка в написании IP-адреса !");
				return 1;
			}
			new dopper33[256];//бан IP-адреса
			strdel(dopper33, 0, 256);
			strcat(dopper33, "unbanip ");
			strcat(dopper33, tmp);
			SendRconCommand(dopper33);
			SendRconCommand("reloadbans");
			format(string, sizeof(string), " Админ %s разбанил IP адрес: [%s]", RealName[playerid], tmp);
			print(string);
			SendClientMessageToAll(COLOR_GREEN, string);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	//-------------------- команды админов 11 лвл (конец) --------------------------
	//----------------- команды админов 12 и 13 лвл (начало) -----------------------
	if(strcmp(cmd, "/admakk", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 12)
		{
			new data2[26], Float:data333[28], FracTxt[6][64];
			akk = strtok(cmdtext, idx);
			if(!strlen(akk))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /admakk [имя аккаунта] [левел(0-12)] ( дополнительно:");
				SendClientMessage(playerid, COLOR_GRAD2, " [сумма] [очки] ),");
				SendClientMessage(playerid, COLOR_GRAD2, " или /admakk [имя аккаунта] 99 [пароль] - сменить пароль,");
				SendClientMessage(playerid, COLOR_GRAD2, " или /admakk [имя аккаунта] 100 - просмотреть аккаунт");
				return 1;
			}
			if(strlen(akk) < 1 || strlen(akk) > 25)
			{
				SendClientMessage(playerid, COLOR_RED, " Длина имени аккаунта должна быть от 1 до 25 символов !");
				return 1;
			}
			format(string, sizeof(string), "players/%s.ini", akk);
			if(!fexist(string))
			{
				SendClientMessage(playerid,COLOR_RED," Такого аккаунта не существует !");
				return 1;
			}
			new entpass[64], level, oldlevel, summ1, summ2;
			new ochki1, ochki2, dopper;
			dopper = 0;
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " [левел(0-12), или 99, или 100] ( дополнительно: [сумма] [очки] ) !");
				return 1;
			}
			level = strval(tmp);
			if((level < 0 || level > 12) && level != 99 && level != 100)
			{
				SendClientMessage(playerid, COLOR_RED, " Уровень админа должен быть от 0 до 12 , (или 99, или 100) !");
				return 1;
			}
			if(level == 99)
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_RED, " /admakk [имя аккаунта] 99 [пароль] !");
					return 1;
				}
				if(strlen(tmp) < 3 || strlen(tmp) > 20)
				{
					SendClientMessage(playerid, COLOR_RED, " Длина пароля должна быть от 3 до 20 символов !");
					return 1;
				}
				if(PassControl(tmp) == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " В пароле можно использовать ТОЛЬКО латинские");
					SendClientMessage(playerid, COLOR_RED, " символы: от a до z , от A до Z , и цифры от 0 до 9 !");
					return 1;
				}
				strdel(entpass, 0, 64);
				strcat(entpass, tmp);
			}
			else
			{
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					summ1 = 0;
				}
				else
				{
					summ1 = 1;
					summ2 = strval(tmp);
				}
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					ochki1 = 0;
				}
				else
				{
					ochki1 = 1;
					ochki2 = strval(tmp);
				}
			}
			new file, locper22[64];//чтение аккаунта
			file = ini_openFile(string);
			if(file == INI_OK)
			{
				ini_getString(file, "Key", igkey);
				ini_getString(file, "TDReg", tdreg);
				ini_getString(file, "IPAdr", adrip);
				ini_getInteger(file, "MinLog", data2[0]);
				ini_getInteger(file, "AdminLevel", data2[1]);
				ini_getInteger(file, "AdminShadow", data2[2]);
				ini_getInteger(file, "AdminLive", data2[3]);
				ini_getInteger(file, "Registered", data2[4]);
				ini_getInteger(file, "Prison", data2[5]);
				ini_getInteger(file, "Prisonsec", data2[6]);
				ini_getInteger(file, "Muted", data2[7]);
				ini_getInteger(file, "Mutedsec", data2[8]);
				ini_getInteger(file, "Money", data2[9]);
				ini_getInteger(file, "Score", data2[10]);
				ini_getInteger(file, "Kills", data2[11]);
				ini_getInteger(file, "Deaths", data2[12]);
				ini_getInteger(file, "Lock", data2[13]);
				ini_getFloat(file, "Cord_X", data333[0]);
				ini_getFloat(file, "Cord_Y", data333[1]);
				ini_getFloat(file, "Cord_Z", data333[2]);
				ini_getFloat(file, "Angle", data333[3]);
				ini_getInteger(file, "Frac1", data2[14]);
				ini_getInteger(file, "FracLvl1", data2[15]);
				ini_getFloat(file, "FracCord_X1", data333[4]);
				ini_getFloat(file, "FracCord_Y1", data333[5]);
				ini_getFloat(file, "FracCord_Z1", data333[6]);
				ini_getFloat(file, "FracAngle1", data333[7]);
				ini_getString(file, "FracTxt1", locper22);
				strmid(FracTxt[0], locper22, 0, strlen(locper22), 64);
				ini_getInteger(file, "Frac2", data2[16]);
				ini_getInteger(file, "FracLvl2", data2[17]);
				ini_getFloat(file, "FracCord_X2", data333[8]);
				ini_getFloat(file, "FracCord_Y2", data333[9]);
				ini_getFloat(file, "FracCord_Z2", data333[10]);
				ini_getFloat(file, "FracAngle2", data333[11]);
				ini_getString(file, "FracTxt2", locper22);
				strmid(FracTxt[1], locper22, 0, strlen(locper22), 64);
				ini_getInteger(file, "Frac3", data2[18]);
				ini_getInteger(file, "FracLvl3", data2[19]);
				ini_getFloat(file, "FracCord_X3", data333[12]);
				ini_getFloat(file, "FracCord_Y3", data333[13]);
				ini_getFloat(file, "FracCord_Z3", data333[14]);
				ini_getFloat(file, "FracAngle3", data333[15]);
				ini_getString(file, "FracTxt3", locper22);
				strmid(FracTxt[2], locper22, 0, strlen(locper22), 64);
				ini_getInteger(file, "Frac4", data2[20]);
				ini_getInteger(file, "FracLvl4", data2[21]);
				ini_getFloat(file, "FracCord_X4", data333[16]);
				ini_getFloat(file, "FracCord_Y4", data333[17]);
				ini_getFloat(file, "FracCord_Z4", data333[18]);
				ini_getFloat(file, "FracAngle4", data333[19]);
				ini_getString(file, "FracTxt4", locper22);
				strmid(FracTxt[3], locper22, 0, strlen(locper22), 64);
				ini_getInteger(file, "Frac5", data2[22]);
				ini_getInteger(file, "FracLvl5", data2[23]);
				ini_getFloat(file, "FracCord_X5", data333[20]);
				ini_getFloat(file, "FracCord_Y5", data333[21]);
				ini_getFloat(file, "FracCord_Z5", data333[22]);
				ini_getFloat(file, "FracAngle5", data333[23]);
				ini_getString(file, "FracTxt5", locper22);
				strmid(FracTxt[4], locper22, 0, strlen(locper22), 64);
				ini_getInteger(file, "Frac6", data2[24]);
				ini_getInteger(file, "FracLvl6", data2[25]);
				ini_getFloat(file, "FracCord_X6", data333[24]);
				ini_getFloat(file, "FracCord_Y6", data333[25]);
				ini_getFloat(file, "FracCord_Z6", data333[26]);
				ini_getFloat(file, "FracAngle6", data333[27]);
				ini_getString(file, "FracTxt6", locper22);
				strmid(FracTxt[5], locper22, 0, strlen(locper22), 64);
				ini_closeFile(file);
			}
			new fadm;
			if(data2[1] < 0)
			{
				fadm = data2[1] * -1;
			}
			else
			{
				fadm = data2[1];
			}
			if(level == 100)
			{
				new dopdata44;
				dopdata44 = 0;
				for(new i=0;i<MAX_PLAYERS;i++)//проверка аккаунта на On-Line
				{
					if(IsPlayerConnected(i))
					{
						if(strcmp(akk, RealName[i], false) == 0) { dopdata44 = 1; }
					}
				}
				new dopdata2;
				if(data2[14] == -600)
				{
					dopdata2 = 0;
				}
				else
				{
					dopdata2 = data2[14];
				}
				printf(" Админ %s [%d] просмотрел аккаунт игрока %s .", RealName[playerid], playerid, akk);

				SendClientMessage(playerid, COLOR_LIGHTBLUE, "---------------------------------------------------------------");
				format(ssss, sizeof(ssss), "           Аккаунт игрока [%s]", akk);
				SendClientMessage(playerid, COLOR_WHITE, ssss);
				if(dopdata44 == 1)
				{
					SendClientMessage(playerid, COLOR_LIGHTRED, " Внимание !!! Аккаунт игрока On-Line !");
				}
				format(ssss, sizeof(ssss), " Время и дата регистрации: [ %s ]", tdreg);
				SendClientMessage(playerid, COLOR_GRAD1, ssss);
				format(ssss, sizeof(ssss), " Координаты: X = %f Y = %f Z = %f Угол: %f",
				data333[0], data333[1], data333[2], data333[3]);
				SendClientMessage(playerid, COLOR_GRAD1, ssss);
				format(ssss, sizeof(ssss), " Пароль: [%s] IP: [%s] Админ LVL: [%d] Скрытость админа: [%d]",
				igkey, adrip, fadm, data2[2]);
				SendClientMessage(playerid, COLOR_GRAD1, ssss);
				format(ssss, sizeof(ssss), " Посадок в тюрьму: [%d] Секунд тюрьмы: [%d] Число затыков: [%d] Секунд затыка: [%d]",
				data2[5], data2[6], data2[7], data2[8]);
				SendClientMessage(playerid, COLOR_GRAD1, ssss);
				format(ssss, sizeof(ssss), " Денег: [%d $] Очков: [%d] Убийств: [%d] Смертей: [%d] Блокировка аккаунта: [%d]",
				data2[9], data2[10], data2[11], data2[12], data2[13]);
				SendClientMessage(playerid, COLOR_GRAD1, ssss);
				format(ssss, sizeof(ssss), " Минут на сервере: [%d] Бессмертие: [%d]", data2[0], data2[3]);
				SendClientMessage(playerid, COLOR_GRAD1, ssss);
				format(ssss, sizeof(ssss), " ID банды: [%d] Уровень в банде: [%d]", dopdata2, data2[15]);
				SendClientMessage(playerid, COLOR_GRAD1, ssss);
				/*
				format(ssss, sizeof(ssss), " ID Фракции-2: [%d] Уровень во фракции-2: [%d] Текст фракции-2: [ %s ]",
				data2[16], data2[17], FracTxt[1]);
				SendClientMessage(playerid, COLOR_GRAD1, ssss);
				format(ssss, sizeof(ssss), " Координаты фракции-2: X = %f Y = %f Z = %f Угол фракции-2: %f",
				data333[8], data333[9], data333[10], data333[11]);
				SendClientMessage(playerid, COLOR_GRAD1, ssss);
*/
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "---------------------------------------------------------------");

				return 1;
			}
			for(new i = 0; i < MAX_PLAYERS; i++)//проверка аккаунта на On-Line
			{
				if(IsPlayerConnected(i))
				{
					if(strcmp(akk, RealName[i], false) == 0)
					{
						format(ssss, sizeof(ssss), " Нельзя, аккаунт игрока [%s] On-Line !", akk);
						SendClientMessage(playerid, COLOR_RED, ssss);
						return 1;
					}
				}
			}
			if(level == 99)
			{
				if(strcmp(igkey, entpass, false) == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Аккаунт игрока остался без изменений !");
					return 1;
				}
				printf(" Админ %s сменил пароль аккаунту игрока [%s] на (%s) FP: (%s) .", RealName[playerid], akk, entpass, igkey);
				format(ssss, sizeof(ssss), " Вы сменили пароль аккаунту игрока [%s] на (%s) FP: (%s) .", akk, entpass, igkey);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, ssss);
				strdel(igkey, 0, 256);
				strcat(igkey, entpass);
			}
			else
			{
				if(level == fadm && (summ1 == 0 || summ2 == data2[9]) && (ochki1 == 0 || ochki2 == data2[10]))
				{
					SendClientMessage(playerid, COLOR_RED, " Аккаунт игрока остался без изменений !");
					return 1;
				}
				if(level == 0 && level != fadm)
				{
					dopper = 1;
					data2[2] = 0;//убрать скрытость
					data2[3] = 0;//убрать бессмертие
					data2[1] = level;//изменение уровня админки
					format(ssss, sizeof(ssss), " Админ %s снял админку с аккаунта игрока [%s] .", RealName[playerid], akk);
					print(ssss);
					SendAdminMessage(COLOR_LIGHTBLUE, ssss);
				}
				if(level > 0 && level != fadm)
				{
					dopper = 1;
					oldlevel = fadm;//сохранение старого уровня админки
					data2[2] = 0;//убрать скрытость
					if(data2[1] <= 0)//изменение уровня админки
					{
						data2[1] = level * -1;
					}
					else
					{
						data2[1] = level;
					}
					format(ssss, sizeof(ssss), " Админ %s дал аккаунту игрока [%s] админку %d уровня.", RealName[playerid],
					akk, level);
					print(ssss);
					SendAdminMessage(COLOR_LIGHTBLUE, ssss);
					if(level <= 6 && oldlevel >= 7)
					{
						data2[3] = 0;//выключить бессмертие
					}
					if(level >= 7 && oldlevel <= 6)
					{
						data2[3] = 1;//включить бессмертие
					}
				}
				if(summ1 == 1 && summ2 != data2[9])
				{
					dopper = 1;
					data2[9] = summ2;//изменение личного счёта
					format(ssss, sizeof(ssss), " Личный счёт аккаунта игрока [%s] был изменён на: %d $ .", akk, data2[9]);
					print(ssss);
					SendAdminMessage(COLOR_LIGHTBLUE, ssss);
				}
				if(ochki1 == 1 && ochki2 != data2[10])
				{
					dopper = 1;
					data2[10] = ochki2;//изменение личного счёта
					format(ssss, sizeof(ssss), " Очки аккаунта игрока [%s] были изменены на: %d .", akk, data2[10]);
					print(ssss);
					SendAdminMessage(COLOR_LIGHTBLUE, ssss);
				}
				if(dopper == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Аккаунт игрока остался без изменений !");
					return 1;
				}
			}
			file = ini_openFile(string);//запись изменённого аккаунта
			if(file == INI_OK)
			{
				ini_setString(file, "Key", igkey);
				ini_setInteger(file, "AdminLevel", data2[1]);
				ini_setInteger(file, "AdminShadow", data2[2]);
				ini_setInteger(file, "AdminLive", data2[3]);
				ini_setInteger(file, "Money", data2[9]);
				ini_setInteger(file, "Score", data2[10]);
				ini_closeFile(file);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/delakk", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 12)
		{
			new data222[2];
			akk = strtok(cmdtext, idx);
			if(!strlen(akk))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /delakk [имя аккаунта]");
				return 1;
			}
			if(strlen(akk) < 1 || strlen(akk) > 25)
			{
				SendClientMessage(playerid, COLOR_RED, " Длина имени аккаунта должна быть от 1 до 25 символов !");
				return 1;
			}
			format(string, sizeof(string), "players/%s.ini", akk);
			if(!fexist(string))
			{
				SendClientMessage(playerid,COLOR_RED," Такого аккаунта не существует !");
				return 1;
			}
			for(new i = 0; i < MAX_PLAYERS; i++)//проверка аккаунта на On-Line
			{
				if(IsPlayerConnected(i))
				{
					if(strcmp(akk, RealName[i], false) == 0)
					{
						format(ssss, sizeof(ssss), " Нельзя, аккаунт игрока [%s] On-Line !", akk);
						SendClientMessage(playerid, COLOR_RED, ssss);
						return 1;
					}
				}
			}
			new file;//чтение аккаунта
			file = ini_openFile(string);
			if(file == INI_OK)
			{
				ini_getString(file, "IPAdr", adrip);
				ini_getInteger(file, "Frac1", data222[0]);
				ini_getInteger(file, "FracLvl1", data222[1]);
				ini_closeFile(file);
			}
			if(fexist(string))
			{
				fremove(string);//удаляем аккаунт
			}
			format(ssss,sizeof(ssss)," Админ %s удалил аккаунт игрока [%s] .", RealName[playerid], akk);
			print(ssss);
			SendClientMessageToAll(COLOR_LIGHTBLUE, ssss);
			strdel(ssss, 0, 256);//очистка переменной для разбана
			strcat(ssss, "unbanip ");//сборка RCON-команды разбана
			strcat(ssss, adrip);
			SendRconCommand(ssss);//RCON-команда разбана
			SendRconCommand("reloadbans");//RCON-команда перезагрузки бан-листа
			format(ssss,sizeof(ssss)," ( IP: [%s] был удалён из файла samp.ban ) !", adrip);
			print(ssss);
			SendAdminMessage(COLOR_LIGHTBLUE, ssss);
			format(ssss,sizeof(ssss)," ( IP-адрес игрока [%s] был удалён из файла samp.ban ) !", akk);
			for(new i=0;i<MAX_PLAYERS;i++)//отправка сообщения НЕ админам
			{
				if(IsPlayerConnected(i) && PlayerInfo[i][pAdmin] == 0)
				{
					SendClientMessage(i, COLOR_LIGHTBLUE, ssss);
				}
			}
			if(data222[1] == 6)//если удаляемый аккаунт - лидер банды, то:
			{
				format(string, sizeof(string), "gangs/%d.ini", data222[0]);
				if(fexist(string))//если файл с ID банды существует, то:
				{
					GangSA[data222[0]] = 0;//запрещаем запись ID банды в файл
					SetTimerEx("DelAkk22", 300, 0, "i", data222[0]);
				}
			}
			else//если удаляемый аккаунт - НЕ лидер банды, то:
			{
				if(data222[0] > 0)//если игрок состоял в банде, то:
				{
					format(string, sizeof(string), "gangs/%d.ini", data222[0]);
					if(fexist(string))//если файл с ID банды существует, то:
					{
						GPlayers[data222[0]]--;//делаем в банде -1 игрок, и сохраняем изменения
						GangSave(data222[0]);//запись ID банды в файл
						format(ssss, sizeof(ssss), " и изменил число игроков в банде [%s{33CCFF}] на %d (автоматически) .",
						GName[data222[0]], GPlayers[data222[0]]);
						print(ssss);
						SendClientMessageToAll(COLOR_LIGHTBLUE, ssss);
					}
				}
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/edplgangs", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 12)
		{
			new data222[2];
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /edplgangs [режим (0- On-Line игрок, 1- Off-Line игрок)]");
				SendClientMessage(playerid, COLOR_GRAD2, " [ид игрока (режим 0), или имя аккаунта (режим 1)]");
				SendClientMessage(playerid, COLOR_GRAD2, " [ид банды, или: 0 - удалить игрока из банды, -600 - запретить приглашать");
				SendClientMessage(playerid, COLOR_GRAD2, " игрока в банду] ( дополнительно: [уровень в банде (от 1 до 6)] )");
				return 1;
			}
			new para1 = strval(tmp);
			if(para1 < 0 || para1 > 1)
			{
				SendClientMessage(playerid, COLOR_RED, " [режим (0- On-Line игрок, 1- Off-Line игрок)] !");
				return 1;
			}
			akk = strtok(cmdtext, idx);
			if(!strlen(akk))
			{
				SendClientMessage(playerid, COLOR_RED, " [ид игрока (режим 0), или имя аккаунта (режим 1)] !");
				return 1;
			}
			new para2;
			if(para1 == 0)
			{
				para2 = strval(akk);
				if(!IsPlayerConnected(para2))
				{
					SendClientMessage(playerid, COLOR_RED, " Такого [ид игрока] на сервере нет !");
					return 1;
				}
				if(gPlayerLogged[para2] == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Выбранный игрок ещё не залогинился !");
					return 1;
				}
			}
			if(para1 == 1)
			{
				if(strlen(akk) < 1 || strlen(akk) > 25)
				{
					SendClientMessage(playerid, COLOR_RED, " Длина имени аккаунта должна быть от 1 до 25 символов !");
					return 1;
				}
				format(string, sizeof(string), "players/%s.ini", akk);
				if(!fexist(string))
				{
					SendClientMessage(playerid,COLOR_RED," Такого аккаунта не существует !");
					return 1;
				}
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " [ид банды, или 0 , или -600] !");
				return 1;
			}
			new para3 = strval(tmp);
			if(para3 < 0 && para3 != -600)
			{
				SendClientMessage(playerid, COLOR_RED, " [ид банды, или 0 , или -600] !");
				return 1;
			}
			new para4 = 0;
			if(para3 > 0)
			{
				new string22[256];
				format(string22,sizeof(string22),"gangs/%i.ini",para3);
				if(!fexist(string22) || para3 >= (MAX_GANGS - 1))
				{
					SendClientMessage(playerid, COLOR_RED, " Такого [ид банды] на сервере нет !");
					return 1;
				}
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					SendClientMessage(playerid, COLOR_RED, " [уровень в банде (от 1 до 6)] !");
					return 1;
				}
				para4 = strval(tmp);
				if(para4 < 1 || para4 > 6)
				{
					SendClientMessage(playerid, COLOR_RED, " [уровень в банде (от 1 до 6)] !");
					return 1;
				}
			}
			if(para1 == 0)
			{
				if(PGang[para2] == para3 && GangLvl[para2] == para4)
				{
					SendClientMessage(playerid,COLOR_RED," У выбранного игрока уже установлены назначаемые данные !");
					return 1;
				}
				if(para3 == -600)
				{
					if(PGang[para2] == 0)
					{
						format(ssss, sizeof(ssss), " Админ %s запретил приглашать игрока %s в банду (/edplgangs) .",
						RealName[playerid], RealName[para2]);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
					}
					if(PGang[para2] > 0)
					{
						if(idgangsave[para2] > 0)//если ID банды для записи - активен, то:
						{
							new perloc;
							idgangsave[para2] = 0;//очистка ID банды для записи
							perloc = 0;
							while(perloc < MAX_PLAYERS)//цикл для всех игроков
							{
								if(PGang[para2] == PGang[perloc] && para2 != perloc)
								{//если есть хотя бы один игрок из банды выходящего, то:
									idgangsave[perloc] = PGang[para2];
									break;
								}
								perloc++;
							}
						}
						format(ssss, sizeof(ssss), " Админ %s удалил игрока %s из банды (ид: %d) ,",
						RealName[playerid], RealName[para2], PGang[para2]);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						format(ssss, sizeof(ssss), " и запретил приглашать игрока %s в банду (/edplgangs) .",
						RealName[para2]);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						GPlayers[PGang[para2]]--;//делаем в банде -1 игрок
						GangSave(PGang[para2]);//записываем банду
					}
				}
				if(para3 == 0)
				{
					if(PGang[para2] == -600)
					{
						format(ssss, sizeof(ssss), " Админ %s разрешил приглашать игрока %s в банду (/edplgangs) .",
						RealName[playerid], RealName[para2]);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
					}
					if(PGang[para2] > 0)
					{
						if(idgangsave[para2] > 0)//если ID банды для записи - активен, то:
						{
							new perloc;
							idgangsave[para2] = 0;//очистка ID банды для записи
							perloc = 0;
							while(perloc < MAX_PLAYERS)//цикл для всех игроков
							{
								if(PGang[para2] == PGang[perloc] && para2 != perloc)
								{//если есть хотя бы один игрок из банды выходящего, то:
									idgangsave[perloc] = PGang[para2];
									break;
								}
								perloc++;
							}
						}

						format(ssss, sizeof(ssss), " Админ %s удалил игрока %s из банды (ид: %d) ,",
						RealName[playerid], RealName[para2], PGang[para2]);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						format(ssss, sizeof(ssss), " и разрешил приглашать игрока %s в банду (/edplgangs) .",
						RealName[para2]);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						GPlayers[PGang[para2]]--;//делаем в банде -1 игрок
						GangSave(PGang[para2]);//записываем банду
					}
				}
				if(para3 > 0)
				{
					if(PGang[para2] == -600 || PGang[para2] == 0)
					{
						format(ssss, sizeof(ssss), " Админ %s приписал игрока %s к банде (ид: %d) ,",
						RealName[playerid], RealName[para2], para3);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						format(ssss, sizeof(ssss), " и назначил игроку %s уровень %d в этой банде (/edplgangs) .",
						RealName[para2], para4);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						if(para4 == 6)//если назначаемый уровень - уровень лидера, то:
						{
							strdel(GHead[para3], 0, 64);//удалить имя старого лидера банды
							strcat(GHead[para3], RealName[para2]);//назначить имя нового лидера банды
						}
						GPlayers[para3]++;//делаем в банде +1 игрок
						GangSave(para3);//записываем банду

						if(GSkin[para3][para4-1] < 500)
						{//если на уровне установлен скин, то сменить скин приписанному игроку
							SetPVarInt(para2, "PlSkin", GSkin[para3][para4-1]);
							SetPlayerSkin(para2, GetPVarInt(para2, "PlSkin"));
						}
						ColorPlay[para2] = GColorDec[para3];
						SetPlayerColor(para2, ColorPlay[para2]);//устанавливаем цвет ника
						for(new i=0;i<MAX_PLAYERS;i++)//устанавливаем цвет маркера для всех игроков
						{
							SetPlayerMarkerForPlayer(i, para2, GColorDec[para3]);
						}

						new dopper = 0;
						for(new i = 0; i < MAX_PLAYERS; i++)//подготовка к записи ID банды
						{
							if(para3 > 0 && para3 == idgangsave[i])
							{//если игрок состоит в банде, и ID его банды уже есть в списке, то:
								dopper = 1;
							}
						}
						if(para3 > 0 && dopper == 0)
						{//если игрок состоит в банде, и ID его банды НЕ был найден в списке, то:
							idgangsave[para2] = para3;//записываем в список ID банды игрока
						}
					}
					if(PGang[para2] == para3)
					{
						format(ssss, sizeof(ssss), " Админ %s назначил игроку %s уровень %d в его банде (/edplgangs) .",
						RealName[playerid], RealName[para2], para4);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						if(para4 == 6)//если назначаемый уровень - уровень лидера, то:
						{
							strdel(GHead[para3], 0, 64);//удалить имя старого лидера банды
							strcat(GHead[para3], RealName[para2]);//назначить имя нового лидера банды
						}
						GangSave(para3);//записываем банду

						if(GSkin[para3][para4-1] < 500)
						{//если на уровне установлен скин, то сменить скин приписанному игроку
							SetPVarInt(para2, "PlSkin", GSkin[para3][para4-1]);
							SetPlayerSkin(para2, GetPVarInt(para2, "PlSkin"));
						}
					}
					if(PGang[para2] != para3 && PGang[para2] != -600 && PGang[para2] != 0)
					{
						if(idgangsave[para2] > 0)//если ID банды для записи - активен, то:
						{
							new perloc;
							idgangsave[para2] = 0;//очистка ID банды для записи
							perloc = 0;
							while(perloc < MAX_PLAYERS)//цикл для всех игроков
							{
								if(PGang[para2] == PGang[perloc] && para2 != perloc)
								{//если есть хотя бы один игрок из банды выходящего, то:
									idgangsave[perloc] = PGang[para2];
									break;
								}
								perloc++;
							}
						}

						format(ssss, sizeof(ssss), " Админ %s удалил игрока %s из банды (ид: %d) ,",
						RealName[playerid], RealName[para2], PGang[para2]);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						format(ssss, sizeof(ssss), " приписал игрока %s к банде (ид: %d) ,",
						RealName[para2], para3);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						format(ssss, sizeof(ssss), " и назначил игроку %s уровень %d в этой банде (/edplgangs) .",
						RealName[para2], para4);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						if(para4 == 6)//если назначаемый уровень - уровень лидера, то:
						{
							strdel(GHead[para3], 0, 64);//удалить имя старого лидера банды
							strcat(GHead[para3], RealName[para2]);//назначить имя нового лидера банды
						}
						GPlayers[PGang[para2]]--;//делаем в банде -1 игрок
						GangSave(PGang[para2]);//записываем банду
						GPlayers[para3]++;//делаем в банде +1 игрок
						GangSave(para3);//записываем банду

						if(GSkin[para3][para4-1] < 500)
						{//если на уровне установлен скин, то сменить скин приписанному игроку
							SetPVarInt(para2, "PlSkin", GSkin[para3][para4-1]);
							SetPlayerSkin(para2, GetPVarInt(para2, "PlSkin"));
						}
						ColorPlay[para2] = GColorDec[para3];
						SetPlayerColor(para2, ColorPlay[para2]);//устанавливаем цвет ника
						for(new i=0;i<MAX_PLAYERS;i++)//устанавливаем цвет маркера для всех игроков
						{
							SetPlayerMarkerForPlayer(i, para2, GColorDec[para3]);
						}

						new dopper = 0;
						for(new i = 0; i < MAX_PLAYERS; i++)//подготовка к записи ID банды
						{
							if(para3 > 0 && para3 == idgangsave[i])
							{//если игрок состоит в банде, и ID его банды уже есть в списке, то:
								dopper = 1;
							}
						}
						if(para3 > 0 && dopper == 0)
						{//если игрок состоит в банде, и ID его банды НЕ был найден в списке, то:
							idgangsave[para2] = para3;//записываем в список ID банды игрока
						}
					}
				}
				PGang[para2] = para3;
				GangLvl[para2] = para4;
			}
			if(para1 == 1)
			{
				new file;//чтение аккаунта
				file = ini_openFile(string);
				if(file == INI_OK)
				{
					ini_getInteger(file, "Frac1", data222[0]);
					ini_getInteger(file, "FracLvl1", data222[1]);
					ini_closeFile(file);
				}
				if(data222[0] == para3 && data222[1] == para4)
				{
					SendClientMessage(playerid,COLOR_RED," У выбранного игрока уже установлены назначаемые данные !");
					return 1;
				}
				if(para3 == -600)
				{
					if(data222[0] == 0)
					{
						format(ssss, sizeof(ssss), " Админ %s запретил приглашать аккаунт игрока %s в банду (/edplgangs) .",
						RealName[playerid], akk);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
					}
					if(data222[0] > 0)
					{
						format(ssss, sizeof(ssss), " Админ %s удалил аккаунт игрока %s из банды (ид: %d) ,",
						RealName[playerid], akk, data222[0]);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						format(ssss, sizeof(ssss), " и запретил приглашать аккаунт игрока %s в банду (/edplgangs) .", akk);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						GPlayers[data222[0]]--;//делаем в банде -1 игрок
						GangSave(data222[0]);//записываем банду
					}
				}
				if(para3 == 0)
				{
					if(data222[0] == -600)
					{
						format(ssss, sizeof(ssss), " Админ %s разрешил приглашать аккаунт игрока %s в банду (/edplgangs) .",
						RealName[playerid], akk);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
					}
					if(data222[0] > 0)
					{
						format(ssss, sizeof(ssss), " Админ %s удалил аккаунт игрока %s из банды (ид: %d) ,",
						RealName[playerid], akk, data222[0]);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						format(ssss, sizeof(ssss), " и разрешил приглашать аккаунт игрока %s в банду (/edplgangs) .", akk);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						GPlayers[data222[0]]--;//делаем в банде -1 игрок
						GangSave(data222[0]);//записываем банду
					}
				}
				if(para3 > 0)
				{
					if(data222[0] == -600 || data222[0] == 0)
					{
						format(ssss, sizeof(ssss), " Админ %s приписал аккаунт игрока %s к банде (ид: %d) ,",
						RealName[playerid], akk, para3);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						format(ssss, sizeof(ssss), " и назначил аккаунту игрока %s уровень %d в этой банде (/edplgangs) .",
						akk, para4);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						if(para4 == 6)//если назначаемый уровень - уровень лидера, то:
						{
							strdel(GHead[para3], 0, 64);//удалить имя старого лидера банды
							strcat(GHead[para3], akk);//назначить имя нового лидера банды
						}
						GPlayers[para3]++;//делаем в банде +1 игрок
						GangSave(para3);//записываем банду
					}
					if(data222[0] == para3)
					{
						format(ssss, sizeof(ssss), " Админ %s назначил аккаунту игрока %s уровень %d в его банде (/edplgangs) .",
						RealName[playerid], akk, para4);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						if(para4 == 6)//если назначаемый уровень - уровень лидера, то:
						{
							strdel(GHead[para3], 0, 64);//удалить имя старого лидера банды
							strcat(GHead[para3], akk);//назначить имя нового лидера банды
						}
						GangSave(para3);//записываем банду
					}
					if(data222[0] != para3 && data222[0] != -600 && data222[0] != 0)
					{
						format(ssss, sizeof(ssss), " Админ %s удалил аккаунт игрока %s из банды (ид: %d) ,",
						RealName[playerid], akk, data222[0]);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						format(ssss, sizeof(ssss), " приписал аккаунт игрока %s к банде (ид: %d) ,", akk, para3);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						format(ssss, sizeof(ssss), " и назначил аккаунту игрока %s уровень %d в этой банде (/edplgangs) .",
						akk, para4);
						print(ssss);
						SendAdminMessage(COLOR_LIGHTBLUE, ssss);
						if(para4 == 6)//если назначаемый уровень - уровень лидера, то:
						{
							strdel(GHead[para3], 0, 64);//удалить имя старого лидера банды
							strcat(GHead[para3], akk);//назначить имя нового лидера банды
						}
						GPlayers[data222[0]]--;//делаем в банде -1 игрок
						GangSave(data222[0]);//записываем банду
						GPlayers[para3]++;//делаем в банде +1 игрок
						GangSave(para3);//записываем банду
					}
				}
				data222[0] = para3;
				data222[1] = para4;
				file = ini_openFile(string);//запись изменённого аккаунта
				if(file == INI_OK)
				{
					ini_setInteger(file, "Frac1", data222[0]);
					ini_setInteger(file, "FracLvl1", data222[1]);
					ini_closeFile(file);
				}
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/gmx", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 12)
		{
			format(string, sizeof(string), " Админ %s инициализировал рестарт сервера.", RealName[playerid], playerid);
			print(string);
			SendClientMessageToAll(COLOR_ORANGE, string);
			SendClientMessageToAll(COLOR_ORANGE, " [ВНИМАНИЕ]: Через 30 секунд произойдёт рестарт сервера!");
			restart = SetTimer("RestartS", 30000, 1);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	if(strcmp(cmd, "/rtun", true) == 0)
	{
	    new vehicleid;
		vehicleid = GetPlayerVehicleID(playerid);
		new cartype = GetVehicleModel(vehicleid);
	    AddVehicleComponent(vehicleid, 1083);
		if(cartype == 562) AddVehicleComponent(vehicleid, 1172);
		if(cartype == 560) AddVehicleComponent(vehicleid, 1170);
		if(cartype == 565) AddVehicleComponent(vehicleid, 1152);
		if(cartype == 559) AddVehicleComponent(vehicleid, 1173);
		if(cartype == 561) AddVehicleComponent(vehicleid, 1157);
		if(cartype == 558) AddVehicleComponent(vehicleid, 1165);
		if(cartype == 562) AddVehicleComponent(vehicleid, 1148);
		if(cartype == 560) AddVehicleComponent(vehicleid, 1140);
		if(cartype == 565) AddVehicleComponent(vehicleid, 1151);
		if(cartype == 559) AddVehicleComponent(vehicleid, 1161);
		if(cartype == 561) AddVehicleComponent(vehicleid, 1156);
		if(cartype == 558) AddVehicleComponent(vehicleid, 1167);
		if(cartype == 562) AddVehicleComponent(vehicleid, 1146);
		if(cartype == 560) AddVehicleComponent(vehicleid, 1139);
		if(cartype == 565) AddVehicleComponent(vehicleid, 1050);
		if(cartype == 559) AddVehicleComponent(vehicleid, 1158);
		if(cartype == 561) AddVehicleComponent(vehicleid, 1060);
		if(cartype == 558) AddVehicleComponent(vehicleid, 1163);
		if(cartype == 562)
		{
			AddVehicleComponent(vehicleid, 1041);
			AddVehicleComponent(vehicleid, 1039);
		}
		if(cartype == 560)
		{
			AddVehicleComponent(vehicleid, 1031);
			AddVehicleComponent(vehicleid, 1030);
		}
		if(cartype == 565)
		{
			AddVehicleComponent(vehicleid, 1052);
			AddVehicleComponent(vehicleid, 1048);
		}
		if(cartype == 559)
		{
			AddVehicleComponent(vehicleid, 1070);
			AddVehicleComponent(vehicleid, 1072);
		}
		if(cartype == 561)
		{
			AddVehicleComponent(vehicleid, 1057);
			AddVehicleComponent(vehicleid, 1063);
		}
		if(cartype == 558)
		{
			AddVehicleComponent(vehicleid, 1093);
			AddVehicleComponent(vehicleid, 1095);
		}
		if(cartype == 562) AddVehicleComponent(vehicleid, 1035);
		if(cartype == 560) AddVehicleComponent(vehicleid, 1033);
		if(cartype == 565) AddVehicleComponent(vehicleid, 1053);
		if(cartype == 559) AddVehicleComponent(vehicleid, 1068);
		if(cartype == 561) AddVehicleComponent(vehicleid, 1061);
		if(cartype == 558) AddVehicleComponent(vehicleid, 1091);
		if(cartype == 562) AddVehicleComponent(vehicleid, 1037);
		if(cartype == 560) AddVehicleComponent(vehicleid, 1029);
		if(cartype == 565) AddVehicleComponent(vehicleid, 1045);
		if(cartype == 559) AddVehicleComponent(vehicleid, 1066);
		if(cartype == 561) AddVehicleComponent(vehicleid, 1059);
		if(cartype == 558) AddVehicleComponent(vehicleid, 1089);
	}
	if(strcmp(cmd, "/makeadmin", true) == 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 12 || IsPlayerAdmin(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_GRAD2, " Используйте: /makeadmin [ид игрока/часть ника] [левел(0-13)]");
				SendClientMessage(playerid, COLOR_GRAD2, " ( дополнительно: [сумма] )");
				return 1;
			}
			new para1;
			new level;
			new dopper;
			new summ1, summ2;
			para1 = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			level = strval(tmp);
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				summ1 = 0;
			}
			else
			{
				summ1 = 1;
				summ2 = strval(tmp);
			}
			if(IsPlayerConnected(para1))
			{
				if(gPlayerLogged[para1] == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " Выбранный игрок ещё не залогинился !");
					return 1;
				}
				if(level < 0 || level > 13)
				{
					SendClientMessage(playerid, COLOR_RED, " Уровень админа должен быть от 0 до 13 !");
					return 1;
				}
				dopper = PlayerInfo[para1][pAdmin];
				if(dopper == level)
				{
					SendClientMessage(playerid, COLOR_RED, " У игрока уже есть назначаемый уровень админа !");
					return 1;
				}
				PlayerInfo[para1][pAdmin] = level;//изменение уровня админки
				if(PlayerInfo[para1][pAdmin] == 0)
				{
					PlayerInfo[para1][pAdmshad] = 0;//убрать скрытость
					format(string, sizeof(string), " Админ %s снял админку с игрока %s .", RealName[playerid], RealName[para1]);
					print(string);
					SendAdminMessage(COLOR_RED, string);
					format(string, sizeof(string), " Админ %s снял с Вас админку.", RealName[playerid]);
					SendClientMessage(para1, COLOR_RED, string);
					if(summ1 == 1 && summ2 != GetPlayerMoney(para1))
					{
						SetPVarInt(para1, "MonControl", 1);
						ResetPlayerMoney(para1);//изменение личного счёта
						GivePlayerMoney(para1, summ2);
						format(string, sizeof(string), " Личный счёт игрока %s был изменён на: %d $ .", RealName[para1],
						GetPlayerMoney(para1));
						print(string);
						SendAdminMessage(COLOR_RED, string);
						format(string, sizeof(string), " Ваш личный счёт был изменён на: %d $ .", GetPlayerMoney(para1));
						SendClientMessage(para1, COLOR_RED, string);
					}
				}
				else
				{
					format(string, sizeof(string), " Админ %s дал игроку %s админку %d уровня.", RealName[playerid],
					RealName[para1], level);
					print(string);
					SendAdminMessage(COLOR_YELLOW, string);
				}
				if(PlayerInfo[para1][pAdmin] >= 7 && dopper <= 6)
				{
					PlayerInfo[para1][pAdmlive] = 1;//установить бессмертие
					SendClientMessage(para1, COLOR_LIGHTGREEN, " Бессмертие включено.");
				}
				if(PlayerInfo[para1][pAdmin] <= 6 && dopper >= 7)
				{
					PlayerInfo[para1][pAdmlive] = 0;//убрать бессмертие
					SendClientMessage(para1, COLOR_LIGHTRED, " Бессмертие выключено.");
				}
				if(PlayerInfo[para1][pAdmin] >= 1 && dopper == 0)
				{
					SendClientMessage(para1, COLOR_LIGHTRED, "* Рекомендация: В целях безопасности и защиты своего (АДМИНИСТРАТИВНОГО)");
					SendClientMessage(para1, COLOR_LIGHTRED, "* аккаунта - измените свой пароль. И не используйте пароль от своего");
					SendClientMessage(para1, COLOR_LIGHTRED, "* административного аккаунта на других серверах!!!");
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Такого [ид игрока] на сервере нет !");
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " У Вас нет прав на использование этой команды !");
		}
		return 1;
	}
	return SendClientMessage(playerid, COLOR_WHITE, " ");
}

public OnPlayerEnterVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(!ac_1{playerid} && newstate == PLAYER_STATE_ONFOOT && oldstate == PLAYER_STATE_NONE)
	{
        SetTimerEx("PlayKick", 300, 0, "i", playerid);
        SendClientMessage(playerid, COLOR_RED, "Вы были кикнуты за попытку обхода авторизации");
        return 1;
	}
	if(newstate == PLAYER_STATE_DRIVER)
	{
		PlayerTextDrawShow(playerid, speedometr_PTD[playerid]);
		TextDrawShowForPlayer(playerid, speedometr_TD);

		return 1;
	}
	if(oldstate == PLAYER_STATE_DRIVER)
	{
		TextDrawHideForPlayer(playerid, speedometr_TD);
		PlayerTextDrawHide(playerid, speedometr_PTD[playerid]);

		return 1;
	}
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(Checkpoint[playerid] == 1)
	{
		DisablePlayerCheckpoint(playerid);
		TogglePlayerControllable(playerid,0);
		SendClientMessage(playerid, COLOR_WHITE,"{FF0000}INFO:{FFFFFF} Подождите, идет разгрузка...");
		SetTimerEx("RazgruzFurui",15000,false,"i",playerid);
	}
	else if(Checkpoint[playerid] == 2)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			new zarplata = 400000 + random(50000);
			new string[64];
			format(string, sizeof(string), "{FF0000}INFO:{FFFFFF} За рейс вы получили: {FF0000}$%d", zarplata);
			SendClientMessage(playerid, COLOR_WHITE,string);
			GivePlayerMoney(playerid, zarplata);
			Checkpoint[playerid] = 0;
			DisablePlayerCheckpoint(playerid);
			SetVehicleToRespawn(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
		}
	}
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	StopAudioStreamForPlayer(playerid);//отключаем музыку при входе
	TextDrawShowForPlayer(playerid,Clock);//часы
    	
	SendClientMessage(playerid, COLOR_GREEN, "» {EBEBEB}Приветствуем вас на {D3D3D3}• {FF0000}DAGESTAN MOBILE {D3D3D3}•");
	SendClientMessage(playerid, COLOR_GREEN, "» {EBEBEB}Официальная группа проекта: {FF0000}t.me/MAKHACHKALAmta");
	SendClientMessage(playerid, COLOR_GREEN, "» {EBEBEB}Если заспавнились под картой: {FF0000}/spawn");
	SendClientMessage(playerid, COLOR_GREEN, "» {EBEBEB}Для открытия игрового меню используйте Клавишу: {FF0000}Y {EBEBEB}или {FF0000}/menu");
	SendClientMessage(playerid, COLOR_GREEN, "» {EBEBEB}Помощь по командам — {FF0000}/cmds{EBEBEB} Связь с Администрацией — {FF0000}/report");
	SetSpawnInfo(playerid, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 );
	SpawnPlayer(playerid);
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(pickupid == vid[0])
	{
		new vehid = 562, vehcol1 = -1, vehcol2 = -1, dispz = 0;
		VehicSpawnKK(playerid, vehid, vehcol1, vehcol2, dispz);
		return true;
	}
	if(pickupid == vid[1])
	{
		new vehid = 411, vehcol1 = -1, vehcol2 = -1, dispz = 0;
		VehicSpawnKK(playerid, vehid, vehcol1, vehcol2, dispz);
		return true;
	}
	if(pickupid == vid[2])
	{
		new vehid = 487, vehcol1 = -1, vehcol2 = -1, dispz = 0;
		VehicSpawnKK(playerid, vehid, vehcol1, vehcol2, dispz);
		return true;
	}
	if(pickupid == vid[3])
	{
		new vehid = 481, vehcol1 = -1, vehcol2 = -1, dispz = 0;
		VehicSpawnKK(playerid, vehid, vehcol1, vehcol2, dispz);
		return true;
	}
	if(pickupid == vid[4])
	{
		new vehid = 411, vehcol1 = -1, vehcol2 = -1, dispz = 0;
		VehicSpawnKK(playerid, vehid, vehcol1, vehcol2, dispz);
		return true;
	}
	if(pickupid == vid[5])
	{
		new vehid = 411, vehcol1 = -1, vehcol2 = -1, dispz = 0;
		VehicSpawnKK(playerid, vehid, vehcol1, vehcol2, dispz);
		return true;
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if(pickupid == Pic44[0])//вход в НЛО
		{
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, -8.1075, 0.1189, 45.0078);
			SetPlayerFacingAngle(playerid, 93.1549);
			SetCameraBehindPlayer(playerid);
		}
		if(pickupid == Pic44[1])//выход из НЛО
		{
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 5.7822, 9.2028, 3.1096);
			SetPlayerFacingAngle(playerid, 146.6650);
			SetCameraBehindPlayer(playerid);
		}
		if(pickupid == Pic44[2])//вход в Motel Jefferson
		{
			SetPlayerInterior(playerid, 15);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 2217.2180, -1150.5226, 1025.7969+1);
			SetPlayerFacingAngle(playerid, 270.7929);
			SetCameraBehindPlayer(playerid);
			return 1;
		}
		if(pickupid == Pic44[3])//выход из Motel Jefferson
		{
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 2230.3308, -1159.8536, 25.8170+1);
			SetPlayerFacingAngle(playerid, 90.5809);
			SetCameraBehindPlayer(playerid);
			return 1;
		}
		if(pickupid == Pic44[4])//вход в интерьер полиции LS
		{
			SetPlayerInterior(playerid, 6);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 246.6622, 65.7040, 1003.6406+1);
			SetPlayerFacingAngle(playerid, 358.1500);
			SetCameraBehindPlayer(playerid);
			return 1;
		}
		if(pickupid == Pic44[5])//выход из интерьера полиции LS
		{
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 1552.6047, -1675.6444, 16.1953+1);
			SetPlayerFacingAngle(playerid, 88.3422);
			SetCameraBehindPlayer(playerid);
			return 1;
		}
		if(pickupid == Pic44[6])//вход в Клуб Jizzy
		{
			SetPlayerInterior(playerid, 3);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, -2638.2083, 1405.8302, 906.4609+1);
			SetPlayerFacingAngle(playerid, 71.3634);
			SetCameraBehindPlayer(playerid);
			return 1;
		}
		if(pickupid == Pic44[7])//выход из Клуба Jizzy
		{
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, -2624.7739, 1409.9735, 7.1319+1);
			SetPlayerFacingAngle(playerid, 179.4341);
			SetCameraBehindPlayer(playerid);
			return 1;
		}
		if(pickupid == Pic44[8])//вход в Казино 4 дракона
		{
			SetPlayerInterior(playerid, 10);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 2015.8461, 1017.8807, 996.8750+1);
			SetPlayerFacingAngle(playerid, 89.1678);
			SetCameraBehindPlayer(playerid);
			return 1;
		}
		if(pickupid == Pic44[9])//выход из Казино 4 дракона
		{
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 2022.2078, 1007.8038, 10.8203+1);
			SetPlayerFacingAngle(playerid, 270.7692);
			SetCameraBehindPlayer(playerid);
			return 1;
		}
		if(pickupid == Pic44[10])//вход в Спавн
		{
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 1479.5787, -1803.4825, 13.6563);
			SetPlayerFacingAngle(playerid, 179.4269);
			SetCameraBehindPlayer(playerid);
			return 1;
		}
		if(pickupid == Pic44[11])//выход из Спавн
		{
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 1479.6934, -1792.9886, 13.5469);
			SetPlayerFacingAngle(playerid, 357.4411);
			SetCameraBehindPlayer(playerid);
			return 1;
		}
		if(pickupid == Pic44[12])//вход в дом-бар Чилиад
		{
			SetPlayerInterior(playerid, 11);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 502.2366, -70.9847, 998.7578);
			SetPlayerFacingAngle(playerid, 180.9240);
			SetCameraBehindPlayer(playerid);
		}
		if(pickupid == Pic44[13])//выход из дом-бар Чилиад
		{
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, -2322.2500, -1605.8341, 483.8103);
			SetPlayerFacingAngle(playerid, 205.8397);
			SetCameraBehindPlayer(playerid);
		}
		if(pickupid == Pic44[14])//вход в BMX Stunt
		{
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 2808.0015, 2011.4825, 16.7276);
			SetPlayerFacingAngle(playerid, 178.0061);
			SetCameraBehindPlayer(playerid);
		}
		if(pickupid == Pic44[15])//выход из BMX Stunt
		{
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, 2810.8665, 1983.2255, 10.8203);
			SetPlayerFacingAngle(playerid, 178.5020);
			SetCameraBehindPlayer(playerid);
		}
	}
	return 1;
}
public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	new string[256];
	if(newkeys & 65536)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			if(PlayerInfo[playerid][pPrisonsec] > 0)
			{
				SendClientMessage(playerid, COLOR_RED, " В тюрьме игровое меню не работает.");
				return 1;
			}
			if(dm[playerid] == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Сначало покиньте DM зону.");
				return 1;
			}
			if(admper1[playerid] != 600)
			{
				SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения игровое меню не работает.");
				return 1;
			}
			if(perfrost[playerid] != 600)
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя, Вы заморожены!");
				return 1;
			}
			if(PlayLock1[0][playerid] != 600)
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя, Вы заблокированы!");
				return 1;
			}
			gettime(timedata[0], timedata[1]);
			format(string, sizeof(string), "{FFFFFF}Игровое меню. Точное время: {FF0000}%02d{FFFFFF}:{FF0000}%02d", timedata[0], timedata[1]);
			ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, string, "{FF0000}» Транспортное средство\n{FF0000}» Предметы\
			\n{FF0000}» Оружие\n{FF0000}» Телепорты\n{FF0000}» Аксессуары\n{FF0000}» Действия\n{FF0000}» Радио\n{FF0000}» DeathMatch\
			\n{FF0000}» Платные услуги\n{FF0000}» On-Line Администраторы\n{FF0000}» Правила сервера\n{FF0000}» Система банд", "Выбор", "Отмена");
			dlgcont[playerid] = 4;
		}
	}
    switch (GetPlayerWeapon (playerid))
 	{
 		case 23, 24, 25, 29, 30, 31: //ид наших оружий с которыми запрещаем с+.
 		{
 			if((newkeys == 132)||(newkeys == 4)||newkeys == 4)AntiCPlus[playerid]=GetTickCount();
 			if (((GetTickCount () - AntiCPlus[playerid]) < 1000) && (newkeys == 2))
 			{
 				if(GetPVarInt(playerid,"PlayerCuffed") == 0) ApplyAnimation(playerid,"PED","getup_front",4.0,0,0,1,0,0), ShowPlayerDialog(playerid, 258672, DIALOG_STYLE_MSGBOX,"Анти +С", "На нашем сервере запрещено +С, прекращай давай!", "OK","OK");

 			}
 		}
 	}
	if(newkeys & 512)
	{
		if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
		{
			new regm = 0, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3;//флипнуть
			LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);
		}
	}
	if((newkeys & 4) || ((newkeys & 128) && (oldkeys & 128) && (newkeys & 16)))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			if(IsPlayerInRangeOfPoint(playerid, 100.0, 1479.7732, -1807.1208, 13.7112))
			{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_MSGBOX,"{009900}GREEN ZONE:","{FFFFFF}Внимание. Вы находитесь в {009900}зеленой зоне{FFFFFF}, а значит\
				\nв даном месте {E13E3E}ЗАПРЕЩЕНО {FFFFFF}драться или наносить урон игрокам.","Ок","");
				ClearAnimations(playerid);
			}
			if(IsPlayerInRangeOfPoint(playerid, 100.0, 2139.0, 1139.0, 14.0))
			{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_MSGBOX,"{009900}GREEN ZONE:","{FFFFFF}Внимание. Вы находитесь в {009900}зеленой зоне{FFFFFF}, а значит\
				\nв даном месте {E13E3E}ЗАПРЕЩЕНО {FFFFFF}драться или наносить урон игрокам.","Ок","");
				ClearAnimations(playerid);
			}
			if(IsPlayerInRangeOfPoint(playerid, 100.0, -2419.0, 333.45, 35.18))
			{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_MSGBOX,"{009900}GREEN ZONE:","{FFFFFF}Внимание. Вы находитесь в {009900}зеленой зоне{FFFFFF}, а значит\
				\nв даном месте {E13E3E}ЗАПРЕЩЕНО {FFFFFF}драться или наносить урон игрокам.","Ок","");
				ClearAnimations(playerid);
			}
			if(IsPlayerInRangeOfPoint(playerid, 100.0, 2491.6, -1667.1, 13.3))
			{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_MSGBOX,"{009900}GREEN ZONE:","{FFFFFF}Внимание. Вы находитесь в {009900}зеленой зоне{FFFFFF}, а значит\
				\nв даном месте {E13E3E}ЗАПРЕЩЕНО {FFFFFF}драться или наносить урон игрокам.","Ок","");
				ClearAnimations(playerid);
			}
			if(IsPlayerInRangeOfPoint(playerid, 350.0, 1531.6, -1665.5, 13.3))
			{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_MSGBOX,"{009900}GREEN ZONE:","{FFFFFF}Внимание. Вы находитесь в {009900}зеленой зоне{FFFFFF}, а значит\
				\nв даном месте {E13E3E}ЗАПРЕЩЕНО {FFFFFF}драться или наносить урон игрокам.","Ок","");
				ClearAnimations(playerid);
			}
			if(IsPlayerInRangeOfPoint(playerid, 350.0, -49.5, -300.9, 5.4))
			{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_MSGBOX,"{009900}GREEN ZONE:","{FFFFFF}Внимание. Вы находитесь в {009900}зеленой зоне{FFFFFF}, а значит\
				\nв даном месте {E13E3E}ЗАПРЕЩЕНО {FFFFFF}драться или наносить урон игрокам.","Ок","");
				ClearAnimations(playerid);
			}
			if(IsPlayerInRangeOfPoint(playerid, 350.0, -1323.9, -185.8, 14.1))
			{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_MSGBOX,"{009900}GREEN ZONE:","{FFFFFF}Внимание. Вы находитесь в {009900}зеленой зоне{FFFFFF}, а значит\
				\nв даном месте {E13E3E}ЗАПРЕЩЕНО {FFFFFF}драться или наносить урон игрокам.","Ок","");
				ClearAnimations(playerid);
			}
			if(IsPlayerInRangeOfPoint(playerid, 350.0, -1979.3, 883.8, 45.2))
			{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_MSGBOX,"{009900}GREEN ZONE:","{FFFFFF}Внимание. Вы находитесь в {009900}зеленой зоне{FFFFFF}, а значит\
				\nв даном месте {E13E3E}ЗАПРЕЩЕНО {FFFFFF}драться или наносить урон игрокам.","Ок","");
				ClearAnimations(playerid);
			}
			if(IsPlayerInRangeOfPoint(playerid, 350.0, -329.7, 1524.5, 75.3))
			{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_MSGBOX,"{009900}GREEN ZONE:","{FFFFFF}Внимание. Вы находитесь в {009900}зеленой зоне{FFFFFF}, а значит\
				\nв даном месте {E13E3E}ЗАПРЕЩЕНО {FFFFFF}драться или наносить урон игрокам.","Ок","");
				ClearAnimations(playerid);
			}
			if(IsPlayerInRangeOfPoint(playerid, 350.0, 2169.4, 1679.1, 10.8))
			{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_MSGBOX,"{009900}GREEN ZONE:","{FFFFFF}Внимание. Вы находитесь в {009900}зеленой зоне{FFFFFF}, а значит\
				\nв даном месте {E13E3E}ЗАПРЕЩЕНО {FFFFFF}драться или наносить урон игрокам.","Ок","");
				ClearAnimations(playerid);
			}
			if(IsPlayerInRangeOfPoint(playerid, 350.0, -2322.5, -1612.0, 483.7))
			{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_MSGBOX,"{009900}GREEN ZONE:","{FFFFFF}Внимание. Вы находитесь в {009900}зеленой зоне{FFFFFF}, а значит\
				\nв даном месте {E13E3E}ЗАПРЕЩЕНО {FFFFFF}драться или наносить урон игрокам.","Ок","");
				ClearAnimations(playerid);
			}
			if(IsPlayerInRangeOfPoint(playerid, 350.0, 190.1, 1911.2, 17.6))
			{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_MSGBOX,"{009900}GREEN ZONE:","{FFFFFF}Внимание. Вы находитесь в {009900}зеленой зоне{FFFFFF}, а значит\
				\nв даном месте {E13E3E}ЗАПРЕЩЕНО {FFFFFF}драться или наносить урон игрокам.","Ок","");
				ClearAnimations(playerid);
			}
			if(IsPlayerInRangeOfPoint(playerid, 350.0, -2377.5, 1548.7, 31.8))
			{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_MSGBOX,"{009900}GREEN ZONE:","{FFFFFF}Внимание. Вы находитесь в {009900}зеленой зоне{FFFFFF}, а значит\
				\nв даном месте {E13E3E}ЗАПРЕЩЕНО {FFFFFF}драться или наносить урон игрокам.","Ок","");
				ClearAnimations(playerid);
			}
			if(IsPlayerInRangeOfPoint(playerid, 350.0, -1662.3, 883.1, 136.0))
			{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_MSGBOX,"{009900}GREEN ZONE:","{FFFFFF}Внимание. Вы находитесь в {009900}зеленой зоне{FFFFFF}, а значит\
				\nв даном месте {E13E3E}ЗАПРЕЩЕНО {FFFFFF}драться или наносить урон игрокам.","Ок","");
				ClearAnimations(playerid);
			}
			if(IsPlayerInRangeOfPoint(playerid, 350.0, -1813.5, 541.6, 234.8))
			{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_MSGBOX,"{009900}GREEN ZONE:","{FFFFFF}Внимание. Вы находитесь в {009900}зеленой зоне{FFFFFF}, а значит\
				\nв даном месте {E13E3E}ЗАПРЕЩЕНО {FFFFFF}драться или наносить урон игрокам.","Ок","");
				ClearAnimations(playerid);
			}
			if(IsPlayerInRangeOfPoint(playerid, 350.0, 132.7, -67.6, 1.5))
			{
				ShowPlayerDialog(playerid,2,DIALOG_STYLE_MSGBOX,"{009900}GREEN ZONE:","{FFFFFF}Внимание. Вы находитесь в {009900}зеленой зоне{FFFFFF}, а значит\
				\nв даном месте {E13E3E}ЗАПРЕЩЕНО {FFFFFF}драться или наносить урон игрокам.","Ок","");
				ClearAnimations(playerid);
			}
	    }
	}
	if(newkeys & 65536)
	{
		if(PlayerInfo[playerid][pPrisonsec] > 0)
		{
			SendClientMessage(playerid, COLOR_RED, " В тюрьме игровое меню не работает.");
			return 1;
		}
		if(dm[playerid] == 1)
		{
			SendClientMessage(playerid, COLOR_RED, " Сначало покиньте DM зону.");
			return 1;
		}
		if(admper1[playerid] != 600)
		{
			SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения игровое меню не работает.");
			return 1;
		}
		if(perfrost[playerid] != 600)
		{
			SendClientMessage(playerid, COLOR_RED, " Нельзя, Вы заморожены!");
			return 1;
		}
		if(PlayLock1[0][playerid] != 600)
		{
			SendClientMessage(playerid, COLOR_RED, " Нельзя, Вы заблокированы!");
			return 1;
		}
		gettime(timedata[0], timedata[1]);
		format(string, sizeof(string), "{FFFFFF}Игровое меню. Точное время: {FF0000}%02d{FFFFFF}:{FF0000}%02d", timedata[0], timedata[1]);
		ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, string, "{FF0000}» Транспортное средство\n{FF0000}» Предметы\
		\n{FF0000}» Оружие\n{FF0000}» Телепорты\n{FF0000}» Аксессуары\n{FF0000}» Действия\n{FF0000}» Радио\n{FF0000}» DeathMatch\
		\n{FF0000}» Платные услуги\n{FF0000}» On-Line Администраторы\n{FF0000}» Правила сервера\n{FF0000}» Система банд", "Выбор", "Отмена");
		dlgcont[playerid] = 4;
	}
	if(newkeys == 1 || newkeys == 9 || newkeys == 33 && oldkeys != 1 || oldkeys != 9 || oldkeys != 33)
	{
		new car = GetPlayerVehicleID(playerid);
		new Model5 = GetVehicleModel(car);
		switch(Model5)
		{
		case 446,432,448,452,424,453,454,461,462,463,468,471,430,472,449,473,481,484,493,495,509,510,521,538,
			522,523,532,537,570,581,586,590,569,595,604,611: return 1;
		}
  	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	NETafkPl[playerid][0] = 0;//обнулить контрольную переменную AFK
	if(GetPlayerState(playerid) == 2)
	{
		//SetSpeedDel(playerid);
		SetSpeedPok(playerid);
	}
	return 1;
}

stock SpeedVehicle(playerid)
{
	new Float:ST[4];
	if(IsPlayerInAnyVehicle(playerid))
	GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
	else GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
	ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 253.3;
	return floatround(ST[3]);
}

stock SetSpeedPok(playerid)
{
	new string[5];

	format(string, sizeof string, "%03i", SpeedVehicle(playerid));
	PlayerTextDrawSetString(playerid, speedometr_PTD[playerid], string);

	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	dialogcon[playerid]++;//прибавляем 1 к контрольной переменной диалогов
	new string[256], strdln[5000];
	if(dialogid == 0)
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(!response)
		{
			format(string, sizeof(string), "* Игрок %s [%d] был кикнут - отказ от регистрации !", RealName[playerid], playerid);
			print(string);
			SendClientMessageToAll(COLOR_LIGHTRED, string);
			SetTimerEx("PlayKick", 300, 0, "i", playerid);
		}
		else
		{
			if(strlen(inputtext) < 3 || strlen(inputtext) > 20)
			{
				SendClientMessage(playerid, COLOR_RED, " Длина пароля должна быть от 3 до 20 символов!");
				ShowPlayerDialog(playerid, 0, DIALOG_STYLE_INPUT, "Регистрация", "{02ED56}Добро пожаловать на {FF0000}DAGESTAN MOBILE Mobile{02ED56}.\
				\n{02ED56}Вы не {E60000}зарегистрированы {02ED56}на нашем сервере.\n\nДля продолжения, придумайте пароль.", "Войти", "Отмена");
				dlgcont[playerid] = 0;
				return 1;
			}
			if(PassControl(inputtext) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " В пароле можно использовать ТОЛЬКО латинские");
				SendClientMessage(playerid, COLOR_RED, " символы: от a до z , от A до Z , и цифры от 0 до 9 !");
				ShowPlayerDialog(playerid, 0, DIALOG_STYLE_INPUT, "Регистрация", "{02ED56}Добро пожаловать на {FF0000}DAGESTAN MOBILE Mobile{02ED56}.\
				\n{02ED56}Вы не {E60000}зарегистрированы {02ED56}на нашем сервере.\n\nДля продолжения, придумайте пароль.", "Войти", "Отмена");
				dlgcont[playerid] = 0;
				return 1;
			}
			if(gPlayerAccount[playerid] == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Этот ник уже зарегистрирован!");
				return 1;
			}
			format(string, sizeof(string), "players/%s.ini", RealName[playerid]);
			if(fexist(string))
			{
				SendClientMessage(playerid, COLOR_RED, " Этот ник уже зарегистрирован!");
				return 1;
			}
			OnPlayerRegister(playerid, inputtext);
		}
		return 1;
	}
	if(dialogid == 1)
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(!response)
		{
			format(string, sizeof(string), "* Игрок %s[%d] был кикнут - спавн без логирования!", RealName[playerid], playerid);
			print(string);
			SendClientMessageToAll(COLOR_LIGHTRED, string);
			SetTimerEx("PlayKick", 300, 0, "i", playerid);
		}
		else
		{
			if(strlen(inputtext) < 3 || strlen(inputtext) > 20)
			{
				SendClientMessage(playerid, COLOR_RED, " Длина пароля должна быть от 3 до 20 символов");
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_INPUT, "Вход в аккаунт","{02ED56}Добро пожаловать на {FF0000}DAGESTAN MOBILE Mobile{02ED56}.\
				\n{02ED56}Вы уже {00B000}зарегистрированы {02ED56}на нашем сервере.\n\nЧтобы войти, введите свой пароль.", "Войти", "Отмена");
				dlgcont[playerid] = 1;
				return 1;
			}
			if(PassControl(inputtext) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " В пароле можно использовать ТОЛЬКО латинские");
				SendClientMessage(playerid, COLOR_RED, " символы: от a до z , от A до Z , и цифры от 0 до 9");
				ShowPlayerDialog(playerid, 1, DIALOG_STYLE_INPUT, "Вход в аккаунт","{02ED56}Добро пожаловать на {FF0000}DAGESTAN MOBILE Mobile{02ED56}.\
				\n{02ED56}Вы уже {00B000}зарегистрированы {02ED56}на нашем сервере.\n\nЧтобы войти, введите свой пароль.", "Войти", "Отмена");
				dlgcont[playerid] = 1;
				return 1;
			}
			if (gPlayerLogged[playerid] == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Этот ник уже залогинился!");
				return 1;
			}
			new tmppass[64];
			strmid(tmppass, inputtext, 0, strlen(inputtext), 255);
			OnPlayerLogin(playerid, tmppass);
		}
		return 1;
	}
	if(dialogid == 605)
	{
	    if(response)
		{
		    if(strlen(inputtext) > 128 || strlen(inputtext) < 2) return SendClientMessage(playerid,COLOR_GREY, "Максимальная длина репорта - 128 символов, минимальная - 2 символа");
		    new stringer[365];
			format(stringer, sizeof(stringer), "[Репорт от %s (%d)] {FFFFFF}%s", RealName[playerid], playerid, inputtext);
			SendAdminMessage(COLOR_YELLOW, stringer);
			new stringg[365];
			format(stringg, sizeof(stringg), "[Ваш репорт] {FFFFFF}%s", inputtext);
			SendClientMessage(playerid, COLOR_YELLOW, stringg);
			SetPVarInt(playerid, "antireportflood", gettime()+30);
			return 0;
		}
	}
	if(dialogid == 2)
	{
        if(response)
		{
			switch(listitem)
	  		{
	    		case 0: SetPlayerAttachedObject(playerid, 1, 1210, 6, 0.259532, -0.043030, -0.009978, 85.185333, 271.380615, 253.650283, 1.000000, 1.000000, 1.000000 );
				case 1: SetPlayerAttachedObject(playerid, 1, 18637, 4, 0.3, 0, 0, 0, 170, 270, 1, 1, 1);
				case 2: SetPlayerAttachedObject(playerid, 2, 2226, 5, 0.3089, 0.0089, 0.0380, -20.29, -99.49, 0.00, 1.00, 1.00, 1.00);
				case 3: SetPlayerAttachedObject(playerid, 3, 1550, 15, 0.016491, 0.205742, -0.208498, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 );
				case 4: SetPlayerAttachedObject(playerid, 4, 19078, 1, 0.329150, -0.072101, 0.156082, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
				case 5:
					{
	                    RemovePlayerAttachedObject(playerid, 1);
					 	RemovePlayerAttachedObject(playerid, 2);
					 	RemovePlayerAttachedObject(playerid, 3);
					 	RemovePlayerAttachedObject(playerid, 4);
					 	RemovePlayerAttachedObject(playerid, 6);
						SetPlayerAttachedObject(playerid, 5, 19078, 1, -1.097527, -0.348305, -0.008029, 0.000000, 0.000000, 0.000000, 8.073966, 8.073966, 8.073966);
					}
				case 6:
					{
	                    RemovePlayerAttachedObject(playerid, 1);
					 	RemovePlayerAttachedObject(playerid, 2);
					 	RemovePlayerAttachedObject(playerid, 3);
					 	RemovePlayerAttachedObject(playerid, 4);
					 	RemovePlayerAttachedObject(playerid, 6);
						SetPlayerAttachedObject(playerid, 5, 1371, 1, 0.037538, 0.000000, -0.020199, 350.928314, 89.107200, 180.974227, 1.000000, 1.000000, 1.000000 );
					}
				case 7: SetPlayerAttachedObject(playerid, 6, 19270, 2, 0.111052, 0.021643, -0.000846, 92.280899, 92.752510, 358.071044, 1.200000, 1.283168, 1.200000);
				case 8: SetPlayerAttachedObject(playerid, 6, 3528, 2, 0.111052, 0.021643, -0.000846, 92.280899, 92.752510, 358.071044, 0.100000, 0.100000, 0.100000);
				case 9: SetPlayerAttachedObject(playerid, 6,19137,2,0.100000,0.000000,0.000000,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000);
				case 10: SetPlayerAttachedObject(playerid, 1, 356, 6, 0.013610, -0.021393, -0.144862, 2.354303, 354.413848, 0.219168, 3.034477, 3.000000, 3.000000);
				case 11:
					{
					 	RemovePlayerAttachedObject(playerid, 1);
					 	RemovePlayerAttachedObject(playerid, 2);
					 	RemovePlayerAttachedObject(playerid, 3);
					 	RemovePlayerAttachedObject(playerid, 4);
					 	RemovePlayerAttachedObject(playerid, 5);
					 	RemovePlayerAttachedObject(playerid, 6);
					}
	 		}
		}
		return 1;
	}
	if(dialogid == 3)
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(!response)
		{
			format(string, sizeof(string), "* Игрок %s[%d] был кикнут - спавн без логирования.", RealName[playerid], playerid);
			print(string);
			SendClientMessageToAll(COLOR_LIGHTRED, string);
			SetTimerEx("PlayKick", 300, 0, "i", playerid);
		}
		else
		{
			if(strlen(inputtext) < 3 || strlen(inputtext) > 20)
			{
				SendClientMessage(playerid, COLOR_RED, " Длина пароля должна быть от 3 до 20 символов!");
				format(string,sizeof(string), "{E60000}Вы ввели неправильный пароль!\n\n{02ED56}Аккаунт: {FF0000}%s\n\n{02ED56}Попробуйте еще раз:",
				RealName[playerid]);
				ShowPlayerDialog(playerid, 3, DIALOG_STYLE_INPUT, "Вход в аккаунт", string, "Вход", "Отмена");
				dlgcont[playerid] = 3;
				return 1;
			}
			if(PassControl(inputtext) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " В пароле можно использовать ТОЛЬКО латинские");
				SendClientMessage(playerid, COLOR_RED, " символы: от a до z , от A до Z , и цифры от 0 до 9");
				format(string,sizeof(string), "{E60000}Вы ввели неправильный пароль!\n\n{02ED56}Аккаунт: {FF0000}%s\n\n{02ED56}Попробуйте еще раз:",
				RealName[playerid]);
				ShowPlayerDialog(playerid, 3, DIALOG_STYLE_INPUT, "Вход в аккаунт", string, "Вход", "Отмена");
				dlgcont[playerid] = 3;
				return 1;
			}
			if (gPlayerLogged[playerid] == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Этот ник уже залогинился!");
				return 1;
			}
			new tmppass[64];
			strmid(tmppass, inputtext, 0, strlen(inputtext), 255);
			OnPlayerLogin(playerid, tmppass);
		}
		return 1;
	}
	if(dialogid == 4)//Главное меню
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(listitem == 0)
			{
				ShowPlayerDialog(playerid, 10, DIALOG_STYLE_LIST, "Транспортное средство", "{FF0000}Тип транспорта\
				\n{FFFFFF}Тюнинг\n{FF0000}Отключить / включить автоматический ремонт\n{FFFFFF}Уничтожить транспорт\
				\n{FF0000}Флипнуть (Клавиша: 2)", "Выбор", "Отмена");
				dlgcont[playerid] = 10;
				return 1;
			}
			if(listitem == 1)
			{
				ShowPlayerDialog(playerid, 45, DIALOG_STYLE_LIST, "Предметы", "Кастет\nКлюшка для гольфа\
				\nРезиновая дубинка\nНож\nБейсбольная бита\nЛопата\nКий\nКатана\nБензопила\nБаллончик с краской\
				\nОгнетушитель\nФотоаппарат\nБукет цветов\nТрость\nОчки ночного видения\
				\nИнфракрасные очки\nПарашют\nУбрать предметы", "OK", "Отмена");
				dlgcont[playerid] = 45;
				return 1;
			}
			if(listitem == 2)
			{
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 3)
			{
				format(strdln, sizeof(strdln), "{FF0000}KTA CITY #1\n{FFFFFF}KTA CITY #2 - В разработке еще\n{FF0000}Гоночная трасса\
				\n{FFFFFF}Los-Santos\n{FF0000}Работа Дальнобойщика\n{FFFFFF}San-Fierro\n{FF0000}Публичный дом\
				\n{FFFFFF}Las-Venturas\n{FF0000}Аэропорт SF\n{FFFFFF}Драг SF\n{FF0000}Заправка ESPO\
				\n{FFFFFF}Сумо\n{FF0000}Заброшенный Аэропорт\n{FFFFFF}Кавказские Горы");
				format(strdln, sizeof(strdln), "%s\n{FF0000}Автошкола\n{FFFFFF}Каспийское Море\n{FF0000}Драг LS\
				\n{FFFFFF}не  работает\n{FF0000}Аэропорт LV\n{FFFFFF}Дрифт SF\n{FF0000}не  работает\
				\n{FFFFFF}не  работает\n{FF0000}Клуб Джиззи\n{FFFFFF}Казино\n{FF0000}Спринт\n{FFFFFF}Дрифт LV\
				\n{FF0000}Акушинка №2\n{FFFFFF}Гаражи LV\n{FF0000}Парковка LV", strdln);
				format(strdln, sizeof(strdln), "%s\n{FFFFFF}не  работает\n{FF0000}BMX Stunt\n{FFFFFF}Акушинка №1-Грозный\
				\n{FF0000}не  работает\n{FFFFFF}Cobra Gym\n{FF0000}Аэропорт LS\n{FFFFFF}не  работает\n{FF0000}Корабль\
				\n{FFFFFF}не  работает\n{FF0000}не  работает\n{FFFFFF}не  работает\n{FF0000}не  работает\
				\n{FFFFFF}не  работает\n{FF0000}Vice Stadium\n{FFFFFF}Fun Cars", strdln);
				ShowPlayerDialog(playerid, 11, DIALOG_STYLE_LIST, "Телепорты", strdln, "OK", "Отмена");
				dlgcont[playerid] = 11;
				return 1;
			}
			if(listitem == 4)
			{
				format(strdln, sizeof(strdln), "{FFFFFF}Кейс в руке\nЩит в руке\nМагнитофон в руке\
				\nМешок денег на спине\nПопугай на плечо\nКостюм попугая\nКостюм бегемота\
				\nОгонек на голову\nМаска дракона\nШляпа курицы\nБольшой М4 в руку\nУдалить все объекты", strdln);
				ShowPlayerDialog(playerid, 2, DIALOG_STYLE_LIST, "Аксессуары", strdln, "OK", "Отмена");
				dlgcont[playerid] = 2;
				return 1;
			}
			if(listitem == 5)
			{
				ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Действия", "Пополнить жизнь\nАнимации\nСменить цвет ника\
				\nСменить скин\nСменить время\nСменить стиль боя\nСамоубийство\
				\nПросмотреть собственную статистику", "Выбор", "Отмена");
				dlgcont[playerid] = 12;
				return 1;
			}
			if(listitem == 6)
			{
				format(strdln, sizeof(strdln), "{FF0000}Выключить радио\n%s\n%s\n%s\n%s\n%s",
				NMRadio[1], NMRadio[2], NMRadio[3], NMRadio[4], NMRadio[5]);
				ShowPlayerDialog(playerid, 15, DIALOG_STYLE_LIST, "{91EF03}Радио", strdln, "OK", "Отмена");
				dlgcont[playerid] = 15;
				return 1;
			}
			if(listitem == 7)
			{
				format(strdln, sizeof(strdln), "{FF0000}/dm {999999}- Зайти на DM зону.\n{FF0000}/exit {999999}- Покинуть DM зону.");
				ShowPlayerDialog(playerid, 2, DIALOG_STYLE_MSGBOX, "DeathMatch",strdln, "OK", "");
				return 1;
			}
			if(listitem == 8)
			{
				format(strdln, sizeof(strdln), "Купить админку/score можно у основателя! TG: {FF0000}@DonateKTAMTAbot");
				ShowPlayerDialog(playerid, 2, DIALOG_STYLE_MSGBOX, "Платные услуги",strdln, "OK", "");
				return 1;
			}
			if(listitem == 9)//On-Line Администраторы
			{
				AdminsLvl(playerid);
				return 1;
			}
			if(listitem == 10)
			{
				format(strdln, sizeof(strdln), "Наводить суету!");
				ShowPlayerDialog(playerid, 2, DIALOG_STYLE_MSGBOX, "Правила сервера", strdln, "OK", "");
				return 1;
			}
			if(listitem == 11)//Gangs system
			{
				ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_LIST, "Система банд", "Создать банду\nУдалить банду\
				\nНазначить скины\nНазначить место спавна\nОтменить спавн банды\nНазначить уровень\nПригласить в банду\
				\nВыгнать из банды\nОткл. / вкл. разрешение приглашать Вас в банду\nИзменить название банды\
				\nИзменить цвет банды\nУйти из банды\nИнформация о банде", "Выбор", "Отмена");
				dlgcont[playerid] = 1001;
			}
		}
		return 1;
	}
	if(dialogid == 5)//Админ-меню
	{
		if(PlayerInfo[playerid][pAdmin] == 0)
		{
			dialogadm[playerid] = 1;//устанавливаем контрольную переменную админ-меню
			return 1;
		}
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(listitem == 0)//тп к нему
			{
				if(PlayerInfo[playerid][pAdmin] < 1)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "У Вас нет прав на использование этой команды !", "OK", "");
					return 1;
				}
				if(playerid == player[playerid])
				{
					ShowPlayerDialog(playerid, 2, 0, "Информация.", "Попытка ТП к самому себе !", "OK", "");
					return 1;
				}
				if(PlayerInfo[playerid][pPrisonsec] > 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, Вы сидите в тюрьме !", "OK", "");
					return 1;
				}
				if(perfrost[playerid] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, Вы заморожены !", "OK", "");
					return 1;
				}
				if(PlayLock1[0][playerid] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, Вы заблокированы !", "OK", "");
					return 1;
				}
				if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
					return 1;
				}
				if(admper1[playerid] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, Вы заняты наблюдением !", "OK", "");
					return 1;
				}
				if(PlayerInfo[playerid][pAdmin] >= 1 && admper1[player[playerid]] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "{FF0000}Информация.", "{FF0000}Игрок, к кому Вы сейчас ТП - занят наблюдением !",
					"OK", "");
				}
				if(playspa[player[playerid]] == 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок ещё не заспавнился !", "OK", "");
					return 1;
				}
				format(string, 256, " Админ %s телепортировался к игроку %s", RealName[playerid], RealName[player[playerid]]);
				print(string);
				new Float:PosX, Float:PosY, Float:PosZ;
				new nmod = GetVehicleModel(GetPlayerVehicleID(playerid));
				if(nmod == 538 || nmod == 537)
				{//если игрок в поезде, то высадить игрока из поезда
					GetPlayerPos(playerid, PosX, PosY, PosZ);
					SetPlayerPos(playerid, PosX+3, PosY+3, PosZ+5);
				}
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3;
					per1 = GetPlayerInterior(player[playerid]);
					per2 = GetPlayerVirtualWorld(player[playerid]);
					GetPlayerPos(player[playerid], PosX, PosY, PosZ);
					cor1 = PosX;
					cor2 = PosY+1;
					cor3 = PosZ+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, GetPlayerInterior(player[playerid]));
					SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(player[playerid]));
					GetPlayerPos(player[playerid], PosX, PosY, PosZ);
					SetPlayerPos(playerid, PosX, PosY+1, PosZ+1);
				}
				return 1;
			}
			if(listitem == 1)//тп его к себе
			{
				if(PlayerInfo[playerid][pAdmin] < 1)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "У Вас нет прав на использование этой команды !", "OK", "");
					return 1;
				}
				if(playerid == player[playerid])
				{
					ShowPlayerDialog(playerid, 2, 0, "Информация.", "Попытка ТП игрока к самому себе !", "OK", "");
					return 1;
				}
				if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.","Выбранный игрок вышел с сервера !", "OK", "");
					return 1;
				}
				if(PlayerInfo[playerid][pAdmin] <= 6 && PlayerInfo[player[playerid]][pAdmin] >= 7)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Вы не можете этого сделать,\nт.к. уровень админки игрока выше Вашего !",
					"OK", "");
					return 1;
				}
				if(PlayerInfo[player[playerid]][pPrisonsec] > 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок сидит в тюрьме !", "OK", "");
					return 1;
				}
				if(perfrost[player[playerid]] != 600 && perfrost[player[playerid]] != playerid)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок заморожен !\n(+ был заморожен НЕ Вами !)",
					"OK", "");
					return 1;
				}
				if(PlayLock1[0][player[playerid]] != 600 && PlayLock1[0][player[playerid]] != playerid)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок заблокирован !\n(+ был заблокирован НЕ Вами !)",
					"OK", "");
					return 1;
				}
				if(admper1[playerid] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, Вы заняты наблюдением !", "OK", "");
					return 1;
				}
				if(admper1[player[playerid]] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок занят наблюдением !", "OK", "");
					return 1;
				}
				if(playspa[player[playerid]] == 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.","Нельзя, выбранный игрок ещё не заспавнился !", "OK", "");
					return 1;
				}
				format(string, 256, " Админ %s телепортировал игрока %s к себе.", RealName[playerid], RealName[player[playerid]]);
				print(string);
				SendAdminMessage(COLOR_RED, string);
				if(PlayerInfo[player[playerid]][pAdmin] == 0)
				{
					format(string, 256, " Админ %s телепортировал Вас к себе.", RealName[playerid]);
					SendClientMessage(player[playerid], COLOR_RED, string);
				}
				new Float:PosX, Float:PosY, Float:PosZ;
				new nmod = GetVehicleModel(GetPlayerVehicleID(player[playerid]));
				if(nmod == 538 || nmod == 537)
				{//если игрок в поезде, то высадить игрока из поезда
					GetPlayerPos(player[playerid], PosX, PosY, PosZ);
					SetPlayerPos(player[playerid], PosX+3, PosY+3, PosZ+5);
				}
				if(PlayLock1[0][player[playerid]] != 600 && PlayLock1[0][player[playerid]] == playerid)
				{//если игрок заблокирован, то ТП заблокированного игрока
					PlayLock1[1][player[playerid]] = GetPlayerInterior(playerid);//изменение интерьера блокировки
					PlayLock1[2][player[playerid]] = GetPlayerVirtualWorld(playerid);//изменение виртуального мира блокировки
					GetPlayerPos(playerid, PlayLock2[0][player[playerid]], PlayLock2[1][player[playerid]],
					PlayLock2[2][player[playerid]]);//изменение координат блокировки
					PlayLock2[1][player[playerid]] = PlayLock2[1][player[playerid]] + 1;
				}
				else//иначе - ТП НЕ заблокированного игрока
				{
					if(GetPlayerState(player[playerid]) == 2)//если игрок на месте водителя, то:
					{
						new regm = 1, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3;
						per1 = GetPlayerInterior(playerid);
						per2 = GetPlayerVirtualWorld(playerid);
						GetPlayerPos(playerid, PosX, PosY, PosZ);
						cor1 = PosX;
						cor2 = PosY+1;
						cor3 = PosZ+1;
						LogTelPort(player[playerid], regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);
					}
					else//иначе:
					{
						SetPlayerInterior(player[playerid], GetPlayerInterior(playerid));
						SetPlayerVirtualWorld(player[playerid], GetPlayerVirtualWorld(playerid));
						GetPlayerPos(playerid, PosX, PosY, PosZ);
						SetPlayerPos(player[playerid], PosX, PosY+1, PosZ+1);
					}
				}
				return 1;
			}
			if(listitem == 2)//наблюдать
			{
				if(PlayerInfo[playerid][pAdmin] < 1)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "У Вас нет прав на использование этой команды !", "OK", "");
					return 1;
				}
				if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
					return 1;
				}
				if(PlayerInfo[playerid][pAdmin] <= 6 && PlayerInfo[player[playerid]][pAdmin] >= 7)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Вы не можете этого сделать,\nт.к. уровень админки игрока выше Вашего !",
					"OK", "");
					return 1;
				}
				if(PlayerInfo[playerid][pPrisonsec] > 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, Вы сидите в тюрьме !", "OK", "");
					return 1;
				}
				if(perfrost[playerid] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, Вы заморожены !", "OK", "");
					return 1;
				}
				if(PlayLock1[0][playerid] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, Вы заблокированы !", "OK", "");
					return 1;
				}
				if(playspa[player[playerid]] == 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок ещё не заспавнился !", "OK", "");
					return 1;
				}
				if(admper1[player[playerid]] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок занят наблюдением !", "OK", "");
					return 1;
				}
				if(playerid == player[playerid])//если админ наблюдает за собой, то:
				{
					ShowPlayerDialog(playerid, 2, 0, "Информация.", "Снимите наблюдение, и будете наблюдать за собой !", "OK", "");
					return 1;
				}
				else
				{
					format(string, 256, " Админ %s включил наблюдение за игроком %s", RealName[playerid], RealName[player[playerid]]);
					print(string);
					admper6[playerid] = 0;//обнуляем отметку о переключении наблюдения
					if(admper1[playerid] == 600)//если админ только включил наблюдение, то:
					{
						if (GetPlayerState(playerid) == 1)//если админ НЕ в транспорте, то:
						{
							admper4[playerid] = 0;//не будем изменять координаты при "обратном спавне"
						}
						else
						{
							admper4[playerid] = 3;//иначе, прибавим 3 к координатам X, Y, и 5 к Z при "обратном спавне"
						}
						TogglePlayerSpectating(playerid, 1);//разрешить наблюдение для админа
						admper1[playerid] = player[playerid];//установить статус включенного наблюдения
						admper2[playerid] = GetPlayerInterior(playerid);//запомнить интерьер админа
						admper3[playerid] = GetPlayerVirtualWorld(playerid);//запомнить мир админа
						GetPlayerPos(playerid, TelSpec[playerid][0], TelSpec[playerid][1], TelSpec[playerid][2]);//запомнить координаты админа
						mapiconid[playerid] = CreateDynamicMapIcon(TelSpec[playerid][0], TelSpec[playerid][1], TelSpec[playerid][2],
						0, ColorPlay[playerid], admper3[playerid], admper2[playerid], -1, 60000);//создать и запомнить мап иконку на месте возврата админа
						SetPlayerInterior(playerid, GetPlayerInterior(player[playerid]));//установить интерьер админу
						SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(player[playerid]));//установить мир админу
						if(GetPlayerVehicleID(player[playerid]) != 0)//если игрок в транспорте, то:
						{
							PlayerSpectateVehicle(playerid, GetPlayerVehicleID(player[playerid]), SPECTATE_MODE_NORMAL);
							admper5[playerid] = 1;//наблюдаем за транспортом
						}
						else
						{
							PlayerSpectatePlayer(playerid, player[playerid], SPECTATE_MODE_NORMAL);//включить наблюдение
							admper5[playerid] = 0;//наблюдаем за игроком
						}
					}
					else
					{
						admper1[playerid] = player[playerid];//поменять статус включенного наблюдения
						SetPlayerInterior(playerid, GetPlayerInterior(player[playerid]));//установить интерьер админу
						SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(player[playerid]));//установить мир админу
						if(GetPlayerVehicleID(player[playerid]) != 0)//если игрок в транспорте, то:
						{
							PlayerSpectateVehicle(playerid, GetPlayerVehicleID(player[playerid]), SPECTATE_MODE_NORMAL);
							admper5[playerid] = 1;//наблюдаем за транспортом
						}
						else
						{
							PlayerSpectatePlayer(playerid, player[playerid], SPECTATE_MODE_NORMAL);//включить наблюдение
							admper5[playerid] = 0;//наблюдаем за игроком
						}
					}
				}
				return 1;
			}
			if(listitem == 3)//снять наблюдение
			{
				if(PlayerInfo[playerid][pAdmin] < 1)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "У Вас нет прав на использование этой команды !", "OK", "");
					return 1;
				}
				if(admper1[playerid] == 600)//если админ ни за кем не наблюдает, то:
				{
					ShowPlayerDialog(playerid, 2, 0, "Информация.", "Сейчас Вы ни за кем не наблюдаете !", "OK", "");
					return 1;
				}
				if(admper1[playerid] != 600)//если наблюдение было включено, то:
				{
					format(string, 256, " Админ %s снял наблюдение с игрока.", RealName[playerid]);
					print(string);
					TogglePlayerSpectating(playerid, 0);//запретить наблюдение для админа
					admper6[playerid] = 0;//обнуляем отметку о переключении наблюдения
				}
				return 1;
			}
			if(listitem == 4)//пополнить жизнь
			{
				if(PlayerInfo[playerid][pAdmin] < 3)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "У Вас нет прав на использование этой команды !", "OK", "");
					return 1;
				}
				if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
					return 1;
				}
				if(perfrost[player[playerid]] != 600 && perfrost[player[playerid]] != playerid)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок заморожен !\n(+ был заморожен НЕ Вами !)",
					"OK", "");
					return 1;
				}
				if(PlayLock1[0][player[playerid]] != 600 && PlayLock1[0][player[playerid]] != playerid)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок заблокирован !\n(+ был заблокирован НЕ Вами !)",
					"OK", "");
					return 1;
				}
				format(string, 256, " Админ %s пополнил игроку %s жизнь.", RealName[playerid], RealName[player[playerid]]);
				print(string);
				SendClientMessageToAll(COLOR_YELLOW, string);
				SetPlayerHealth(player[playerid], 100);
				return 1;
			}
			if(listitem == 5)//бан
			{
				if(PlayerInfo[playerid][pAdmin] < 6)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "У Вас нет прав на использование этой команды !", "OK", "");
					return 1;
				}
				if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid],RealName[player[playerid]],false) != 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
					return 1;
				}
				if(playerid == player[playerid])
				{
					ShowPlayerDialog(playerid, 2, 0, "Информация.", "Защита от бана самого себя !", "OK", "");
					return 1;
				}
				if(PlayerInfo[playerid][pAdmin] <= 11 && PlayerInfo[player[playerid]][pAdmin] >= 1)
				{
					format(string, 256, " Админ %s попытался забанить админа %s", RealName[playerid], RealName[player[playerid]]);
					print(string);
					SendAdminMessage(COLOR_GREEN, string);
					ShowPlayerDialog(playerid, 2, 0, "Информация.", "Забанить админа может только админ 12-го уровня !", "OK", "");
					return 1;
				}
				if(gPlayerLogged[player[playerid]] == 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок ещё не залогинился !", "OK", "");
					return 1;
				}
				format(string, 256, "Введите причину бана игрока:\nИгрок: %s [%d]", RealName[player[playerid]], player[playerid]);
				ShowPlayerDialog(playerid, 6, DIALOG_STYLE_INPUT, "Причина бана игрока", string, "Бан", "Отмена");
				dlgcont[playerid] = 6;
				return 1;
			}
			if(listitem == 6)//кик
			{
				if(PlayerInfo[playerid][pAdmin] < 5)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "У Вас нет прав на использование этой команды !", "OK", "");
					return 1;
				}
				if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
					return 1;
				}
				if(playerid == player[playerid])
				{
					ShowPlayerDialog(playerid, 2, 0, "Информация.", "Защита от кика самого себя !", "OK", "");
					return 1;
				}
				if(PlayerInfo[playerid][pAdmin] <= 11 && PlayerInfo[player[playerid]][pAdmin] >= 1)
				{
					format(string, 256, " Админ %s попытался кикнуть админа %s", RealName[playerid], RealName[player[playerid]]);
					print(string);
					SendAdminMessage(COLOR_GREEN, string);
					ShowPlayerDialog(playerid, 2, 0, "Информация.", "Кикнуть админа может только админ 12-го уровня !", "OK", "");
					return 1;
				}
				if(gPlayerLogged[player[playerid]] == 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок ещё не залогинился !", "OK", "");
					return 1;
				}
				format(string, 256, "Введите причину кика игрока:\nИгрок: %s [%d]", RealName[player[playerid]], player[playerid]);
				ShowPlayerDialog(playerid, 7, DIALOG_STYLE_INPUT, "Причина кика игрока", string, "Кик", "Отмена");
				dlgcont[playerid] = 7;
				return 1;
			}
			if(listitem == 7)//заблокировать
			{
				if(PlayerInfo[playerid][pAdmin] < 2)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "У Вас нет прав на использование этой команды !", "OK", "");
					return 1;
				}
				if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
					return 1;
				}
				if(PlayerInfo[playerid][pAdmin] <= 6 && PlayerInfo[player[playerid]][pAdmin] >= 7)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Вы не можете этого сделать,\nт.к. уровень админки игрока выше Вашего !",
					"OK", "");
					return 1;
				}
				if(perfrost[player[playerid]] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок заморожен !", "OK", "");
					return 1;
				}
				if(PlayLock1[0][player[playerid]] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок УЖЕ заблокирован !", "OK", "");
					return 1;
				}
				if(admper1[player[playerid]] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок занят наблюдением !", "OK", "");
					return 1;
				}
				if(playspa[player[playerid]] == 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок ещё не заспавнился !", "OK", "");
					return 1;
				}
				format(string, 256, " Админ %s заблокировал игрока %s по причине проверки !", RealName[playerid], RealName[player[playerid]]);
				print(string);
				SendClientMessageToAll(COLOR_RED, string);
				PlayLock1[1][player[playerid]] = GetPlayerInterior(player[playerid]);//сохранение интерьера блокировки
				PlayLock1[2][player[playerid]] = GetPlayerVirtualWorld(player[playerid]);//сохранение виртуального мира блокировки
				GetPlayerPos(player[playerid], PlayLock2[0][player[playerid]], PlayLock2[1][player[playerid]],
				PlayLock2[2][player[playerid]]);//сохранение координат блокировки
				GetPlayerFacingAngle(player[playerid], PlayLock2[3][player[playerid]]);//сохранение угла блокировки
				PlayLock1[0][player[playerid]] = playerid;//включение блокировки
				return 1;
			}
			if(listitem == 8)//разблокировать
			{
				if(PlayerInfo[playerid][pAdmin] < 2)
				{
					ShowPlayerDialog(playerid,2,0,"Ошибка.","У Вас нет прав на использование этой команды !","OK","");
					return 1;
				}
				if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid],RealName[player[playerid]],false) != 0)
				{
					ShowPlayerDialog(playerid,2,0,"Ошибка.","Выбранный игрок вышел с сервера !","OK","");
					return 1;
				}
				if(PlayerInfo[playerid][pAdmin] == 1 && PlayerInfo[player[playerid]][pAdmin] > 1)
				{
					ShowPlayerDialog(playerid,2,0,"Ошибка.","Вы не можете этого сделать,\nт.к. уровень админки игрока выше Вашего !","OK","");
					return 1;
				}
				if(PlayLock1[0][player[playerid]] == 600)
				{
					ShowPlayerDialog(playerid,2,0,"Ошибка.","Нельзя, выбранный игрок НЕ заблокирован !","OK","");
					return 1;
				}
				format(string, 256, " Админ %s разблокировал игрока %s", RealName[playerid], RealName[player[playerid]]);
				print(string);
				SendClientMessageToAll(COLOR_GREEN, string);
				PlayLock1[0][player[playerid]] = 600;//отключение блокировки
				return 1;
			}
			if(listitem == 9)//заморозить
			{
				if(PlayerInfo[playerid][pAdmin] < 2)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "У Вас нет прав на использование этой команды !", "OK", "");
					return 1;
				}
				if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
					return 1;
				}
				if(PlayerInfo[playerid][pAdmin] <= 6 && PlayerInfo[player[playerid]][pAdmin] >= 7)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Вы не можете этого сделать,\nт.к. уровень админки игрока выше Вашего !",
					"OK", "");
					return 1;
				}
				if(perfrost[player[playerid]] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок УЖЕ заморожен !", "OK", "");
					return 1;
				}
				if(PlayLock1[0][player[playerid]] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок заблокирован !", "OK", "");
					return 1;
				}
				if(admper1[player[playerid]] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок занят наблюдением !", "OK", "");
					return 1;
				}
				if(playspa[player[playerid]] == 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок ещё не заспавнился !", "OK", "");
					return 1;
				}
				format(string, 256, "Введите причину заморозки игрока:\nИгрок: %s [%d]", RealName[player[playerid]], player[playerid]);
				ShowPlayerDialog(playerid, 47, DIALOG_STYLE_INPUT, "Причина заморозки игрока", string, "Заморозить", "Отмена");
				dlgcont[playerid] = 47;
				return 1;
			}
			if(listitem == 10)//разморозить
			{
				if(PlayerInfo[playerid][pAdmin] < 2)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "У Вас нет прав на использование этой команды !", "OK", "");
					return 1;
				}
				if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid],RealName[player[playerid]],false) != 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
					return 1;
				}
				if(PlayerInfo[playerid][pAdmin] <= 6 && PlayerInfo[player[playerid]][pAdmin] >= 7)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Вы не можете этого сделать,\nт.к. уровень админки игрока выше Вашего !",
					"OK", "");
					return 1;
				}
				if(perfrost[player[playerid]] == 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок НЕ заморожен !", "OK", "");
					return 1;
				}
				format(string, 256, " Админ %s разморозил игрока %s", RealName[playerid], RealName[player[playerid]]);
				print(string);
				SendClientMessageToAll(COLOR_GREEN, string);
				perfrost[player[playerid]] = 600;//отключение заморозки
				TogglePlayerControllable(player[playerid], 1);
				return 1;
			}
			if(listitem == 11)//убить
			{
				if(PlayerInfo[playerid][pAdmin] < 3)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "У Вас нет прав на использование этой команды !", "OK", "");
					return 1;
				}
				if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
					return 1;
				}
				if(PlayerInfo[playerid][pAdmin] <= 6 && PlayerInfo[player[playerid]][pAdmin] >= 7)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Вы не можете этого сделать,\nт.к. уровень админки игрока выше Вашего !",
					"OK", "");
					return 1;
				}
				if(perfrost[player[playerid]] != 600 && perfrost[player[playerid]] != playerid)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок заморожен !\n(+ был заморожен НЕ Вами !)",
					"OK", "");
					return 1;
				}
				if(PlayLock1[0][player[playerid]] != 600 && PlayLock1[0][player[playerid]] != playerid)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок заблокирован !\n(+ был заблокирован НЕ Вами !)",
					"OK", "");
					return 1;
				}
				if(playspa[player[playerid]] == 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок ещё не заспавнился !", "OK", "");
					return 1;
				}
				format(string, 256, "Введите причину убийства игрока:\nИгрок: %s [%d]", RealName[player[playerid]], player[playerid]);
				ShowPlayerDialog(playerid, 48, DIALOG_STYLE_INPUT, "Причина убийства игрока", string, "Убить", "Отмена");
				dlgcont[playerid] = 48;
				return 1;
			}
			if(listitem == 12)//заткнуть
			{
				if(PlayerInfo[playerid][pAdmin] < 2)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "У Вас нет прав на использование этой команды !", "OK", "");
					return 1;
				}
				if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
					return 1;
				}
				if(PlayerInfo[playerid][pAdmin] <= 6 && PlayerInfo[player[playerid]][pAdmin] >= 7)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Вы не можете этого сделать,\nт.к. уровень админки игрока выше Вашего !",
					"OK","");
					return 1;
				}
				format(string, 256, "Введите число секунд и через пробел причину затыка игрока:\
				\n(чтобы разоткнуть, введите 3 секунды)\nИгрок: %s [%d]", RealName[player[playerid]], player[playerid]);
				ShowPlayerDialog(playerid, 8, DIALOG_STYLE_INPUT, "Секунды и причина затыка игрока", string, "Заткнуть", "Отмена");
				dlgcont[playerid] = 8;
				return 1;
			}
			if(listitem == 13)//посадить в тюрьму
			{
				if(PlayerInfo[playerid][pAdmin] < 2)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "У Вас нет прав на использование этой команды !", "OK", "");
					return 1;
				}
				if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
					return 1;
				}
				if(PlayerInfo[playerid][pAdmin] <= 6 && PlayerInfo[player[playerid]][pAdmin] >= 7)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Вы не можете этого сделать,\nт.к. уровень админки игрока выше Вашего !",
					"OK", "");
					return 1;
				}
				if(perfrost[player[playerid]] != 600 && perfrost[player[playerid]] != playerid)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок заморожен !\n(+ был заморожен НЕ Вами !)",
					"OK", "");
					return 1;
				}
				if(PlayLock1[0][player[playerid]] != 600 && PlayLock1[0][player[playerid]] != playerid)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.","Нельзя, выбранный игрок заблокирован !\n(+ был заблокирован НЕ Вами !)",
					"OK", "");
					return 1;
				}
				if(admper1[player[playerid]] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.","Нельзя, выбранный игрок занят наблюдением !", "OK", "");
					return 1;
				}
				if(playspa[player[playerid]] == 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок ещё не заспавнился !", "OK", "");
					return 1;
				}
				format(string, 256, "Введите число секунд и через пробел причину посадки игрока в тюрьму:\
				\n(чтобы освободить, введите 3 секунды)\nИгрок: %s [%d]", RealName[player[playerid]], player[playerid]);
				ShowPlayerDialog(playerid, 46, DIALOG_STYLE_INPUT, "Секунды и причина посадки игрока в тюрьму", string,
				"Посадить", "Отмена");
				dlgcont[playerid] = 46;
				return 1;
			}
			if(listitem == 14)//тп себя в тюрьму
			{
				if(PlayerInfo[playerid][pAdmin] < 1)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "У Вас нет прав на использование этой команды !", "OK", "");
					return 1;
				}
				if(PlayerInfo[playerid][pPrisonsec] > 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, Вы сидите в тюрьме !", "OK", "");
					return 1;
				}
				if(perfrost[playerid] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, Вы заморожены !", "OK", "");
					return 1;
				}
				if(PlayLock1[0][playerid] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, Вы заблокированы !", "OK", "");
					return 1;
				}
				format(string, 256, " Админ %s телепортировался в тюрьму.", RealName[playerid]);
				print(string);
				SetPlayerInterior(playerid, 0);//интерьер тюрьмы
				SetPlayerVirtualWorld(playerid, 0);//виртуальный мир 0
				SetPlayerPos(playerid, -2088.1086,-96.8724,35.1641);//координаты тюрьмы
				SetPlayerFacingAngle(playerid, 296.6238);//угол спавна в тюрьме
				SetCameraBehindPlayer(playerid);//камера за спиной
				return 1;
			}
			if(listitem == 15)//тп себя в полицейский участок
			{
				if(PlayerInfo[playerid][pAdmin] < 1)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "У Вас нет прав на использование этой команды !", "OK", "");
					return 1;
				}
				if(PlayerInfo[playerid][pPrisonsec] > 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, Вы сидите в тюрьме !", "OK", "");
					return 1;
				}
				if(perfrost[playerid] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, Вы заморожены !", "OK","");
					return 1;
				}
				if(PlayLock1[0][playerid] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, Вы заблокированы !", "OK", "");
					return 1;
				}
				format(string, 256, " Админ %s телепортировался в полицейский участок.", RealName[playerid]);
				print(string);
				SetPlayerInterior(playerid, 0);//интерьер полицейского участка
				SetPlayerVirtualWorld(playerid, 0);//виртуальный мир 0
				SetPlayerPos(playerid, 215.97, 114.45, 999.01);//координаты полицейского участка
				SetPlayerFacingAngle(playerid, 269.82);//угол спавна в полицейском участке
				SetCameraBehindPlayer(playerid);//камера за спиной
				return 1;
			}
			if(listitem == 16)//просмотреть статистику
			{
				if(PlayerInfo[playerid][pAdmin] < 1)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "У Вас нет прав на использование этой команды !", "OK", "");
					return 1;
				}
				if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
					return 1;
				}
				format(string, 256, " Админ %s просмотрел статистику игрока %s", RealName[playerid], RealName[player[playerid]]);
				print(string);
				ShowStats(playerid, player[playerid]);
				return 1;
			}
			if(listitem == 17)//сменить скин
			{
				if(PlayerInfo[playerid][pAdmin] < 3)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "У Вас нет прав на использование этой команды !", "OK", "");
					return 1;
				}
				if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
					return 1;
				}
				if(PlayerInfo[playerid][pAdmin] <= 6 && PlayerInfo[player[playerid]][pAdmin] >= 7)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Вы не можете этого сделать,\nт.к. уровень админки игрока выше Вашего !",
					"OK", "");
					return 1;
				}
				if(perfrost[player[playerid]] != 600 && perfrost[player[playerid]] != playerid)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок заморожен !\n(+ был заморожен НЕ Вами !)",
					"OK", "");
					return 1;
				}
				if(PlayLock1[0][player[playerid]] != 600 && PlayLock1[0][player[playerid]] != playerid)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок заблокирован !\n(+ был заблокирован НЕ Вами !)",
					"OK", "");
					return 1;
				}
				if(playspa[player[playerid]] == 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок ещё не заспавнился !", "OK", "");
					return 1;
				}
				format(string, 256, "Введите ид скина, на который Вы хотите сменить:\nИгрок: %s [%d]",
				RealName[player[playerid]], player[playerid]);
				ShowPlayerDialog(playerid, 9, DIALOG_STYLE_INPUT, "ID скина игрока", string, "Сменить", "Отмена");
				dlgcont[playerid] = 9;
				return 1;
			}
			if(listitem == 18)//узнать IP
			{
				if(PlayerInfo[playerid][pAdmin] < 1)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "У Вас нет прав на использование этой команды !", "OK", "");
					return 1;
				}
				if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
					return 1;
				}
				new ip[64];
				GetPlayerIp(player[playerid], ip, sizeof(ip));
				format(string, 256, " Админ %s просмотрел IP игрока %s [%d]: %s", RealName[playerid],
				RealName[player[playerid]], player[playerid], ip);
				print(string);
				format(string, 256, " Игрок %s [%d] - IP: %s", RealName[player[playerid]], player[playerid], ip);
				SendClientMessage(playerid, COLOR_WHITE, string);
				return 1;
			}
			if(listitem == 19)//слапнуть
			{
				if(PlayerInfo[playerid][pAdmin] < 1)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "У Вас нет прав на использование этой команды !", "OK", "");
					return 1;
				}
				if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
					return 1;
				}
				if(PlayerInfo[playerid][pAdmin] <= 6 && PlayerInfo[player[playerid]][pAdmin] >= 7)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Вы не можете этого сделать,\nт.к. уровень админки игрока выше Вашего !",
					"OK", "");
					return 1;
				}
				if(PlayerInfo[player[playerid]][pPrisonsec] > 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок сидит в тюрьме !", "OK", "");
					return 1;
				}
				if(perfrost[player[playerid]] != 600 && perfrost[player[playerid]] != playerid)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок заморожен !\n(+ был заморожен НЕ Вами !)",
					"OK", "");
					return 1;
				}
				if(PlayLock1[0][player[playerid]] != 600 && PlayLock1[0][player[playerid]] != playerid)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок заблокирован !\n(+ был заблокирован НЕ Вами !)",
					"OK", "");
					return 1;
				}
				if(admper1[player[playerid]] != 600)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок занят наблюдением !", "OK", "");
					return 1;
				}
				if(playspa[player[playerid]] == 0)
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок ещё не заспавнился !", "OK", "");
					return 1;
				}
				new Float:x, Float:y, Float:z, Float:hp;
				GetPlayerHealth(player[playerid], hp);
				SetPlayerHealth(player[playerid], hp-5);
				GetPlayerPos(player[playerid], x, y, z);
				if(PlayLock1[0][player[playerid]] != 600 && PlayLock1[0][player[playerid]] == playerid)
				{//если игрок заблокирован, то слапнуть заблокированного игрока
					x = x + 3;
					y = y + 3;
					z = z + 5;
					PlayLock2[0][player[playerid]] = x;//изменение координат блокировки
					PlayLock2[1][player[playerid]] = y;
					PlayLock2[2][player[playerid]] = z;
				}
				else//иначе - ТП НЕ заблокированного игрока
				{
					SetPlayerPos(player[playerid], x+3, y+3, z+5);
				}
				format(string, 256, " Админ %s слапнул игрока %s [%d]", RealName[playerid],
				RealName[player[playerid]], player[playerid]);
				print(string);
				SendClientMessageToAll(COLOR_RED, string);
				return 1;
			}
		}
		return 1;
	}
	if(dialogid == 6)
	{
		if(PlayerInfo[playerid][pAdmin] == 0)
		{
			dialogadm[playerid] = 1;//устанавливаем контрольную переменную админ-меню
			return 1;
		}
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(InpTxtControl(inputtext) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, "Ошибка, недопустимый символ:");
				SendClientMessage(playerid, COLOR_RED, "запрещённые коды, или знак процентов, или ~ !!!");
				format(string, 256, "Введите причину бана игрока:\nИгрок: %s [%d]", RealName[player[playerid]], player[playerid]);
				ShowPlayerDialog(playerid, 6, DIALOG_STYLE_INPUT, "Причина бана игрока", string, "Бан", "Отмена");
				dlgcont[playerid] = 6;
				return 1;
			}
			if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
			{
				ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
				return 1;
			}
			if(PlayerInfo[playerid][pAdmin] <= 11 && PlayerInfo[player[playerid]][pAdmin] >= 1)
			{
				format(string, 256, " Админ %s попытался забанить админа %s", RealName[playerid], RealName[player[playerid]]);
				print(string);
				SendAdminMessage(COLOR_GREEN, string);
				ShowPlayerDialog(playerid, 2, 0, "Информация.", "Забанить админа может только админ 12-го уровня !", "OK", "");
				return 1;
			}
			if(gPlayerLogged[player[playerid]] == 0)
			{
				ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок ещё не залогинился !", "OK", "");
				return 1;
			}
			new ip[64];
			GetPlayerIp(player[playerid], ip, sizeof(ip));
			format(string, 256, " Админ %s забанил игрока %s , причина: %s", RealName[playerid],
			RealName[player[playerid]], inputtext);
			print(string);
			SendClientMessageToAll(COLOR_RED, string);
			format(string, 256 ," IP игрока %s : [%s]", RealName[player[playerid]], ip);
			print(string);
			SendAdminMessage(COLOR_RED, string);
			PlayerInfo[player[playerid]][pLock] = 1;
			if(!strlen(inputtext))//делаем отметку, если причина не указана
			{
				format(inputtext, 256, "* Причина не указана.");
			}
			format(string, 256, " --- Админ: [ %s ]", RealName[playerid]);//формируем метку админа
			strdel(fbanreason[player[playerid]], 0, 256);//очистка причины бана
			strcat(fbanreason[player[playerid]], inputtext);//добавляем в символьную переменную причину
			strcat(fbanreason[player[playerid]], string);//добавляем в символьную переменную метку админа
			SetTimerEx("PlayBan", 300, 0, "i", player[playerid]);
		}
		return 1;
	}
	if(dialogid == 7)
	{
		if(PlayerInfo[playerid][pAdmin] == 0)
		{
			dialogadm[playerid] = 1;//устанавливаем контрольную переменную админ-меню
			return 1;
		}
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(InpTxtControl(inputtext) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, "Ошибка, недопустимый символ:");
				SendClientMessage(playerid, COLOR_RED, "запрещённые коды, или знак процентов, или ~ !!!");
				format(string, 256, "Введите причину кика игрока:\nИгрок: %s [%d]", RealName[player[playerid]], player[playerid]);
				ShowPlayerDialog(playerid, 7, DIALOG_STYLE_INPUT, "Причина кика игрока", string, "Кик", "Отмена");
				dlgcont[playerid] = 7;
				return 1;
			}
			if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
			{
				ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
				return 1;
			}
			if(PlayerInfo[playerid][pAdmin] <= 11 && PlayerInfo[player[playerid]][pAdmin] >= 1)
			{
				format(string,256," Админ %s попытался кикнуть админа %s", RealName[playerid], RealName[player[playerid]]);
				print(string);
				SendAdminMessage(COLOR_GREEN, string);
				ShowPlayerDialog(playerid, 2, 0, "Информация.", "Кикнуть админа может только админ 12-го уровня !", "OK", "");
				return 1;
			}
			if(gPlayerLogged[player[playerid]] == 0)
			{
				ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Нельзя, выбранный игрок ещё не залогинился !", "OK", "");
				return 1;
			}
			format(string, 256, " Админ %s кикнул игрока %s , причина: %s", RealName[playerid],
			RealName[player[playerid]], inputtext);
			print(string);
			SendClientMessageToAll(COLOR_RED, string);
			SetTimerEx("PlayKick", 300, 0, "i", player[playerid]);
		}
		return 1;
	}
	if(dialogid == 47)
	{
		if(PlayerInfo[playerid][pAdmin] == 0)
		{
			dialogadm[playerid] = 1;//устанавливаем контрольную переменную админ-меню
			return 1;
		}
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(InpTxtControl(inputtext) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, "Ошибка, недопустимый символ:");
				SendClientMessage(playerid, COLOR_RED, "запрещённые коды, или знак процентов, или ~ !!!");
				format(string, 256, "Введите причину заморозки игрока:\nИгрок: %s [%d]", RealName[player[playerid]], player[playerid]);
				ShowPlayerDialog(playerid, 47, DIALOG_STYLE_INPUT, "Причина заморозки игрока", string, "Заморозить", "Отмена");
				dlgcont[playerid] = 47;
				return 1;
			}
			if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
			{
				ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
				return 1;
			}
			format(string, 256, " Админ %s заморозил игрока %s , причина: %s", RealName[playerid],
			RealName[player[playerid]], inputtext);
			print(string);
			SendClientMessageToAll(COLOR_RED, string);
			perfrost[player[playerid]] = playerid;//включение заморозки
			TogglePlayerControllable(player[playerid], 0);
		}
		return 1;
	}
	if(dialogid == 48)
	{
		if(PlayerInfo[playerid][pAdmin] == 0)
		{
			dialogadm[playerid] = 1;//устанавливаем контрольную переменную админ-меню
			return 1;
		}
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(InpTxtControl(inputtext) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, "Ошибка, недопустимый символ:");
				SendClientMessage(playerid, COLOR_RED, "запрещённые коды, или знак процентов, или ~ !!!");
				format(string, 256, "Введите причину убийства игрока:\nИгрок: %s [%d]", RealName[player[playerid]], player[playerid]);
				ShowPlayerDialog(playerid, 48, DIALOG_STYLE_INPUT, "Причина убийства игрока", string, "Убить", "Отмена");
				dlgcont[playerid] = 48;
				return 1;
			}
			if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
			{
				ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
				return 1;
			}
			format(string, 256, " Админ %s убил игрока %s , причина: %s", RealName[playerid],
			RealName[player[playerid]], inputtext);
			print(string);
			SendClientMessageToAll(COLOR_RED, string);
			SetPlayerArmour(player[playerid], 0);
			SetPlayerHealth(player[playerid], 0);
		}
		return 1;
	}
	if(dialogid == 8)
	{
		if(PlayerInfo[playerid][pAdmin] == 0)
		{
			dialogadm[playerid] = 1;//устанавливаем контрольную переменную админ-меню
			return 1;
		}
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(InpTxtControl(inputtext) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, "Ошибка, недопустимый символ:");
				SendClientMessage(playerid, COLOR_RED, "запрещённые коды, или знак процентов, или ~ !!!");
				format(string, 256, "Введите число секунд и через пробел причину затыка игрока:\
				\n(чтобы разоткнуть, введите 3 секунды)\nИгрок: %s [%d]", RealName[player[playerid]], player[playerid]);
				ShowPlayerDialog(playerid, 8, DIALOG_STYLE_INPUT, "Секунды и причина затыка игрока", string, "Заткнуть", "Отмена");
				dlgcont[playerid] = 8;
				return 1;
			}
			new cause[256], i = 0, j = 0, m = 0;//выделение текста из строки
			while (inputtext[i] != 32)
			{
				if(inputtext[i] == 0 || i == 10)
				{
					m = 1;
					break;
				}
				i++;
			}
			if(m == 1)
			{
				cause[0] = 0;
			}
			else
			{
				i++;
				while (i < 256)
				{
					cause[j] = inputtext[i];
					if(inputtext[i] == 0) break;
					i++;
					j++;
				}
			}
			new secon;
			secon = strval(inputtext);
			if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
			{
				ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
				return 1;
			}
			if(secon != 3)
			{
				if(secon < 5) { secon = 5; }
				format(string, 256, " Админ %s заткнул игрока %s на %d секунд , причина: %s", RealName[playerid],
				RealName[player[playerid]], secon, cause);
				print(string);
				SendClientMessageToAll(COLOR_RED, string);
				if(PlayerInfo[player[playerid]][pMutedsec] == 0)//если игрок НЕ заткнут, то:
				{
					PlayerInfo[player[playerid]][pMuted]++;
				}
				PlayerInfo[player[playerid]][pMutedsec] = secon;
			}
			else
			{
				if(PlayerInfo[player[playerid]][pMutedsec] > 0)//если игрок заткнут, то:
				{
					format(string, 256, " Админ %s разоткнул игрока %s", RealName[playerid],
					RealName[player[playerid]]);
					print(string);
					SendClientMessageToAll(COLOR_GREEN, string);
					PlayerInfo[player[playerid]][pMuted]--;
					PlayerInfo[player[playerid]][pMutedsec] = 0;
				}
				else
				{
					ShowPlayerDialog(playerid, 2, 0, "Информация.", "Выбранный игрок не заткнут !", "OK", "");
				}
			}
		}
		return 1;
	}
	if(dialogid == 46)
	{
		if(PlayerInfo[playerid][pAdmin] == 0)
		{
			dialogadm[playerid] = 1;//устанавливаем контрольную переменную админ-меню
			return 1;
		}
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(InpTxtControl(inputtext) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, "Ошибка, недопустимый символ:");
				SendClientMessage(playerid, COLOR_RED, "запрещённые коды, или знак процентов, или ~ !!!");
				format(string, 256, "Введите число секунд и через пробел причину посадки игрока в тюрьму:\
				\n(чтобы освободить, введите 3 секунды)\nИгрок: %s [%d]", RealName[player[playerid]], player[playerid]);
				ShowPlayerDialog(playerid, 46, DIALOG_STYLE_INPUT, "Секунды и причина посадки игрока в тюрьму", string,
				"Посадить","Отмена");
				dlgcont[playerid] = 46;
				return 1;
			}
			new cause[256], i = 0, j = 0, m = 0;//выделение текста из строки
			while (inputtext[i] != 32)
			{
				if(inputtext[i] == 0 || i == 10)
				{
					m = 1;
					break;
				}
				i++;
			}
			if(m == 1)
			{
				cause[0] = 0;
			}
			else
			{
				i++;
				while (i < 256)
				{
					cause[j] = inputtext[i];
					if(inputtext[i] == 0) break;
					i++;
					j++;
				}
			}
			new secon;
			secon = strval(inputtext);
			if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
			{
				ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
				return 1;
			}
			if(secon != 3)
			{
				if(secon < 5) { secon = 5; }
				format(string, 256, " Админ %s посадил игрока %s в тюрьму на %d секунд , причина: %s", RealName[playerid],
				RealName[player[playerid]], secon, cause);
				print(string);
				SendClientMessageToAll(COLOR_RED, string);
				if(PlayerInfo[player[playerid]][pPrisonsec] == 0)//если не в тюрьме, то сохранение слотов оружия игрока
				{
					for(new n = 0; n < 13; n++)//сохранение всех слотов
					{
						GetPlayerWeaponData(player[playerid], n, play2weap[player[playerid]][n], play2ammo[player[playerid]][n]);
					}
					PlayerInfo[player[playerid]][pPrison]++;
					PlayerInfo[player[playerid]][pPrisonsec] = secon;
					if(PlayLock1[0][player[playerid]] != 600 && PlayLock1[0][player[playerid]] == playerid)
					{//если игрок заблокирован, то заменяем данные блокировки на данные тюрьмы
						PlayLock1[1][player[playerid]] = 0;//интерьер тюрьмы
						PlayLock1[2][player[playerid]] = 0;//виртуальный мир 0
						PlayLock2[0][player[playerid]] = -2088.1086;//координаты тюрьмы
						PlayLock2[1][player[playerid]] = -96.8724;
						PlayLock2[2][player[playerid]] = 35.1641;
						PlayLock2[3][player[playerid]] = 296.6238;//угол спавна в тюрьме
						SetCameraBehindPlayer(player[playerid]);//камера за спиной
					}
					SecSpa(player[playerid]);//респавн игрока (с блокировкой заполнения слотов оружия и предметов)
				}
				else//если игрок уже в тюрьме, то изменяем секунды тюрьмы
				{
					PlayerInfo[player[playerid]][pPrisonsec] = secon;
				}
			}
			else
			{
				if(PlayerInfo[player[playerid]][pPrisonsec] > 0)//если игрок в тюрьме, то:
				{
					format(string, 256, " Админ %s освободил игрока %s", RealName[playerid],
					RealName[player[playerid]]);
					print(string);
					SendClientMessageToAll(COLOR_GREEN, string);
					PlayerInfo[player[playerid]][pPrison]--;
					PlayerInfo[player[playerid]][pPrisonsec] = 0;
					weapstatplay[player[playerid]] = 0;
					OnPlayerSpawn(player[playerid]);//респавн игрока
				}
				else
				{
					ShowPlayerDialog(playerid, 2, 0, "Информация.", "Выбранный игрок не сидит в тюрьме !", "OK", "");
				}
			}
		}
		return 1;
	}
	if(dialogid == 9)
	{
		if(PlayerInfo[playerid][pAdmin] == 0)
		{
			dialogadm[playerid] = 1;//устанавливаем контрольную переменную админ-меню
			return 1;
		}
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(InpTxtControl(inputtext) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, "Ошибка, недопустимый символ:");
				SendClientMessage(playerid, COLOR_RED, "запрещённые коды, или знак процентов, или ~ !!!");
				format(string, 256, "Введите ид скина, на который Вы хотите сменить:\nИгрок: %s [%d]",
				RealName[player[playerid]], player[playerid]);
				ShowPlayerDialog(playerid, 9, DIALOG_STYLE_INPUT, "ID скина игрока", string, "Сменить", "Отмена");
				dlgcont[playerid] = 9;
				return 1;
			}
			if(strval(inputtext) < 0 || strval(inputtext) > 311)
			{
				SendClientMessage(playerid, COLOR_RED, " Ид скина должен быть от 0 до 311 !");
		 		return 1;
		 	}
			if(!IsPlayerConnected(player[playerid]) || strcmp(playtarget[playerid], RealName[player[playerid]], false) != 0)
			{
				ShowPlayerDialog(playerid, 2, 0, "Ошибка.", "Выбранный игрок вышел с сервера !", "OK", "");
				return 1;
			}
			format(string, 256, " Админ %s сменил скин игроку %s на %d", RealName[playerid], RealName[player[playerid]],
			strval(inputtext));
			print(string);
			SendClientMessageToAll(COLOR_YELLOW, string);
			SetPVarInt(player[playerid], "PlSkin", strval(inputtext));
			SetPlayerSkin(player[playerid], GetPVarInt(player[playerid], "PlSkin"));
		}
		return 1;
	}
if(dialogid == DIALOG_CAR_MAIN)
{
    if(!response) return 1;
    switch(listitem)
    {
        case 0: ShowPlayerDialog(playerid, DIALOG_CAR_VAZ, DIALOG_STYLE_LIST, "VAZ",
            "2101\n2105\n2106\n2109\n2110\n2112\n2114\nGranta\nPriora\n21099\n2107\nNiva", "Далее", "Отмена");
        case 1: ShowPlayerDialog(playerid, DIALOG_CAR_MERCEDES, DIALOG_STYLE_LIST, "Mercedes",
            "CLS55\nE55AMG\nE63S\nG63\nW140\nW204\nW211\nW212\nW218\nW221\nW223\nПузатый мерс\nCLS 63 (Ахмеда)", "Далее", "Отмена");
        case 2: ShowPlayerDialog(playerid, DIALOG_CAR_BMW, DIALOG_STYLE_LIST, "BMW",
            "E34\nE60\nE92\nG82\nM5 F90\nM6\nX5\nM8\nM4 F82\nM5 F10\nM5 F90 (LEVEL)\nM5 F90 (Asko)\nE38", "Далее", "Отмена");
        case 3: ShowPlayerDialog(playerid, DIALOG_CAR_TOYOTA, DIALOG_STYLE_LIST, "Toyota",
            "Land Cruiser 200\nToyota Camry 55", "Далее", "Отмена");
        case 4: ShowPlayerDialog(playerid, DIALOG_CAR_LEXUS, DIALOG_STYLE_LIST, "Lexus",
            "Lexus 570\nISF", "Далее", "Отмена");
        case 5: ShowPlayerDialog(playerid, DIALOG_CAR_PORSCHE, DIALOG_STYLE_LIST, "Porsche",
            "Cayenne", "Далее", "Отмена");
        case 6: ShowPlayerDialog(playerid, DIALOG_CAR_KITAY, DIALOG_STYLE_LIST, "Китай",
            "ZEEKR 001\nLI9", "Далее", "Отмена");
        case 7: ShowPlayerDialog(playerid, DIALOG_CAR_BIKES, DIALOG_STYLE_LIST, "Мото",
            "BMW\nDucati", "Далее", "Отмена");
        case 8: ShowPlayerDialog(playerid, DIALOG_CAR_POLICE, DIALOG_STYLE_LIST, "Полиция",
            "Skoda Octavia (ДПС)\nLADA VESTA (ДПС)", "Далее", "Отмена");
    }
    return 1;
}

// Обработка выбора конкретной модели
if(dialogid == DIALOG_CAR_VAZ && response)
{
    new vehid;
    switch(listitem)
    {
        case 0: vehid = 492; case 1: vehid = 422; case 2: vehid = 479; case 3: vehid = 442;
        case 4: vehid = 491; case 5: vehid = 549; case 6: vehid = 543; case 7: vehid = 404;
        case 8: vehid = 410; case 9: vehid = 499; case 10: vehid = 478;  case 11: vehid = 600; 
    }
    SpawnNewCar(playerid, vehid);
    return 1;
}
if(dialogid == DIALOG_CAR_MERCEDES && response)
{
    new vehid;
    switch(listitem)
    {
        case 0: vehid = 467; case 1: vehid = 458; case 2: vehid = 558; case 3: vehid = 602;
        case 4: vehid = 436; case 5: vehid = 527; case 6: vehid = 587; case 7: vehid = 551;
        case 8: vehid = 541; case 9: vehid = 535; case 10: vehid = 545; case 11: vehid = 573;  case 12: vehid = 603; 
    }
    SpawnNewCar(playerid, vehid);
    return 1;
}
if(dialogid == DIALOG_CAR_BMW && response)
{
    new vehid;
    switch(listitem)
    {
        case 0: vehid = 412; case 1: vehid = 474; case 2: vehid = 475; case 3: vehid = 542;
        case 4: vehid = 567; case 5: vehid = 439; case 6: vehid = 402; case 7: vehid = 516;
        case 8: vehid = 518; case 9: vehid = 536; case 10: vehid = 576;  case 11: vehid = 566;  case 12: vehid = 409; 
    }
    SpawnNewCar(playerid, vehid);
    return 1;
}
if(dialogid == DIALOG_CAR_TOYOTA && response)
{
    new vehid;
    switch(listitem)
    {
        case 0: vehid = 579;  case 1: vehid = 507;
    }
    SpawnNewCar(playerid, vehid);
    return 1;
}
if(dialogid == DIALOG_CAR_LEXUS && response)
{
    new vehid;
    switch(listitem)
    {
        case 0: vehid = 489; case 1: vehid = 559;
    }
    SpawnNewCar(playerid, vehid);
    return 1;
}
if(dialogid == DIALOG_CAR_PORSCHE && response)
{
    SpawnNewCar(playerid, 411);
    return 1;
}
if(dialogid == DIALOG_CAR_KITAY && response)
{
    new vehid;
    switch(listitem)
    {
        case 0: vehid = 451; case 1: vehid = 415;
    }
    SpawnNewCar(playerid, vehid);
    return 1;
}
if(dialogid == DIALOG_CAR_BIKES && response)
{
    new vehid;
    switch(listitem)
    {
        case 0: vehid = 521; case 1: vehid = 522;
    }
    SpawnNewCar(playerid, vehid);
    return 1;
}
if(dialogid == DIALOG_CAR_POLICE && response)
{
    new vehid;
    switch(listitem)
    {
        case 0: vehid = 596; case 1: vehid = 597;
    }
    SpawnNewCar(playerid, vehid);
    return 1;
}

	/*
if(dialogid == 10)//меню Транспортное средство
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(listitem == 0)
			{
				format(strdln, sizeof(strdln), "{FF0000}отечественные\n{FFFFFF}спорткары\n{FF0000}отечественные №2\
				\n{FFFFFF}отечественные №3\n{FF0000}иномарки\n{FFFFFF}# Niva меню\n{FF0000}•Легенды - Известные авто\
				\n{FFFFFF}Korch Жигули\n{FF0000}Лёгкие грузовики и фургоны\n{FFFFFF}Транспорт для развлечения\
				\n{FF0000}Велосипеды и мотоциклы");
				format(strdln, sizeof(strdln), "%s\n{FFFFFF}Авто для транспортировки\
				\n{FF0000}Коммерческий и государственный транспорт\n{FFFFFF}Воздушный транспорт\n{FF0000}Водный транспорт\
				\n{FFFFFF}Радиоуправляемые авто", strdln);
				ShowPlayerDialog(playerid, 21, DIALOG_STYLE_LIST, "Тип транспорта", strdln, "Выбор", "Отмена");
				dlgcont[playerid] = 21;
				return 1;
			}
			if(listitem == 1)
			{
				ShowPlayerDialog(playerid, 19, DIALOG_STYLE_LIST, "Тюнинг", "Диски\nГидравлика\nУдалить гидравлику\nЦвет\
				\nВинилы\nАрхангел тюнинг\nНеон, дополнительно\nВыключить фары\nУдалить детали транспорта\
				\nУдалить бампера\nПроколоть шины", "Выбор", "Отмена");
				dlgcont[playerid] = 19;
				return 1;
			}
			if(listitem == 2)
			{
				if(autorepair[playerid] == 0)
				{
					autorepair[playerid] = 1;
					ShowPlayerDialog(playerid, 2, 0, "Автоматический ремонт", "{62E300}Автоматический ремонт включен!", "OK", "");
				}else{
					autorepair[playerid] = 0;
					ShowPlayerDialog(playerid, 2, 0, "Автоматический ремонт", "{E30000}Автоматический ремонт отключен!", "OK", "");
				}
				return 1;
			}
			if(listitem == 3)//уничтожить транспорт
			{
				new car = GetPlayerVehicleID(playerid);
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					if(CallRemoteFunction("myobjvehfunc", "d", car) != 0)//чтение ИД транспорта из скпипта myobj
					{
						SendClientMessage(playerid, 0xFF0000FF, " Нельзя ! Это отдельно созданный транспорт !");
						return 1;
					}
					if(CallRemoteFunction("garagefunction", "d", car) != 0)//чтение ИД транспорта из системы гаражей
					{
						SendClientMessage(playerid, 0xFF0000FF, " Нельзя ! Это транспорт системы гаражей !");
						return 1;
					}
					if(CallRemoteFunction("basesysvehfunc", "d", car) != 0)//чтение ИД транспорта из системы баз
					{
						SendClientMessage(playerid, 0xFF0000FF, " Нельзя ! Это транспорт системы баз !");
						return 1;
					}
					for(new i = 0; i < MAX_PLAYERS; i++)//уничтожить любой транспорт
					{
						if(GetPlayerVehicleID(playerid) == playcar[i])//уничтожить чужой транспорт вместе с неоном
						{
							if(neon[i][0] != 0) { DestroyObject(neon[i][0]); }//убрать неон
							if(neon[i][1] != 0) { DestroyObject(neon[i][1]); }//убрать неон
							neon[i][0] = 0;//присваиваем неону несуществующий номер объекта
							neon[i][1] = 0;//присваиваем неону несуществующий номер объекта
							neon[i][2] = 0;//несуществующий ид транспорта с неоном
							playcar[i] = 0;//несуществующий ид транспорта
						}
						if(GetPlayerVehicleID(playerid) == neon[i][2])//уничтожить чужой неон на свободном транспорте
						{
							DestroyObject(neon[i][0]);//убрать неон
							DestroyObject(neon[i][1]);//убрать неон
							neon[i][0] = 0;//присваиваем неону несуществующий номер объекта
							neon[i][1] = 0;//присваиваем неону несуществующий номер объекта
							neon[i][2] = 0;//несуществующий ид транспорта с неоном
						}
					}
					DestroyVehicle(car);
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, " Вы должны быть на месте водителя !");
				}
				return 1;
			}
			if(listitem == 4)
			{
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 0, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3;//флипнуть
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, " Вы должны быть на месте водителя !");
				}
			}
		}else{
			gettime(timedata[0], timedata[1]);
			format(string, sizeof(string), "{FFFFFF}Игровое меню. Точное время: {FF0000}%02d{FFFFFF}:{FF0000}%02d", timedata[0], timedata[1]);
			ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, string, "{FF0000}» Транспортное средство\n{FF0000}» Предметы\
			\n{FF0000}» Оружие\n{FF0000}» Телепорты\n{FF0000}» Аксессуары\n{FF0000}» Действия\n{FF0000}» Радио\n{FF0000}» DeathMatch\
			\n{FF0000}» Платные услуги\n{FF0000}» On-Line Администраторы\n{FF0000}» Правила сервера\n{FF0000}» Система банд", "Выбор", "Отмена");
			dlgcont[playerid] = 4;
		}
		return 1;
	}
	*/
	if(dialogid == 45)//меню Предметы
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(listitem == 0)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 0, pweap, pammo);
				if(pweap == 1 && pammo >= 1)
				{
					pammo = 1;
				}
				else
				{
					GivePlayerWeapon(playerid, 1, 1);
				}
				ShowPlayerDialog(playerid, 45, DIALOG_STYLE_LIST, "Предметы", "Кастет\nКлюшка для гольфа\
				\nРезиновая дубинка\nНож\nБейсбольная бита\nЛопата\nКий\nКатана\nБензопила\nБаллончик с краской\
				\nОгнетушитель\nФотоаппарат\nБукет цветов\nТрость\nОчки ночного видения\
				\nИнфракрасные очки\nПарашют\nУбрать предметы", "OK", "Отмена");
				dlgcont[playerid] = 45;
				return 1;
			}
			if(listitem == 1)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 1, pweap, pammo);
				if(pweap == 2 && pammo >= 1)
				{
					pammo = 1;
				}
				else
				{
					GivePlayerWeapon(playerid, 2, 1);
				}
				ShowPlayerDialog(playerid, 45, DIALOG_STYLE_LIST, "Предметы", "Кастет\nКлюшка для гольфа\
				\nРезиновая дубинка\nНож\nБейсбольная бита\nЛопата\nКий\nКатана\nБензопила\nБаллончик с краской\
				\nОгнетушитель\nФотоаппарат\nБукет цветов\nТрость\nОчки ночного видения\
				\nИнфракрасные очки\nПарашют\nУбрать предметы", "OK", "Отмена");
				dlgcont[playerid] = 45;
				return 1;
			}
			if(listitem == 2)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 1, pweap, pammo);
				if(pweap == 3 && pammo >= 1)
				{
					pammo = 1;
				}
				else
				{
					GivePlayerWeapon(playerid, 3, 1);
				}
				ShowPlayerDialog(playerid, 45, DIALOG_STYLE_LIST, "Предметы", "Кастет\nКлюшка для гольфа\
				\nРезиновая дубинка\nНож\nБейсбольная бита\nЛопата\nКий\nКатана\nБензопила\nБаллончик с краской\
				\nОгнетушитель\nФотоаппарат\nБукет цветов\nТрость\nОчки ночного видения\
				\nИнфракрасные очки\nПарашют\nУбрать предметы", "OK", "Отмена");
				dlgcont[playerid] = 45;
				return 1;
			}
			if(listitem == 3)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 1, pweap, pammo);
				if(pweap == 4 && pammo >= 1)
				{
					pammo = 1;
				}
				else
				{
					GivePlayerWeapon(playerid, 4, 1);
				}
				ShowPlayerDialog(playerid, 45, DIALOG_STYLE_LIST, "Предметы", "Кастет\nКлюшка для гольфа\
				\nРезиновая дубинка\nНож\nБейсбольная бита\nЛопата\nКий\nКатана\nБензопила\nБаллончик с краской\
				\nОгнетушитель\nФотоаппарат\nБукет цветов\nТрость\nОчки ночного видения\
				\nИнфракрасные очки\nПарашют\nУбрать предметы", "OK", "Отмена");
				dlgcont[playerid] = 45;
				return 1;
			}
			if(listitem == 4)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 1, pweap, pammo);
				if(pweap == 5 && pammo >= 1)
				{
					pammo = 1;
				}
				else
				{
					GivePlayerWeapon(playerid, 5, 1);
				}
				ShowPlayerDialog(playerid, 45, DIALOG_STYLE_LIST, "Предметы", "Кастет\nКлюшка для гольфа\
				\nРезиновая дубинка\nНож\nБейсбольная бита\nЛопата\nКий\nКатана\nБензопила\nБаллончик с краской\
				\nОгнетушитель\nФотоаппарат\nБукет цветов\nТрость\nОчки ночного видения\
				\nИнфракрасные очки\nПарашют\nУбрать предметы", "OK", "Отмена");
				dlgcont[playerid] = 45;
				return 1;
			}
			if(listitem == 5)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 1, pweap, pammo);
				if(pweap == 6 && pammo >= 1)
				{
					pammo = 1;
				}
				else
				{
					GivePlayerWeapon(playerid, 6, 1);
				}
				ShowPlayerDialog(playerid, 45, DIALOG_STYLE_LIST, "Предметы", "Кастет\nКлюшка для гольфа\
				\nРезиновая дубинка\nНож\nБейсбольная бита\nЛопата\nКий\nКатана\nБензопила\nБаллончик с краской\
				\nОгнетушитель\nФотоаппарат\nБукет цветов\nТрость\nОчки ночного видения\
				\nИнфракрасные очки\nПарашют\nУбрать предметы", "OK", "Отмена");
				dlgcont[playerid] = 45;
				return 1;
			}
			if(listitem == 6)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 1, pweap, pammo);
				if(pweap == 7 && pammo >= 1)
				{
					pammo = 1;
				}
				else
				{
					GivePlayerWeapon(playerid, 7, 1);
				}
				ShowPlayerDialog(playerid, 45, DIALOG_STYLE_LIST, "Предметы", "Кастет\nКлюшка для гольфа\
				\nРезиновая дубинка\nНож\nБейсбольная бита\nЛопата\nКий\nКатана\nБензопила\nБаллончик с краской\
				\nОгнетушитель\nФотоаппарат\nБукет цветов\nТрость\nОчки ночного видения\
				\nИнфракрасные очки\nПарашют\nУбрать предметы", "OK", "Отмена");
				dlgcont[playerid] = 45;
				return 1;
			}
			if(listitem == 7)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 1, pweap, pammo);
				if(pweap == 8 && pammo >= 1)
				{
					pammo = 1;
				}
				else
				{
					GivePlayerWeapon(playerid, 8, 1);
				}
				ShowPlayerDialog(playerid, 45, DIALOG_STYLE_LIST, "Предметы", "Кастет\nКлюшка для гольфа\
				\nРезиновая дубинка\nНож\nБейсбольная бита\nЛопата\nКий\nКатана\nБензопила\nБаллончик с краской\
				\nОгнетушитель\nФотоаппарат\nБукет цветов\nТрость\nОчки ночного видения\
				\nИнфракрасные очки\nПарашют\nУбрать предметы", "OK", "Отмена");
				dlgcont[playerid] = 45;
				return 1;
			}
			if(listitem == 8)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 1, pweap, pammo);
				if(pweap == 9 && pammo >= 1)
				{
					pammo = 1;
				}
				else
				{
					GivePlayerWeapon(playerid, 9, 1);
				}
				ShowPlayerDialog(playerid, 45, DIALOG_STYLE_LIST, "Предметы", "Кастет\nКлюшка для гольфа\
				\nРезиновая дубинка\nНож\nБейсбольная бита\nЛопата\nКий\nКатана\nБензопила\nБаллончик с краской\
				\nОгнетушитель\nФотоаппарат\nБукет цветов\nТрость\nОчки ночного видения\
				\nИнфракрасные очки\nПарашют\nУбрать предметы", "OK", "Отмена");
				dlgcont[playerid] = 45;
				return 1;
			}
			if(listitem == 9)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 9, pweap, pammo);
				if(pweap == 41 && pammo > 1000)
				{
					SendClientMessage(playerid, COLOR_RED, "Больше взять нельзя.");
				}
				else
				{
					if((pweap == 41 || pweap == 0) && pammo <= 1000)
					{
						GivePlayerWeapon(playerid, 41, 1000);
					}
					else
					{
						GivePlayerWeapon(playerid, 41, pammo);
					}
				}
				ShowPlayerDialog(playerid, 45, DIALOG_STYLE_LIST, "Предметы", "Кастет\nКлюшка для гольфа\
				\nРезиновая дубинка\nНож\nБейсбольная бита\nЛопата\nКий\nКатана\nБензопила\nБаллончик с краской\
				\nОгнетушитель\nФотоаппарат\nБукет цветов\nТрость\nОчки ночного видения\
				\nИнфракрасные очки\nПарашют\nУбрать предметы", "OK", "Отмена");
				dlgcont[playerid] = 45;
				return 1;
			}
			if(listitem == 10)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 9, pweap, pammo);
				if(pweap == 42 && pammo > 1000)
				{
					SendClientMessage(playerid, COLOR_RED, "Больше взять нельзя.");
				}
				else
				{
					if((pweap == 42 || pweap == 0) && pammo <= 1000)
					{
						GivePlayerWeapon(playerid, 42, 1000);
					}
					else
					{
						GivePlayerWeapon(playerid, 42, pammo);
					}
				}
				ShowPlayerDialog(playerid, 45, DIALOG_STYLE_LIST, "Предметы", "Кастет\nКлюшка для гольфа\
				\nРезиновая дубинка\nНож\nБейсбольная бита\nЛопата\nКий\nКатана\nБензопила\nБаллончик с краской\
				\nОгнетушитель\nФотоаппарат\nБукет цветов\nТрость\nОчки ночного видения\
				\nИнфракрасные очки\nПарашют\nУбрать предметы", "OK", "Отмена");
				dlgcont[playerid] = 45;
				return 1;
			}
			if(listitem == 11)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 9, pweap, pammo);
				if(pweap == 43 && pammo > 1000)
				{
					SendClientMessage(playerid, COLOR_RED, "Больше взять нельзя.");
				}
				else
				{
					if((pweap == 43 || pweap == 0) && pammo <= 1000)
					{
						GivePlayerWeapon(playerid, 43, 1000);
					}
					else
					{
						GivePlayerWeapon(playerid, 43, pammo);
					}
				}
				ShowPlayerDialog(playerid, 45, DIALOG_STYLE_LIST, "Предметы", "Кастет\nКлюшка для гольфа\
				\nРезиновая дубинка\nНож\nБейсбольная бита\nЛопата\nКий\nКатана\nБензопила\nБаллончик с краской\
				\nОгнетушитель\nФотоаппарат\nБукет цветов\nТрость\nОчки ночного видения\
				\nИнфракрасные очки\nПарашют\nУбрать предметы", "OK", "Отмена");
				dlgcont[playerid] = 45;
				return 1;
			}
			if(listitem == 12)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 10, pweap, pammo);
				if(pweap == 14 && pammo >= 1)
				{
					pammo = 1;
				}
				else
				{
					GivePlayerWeapon(playerid, 14, 1);
				}
				ShowPlayerDialog(playerid, 45, DIALOG_STYLE_LIST, "Предметы", "Кастет\nКлюшка для гольфа\
				\nРезиновая дубинка\nНож\nБейсбольная бита\nЛопата\nКий\nКатана\nБензопила\nБаллончик с краской\
				\nОгнетушитель\nФотоаппарат\nБукет цветов\nТрость\nОчки ночного видения\
				\nИнфракрасные очки\nПарашют\nУбрать предметы", "OK", "Отмена");
				dlgcont[playerid] = 45;
				return 1;
			}
			if(listitem == 13)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 10, pweap, pammo);
				if(pweap == 15 && pammo >= 1)
				{
					pammo = 1;
				}
				else
				{
					GivePlayerWeapon(playerid, 15, 1);
				}
				ShowPlayerDialog(playerid, 45, DIALOG_STYLE_LIST, "Предметы", "Кастет\nКлюшка для гольфа\
				\nРезиновая дубинка\nНож\nБейсбольная бита\nЛопата\nКий\nКатана\nБензопила\nБаллончик с краской\
				\nОгнетушитель\nФотоаппарат\nБукет цветов\nТрость\nОчки ночного видения\
				\nИнфракрасные очки\nПарашют\nУбрать предметы", "OK", "Отмена");
				dlgcont[playerid] = 45;
				return 1;
			}
			if(listitem == 14)
			{
				if (PlayerInfo[playerid][pAdmin] == 0)
				{
					SendClientMessage(playerid, COLOR_RED, "Этот предмет могут взять только админы !");
				}
				else
				{
					new pweap, pammo;
					GetPlayerWeaponData(playerid, 11, pweap, pammo);
					if(pweap == 44 && pammo >= 1)
					{
						pammo = 1;
					}
					else
					{
						GivePlayerWeapon(playerid, 44, 1);
					}
				}
				ShowPlayerDialog(playerid, 45, DIALOG_STYLE_LIST, "Предметы", "Кастет\nКлюшка для гольфа\
				\nРезиновая дубинка\nНож\nБейсбольная бита\nЛопата\nКий\nКатана\nБензопила\nБаллончик с краской\
				\nОгнетушитель\nФотоаппарат\nБукет цветов\nТрость\nОчки ночного видения\
				\nИнфракрасные очки\nПарашют\nУбрать предметы", "OK", "Отмена");
				dlgcont[playerid] = 45;
				return 1;
			}
			if(listitem == 15)
			{
				if (PlayerInfo[playerid][pAdmin] == 0)
				{
					SendClientMessage(playerid, COLOR_RED, "Этот предмет могут взять только админы !");
				}
				else
				{
					new pweap, pammo;
					GetPlayerWeaponData(playerid, 11, pweap, pammo);
					if(pweap == 45 && pammo >= 1)
					{
						pammo = 1;
					}
					else
					{
						GivePlayerWeapon(playerid, 45, 1);
					}
				}
				ShowPlayerDialog(playerid, 45, DIALOG_STYLE_LIST, "Предметы", "Кастет\nКлюшка для гольфа\
				\nРезиновая дубинка\nНож\nБейсбольная бита\nЛопата\nКий\nКатана\nБензопила\nБаллончик с краской\
				\nОгнетушитель\nФотоаппарат\nБукет цветов\nТрость\nОчки ночного видения\
				\nИнфракрасные очки\nПарашют\nУбрать предметы", "OK", "Отмена");
				dlgcont[playerid] = 45;
				return 1;
			}
			if(listitem == 16)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 11, pweap, pammo);
				if(pweap == 46 && pammo >= 1)
				{
					pammo = 1;
				}
				else
				{
					GivePlayerWeapon(playerid, 46, 1);
				}
				ShowPlayerDialog(playerid, 45, DIALOG_STYLE_LIST, "Предметы", "Кастет\nКлюшка для гольфа\
				\nРезиновая дубинка\nНож\nБейсбольная бита\nЛопата\nКий\nКатана\nБензопила\nБаллончик с краской\
				\nОгнетушитель\nФотоаппарат\nБукет цветов\nТрость\nОчки ночного видения\
				\nИнфракрасные очки\nПарашют\nУбрать предметы", "OK", "Отмена");
				dlgcont[playerid] = 45;
				return 1;
			}
			if(listitem == 17)
			{
				for(new j = 0; j < 13; j++)//сохранение слотов оружия и предметов
				{
					GetPlayerWeaponData(playerid, j, play2weap[playerid][j], play2ammo[playerid][j]);
				}
				ResetPlayerWeapons(playerid);//отбираем оружие и предметы
				GivePlayerWeapon(playerid, play2weap[playerid][2], play2ammo[playerid][2]);//возвращаем оружие
				GivePlayerWeapon(playerid, play2weap[playerid][3], play2ammo[playerid][3]);
				GivePlayerWeapon(playerid, play2weap[playerid][4], play2ammo[playerid][4]);
				GivePlayerWeapon(playerid, play2weap[playerid][5], play2ammo[playerid][5]);
				GivePlayerWeapon(playerid, play2weap[playerid][6], play2ammo[playerid][6]);
				GivePlayerWeapon(playerid, play2weap[playerid][7], play2ammo[playerid][7]);
				GivePlayerWeapon(playerid, play2weap[playerid][8], play2ammo[playerid][8]);
				GivePlayerWeapon(playerid, play2weap[playerid][12], play2ammo[playerid][12]);
				ShowPlayerDialog(playerid, 45, DIALOG_STYLE_LIST, "Предметы", "Кастет\nКлюшка для гольфа\
				\nРезиновая дубинка\nНож\nБейсбольная бита\nЛопата\nКий\nКатана\nБензопила\nБаллончик с краской\
				\nОгнетушитель\nФотоаппарат\nБукет цветов\nТрость\nОчки ночного видения\
				\nИнфракрасные очки\nПарашют\nУбрать предметы", "OK", "Отмена");
				dlgcont[playerid] = 45;
			}
		}else{
			gettime(timedata[0], timedata[1]);
			format(string, sizeof(string), "{FFFFFF}Игровое меню. Точное время: {FF0000}%02d{FFFFFF}:{FF0000}%02d", timedata[0], timedata[1]);
			ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, string, "{FF0000}» Транспортное средство\n{FF0000}» Предметы\
			\n{FF0000}» Оружие\n{FF0000}» Телепорты\n{FF0000}» Аксессуары\n{FF0000}» Действия\n{FF0000}» Радио\n{FF0000}» DeathMatch\
			\n{FF0000}» Платные услуги\n{FF0000}» On-Line Администраторы\n{FF0000}» Правила сервера\n{FF0000}» Система банд", "Выбор", "Отмена");
			dlgcont[playerid] = 4;
		}
		return 1;
	}
	if(dialogid == 20)//меню Оружие
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(listitem == 0)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 2, pweap, pammo);
				if((pweap == 22 || pweap == 0) && GetPlayerMoney(playerid) < 10000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 22 && pammo > 300)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 22 || pweap == 0) && pammo <= 300)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -10000);
							GivePlayerWeapon(playerid, 22, 100);
						}
						else
						{
							GivePlayerWeapon(playerid, 22, pammo);
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 1)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 2, pweap, pammo);
				if((pweap == 23 || pweap == 0) && GetPlayerMoney(playerid) < 10000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 23 && pammo > 300)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 23 || pweap == 0) && pammo <= 300)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -10000);
							GivePlayerWeapon(playerid, 23, 100);
						}
						else
						{
							GivePlayerWeapon(playerid, 23, pammo);
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 2)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 2, pweap, pammo);
				if((pweap == 24 || pweap == 0) && GetPlayerMoney(playerid) < 10000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 24 && pammo > 300)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 24 || pweap == 0) && pammo <= 300)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -10000);
							GivePlayerWeapon(playerid, 24, 100);
						}
						else
						{
							GivePlayerWeapon(playerid, 24, pammo);
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 3)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 3, pweap, pammo);
				if((pweap == 25 || pweap == 0) && GetPlayerMoney(playerid) < 30000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 25 && pammo > 300)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 25 || pweap == 0) && pammo <= 300)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -30000);
							GivePlayerWeapon(playerid, 25, 100);
						}
						else
						{
							for(new j = 0; j < 13; j++)//сохранение слотов оружия и предметов
							{//только для 3, 4, и 5-го слотов !!!
								GetPlayerWeaponData(playerid, j, play2weap[playerid][j], play2ammo[playerid][j]);
							}
							ResetPlayerWeapons(playerid);//отбираем оружие и предметы
							play2weap[playerid][3] = 0;//обнуление 3-го слота
							play2ammo[playerid][3] = 0;
							for(new j = 0; j < 13; j++)//возвращение слотов оружия и предметов
							{
								GivePlayerWeapon(playerid, play2weap[playerid][j], play2ammo[playerid][j]);
							}
							GivePlayerWeapon(playerid, 25, pammo);
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 4)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 3, pweap, pammo);
				if((pweap == 26 || pweap == 0) && GetPlayerMoney(playerid) < 30000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 26 && pammo > 300)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 26 || pweap == 0) && pammo <= 300)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -30000);
							GivePlayerWeapon(playerid, 26, 100);
						}
						else
						{
							for(new j = 0; j < 13; j++)//сохранение слотов оружия и предметов
							{//только для 3, 4, и 5-го слотов !!!
								GetPlayerWeaponData(playerid, j, play2weap[playerid][j], play2ammo[playerid][j]);
							}
							ResetPlayerWeapons(playerid);//отбираем оружие и предметы
							play2weap[playerid][3] = 0;//обнуление 3-го слота
							play2ammo[playerid][3] = 0;
							for(new j = 0; j < 13; j++)//возвращение слотов оружия и предметов
							{
								GivePlayerWeapon(playerid, play2weap[playerid][j], play2ammo[playerid][j]);
							}
							GivePlayerWeapon(playerid, 26, pammo);
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 5)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 3, pweap, pammo);
				if((pweap == 27 || pweap == 0) && GetPlayerMoney(playerid) < 30000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 27 && pammo > 300)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 27 || pweap == 0) && pammo <= 300)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -30000);
							GivePlayerWeapon(playerid, 27, 100);
						}
						else
						{
							for(new j = 0; j < 13; j++)//сохранение слотов оружия и предметов
							{//только для 3, 4, и 5-го слотов !!!
								GetPlayerWeaponData(playerid, j, play2weap[playerid][j], play2ammo[playerid][j]);
							}
							ResetPlayerWeapons(playerid);//отбираем оружие и предметы
							play2weap[playerid][3] = 0;//обнуление 3-го слота
							play2ammo[playerid][3] = 0;
							for(new j = 0; j < 13; j++)//возвращение слотов оружия и предметов
							{
								GivePlayerWeapon(playerid, play2weap[playerid][j], play2ammo[playerid][j]);
							}
							GivePlayerWeapon(playerid, 27, pammo);
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 6)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 4, pweap, pammo);
				if((pweap == 28 || pweap == 0) && GetPlayerMoney(playerid) < 30000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 28 && pammo > 900)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 28 || pweap == 0) && pammo <= 900)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -30000);
							GivePlayerWeapon(playerid, 28, 300);
						}
						else
						{
							for(new j = 0; j < 13; j++)//сохранение слотов оружия и предметов
							{//только для 3, 4, и 5-го слотов !!!
								GetPlayerWeaponData(playerid, j, play2weap[playerid][j], play2ammo[playerid][j]);
							}
							ResetPlayerWeapons(playerid);//отбираем оружие и предметы
							play2weap[playerid][4] = 0;//обнуление 4-го слота
							play2ammo[playerid][4] = 0;
							for(new j = 0; j < 13; j++)//возвращение слотов оружия и предметов
							{
								GivePlayerWeapon(playerid, play2weap[playerid][j], play2ammo[playerid][j]);
							}
							GivePlayerWeapon(playerid, 28, pammo);
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 7)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 4, pweap, pammo);
				if((pweap == 29 || pweap == 0) && GetPlayerMoney(playerid) < 30000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 29 && pammo > 900)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 29 || pweap == 0) && pammo <= 900)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -30000);
							GivePlayerWeapon(playerid, 29, 300);
						}
						else
						{
							for(new j = 0; j < 13; j++)//сохранение слотов оружия и предметов
							{//только для 3, 4, и 5-го слотов !!!
								GetPlayerWeaponData(playerid, j, play2weap[playerid][j], play2ammo[playerid][j]);
							}
							ResetPlayerWeapons(playerid);//отбираем оружие и предметы
							play2weap[playerid][4] = 0;//обнуление 4-го слота
							play2ammo[playerid][4] = 0;
							for(new j = 0; j < 13; j++)//возвращение слотов оружия и предметов
							{
								GivePlayerWeapon(playerid, play2weap[playerid][j], play2ammo[playerid][j]);
							}
							GivePlayerWeapon(playerid, 29, pammo);
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 8)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 4, pweap, pammo);
				if((pweap == 32 || pweap == 0) && GetPlayerMoney(playerid) < 30000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 32 && pammo > 900)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 32 || pweap == 0) && pammo <= 900)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -30000);
							GivePlayerWeapon(playerid, 32, 300);
						}
						else
						{
							for(new j = 0; j < 13; j++)//сохранение слотов оружия и предметов
							{//только для 3, 4, и 5-го слотов !!!
								GetPlayerWeaponData(playerid, j, play2weap[playerid][j], play2ammo[playerid][j]);
							}
							ResetPlayerWeapons(playerid);//отбираем оружие и предметы
							play2weap[playerid][4] = 0;//обнуление 4-го слота
							play2ammo[playerid][4] = 0;
							for(new j = 0; j < 13; j++)//возвращение слотов оружия и предметов
							{
								GivePlayerWeapon(playerid, play2weap[playerid][j], play2ammo[playerid][j]);
							}
							GivePlayerWeapon(playerid, 32, pammo);
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 9)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 5, pweap, pammo);
				if((pweap == 30 || pweap == 0) && GetPlayerMoney(playerid) < 30000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 30 && pammo > 900)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 30 || pweap == 0) && pammo <= 900)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -30000);
							GivePlayerWeapon(playerid, 30, 300);
						}
						else
						{
							for(new j = 0; j < 13; j++)//сохранение слотов оружия и предметов
							{//только для 3, 4, и 5-го слотов !!!
								GetPlayerWeaponData(playerid, j, play2weap[playerid][j], play2ammo[playerid][j]);
							}
							ResetPlayerWeapons(playerid);//отбираем оружие и предметы
							play2weap[playerid][5] = 0;//обнуление 5-го слота
							play2ammo[playerid][5] = 0;
							for(new j = 0; j < 13; j++)//возвращение слотов оружия и предметов
							{
								GivePlayerWeapon(playerid, play2weap[playerid][j], play2ammo[playerid][j]);
							}
							GivePlayerWeapon(playerid, 30, pammo);
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 10)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 5, pweap, pammo);
				if((pweap == 31 || pweap == 0) && GetPlayerMoney(playerid) < 30000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 31 && pammo > 900)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 31 || pweap == 0) && pammo <= 900)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -30000);
							GivePlayerWeapon(playerid, 31, 300);
						}
						else
						{
							for(new j = 0; j < 13; j++)//сохранение слотов оружия и предметов
							{//только для 3, 4, и 5-го слотов !!!
								GetPlayerWeaponData(playerid, j, play2weap[playerid][j], play2ammo[playerid][j]);
							}
							ResetPlayerWeapons(playerid);//отбираем оружие и предметы
							play2weap[playerid][5] = 0;//обнуление 5-го слота
							play2ammo[playerid][5] = 0;
							for(new j = 0; j < 13; j++)//возвращение слотов оружия и предметов
							{
								GivePlayerWeapon(playerid, play2weap[playerid][j], play2ammo[playerid][j]);
							}
							GivePlayerWeapon(playerid, 31, pammo);
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 11)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 6, pweap, pammo);
				if((pweap == 33 || pweap == 0) && GetPlayerMoney(playerid) < 30000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 33 && pammo > 300)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 33 || pweap == 0) && pammo <= 300)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -30000);
							GivePlayerWeapon(playerid, 33, 100);
						}
						else
						{
							GivePlayerWeapon(playerid, 33, pammo);
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 12)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 6, pweap, pammo);
				if((pweap == 34 || pweap == 0) && GetPlayerMoney(playerid) < 30000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 34 && pammo > 300)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 34 || pweap == 0) && pammo <= 300)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -30000);
							GivePlayerWeapon(playerid, 34, 100);
						}
						else
						{
							GivePlayerWeapon(playerid, 34, pammo);
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 13)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 7, pweap, pammo);
				if((pweap == 35 || pweap == 0) && GetPlayerMoney(playerid) < 500000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 35 && pammo > 300)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 35 || pweap == 0) && pammo <= 300)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -500000);
							GivePlayerWeapon(playerid, 35, 100);
						}
						else
						{
							if(pweap == 37 || pweap == 38)
							{
								GivePlayerWeapon(playerid, 35, pammo / 5);
							}
							else
							{
								GivePlayerWeapon(playerid, 35, pammo);
							}
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 14)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 7, pweap, pammo);
				if((pweap == 36 || pweap == 0) && GetPlayerMoney(playerid) < 500000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 36 && pammo > 300)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 36 || pweap == 0) && pammo <= 300)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -500000);
							GivePlayerWeapon(playerid, 36, 100);
						}
						else
						{
							if(pweap == 37 || pweap == 38)
							{
								GivePlayerWeapon(playerid, 36, pammo / 5);
							}
							else
							{
								GivePlayerWeapon(playerid, 36, pammo);
							}
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 15)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 7, pweap, pammo);
				if((pweap == 37 || pweap == 0) && GetPlayerMoney(playerid) < 500000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 37 && pammo > 1500)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 37 || pweap == 0) && pammo <= 1500)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -500000);
							GivePlayerWeapon(playerid, 37, 500);
						}
						else
						{
							if(pweap == 35 || pweap == 36)
							{
								GivePlayerWeapon(playerid, 37, pammo * 5);
							}
							else
							{
								GivePlayerWeapon(playerid, 37, pammo);
							}
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 16)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 7, pweap, pammo);
				if((pweap == 38 || pweap == 0) && GetPlayerMoney(playerid) < 500000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 38 && pammo > 1500)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 38 || pweap == 0) && pammo <= 1500)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -500000);
							GivePlayerWeapon(playerid, 38, 500);
						}
						else
						{
							if(pweap == 35 || pweap == 36)
							{
								GivePlayerWeapon(playerid, 38, pammo * 5);
							}
							else
							{
								GivePlayerWeapon(playerid, 38, pammo);
							}
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 17)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 8, pweap, pammo);
				if((pweap == 16 || pweap == 0) && GetPlayerMoney(playerid) < 50000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 16 && pammo > 300)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 16 || pweap == 0) && pammo <= 300)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -50000);
							GivePlayerWeapon(playerid, 16, 100);
						}
						else
						{
							GivePlayerWeapon(playerid, 16, pammo);
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 18)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 8, pweap, pammo);
				if((pweap == 17 || pweap == 0) && GetPlayerMoney(playerid) < 50000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 17 && pammo > 300)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 17 || pweap == 0) && pammo <= 300)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -50000);
							GivePlayerWeapon(playerid, 17, 100);
						}
						else
						{
							GivePlayerWeapon(playerid, 17, pammo);
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 19)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 8, pweap, pammo);
				if((pweap == 18 || pweap == 0) && GetPlayerMoney(playerid) < 50000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 18 && pammo > 300)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 18 || pweap == 0) && pammo <= 300)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -50000);
							GivePlayerWeapon(playerid, 18, 100);
						}
						else
						{
							GivePlayerWeapon(playerid, 18, pammo);
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 20)
			{
				new pweap, pammo;
				GetPlayerWeaponData(playerid, 8, pweap, pammo);
				if((pweap == 39 || pweap == 0) && GetPlayerMoney(playerid) < 50000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					if(pweap == 39 && pammo > 300)
					{
						SendClientMessage(playerid, COLOR_RED, "Больше купить нельзя.");
					}
					else
					{
						if((pweap == 39 || pweap == 0) && pammo <= 300)
						{
							SetPVarInt(playerid, "MonControl", 1);
							GivePlayerMoney(playerid, -50000);
							GivePlayerWeapon(playerid, 40, 0);
							GivePlayerWeapon(playerid, 39, 100);
						}
						else
						{
							GivePlayerWeapon(playerid, 40, 0);
							GivePlayerWeapon(playerid, 39, pammo);
						}
					}
				}
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
				return 1;
			}
			if(listitem == 21)
			{
				for(new j = 0; j < 13; j++)//сохранение слотов оружия и предметов
				{
					GetPlayerWeaponData(playerid, j, play2weap[playerid][j], play2ammo[playerid][j]);
				}
				ResetPlayerWeapons(playerid);//отбираем оружие и предметы
				GivePlayerWeapon(playerid, play2weap[playerid][0], play2ammo[playerid][0]);//возвращаем предметы
				GivePlayerWeapon(playerid, play2weap[playerid][1], play2ammo[playerid][1]);
				GivePlayerWeapon(playerid, play2weap[playerid][9], play2ammo[playerid][9]);
				GivePlayerWeapon(playerid, play2weap[playerid][10], play2ammo[playerid][10]);
				GivePlayerWeapon(playerid, play2weap[playerid][11], play2ammo[playerid][11]);
				ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Оружие", "9mm Pistol   [10.000$]\nSilenced Pistol\
				\nDesert Eagle\nShotGun   [30.000$]\nSawn-off Shotgun\nSPAZ 12\nUZI   [30.000$]\nMP5\nTec9\
				\nАК-47   [30.000$]\nM4\nCountry rifle   [30000$]\nSniper rifle\
				\nRPG   [500.000$]\nHeat Seeking Rocket\nFlame-Thrower\nMini-Gun\nGrenades   [50.000$]\nTear Gas\
				\nMolotov Cocktail\nC4\nУбрать оружие", "OK", "Отмена");
				dlgcont[playerid] = 20;
			}
		}else{
			gettime(timedata[0], timedata[1]);
			format(string, sizeof(string), "{FFFFFF}Игровое меню. Точное время: {FF0000}%02d{FFFFFF}:{FF0000}%02d", timedata[0], timedata[1]);
			ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, string, "{FF0000}» Транспортное средство\n{FF0000}» Предметы\
			\n{FF0000}» Оружие\n{FF0000}» Телепорты\n{FF0000}» Аксессуары\n{FF0000}» Действия\n{FF0000}» Радио\n{FF0000}» DeathMatch\
			\n{FF0000}» Платные услуги\n{FF0000}» On-Line Администраторы\n{FF0000}» Правила сервера\n{FF0000}» Система банд", "Выбор", "Отмена");
			dlgcont[playerid] = 4;
		}
		return 1;
	}
/*
	if(dialogid == 21)//меню Тип транспорта
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(listitem == 0)
			{
				ShowPlayerDialog(playerid, 14, DIALOG_STYLE_LIST, "Street JDM", "Lada Vesta Sport\nLada Vesta\nLada Granta FL\
				\nLada 2108\nLada Priora 1 \nLada  Priora 2", "OK", "Отмена");
				dlgcont[playerid] = 14;
				return 1;
			}
			if(listitem == 1)
			{
				ShowPlayerDialog(playerid, 22, DIALOG_STYLE_LIST, "Японские", "Mercedes  C180\nMercedes G65\nMercedes G63\nMercedes E63\nMercedes E60\
				\nMercedes Maybach\nMercedes G65\nMercedes W221\nMercedes W222\nMercedes W223\nMercedes CLS Банан\nMercedes C63", "OK", "Отмена");
				dlgcont[playerid] = 22;
				return 1;
			}
			if(listitem == 2)
			{
				ShowPlayerDialog(playerid, 23, DIALOG_STYLE_LIST, "Легендарные Авто", "Lada 2108\nLada 2109\n ваз 21099\nLada 2110\nLada Vesta Sport\
				\nLada 2106\nLada 2107", "OK", "Отмена");
				dlgcont[playerid] = 23;
				return 1;
			}
			if(listitem == 3)
			{
				ShowPlayerDialog(playerid, 24, DIALOG_STYLE_LIST, "JDM Pandem", "Lada Vesta\nLada Priora\nLada 2101\nLada Granta LF SPORT\nLada 2105\
				\nLada 2110\nLada 2112\nLada 2113\nLada 2114\nLada 2115\nLada 2170\nLada 2172\nLada Granta Sport\nLada Priora Amg\
				\nLada Priora 2172 Amg", "OK", "Отмена");
				dlgcont[playerid] = 24;
				return 1;
			}
			if(listitem == 4)
			{
				ShowPlayerDialog(playerid, 25, DIALOG_STYLE_LIST, "JDM Жигули", "Porsche Cayenne\nBMW M5 E60\nBMW M5 F90\nBMW M5 F10\
				\nBMW e34\nBMW e39\nBMW M6 E60\nBMW X5 F85\nBMW X6 M Competition\nBMW X7\nBMW M3\nBMW M4\nToyota Camry e55\nToyota Land Cruiser 200\nToyota Land Cruiser 300\nCamry v70\
				\nRolls-Royce Cullinan\nLexus Is F\nSKODA OCTAVIA\nBMW M5 F90 REST\nLexus LX570\nLexus LS 300\nROLLS ROYCE WRITH\nBmw m8 CABRIO\nM6 CABRIO", "OK", "Отмена");
				dlgcont[playerid] = 25;
			}
			if(listitem == 5)
			{
				ShowPlayerDialog(playerid, 26, DIALOG_STYLE_LIST, "Korch Жигули", "Tesla Model S\nTesla CyberTruck\nLamborghini Huracan\nLamborghini Urus\nLamborhini Aventador\
				\nG65 BRABUS\nCAMRY 40\nHYUNDAY ACCENT", "OK", "Отмена");
				dlgcont[playerid] = 26;
				return 1;
			}
			if(listitem == 6)
			{
				ShowPlayerDialog(playerid, 27, DIALOG_STYLE_LIST, "Китайцы", "ZEEKR-001\nLI7\nLI9\
				\nHAVAL", "OK", "Отмена");
				dlgcont[playerid] = 27;
				return 1;
			}
			if(listitem == 7)
			{
				ShowPlayerDialog(playerid, 28, DIALOG_STYLE_LIST, "Камаз", "lit energy KAMAZ\n\
				\n\n\n\n\n\n\n\n\n\
				\n\n\n\n\n\n\n\n", "OK", "Отмена");
				dlgcont[playerid] = 28;
				return 1;
			}
			if(listitem == 8)
			{
				ShowPlayerDialog(playerid, 29, DIALOG_STYLE_LIST, "Американцы", "DODGE DEMON SRT HELLCAT\nDODGE RAM\
				\nJEEP GRAND CHEROKEE\n\n\n\n\n\n\n\n\n", "OK", "Отмена");
				dlgcont[playerid] = 29;
				return 1;
			}
			if(listitem == 9)
			{
			
			}
			if(listitem == 10)
			{
				ShowPlayerDialog(playerid, 31, DIALOG_STYLE_LIST, "Велосипеды и мотоциклы", "BMX\nBike\nMountain Bike\nDUCATI\
				\nPROGASI ZS 300\nSUZUKI\nHARLEY\nBMW S1000RR\nKAWASAKI NINJA\nMOPED\nKAYO TT125\nKAYO TT140", "OK", "Отмена");
				dlgcont[playerid] = 31;
				return 1;
			}
			if(listitem == 11)
			{
				
			}
			if(listitem == 12)
			{
				ShowPlayerDialog(playerid, 33, DIALOG_STYLE_LIST, "Коммерческий и государственный транспорт", "скорая помощь\
				\nHAVAL POLICE\nАВТОБУС ПОЛИЦИЯ\nПОЖАРКА АМЕРИКА\nПОЖАРКА\nHPV-1000\nPatriot\nSKODA OCTAVIA\
				\nBMW F90 CHECNYA\nCRUISER 200\nTANK НАХУЙ\nФСБ ГЕЛИК", "OK", "Отмена");
				dlgcont[playerid] = 33;
				return 1;
			}
			if(listitem == 13)
			{
				ShowPlayerDialog(playerid, 34, DIALOG_STYLE_LIST, "Воздушный транспорт", "Andromada\nAT-400\nBeagle\nCargobob\
				\nCropduster\nDodo\nHunter   / 1000000$ /\nLeviathan\nMaverick\nNevada\nNews Maverick\nPolice Maverick\nRaindance\
				\nRustler\nSeasparrow\nShamal\nSkimmer\nSparrow\nStunt Plane\nHydra   / 1000000$ /", "OK", "Отмена");
				dlgcont[playerid] = 34;
				return 1;
			}
			if(listitem == 14)
			{
				ShowPlayerDialog(playerid, 35, DIALOG_STYLE_LIST, "Водный транспорт", "Coastguard\nDingy\nJetmax\nLaunch\nMarquis\
				\nPredator\nReefer\nSpeeder\nSquallo\nTropic", "OK", "Отмена");
				dlgcont[playerid] = 35;
				return 1;
			}
			if(listitem == 15)
			{
				ShowPlayerDialog(playerid, 36, DIALOG_STYLE_LIST, "Радиоуправляемые авто", "RC Bandit\nRC Baron\nRC Cam\
				\nRC Goblin\nRC Tiger\nGlendale\nSadler", "OK", "Отмена");
				dlgcont[playerid] = 36;
			}
		}else{
			ShowPlayerDialog(playerid, 10, DIALOG_STYLE_LIST, "Транспортное средство", "{FF0000}Тип транспорта\
				\n{FFFFFF}Тюнинг\n{FF0000}Отключить / включить автоматический ремонт\n{FFFFFF}Уничтожить транспорт\
				\n{FF0000}Флипнуть (Клавиша: 2)", "Выбор", "Отмена");
			dlgcont[playerid] = 10;
		}
		return 1;
	}
	*/
	if(dialogid == 16)
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(InpTxtControl(inputtext) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, "Ошибка, недопустимый символ:");
				SendClientMessage(playerid, COLOR_RED, "запрещённые коды, или знак процентов, или ~ !!!");
				ShowPlayerDialog(playerid, 16, DIALOG_STYLE_INPUT, "Смена скина", "Введите ид скина, на который Вы хотите сменить:",
				"Сменить","Отмена");
				dlgcont[playerid] = 16;
				return 1;
			}
			if(strval(inputtext) < 0 || strval(inputtext) > 311)
			{
				SendClientMessage(playerid, COLOR_RED, " Ид скина должен быть от 0 до 311 !");
				ShowPlayerDialog(playerid, 16, DIALOG_STYLE_INPUT,"Смена скина","Введите ид скина, на который Вы хотите сменить:",
				"Сменить","Отмена");
				dlgcont[playerid] = 16;
				return 1;
			}
			SetPVarInt(playerid, "PlSkin", strval(inputtext));
			SetPlayerSkin(playerid, GetPVarInt(playerid, "PlSkin"));
		}else{
			ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Действия", "Пополнить жизнь\nАнимации\nСменить цвет ника\
			\nСменить скин\nСменить время\nСменить стиль боя\nСамоубийство\
			\nПросмотреть собственную статистику", "Выбор", "Отмена");
			dlgcont[playerid] = 12;
		}
		return 1;
	}
	if(dialogid == 17)//меню Цвет
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new vehicleid;
			if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
			{
				vehicleid = GetPlayerVehicleID(playerid);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Вы должны быть на месте водителя !");
				ShowPlayerDialog(playerid, 17, DIALOG_STYLE_LIST, "Цвет", "{FF0000}Красный\n{991E1E}Кирпичный\n{332AE0}Синий\
				\n{A43FF9}Фиолетовый\n{FFFF33}Жёлтый\n{FF9933}Светло-жёлтый\n{28A937}Зеленый\n{1E9999}Бирюзовый\n{808080}Серый\
				\n{FFFFFF}Черный\n{FFFFFF}Белый", "OK", "Отмена");
				dlgcont[playerid] = 17;
				return 1;
			}
			if(listitem == 0) ChangeVehicleColor(vehicleid, 3, 3);
			if(listitem == 1) ChangeVehicleColor(vehicleid, 175, 175);
			if(listitem == 2) ChangeVehicleColor(vehicleid, 79, 79);
			if(listitem == 3) ChangeVehicleColor(vehicleid, 211, 211);
			if(listitem == 4) ChangeVehicleColor(vehicleid, 6, 6);
			if(listitem == 5) ChangeVehicleColor(vehicleid, 65, 65);
			if(listitem == 6) ChangeVehicleColor(vehicleid, 86, 86);
			if(listitem == 7) ChangeVehicleColor(vehicleid, 155, 155);
			if(listitem == 8) ChangeVehicleColor(vehicleid, 9, 9);
			if(listitem == 9) ChangeVehicleColor(vehicleid, 0, 0);
			if(listitem == 10) ChangeVehicleColor(vehicleid, 1, 1);
			PlayerPlaySound(playerid, 1134, 0.0, 0.0 ,0.0);
			ShowPlayerDialog(playerid, 17, DIALOG_STYLE_LIST, "Цвет", "{FF0000}Красный\n{991E1E}Кирпичный\n{332AE0}Синий\
			\n{A43FF9}Фиолетовый\n{FFFF33}Жёлтый\n{FF9933}Светло-жёлтый\n{28A937}Зеленый\n{1E9999}Бирюзовый\n{808080}Серый\
			\n{FFFFFF}Черный\n{FFFFFF}Белый", "OK", "Отмена");
			dlgcont[playerid] = 17;
		}else{
			ShowPlayerDialog(playerid, 19, DIALOG_STYLE_LIST, "Тюнинг", "Диски\nГидравлика\nУдалить гидравлику\nЦвет\
		\nВинилы\nАрхангел тюнинг\nНеон, дополнительно\nВыключить фары\nУдалить детали транспорта\
		\nУдалить бампера\nПроколоть шины", "Выбор", "Отмена");
			dlgcont[playerid] = 19;
		}
		return 1;
	}
	if(dialogid == 18)//меню Установка времени
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(listitem == 0) SetPlayerTime(playerid, 0, 0);
			if(listitem == 1) SetPlayerTime(playerid, 1, 0);
			if(listitem == 2) SetPlayerTime(playerid, 2, 0);
			if(listitem == 3) SetPlayerTime(playerid, 3, 0);
			if(listitem == 4) SetPlayerTime(playerid, 4, 0);
			if(listitem == 5) SetPlayerTime(playerid, 5, 0);
			if(listitem == 6) SetPlayerTime(playerid, 6, 0);
			if(listitem == 7) SetPlayerTime(playerid, 7, 0);
			if(listitem == 8) SetPlayerTime(playerid, 8, 0);
			if(listitem == 9) SetPlayerTime(playerid, 9, 0);
			if(listitem == 10) SetPlayerTime(playerid, 10, 0);
			if(listitem == 11) SetPlayerTime(playerid, 11, 0);
			if(listitem == 12) SetPlayerTime(playerid, 12, 0);
			if(listitem == 13) SetPlayerTime(playerid, 13, 0);
			if(listitem == 14) SetPlayerTime(playerid, 14, 0);
			if(listitem == 15) SetPlayerTime(playerid, 15, 0);
			if(listitem == 16) SetPlayerTime(playerid, 16, 0);
			if(listitem == 17) SetPlayerTime(playerid, 17, 0);
			if(listitem == 18) SetPlayerTime(playerid, 18, 0);
			if(listitem == 19) SetPlayerTime(playerid, 19, 0);
			if(listitem == 20) SetPlayerTime(playerid, 20, 0);
			if(listitem == 21) SetPlayerTime(playerid, 21, 0);
			if(listitem == 22) SetPlayerTime(playerid, 22, 0);
			if(listitem == 23) SetPlayerTime(playerid, 23, 0);
		}else{
			ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Действия", "Пополнить жизнь\nАнимации\nСменить цвет ника\
			\nСменить скин\nСменить время\nСменить стиль боя\nСамоубийство\
			\nПросмотреть собственную статистику", "Выбор", "Отмена");
			dlgcont[playerid] = 12;
		}
		return 1;
	}
	if(dialogid == 37)//меню Диски
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new vehicleid;
			if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
			{
				vehicleid = GetPlayerVehicleID(playerid);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Вы должны быть на месте водителя !");
				ShowPlayerDialog(playerid, 37, DIALOG_STYLE_LIST, "Диски", "Shadow\nMega\nWires\nClassic\nRimshine\nCutter\
				\nTwist\nSwitch\nGrove\nImport\nDollar\nTrance\nAtomic\nСтандарт", "OK", "Отмена");
				dlgcont[playerid] = 37;
				return 1;
			}
			if(listitem == 0) AddVehicleComponent(vehicleid, 1073);
			if(listitem == 1) AddVehicleComponent(vehicleid, 1074);
			if(listitem == 2) AddVehicleComponent(vehicleid, 1076);
			if(listitem == 3) AddVehicleComponent(vehicleid, 1077);
			if(listitem == 4) AddVehicleComponent(vehicleid, 1075);
			if(listitem == 5) AddVehicleComponent(vehicleid, 1079);
			if(listitem == 6) AddVehicleComponent(vehicleid, 1078);
			if(listitem == 7) AddVehicleComponent(vehicleid, 1080);
			if(listitem == 8) AddVehicleComponent(vehicleid, 1081);
			if(listitem == 9) AddVehicleComponent(vehicleid, 1082);
			if(listitem == 10) AddVehicleComponent(vehicleid, 1083);
			if(listitem == 11) AddVehicleComponent(vehicleid, 1084);
			if(listitem == 12) AddVehicleComponent(vehicleid, 1085);
			if(listitem >= 0 && listitem <= 12 )PlayerPlaySound(playerid, 1133 ,0.0, 0.0, 0.0);
			if(listitem == 13)
			{
				new dop;
				dop = GetVehicleComponentInSlot(vehicleid, 7);
				if(dop != 0)
				{
					RemoveVehicleComponent(vehicleid, dop);
					PlayerPlaySound(playerid, 5202, 0.0, 0.0, 0.0);
				}
			}
			ShowPlayerDialog(playerid, 37, DIALOG_STYLE_LIST, "Диски", "Shadow\nMega\nWires\nClassic\nRimshine\nCutter\
			\nTwist\nSwitch\nGrove\nImport\nDollar\nTrance\nAtomic\nСтандарт", "OK", "Отмена");
			dlgcont[playerid] = 37;
		}else{
			ShowPlayerDialog(playerid, 19, DIALOG_STYLE_LIST, "Тюнинг", "Диски\nГидравлика\nУдалить гидравлику\nЦвет\
		\nВинилы\nАрхангел тюнинг\nНеон, дополнительно\nВыключить фары\nУдалить детали транспорта\
		\nУдалить бампера\nПроколоть шины", "Выбор", "Отмена");
			dlgcont[playerid] = 19;
		}
		return 1;
	}
	if(dialogid == 38)//меню Винилы
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new vehicleid;
			if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
			{
				vehicleid = GetPlayerVehicleID(playerid);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Вы должны быть на месте водителя !");
				ShowPlayerDialog(playerid, 38, DIALOG_STYLE_LIST, "Винилы", "Винил 1\nВинил 2\nВинил 3\nУдалить винил", "OK", "Отмена");
				dlgcont[playerid] = 38;
				return 1;
			}
			ChangeVehiclePaintjob(vehicleid, listitem);
			PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
			ShowPlayerDialog(playerid, 38, DIALOG_STYLE_LIST, "Винилы", "Винил 1\nВинил 2\nВинил 3\nУдалить винил", "OK", "Отмена");
			dlgcont[playerid] = 38;
		}else{
			ShowPlayerDialog(playerid, 19, DIALOG_STYLE_LIST, "Тюнинг", "Диски\nГидравлика\nУдалить гидравлику\nЦвет\
		\nВинилы\nАрхангел тюнинг\nНеон, дополнительно\nВыключить фары\nУдалить детали транспорта\
		\nУдалить бампера\nПроколоть шины", "Выбор", "Отмена");
			dlgcont[playerid] = 19;
		}
		return 1;
	}
	if(dialogid == 39)//меню Неон, Номер, дополнительно
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new carid;
			if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
			{
				carid = GetPlayerVehicleID(playerid);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Вы должны быть на месте водителя !");
				ShowPlayerDialog(playerid, 39, DIALOG_STYLE_LIST, "Неон, Номер, дополнительно", "Неон\nОткрыть багажник\
				\nЗакрыть багажник\nОткрыть капот\nЗакрыть капот\nВключить свет\nВыключить свет\nЗамкнуть двери\nОткрыть двери\
				\nВключить сигнализацию\nВыключить сигнализацию\nЗавести двигатель\nЗаглушить двигатель", "Выбор", "Отмена");
				dlgcont[playerid] = 39;
				return 1;
			}
			new engine, lights, alarm, doors, bonnet, boot, objective;
			if(listitem == 0)//неон
			{
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					ShowPlayerDialog(playerid, 40,DIALOG_STYLE_LIST,"Неон","{FF3300}Красный\n{0033CC}Синий\n{33FF00}Зелёный\
					\n{FFFF00}Жёлтый\n{E63E85}Розовый\nБелый\nУдалить Неон","OK","Отмена");
					dlgcont[playerid] = 40;
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, " Вы должны быть на месте водителя !");
					ShowPlayerDialog(playerid, 39, DIALOG_STYLE_LIST, "Неон, Номер, дополнительно", "Неон\nОткрыть багажник\
					\nЗакрыть багажник\nОткрыть капот\nЗакрыть капот\nВключить свет\nВыключить свет\nЗамкнуть двери\nОткрыть двери\
					\nВключить сигнализацию\nВыключить сигнализацию\nЗавести двигатель\nЗаглушить двигатель", "Выбор", "Отмена");
					dlgcont[playerid] = 39;
				}
				return 1;
			}
			if(listitem == 1)//сменить номер
			{
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					ShowPlayerDialog(playerid, 41, DIALOG_STYLE_INPUT, "Сменить номер", "Введите номера авто", "OK", "Отмена");
					dlgcont[playerid] = 41;
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, " Вы должны быть на месте водителя !");
					ShowPlayerDialog(playerid, 39, DIALOG_STYLE_LIST, "Неон, Номер, дополнительно", "Неон\nОткрыть багажник\
					\nЗакрыть багажник\nОткрыть капот\nЗакрыть капот\nВключить свет\nВыключить свет\nЗамкнуть двери\nОткрыть двери\
					\nВключить сигнализацию\nВыключить сигнализацию\nЗавести двигатель\nЗаглушить двигатель", "Выбор", "Отмена");
					dlgcont[playerid] = 39;
				}
				return 1;
			}
			if(listitem == 2)//открыть багажник
			{
				GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, true, objective);
				ShowPlayerDialog(playerid, 39, DIALOG_STYLE_LIST, "Неон, Номер, дополнительно", "Неон\nОткрыть багажник\
				\nЗакрыть багажник\nОткрыть капот\nЗакрыть капот\nВключить свет\nВыключить свет\nЗамкнуть двери\nОткрыть двери\
				\nВключить сигнализацию\nВыключить сигнализацию\nЗавести двигатель\nЗаглушить двигатель", "Выбор", "Отмена");
				dlgcont[playerid] = 39;
				return 1;
			}
			if(listitem == 3)//закрыть багажник
			{
				GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, false, objective);
				ShowPlayerDialog(playerid, 39, DIALOG_STYLE_LIST, "Неон, Номер, дополнительно", "Неон\nОткрыть багажник\
				\nЗакрыть багажник\nОткрыть капот\nЗакрыть капот\nВключить свет\nВыключить свет\nЗамкнуть двери\nОткрыть двери\
				\nВключить сигнализацию\nВыключить сигнализацию\nЗавести двигатель\nЗаглушить двигатель", "Выбор", "Отмена");
				dlgcont[playerid] = 39;
				return 1;
			}
			if(listitem == 4)//открыть капот
			{
				GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(carid, engine, lights, alarm, doors, true, boot, objective);
				ShowPlayerDialog(playerid, 39, DIALOG_STYLE_LIST, "Неон, Номер, дополнительно", "Неон\nОткрыть багажник\
				\nЗакрыть багажник\nОткрыть капот\nЗакрыть капот\nВключить свет\nВыключить свет\nЗамкнуть двери\nОткрыть двери\
				\nВключить сигнализацию\nВыключить сигнализацию\nЗавести двигатель\nЗаглушить двигатель", "Выбор", "Отмена");
				dlgcont[playerid] = 39;
				return 1;
			}
			if(listitem == 5)//закрыть капот
			{
				GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(carid, engine, lights, alarm, doors, false, boot, objective);
				ShowPlayerDialog(playerid, 39, DIALOG_STYLE_LIST, "Неон, Номер, дополнительно", "Неон\nОткрыть багажник\
				\nЗакрыть багажник\nОткрыть капот\nЗакрыть капот\nВключить свет\nВыключить свет\nЗамкнуть двери\nОткрыть двери\
				\nВключить сигнализацию\nВыключить сигнализацию\nЗавести двигатель\nЗаглушить двигатель", "Выбор", "Отмена");
				dlgcont[playerid] = 39;
				return 1;
			}
			if(listitem == 6)//включить свет
			{
				GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(carid, engine, true, alarm, doors, bonnet, boot, objective);
				ShowPlayerDialog(playerid, 39, DIALOG_STYLE_LIST, "Неон, Номер, дополнительно", "Неон\nОткрыть багажник\
				\nЗакрыть багажник\nОткрыть капот\nЗакрыть капот\nВключить свет\nВыключить свет\nЗамкнуть двери\nОткрыть двери\
				\nВключить сигнализацию\nВыключить сигнализацию\nЗавести двигатель\nЗаглушить двигатель", "Выбор", "Отмена");
				dlgcont[playerid] = 39;
				return 1;
			}
			if(listitem == 7)//выключить свет
			{
				GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(carid, engine, false, alarm, doors, bonnet, boot, objective);
				ShowPlayerDialog(playerid, 39, DIALOG_STYLE_LIST, "Неон, Номер, дополнительно", "Неон\nОткрыть багажник\
				\nЗакрыть багажник\nОткрыть капот\nЗакрыть капот\nВключить свет\nВыключить свет\nЗамкнуть двери\nОткрыть двери\
				\nВключить сигнализацию\nВыключить сигнализацию\nЗавести двигатель\nЗаглушить двигатель", "Выбор", "Отмена");
				dlgcont[playerid] = 39;
				return 1;
			}
			if(listitem == 8)//замкнуть двери
			{
				GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(carid, engine, lights, alarm, true, bonnet, boot, objective);
				ShowPlayerDialog(playerid, 39, DIALOG_STYLE_LIST, "Неон, Номер, дополнительно", "Неон\nОткрыть багажник\
				\nЗакрыть багажник\nОткрыть капот\nЗакрыть капот\nВключить свет\nВыключить свет\nЗамкнуть двери\nОткрыть двери\
				\nВключить сигнализацию\nВыключить сигнализацию\nЗавести двигатель\nЗаглушить двигатель", "Выбор", "Отмена");
				dlgcont[playerid] = 39;
				return 1;
			}
			if(listitem == 9)//открыть двери
			{
				GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(carid, engine, lights, alarm, false, bonnet, boot, objective);
				ShowPlayerDialog(playerid, 39, DIALOG_STYLE_LIST, "Неон, Номер, дополнительно", "Неон\nОткрыть багажник\
				\nЗакрыть багажник\nОткрыть капот\nЗакрыть капот\nВключить свет\nВыключить свет\nЗамкнуть двери\nОткрыть двери\
				\nВключить сигнализацию\nВыключить сигнализацию\nЗавести двигатель\nЗаглушить двигатель", "Выбор", "Отмена");
				dlgcont[playerid] = 39;
				return 1;
			}
			if(listitem == 10)//включить сигнализацию
			{
				GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(carid, engine, lights, true, doors, bonnet, boot, objective);
				ShowPlayerDialog(playerid, 39, DIALOG_STYLE_LIST, "Неон, Номер, дополнительно", "Неон\nОткрыть багажник\
				\nЗакрыть багажник\nОткрыть капот\nЗакрыть капот\nВключить свет\nВыключить свет\nЗамкнуть двери\nОткрыть двери\
				\nВключить сигнализацию\nВыключить сигнализацию\nЗавести двигатель\nЗаглушить двигатель", "Выбор", "Отмена");
				dlgcont[playerid] = 39;
				return 1;
			}
			if(listitem == 11)//выключить сигнализацию
			{
				GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(carid, engine, lights, false, doors, bonnet, boot, objective);
				ShowPlayerDialog(playerid, 39, DIALOG_STYLE_LIST, "Неон, Номер, дополнительно", "Неон\nОткрыть багажник\
				\nЗакрыть багажник\nОткрыть капот\nЗакрыть капот\nВключить свет\nВыключить свет\nЗамкнуть двери\nОткрыть двери\
				\nВключить сигнализацию\nВыключить сигнализацию\nЗавести двигатель\nЗаглушить двигатель", "Выбор", "Отмена");
				dlgcont[playerid] = 39;
				return 1;
			}
			if(listitem == 12)//завести двигатель
			{
				GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(carid, true, lights, alarm, doors, bonnet, boot, objective);
				ShowPlayerDialog(playerid, 39, DIALOG_STYLE_LIST, "Неон, Номер, дополнительно", "Неон\nОткрыть багажник\
				\nЗакрыть багажник\nОткрыть капот\nЗакрыть капот\nВключить свет\nВыключить свет\nЗамкнуть двери\nОткрыть двери\
				\nВключить сигнализацию\nВыключить сигнализацию\nЗавести двигатель\nЗаглушить двигатель", "Выбор", "Отмена");
				dlgcont[playerid] = 39;
				return 1;
			}
			if(listitem == 13)//заглушить двигатель
			{
				GetVehicleParamsEx(carid, engine, lights, alarm, doors, bonnet, boot, objective);
				SetVehicleParamsEx(carid, false, lights, alarm, doors, bonnet, boot, objective);
				ShowPlayerDialog(playerid, 39, DIALOG_STYLE_LIST, "Неон, Номер, дополнительно", "Неон\nОткрыть багажник\
				\nЗакрыть багажник\nОткрыть капот\nЗакрыть капот\nВключить свет\nВыключить свет\nЗамкнуть двери\nОткрыть двери\
				\nВключить сигнализацию\nВыключить сигнализацию\nЗавести двигатель\nЗаглушить двигатель", "Выбор", "Отмена");
				dlgcont[playerid] = 39;
			}
		}else{
			ShowPlayerDialog(playerid, 19, DIALOG_STYLE_LIST, "Тюнинг", "Диски\nГидравлика\nУдалить гидравлику\nЦвет\
		\nВинилы\nАрхангел тюнинг\nНеон, дополнительно\nВыключить фары\nУдалить детали транспорта\
		\nУдалить бампера\nПроколоть шины", "Выбор", "Отмена");
			dlgcont[playerid] = 19;
		}
		return 1;
	}
	if(dialogid == 40)
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(listitem == 0)
			{
				for(new i = 0; i < MAX_PLAYERS; i++)//убрать неон с любого транспорта
				{
					if(GetPlayerVehicleID(playerid) == neon[i][2])
					{
						DestroyObject(neon[i][0]);//убрать неон
						DestroyObject(neon[i][1]);//убрать неон
						neon[i][0] = 0;//присваиваем неону несуществующий номер объекта
						neon[i][1] = 0;//присваиваем неону несуществующий номер объекта
						neon[i][2] = 0;//несуществующий ид транспорта с неоном
					}
				}
				if(neon[playerid][0] != 0) { DestroyObject(neon[playerid][0]); }//убрать неон
				if(neon[playerid][1] != 0) { DestroyObject(neon[playerid][1]); }//убрать неон
				neon[playerid][0] = CreateObject(18647, 0, 0, 0, 0, 0, 0, 100.0);
				neon[playerid][1] = CreateObject(18647, 0, 0, 0, 0, 0, 0, 100.0);
				neon[playerid][2] = GetPlayerVehicleID(playerid);//ид транспорта, на который устанавливается неон
				AttachObjectToVehicle(neon[playerid][0], neon[playerid][2], -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], neon[playerid][2], 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				ShowPlayerDialog(playerid, 40, DIALOG_STYLE_LIST, "Неон", "{FF3300}Красный\n{0033CC}Синий\n{33FF00}Зелёный\
				\n{FFFF00}Жёлтый\n{E63E85}Розовый\nБелый\nУдалить Неон", "OK", "Отмена");
				dlgcont[playerid] = 40;
				return 1;
			}
			if(listitem == 1)
			{
				for(new i = 0; i < MAX_PLAYERS; i++)//убрать неон с любого транспорта
				{
					if(GetPlayerVehicleID(playerid) == neon[i][2])
					{
						DestroyObject(neon[i][0]);//убрать неон
						DestroyObject(neon[i][1]);//убрать неон
						neon[i][0] = 0;//присваиваем неону несуществующий номер объекта
						neon[i][1] = 0;//присваиваем неону несуществующий номер объекта
						neon[i][2] = 0;//несуществующий ид транспорта с неоном
					}
				}
				if(neon[playerid][0] != 0) { DestroyObject(neon[playerid][0]); }//убрать неон
				if(neon[playerid][1] != 0) { DestroyObject(neon[playerid][1]); }//убрать неон
				neon[playerid][0] = CreateObject(18648, 0, 0, 0, 0, 0, 0, 100.0);
				neon[playerid][1] = CreateObject(18648, 0, 0, 0, 0, 0, 0, 100.0);
				neon[playerid][2] = GetPlayerVehicleID(playerid);//ид транспорта, на который устанавливается неон
				AttachObjectToVehicle(neon[playerid][0], neon[playerid][2], -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], neon[playerid][2], 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				ShowPlayerDialog(playerid, 40, DIALOG_STYLE_LIST, "Неон", "{FF3300}Красный\n{0033CC}Синий\n{33FF00}Зелёный\
				\n{FFFF00}Жёлтый\n{E63E85}Розовый\nБелый\nУдалить Неон", "OK", "Отмена");
				dlgcont[playerid] = 40;
				return 1;
			}
			if(listitem == 2)
			{
				for(new i = 0; i < MAX_PLAYERS; i++)//убрать неон с любого транспорта
				{
					if(GetPlayerVehicleID(playerid) == neon[i][2])
					{
						DestroyObject(neon[i][0]);//убрать неон
						DestroyObject(neon[i][1]);//убрать неон
						neon[i][0] = 0;//присваиваем неону несуществующий номер объекта
						neon[i][1] = 0;//присваиваем неону несуществующий номер объекта
						neon[i][2] = 0;//несуществующий ид транспорта с неоном
					}
				}
				if(neon[playerid][0] != 0) { DestroyObject(neon[playerid][0]); }//убрать неон
				if(neon[playerid][1] != 0) { DestroyObject(neon[playerid][1]); }//убрать неон
				neon[playerid][0] = CreateObject(18649, 0, 0, 0, 0, 0, 0, 100.0);
				neon[playerid][1] = CreateObject(18649, 0, 0, 0, 0, 0, 0, 100.0);
				neon[playerid][2] = GetPlayerVehicleID(playerid);//ид транспорта, на который устанавливается неон
				AttachObjectToVehicle(neon[playerid][0], neon[playerid][2], -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], neon[playerid][2], 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				ShowPlayerDialog(playerid, 40, DIALOG_STYLE_LIST, "Неон", "{FF3300}Красный\n{0033CC}Синий\n{33FF00}Зелёный\
				\n{FFFF00}Жёлтый\n{E63E85}Розовый\nБелый\nУдалить Неон", "OK", "Отмена");
				dlgcont[playerid] = 40;
				return 1;
			}
			if(listitem == 3)
			{
				for(new i = 0; i < MAX_PLAYERS; i++)//убрать неон с любого транспорта
				{
					if(GetPlayerVehicleID(playerid) == neon[i][2])
					{
						DestroyObject(neon[i][0]);//убрать неон
						DestroyObject(neon[i][1]);//убрать неон
						neon[i][0] = 0;//присваиваем неону несуществующий номер объекта
						neon[i][1] = 0;//присваиваем неону несуществующий номер объекта
						neon[i][2] = 0;//несуществующий ид транспорта с неоном
					}
				}
				if(neon[playerid][0] != 0) { DestroyObject(neon[playerid][0]); }//убрать неон
				if(neon[playerid][1] != 0) { DestroyObject(neon[playerid][1]); }//убрать неон
				neon[playerid][0] = CreateObject(18650, 0, 0, 0, 0, 0, 0, 100.0);
				neon[playerid][1] = CreateObject(18650, 0, 0, 0, 0, 0, 0, 100.0);
				neon[playerid][2] = GetPlayerVehicleID(playerid);//ид транспорта, на который устанавливается неон
				AttachObjectToVehicle(neon[playerid][0], neon[playerid][2], -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], neon[playerid][2], 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				ShowPlayerDialog(playerid, 40, DIALOG_STYLE_LIST, "Неон", "{FF3300}Красный\n{0033CC}Синий\n{33FF00}Зелёный\
				\n{FFFF00}Жёлтый\n{E63E85}Розовый\nБелый\nУдалить Неон", "OK", "Отмена");
				dlgcont[playerid] = 40;
				return 1;
			}
			if(listitem == 4)
			{
				for(new i = 0; i < MAX_PLAYERS; i++)//убрать неон с любого транспорта
				{
					if(GetPlayerVehicleID(playerid) == neon[i][2])
					{
						DestroyObject(neon[i][0]);//убрать неон
						DestroyObject(neon[i][1]);//убрать неон
						neon[i][0] = 0;//присваиваем неону несуществующий номер объекта
						neon[i][1] = 0;//присваиваем неону несуществующий номер объекта
						neon[i][2] = 0;//несуществующий ид транспорта с неоном
					}
				}
				if(neon[playerid][0] != 0) { DestroyObject(neon[playerid][0]); }//убрать неон
				if(neon[playerid][1] != 0) { DestroyObject(neon[playerid][1]); }//убрать неон
				neon[playerid][0] = CreateObject(18651, 0, 0, 0, 0, 0, 0, 100.0);
				neon[playerid][1] = CreateObject(18651, 0, 0, 0, 0, 0, 0, 100.0);
				neon[playerid][2] = GetPlayerVehicleID(playerid);//ид транспорта, на который устанавливается неон
				AttachObjectToVehicle(neon[playerid][0], neon[playerid][2], -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], neon[playerid][2], 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				ShowPlayerDialog(playerid, 40, DIALOG_STYLE_LIST, "Неон", "{FF3300}Красный\n{0033CC}Синий\n{33FF00}Зелёный\
				\n{FFFF00}Жёлтый\n{E63E85}Розовый\nБелый\nУдалить Неон", "OK", "Отмена");
				dlgcont[playerid] = 40;
				return 1;
			}
			if(listitem == 5)
			{
				for(new i = 0; i < MAX_PLAYERS; i++)//убрать неон с любого транспорта
				{
					if(GetPlayerVehicleID(playerid) == neon[i][2])
					{
						DestroyObject(neon[i][0]);//убрать неон
						DestroyObject(neon[i][1]);//убрать неон
						neon[i][0] = 0;//присваиваем неону несуществующий номер объекта
						neon[i][1] = 0;//присваиваем неону несуществующий номер объекта
						neon[i][2] = 0;//несуществующий ид транспорта с неоном
					}
				}
				if(neon[playerid][0] != 0) { DestroyObject(neon[playerid][0]); }//убрать неон
				if(neon[playerid][1] != 0) { DestroyObject(neon[playerid][1]); }//убрать неон
				neon[playerid][0] = CreateObject(18652, 0, 0, 0, 0, 0, 0, 100.0);
				neon[playerid][1] = CreateObject(18652, 0, 0, 0, 0, 0, 0, 100.0);
				neon[playerid][2] = GetPlayerVehicleID(playerid);//ид транспорта, на который устанавливается неон
				AttachObjectToVehicle(neon[playerid][0], neon[playerid][2], -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(neon[playerid][1], neon[playerid][2], 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
				ShowPlayerDialog(playerid, 40, DIALOG_STYLE_LIST, "Неон", "{FF3300}Красный\n{0033CC}Синий\n{33FF00}Зелёный\
				\n{FFFF00}Жёлтый\n{E63E85}Розовый\nБелый\nУдалить Неон", "OK", "Отмена");
				dlgcont[playerid] = 40;
				return 1;
			}
			if(listitem == 6)
			{
				for(new i = 0; i < MAX_PLAYERS; i++)//убрать неон с любого транспорта
				{
					if(GetPlayerVehicleID(playerid) == neon[i][2])
					{
						DestroyObject(neon[i][0]);//убрать неон
						DestroyObject(neon[i][1]);//убрать неон
						neon[i][0] = 0;//присваиваем неону несуществующий номер объекта
						neon[i][1] = 0;//присваиваем неону несуществующий номер объекта
						neon[i][2] = 0;//несуществующий ид транспорта с неоном
					}
				}
				if(neon[playerid][0] != 0) { DestroyObject(neon[playerid][0]); }//убрать неон
				if(neon[playerid][1] != 0) { DestroyObject(neon[playerid][1]); }//убрать неон
				neon[playerid][0] = 0;//присваиваем неону несуществующий номер объекта
				neon[playerid][1] = 0;//присваиваем неону несуществующий номер объекта
				neon[playerid][2] = 0;//несуществующий ид транспорта с неоном
			}
			ShowPlayerDialog(playerid, 40, DIALOG_STYLE_LIST, "Неон", "{FF3300}Красный\n{0033CC}Синий\n{33FF00}Зелёный\
			\n{FFFF00}Жёлтый\n{E63E85}Розовый\nБелый\nУдалить Неон", "OK", "Отмена");
			dlgcont[playerid] = 40;
		}else{
			ShowPlayerDialog(playerid, 39, DIALOG_STYLE_LIST, "Неон, Номер, дополнительно", "Неон\nОткрыть багажник\
		\nЗакрыть багажник\nОткрыть капот\nЗакрыть капот\nВключить свет\nВыключить свет\nЗамкнуть двери\nОткрыть двери\
		\nВключить сигнализацию\nВыключить сигнализацию\nЗавести двигатель\nЗаглушить двигатель", "Выбор", "Отмена");
			dlgcont[playerid] = 39;
		}
		return 1;
	}
	if(dialogid == 41)
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(InpTxtControl(inputtext) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, "Ошибка, недопустимый символ:");
				SendClientMessage(playerid, COLOR_RED, "запрещённые коды, или знак процентов, или ~ !!!");
				ShowPlayerDialog(playerid, 41, DIALOG_STYLE_INPUT, "Сменить номер", "Введите номер авто", "OK", "Отмена");
				dlgcont[playerid] = 41;
				return 1;
			}
			if(!strlen(inputtext))
			{
				ShowPlayerDialog(playerid, 41, DIALOG_STYLE_INPUT, "Сменить номер", "Введите номер авто", "OK", "Отмена");
				dlgcont[playerid] = 41;
				return 1;
			}
			if(strlen(inputtext) > 10)
			{
				ShowPlayerDialog(playerid, 41, DIALOG_STYLE_INPUT, "Сменить номер", "Cлишком длинный номер!\
				\nВведите номер авто", "OK", "Отмена");
				dlgcont[playerid] = 41;
				return 1;
			}
			new Float:x, Float:y, Float:z, Float:ang, carid;
			carid = GetPlayerVehicleID(playerid);
			SetVehicleNumberPlate(carid, inputtext);
			GetVehiclePos(carid, x, y, z);
			GetVehicleZAngle(carid, ang);
			new Float:igx, Float:igy, Float:igz;
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))//дальнейшее выполняем если игрок в коннекте
				{
					if(GetPlayerVehicleID(i) == carid && playerid != i)
					{//если есть пассажир (пассажиры) в авто водителя, то:
						GetPlayerPos(i, igx, igy, igz);//высадить пассажира (пассажиров)
						SetPlayerPos(i, igx+3, igy+3, igz);
					}
					if(admper1[i] != 600 && admper1[i] == playerid)//если есть админ ведущий наблюдение,
					{//И этот админ наблюдает за игроком, то:
						admper5[i] = 2;//устанавливаем переключение наблюдения
					}
				}
			}
			SetVehicleToRespawn(carid);
			SetVehiclePos(carid, x, y, z);
			PutPlayerInVehicle(playerid, carid, 0);
			SetVehicleZAngle(carid, ang);
			ShowPlayerDialog(playerid, 39, DIALOG_STYLE_LIST, "Неон, Номер, дополнительно", "Неон\nОткрыть багажник\
			\nЗакрыть багажник\nОткрыть капот\nЗакрыть капот\nВключить свет\nВыключить свет\nЗамкнуть двери\nОткрыть двери\
			\nВключить сигнализацию\nВыключить сигнализацию\nЗавести двигатель\nЗаглушить двигатель", "Выбор", "Отмена");
			dlgcont[playerid] = 39;
		}else{
			ShowPlayerDialog(playerid, 39, DIALOG_STYLE_LIST, "Неон, Номер, дополнительно", "Неон\nОткрыть багажник\
		\nЗакрыть багажник\nОткрыть капот\nЗакрыть капот\nВключить свет\nВыключить свет\nЗамкнуть двери\nОткрыть двери\
		\nВключить сигнализацию\nВыключить сигнализацию\nЗавести двигатель\nЗаглушить двигатель", "Выбор", "Отмена");
			dlgcont[playerid] = 39;
		}
		return 1;
	}
	if(dialogid == 42)//меню Архангел тюнинг
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new vehicleid;
			if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
			{
				vehicleid = GetPlayerVehicleID(playerid);
				new cartype = GetVehicleModel(vehicleid);
				if(cartype != 562 && cartype != 560 && cartype != 565 &&
						cartype != 559 && cartype != 561 && cartype != 558)
				{
					SendClientMessage(playerid, COLOR_RED, " Вы должны быть в стритрейсерском авто !!!");
					ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
					\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
					\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
					\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
					\nВыхлоп стандарт", "OK", "Отмена");
					dlgcont[playerid] = 42;
					return 1;
				}
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Вы должны быть на месте водителя !");
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
				return 1;
			}
			new cartype = GetVehicleModel(vehicleid);
			if(listitem == 0)//Передний бампер X-flow
			{
				if(cartype == 562) AddVehicleComponent(vehicleid, 1172);
				if(cartype == 560) AddVehicleComponent(vehicleid, 1170);
				if(cartype == 565) AddVehicleComponent(vehicleid, 1152);
				if(cartype == 559) AddVehicleComponent(vehicleid, 1173);
				if(cartype == 561) AddVehicleComponent(vehicleid, 1157);
				if(cartype == 558) AddVehicleComponent(vehicleid, 1165);

				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
				return 1;
			}
			if(listitem == 1)//Передний бампер Alien
			{
				if(cartype == 562) AddVehicleComponent(vehicleid, 1171);
				if(cartype == 560) AddVehicleComponent(vehicleid, 1169);
				if(cartype == 565) AddVehicleComponent(vehicleid, 1153);
				if(cartype == 559) AddVehicleComponent(vehicleid, 1160);
				if(cartype == 561) AddVehicleComponent(vehicleid, 1155);
				if(cartype == 558) AddVehicleComponent(vehicleid, 1166);

				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
				return 1;
			}
			if(listitem == 2)//Передний бампер стандарт
			{
				new dop;
				dop = GetVehicleComponentInSlot(vehicleid, 10);
				if(dop != 0)
				{
					RemoveVehicleComponent(vehicleid, dop);
					PlayerPlaySound(playerid, 5202, 0.0, 0.0, 0.0);
				}
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
				return 1;
			}
			if(listitem == 3)//Задний бампер X-Flow
			{
				if(cartype == 562) AddVehicleComponent(vehicleid, 1148);
				if(cartype == 560) AddVehicleComponent(vehicleid, 1140);
				if(cartype == 565) AddVehicleComponent(vehicleid, 1151);
				if(cartype == 559) AddVehicleComponent(vehicleid, 1161);
				if(cartype == 561) AddVehicleComponent(vehicleid, 1156);
				if(cartype == 558) AddVehicleComponent(vehicleid, 1167);

				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
				return 1;
			}
			if(listitem == 4)//Задний бампер Alien
			{
				if(cartype == 562) AddVehicleComponent(vehicleid, 1149);
				if(cartype == 560) AddVehicleComponent(vehicleid, 1141);
				if(cartype == 565) AddVehicleComponent(vehicleid, 1150);
				if(cartype == 559) AddVehicleComponent(vehicleid, 1159);
				if(cartype == 561) AddVehicleComponent(vehicleid, 1154);
				if(cartype == 558) AddVehicleComponent(vehicleid, 1168);

				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
				return 1;
			}
			if(listitem == 5)//Задний бампер стандарт
			{
				new dop;
				dop = GetVehicleComponentInSlot(vehicleid, 11);
				if(dop != 0)
				{
					RemoveVehicleComponent(vehicleid, dop);
					PlayerPlaySound(playerid, 5202, 0.0, 0.0, 0.0);
				}
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
				return 1;
			}
			if(listitem == 6)//Спойлер X-Flow
			{
				if(cartype == 562) AddVehicleComponent(vehicleid, 1146);
				if(cartype == 560) AddVehicleComponent(vehicleid, 1139);
				if(cartype == 565) AddVehicleComponent(vehicleid, 1050);
				if(cartype == 559) AddVehicleComponent(vehicleid, 1158);
				if(cartype == 561) AddVehicleComponent(vehicleid, 1060);
				if(cartype == 558) AddVehicleComponent(vehicleid, 1163);

				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
				return 1;
			}
			if(listitem == 7)//Спойлер Alien
			{
				if(cartype == 562) AddVehicleComponent(vehicleid, 1147);
				if(cartype == 560) AddVehicleComponent(vehicleid, 1138);
				if(cartype == 565) AddVehicleComponent(vehicleid, 1049);
				if(cartype == 559) AddVehicleComponent(vehicleid, 1162);
				if(cartype == 561) AddVehicleComponent(vehicleid, 1058);
				if(cartype == 558) AddVehicleComponent(vehicleid, 1164);

				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
				return 1;
			}
			if(listitem == 8)//Удалить спойлер
			{
				new dop;
				dop = GetVehicleComponentInSlot(vehicleid, 0);
				if(dop != 0)
				{
					RemoveVehicleComponent(vehicleid, dop);
					PlayerPlaySound(playerid, 5202, 0.0, 0.0, 0.0);
				}
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
				return 1;
			}
			if(listitem == 9)//Боковые юбки X-Flow
			{
				if(cartype == 562)
				{
					AddVehicleComponent(vehicleid, 1041);
					AddVehicleComponent(vehicleid, 1039);
				}
				if(cartype == 560)
				{
					AddVehicleComponent(vehicleid, 1031);
					AddVehicleComponent(vehicleid, 1030);
				}
				if(cartype == 565)
				{
					AddVehicleComponent(vehicleid, 1052);
					AddVehicleComponent(vehicleid, 1048);
				}
				if(cartype == 559)
				{
					AddVehicleComponent(vehicleid, 1070);
					AddVehicleComponent(vehicleid, 1072);
				}
				if(cartype == 561)
				{
					AddVehicleComponent(vehicleid, 1057);
					AddVehicleComponent(vehicleid, 1063);
				}
				if(cartype == 558)
				{
					AddVehicleComponent(vehicleid, 1093);
					AddVehicleComponent(vehicleid, 1095);
				}

				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
				return 1;
			}
			if(listitem == 10)//Боковые юбки Alien
			{
				if(cartype == 562)
				{
					AddVehicleComponent(vehicleid, 1036);
					AddVehicleComponent(vehicleid, 1040);
				}
				if(cartype == 560)
				{
					AddVehicleComponent(vehicleid, 1026);
					AddVehicleComponent(vehicleid, 1027);
				}
				if(cartype == 565)
				{
					AddVehicleComponent(vehicleid, 1051);
					AddVehicleComponent(vehicleid, 1047);
				}
				if(cartype == 559)
				{
					AddVehicleComponent(vehicleid, 1069);
					AddVehicleComponent(vehicleid, 1071);
				}
				if(cartype == 561)
				{
					AddVehicleComponent(vehicleid, 1056);
					AddVehicleComponent(vehicleid, 1062);
				}
				if(cartype == 558)
				{
					AddVehicleComponent(vehicleid, 1090);
					AddVehicleComponent(vehicleid, 1094);
				}

				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
				return 1;
			}
			if(listitem == 11)//Боковые юбки стандарт
			{
				new dop;
				dop = GetVehicleComponentInSlot(vehicleid, 3);
				if(dop != 0)
				{
					RemoveVehicleComponent(vehicleid, dop);
					PlayerPlaySound(playerid, 5202, 0.0, 0.0, 0.0);
				}
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
				return 1;
			}
			if(listitem == 12)//Воздухозаборник X-Flow
			{
				if(cartype == 562) AddVehicleComponent(vehicleid, 1035);
				if(cartype == 560) AddVehicleComponent(vehicleid, 1033);
				if(cartype == 565) AddVehicleComponent(vehicleid, 1053);
				if(cartype == 559) AddVehicleComponent(vehicleid, 1068);
				if(cartype == 561) AddVehicleComponent(vehicleid, 1061);
				if(cartype == 558) AddVehicleComponent(vehicleid, 1091);

				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
				return 1;
			}
			if(listitem == 13)//Воздухозаборник Alien
			{
				if(cartype == 562) AddVehicleComponent(vehicleid, 1038);
				if(cartype == 560) AddVehicleComponent(vehicleid, 1032);
				if(cartype == 565) AddVehicleComponent(vehicleid, 1054);
				if(cartype == 559) AddVehicleComponent(vehicleid, 1067);
				if(cartype == 561) AddVehicleComponent(vehicleid, 1055);
				if(cartype == 558) AddVehicleComponent(vehicleid, 1088);

				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
				return 1;
			}
			if(listitem == 14)//Удалить воздухозаборник
			{
				new dop;
				dop = GetVehicleComponentInSlot(vehicleid, 2);
				if(dop != 0)
				{
					RemoveVehicleComponent(vehicleid, dop);
					PlayerPlaySound(playerid, 5202, 0.0, 0.0, 0.0);
				}
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
				return 1;
			}
			if(listitem == 15)//Выхлоп X-flow
			{
				if(cartype == 562) AddVehicleComponent(vehicleid, 1037);
				if(cartype == 560) AddVehicleComponent(vehicleid, 1029);
				if(cartype == 565) AddVehicleComponent(vehicleid, 1045);
				if(cartype == 559) AddVehicleComponent(vehicleid, 1066);
				if(cartype == 561) AddVehicleComponent(vehicleid, 1059);
				if(cartype == 558) AddVehicleComponent(vehicleid, 1089);

				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
				return 1;
			}
			if(listitem == 16)//Выхлоп Alien
			{
				if(cartype == 562) AddVehicleComponent(vehicleid, 1034);
				if(cartype == 560) AddVehicleComponent(vehicleid, 1028);
				if(cartype == 565) AddVehicleComponent(vehicleid, 1046);
				if(cartype == 559) AddVehicleComponent(vehicleid, 1065);
				if(cartype == 561) AddVehicleComponent(vehicleid, 1064);
				if(cartype == 558) AddVehicleComponent(vehicleid, 1092);

				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
				return 1;
			}
			if(listitem == 17)//Выхлоп стандарт
			{
				new dop;
				dop = GetVehicleComponentInSlot(vehicleid, 6);
				if(dop != 0)
				{
					RemoveVehicleComponent(vehicleid, dop);
					PlayerPlaySound(playerid, 5202, 0.0, 0.0, 0.0);
				}
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
			}
		}else{
			ShowPlayerDialog(playerid, 19, DIALOG_STYLE_LIST, "Тюнинг", "Диски\nГидравлика\nУдалить гидравлику\nЦвет\
		\nВинилы\nАрхангел тюнинг\nНеон, дополнительно\nВыключить фары\nУдалить детали транспорта\
		\nУдалить бампера\nПроколоть шины", "Выбор", "Отмена");
			dlgcont[playerid] = 19;
		}
		return 1;
	}
	if(dialogid == 19)//меню Тюнинг
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(listitem == 0)
			{
				ShowPlayerDialog(playerid, 37, DIALOG_STYLE_LIST, "Диски", "Shadow\nMega\nWires\nClassic\nRimshine\nCutter\
				\nTwist\nSwitch\nGrove\nImport\nDollar\nTrance\nAtomic\nСтандарт", "OK", "Отмена");
				dlgcont[playerid] = 37;
				return 1;
			}
			if(listitem == 1)
			{
				new vehicleid;
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					vehicleid = GetPlayerVehicleID(playerid);
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, " Вы должны быть на месте водителя !");
					ShowPlayerDialog(playerid, 19, DIALOG_STYLE_LIST, "Тюнинг", "Диски\nГидравлика\nУдалить гидравлику\nЦвет\
					\nВинилы\nАрхангел тюнинг\nНеон, дополнительно\nВыключить фары\nУдалить детали транспорта\
					\nУдалить бампера\nПроколоть шины", "Выбор", "Отмена");
					dlgcont[playerid] = 19;
					return 1;
				}
				AddVehicleComponent(vehicleid, 1087);
				PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				ShowPlayerDialog(playerid, 19, DIALOG_STYLE_LIST, "Тюнинг", "Диски\nГидравлика\nУдалить гидравлику\nЦвет\
				\nВинилы\nАрхангел тюнинг\nНеон, дополнительно\nВыключить фары\nУдалить детали транспорта\
				\nУдалить бампера\nПроколоть шины", "Выбор", "Отмена");
				dlgcont[playerid] = 19;
				return 1;
			}
			if(listitem == 2)
			{
				new vehicleid;
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					vehicleid = GetPlayerVehicleID(playerid);
				}
				else
				{
					SendClientMessage(playerid, COLOR_RED, " Вы должны быть на месте водителя !");
					ShowPlayerDialog(playerid, 19, DIALOG_STYLE_LIST, "Тюнинг", "Диски\nГидравлика\nУдалить гидравлику\nЦвет\
					\nВинилы\nАрхангел тюнинг\nНеон, дополнительно\nВыключить фары\nУдалить детали транспорта\
					\nУдалить бампера\nПроколоть шины", "Выбор", "Отмена");
					dlgcont[playerid] = 19;
					return 1;
				}
				new dop;
				dop = GetVehicleComponentInSlot(vehicleid, 9);
				if(dop != 0)
				{
					RemoveVehicleComponent(vehicleid, dop);
					PlayerPlaySound(playerid, 5202, 0.0, 0.0, 0.0);
				}
				ShowPlayerDialog(playerid, 19, DIALOG_STYLE_LIST, "Тюнинг", "Диски\nГидравлика\nУдалить гидравлику\nЦвет\
				\nВинилы\nАрхангел тюнинг\nНеон, дополнительно\nВыключить фары\nУдалить детали транспорта\
				\nУдалить бампера\nПроколоть шины", "Выбор", "Отмена");
				dlgcont[playerid] = 19;
				return 1;
			}
			if(listitem == 3)
			{
				ShowPlayerDialog(playerid, 17, DIALOG_STYLE_LIST, "Цвет", "{FF0000}Красный\n{991E1E}Кирпичный\n{332AE0}Синий\
				\n{A43FF9}Фиолетовый\n{FFFF33}Жёлтый\n{FF9933}Светло-жёлтый\n{28A937}Зеленый\n{1E9999}Бирюзовый\n{808080}Серый\
				\n{FFFFFF}Черный\n{FFFFFF}Белый", "OK", "Отмена");
				dlgcont[playerid] = 17;
				return 1;
			}
			if(listitem == 4)
			{
				ShowPlayerDialog(playerid, 38, DIALOG_STYLE_LIST, "Винилы", "Винил 1\nВинил 2\nВинил 3\nУдалить винил", "OK", "Отмена");
				dlgcont[playerid] = 38;
				return 1;
			}
			if(listitem == 5)
			{
				ShowPlayerDialog(playerid, 42, DIALOG_STYLE_LIST, "Архангел тюнинг", "Передний бампер X-flow\nПередний бампер Alien\
				\nПередний бампер стандарт\nЗадний бампер X-Flow\nЗадний бампер Alien\nЗадний бампер стандарт\nСпойлер X-Flow\
				\nСпойлер Alien\nУдалить спойлер\nБоковые юбки X-Flow\nБоковые юбки Alien\nБоковые юбки стандарт\
				\nВоздухозаборник X-Flow\nВоздухозаборник Alien\nУдалить воздухозаборник\nВыхлоп X-flow\nВыхлоп Alien\
				\nВыхлоп стандарт", "OK", "Отмена");
				dlgcont[playerid] = 42;
				return 1;
			}
			if(listitem == 6)
			{
				ShowPlayerDialog(playerid, 39, DIALOG_STYLE_LIST, "Неон, Номер, дополнительно", "Неон\nОткрыть багажник\
				\nЗакрыть багажник\nОткрыть капот\nЗакрыть капот\nВключить свет\nВыключить свет\nЗамкнуть двери\nОткрыть двери\
				\nВключить сигнализацию\nВыключить сигнализацию\nЗавести двигатель\nЗаглушить двигатель", "Выбор", "Отмена");
				dlgcont[playerid] = 39;
				return 1;
			}
			if(listitem == 7)
			{
				ShowPlayerDialog(playerid, 52, DIALOG_STYLE_LIST, "Выключить фары", "Левую переднюю\nПравую переднюю\nОбе передних\
				\nОбе задних\nЛевую переднюю и обе задних\nПравую переднюю и обе задних\nВсе\
				\nВключить все фары", "OK", "Отмена");
				dlgcont[playerid] = 52;
				return 1;
			}
			if(listitem == 8)
			{
				ShowPlayerDialog(playerid, 53, DIALOG_STYLE_LIST, "Удалить детали транспорта", "Капот\nБагажник\nКапот и багажник\
				\nЛевую дверь\nЛевую дверь и капот\nЛевую дверь и багажник\nЛевую дверь ' капот и багажник\nПравую дверь\
				\nПравую дверь и капот\nПравую дверь и багажник\nПравую дверь ' капот и багажник\nОбе двери\nОбе двери и капот\
				\nОбе двери и багажник\nОбе двери ' капот и багажник\nВосстановить все детали", "OK", "Отмена");
				dlgcont[playerid] = 53;
				return 1;
			}
			if(listitem == 9)
			{
				ShowPlayerDialog(playerid, 54, DIALOG_STYLE_LIST, "Удалить бампера", "Передний\nЗадний\nОба\
				\nВосстановить бампера", "OK", "Отмена");
				dlgcont[playerid] = 54;
				return 1;
			}
			if(listitem == 10)
			{
				ShowPlayerDialog(playerid, 51, DIALOG_STYLE_LIST, "Проколоть шины", "Правую заднюю / заднюю\nПравую переднюю / переднюю\
				\nОбе правых / обе\nЛевую заднюю\nОбе задних\nЛевую заднюю и правую переднюю\nЛевую заднюю и обе правых\
				\nЛевую переднюю\nЛевую переднюю и правую заднюю\nОбе передних\nЛевую переднюю и обе правых\nОбе левых\
				\nОбе левых и правую заднюю\nОбе левых и правую переднюю\nВсе\nВулканизировать все шины", "OK", "Отмена");
				dlgcont[playerid] = 51;
			}
		}else{
			ShowPlayerDialog(playerid, 10, DIALOG_STYLE_LIST, "Транспортное средство", "{FF0000}Тип транспорта\
				\n{FFFFFF}Тюнинг\n{FF0000}Отключить / включить автоматический ремонт\n{FFFFFF}Уничтожить транспорт\
				\n{FF0000}Флипнуть (Клавиша: 2)", "Выбор", "Отмена");
			dlgcont[playerid] = 10;
		}
		return 1;
	}
	if(dialogid == 51)//меню Проколоть шины
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new vehicleid;
			if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
			{
				vehicleid = GetPlayerVehicleID(playerid);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Вы должны быть на месте водителя !");
				ShowPlayerDialog(playerid, 51, DIALOG_STYLE_LIST, "Проколоть шины", "Правую заднюю / заднюю\nПравую переднюю / переднюю\
				\nОбе правых / обе\nЛевую заднюю\nОбе задних\nЛевую заднюю и правую переднюю\nЛевую заднюю и обе правых\
				\nЛевую переднюю\nЛевую переднюю и правую заднюю\nОбе передних\nЛевую переднюю и обе правых\nОбе левых\
				\nОбе левых и правую заднюю\nОбе левых и правую переднюю\nВсе\nВулканизировать все шины", "OK", "Отмена");
				dlgcont[playerid] = 51;
				return 1;
			}
			new panels, doors, lights, tires;
			GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
			if(listitem == 15)
			{
				autorepair[playerid] = 1;
				if(tires != 0)
				{
					UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, 0);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				}

				ShowPlayerDialog(playerid, 51, DIALOG_STYLE_LIST, "Проколоть шины", "Правую заднюю / заднюю\nПравую переднюю / переднюю\
				\nОбе правых / обе\nЛевую заднюю\nОбе задних\nЛевую заднюю и правую переднюю\nЛевую заднюю и обе правых\
				\nЛевую переднюю\nЛевую переднюю и правую заднюю\nОбе передних\nЛевую переднюю и обе правых\nОбе левых\
				\nОбе левых и правую заднюю\nОбе левых и правую переднюю\nВсе\nВулканизировать все шины", "OK", "Отмена");
				dlgcont[playerid] = 51;
				return 1;
			}
			new dop;
			dop = listitem;
			dop++;

			autorepair[playerid] = 0;
			UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, dop);
			PlayerPlaySound(playerid, 5202, 0.0, 0.0, 0.0);

			ShowPlayerDialog(playerid, 51, DIALOG_STYLE_LIST, "Проколоть шины", "Правую заднюю / заднюю\nПравую переднюю / переднюю\
			\nОбе правых / обе\nЛевую заднюю\nОбе задних\nЛевую заднюю и правую переднюю\nЛевую заднюю и обе правых\
			\nЛевую переднюю\nЛевую переднюю и правую заднюю\nОбе передних\nЛевую переднюю и обе правых\nОбе левых\
			\nОбе левых и правую заднюю\nОбе левых и правую переднюю\nВсе\nВулканизировать все шины", "OK", "Отмена");
			dlgcont[playerid] = 51;
		}else{
			ShowPlayerDialog(playerid, 19, DIALOG_STYLE_LIST, "Тюнинг", "Диски\nГидравлика\nУдалить гидравлику\nЦвет\
		\nВинилы\nАрхангел тюнинг\nНеон, дополнительно\nВыключить фары\nУдалить детали транспорта\
		\nУдалить бампера\nПроколоть шины", "Выбор", "Отмена");
			dlgcont[playerid] = 19;
		}
		return 1;
	}
	if(dialogid == 52)//меню Выключить фары
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new vehicleid;
			if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
			{
				vehicleid = GetPlayerVehicleID(playerid);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Вы должны быть на месте водителя !");
				ShowPlayerDialog(playerid, 52, DIALOG_STYLE_LIST, "Выключить фары", "Левую переднюю\nПравую переднюю\nОбе передних\
				\nОбе задних\nЛевую переднюю и обе задних\nПравую переднюю и обе задних\nВсе\
				\nВключить все фары", "OK", "Отмена");
				dlgcont[playerid] = 52;
				return 1;
			}
			new panels, doors, lights, tires;
			GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
			new dop;
			if(listitem == 0) dop = 3;
			if(listitem == 1) dop = 12;
			if(listitem == 2) dop = 15;
			if(listitem == 3) dop = 192;
			if(listitem == 4) dop = 195;
			if(listitem == 5) dop = 204;
			if(listitem == 6) dop = 207;
			if(listitem >= 0 && listitem <= 6)
			{
				autorepair[playerid] = 0;
				UpdateVehicleDamageStatus(vehicleid, panels, doors, dop, tires);
				PlayerPlaySound(playerid, 5202, 0.0, 0.0, 0.0);

				ShowPlayerDialog(playerid, 52, DIALOG_STYLE_LIST, "Выключить фары", "Левую переднюю\nПравую переднюю\nОбе передних\
				\nОбе задних\nЛевую переднюю и обе задних\nПравую переднюю и обе задних\nВсе\
				\nВключить все фары", "OK", "Отмена");
				dlgcont[playerid] = 52;
				return 1;
			}
			if(listitem == 7)
			{
				autorepair[playerid] = 1;
				if(lights != 0)
				{
					UpdateVehicleDamageStatus(vehicleid, panels, doors, 0, tires);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				}

				ShowPlayerDialog(playerid, 52, DIALOG_STYLE_LIST, "Выключить фары", "Левую переднюю\nПравую переднюю\nОбе передних\
				\nОбе задних\nЛевую переднюю и обе задних\nПравую переднюю и обе задних\nВсе\
				\nВключить все фары", "OK", "Отмена");
				dlgcont[playerid] = 52;
			}
		}else{
			ShowPlayerDialog(playerid, 19, DIALOG_STYLE_LIST, "Тюнинг", "Диски\nГидравлика\nУдалить гидравлику\nЦвет\
		\nВинилы\nАрхангел тюнинг\nНеон, дополнительно\nВыключить фары\nУдалить детали транспорта\
		\nУдалить бампера\nПроколоть шины", "Выбор", "Отмена");
			dlgcont[playerid] = 19;
		}
		return 1;
	}
	if(dialogid == 53)//меню Удалить детали транспорта
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new vehicleid;
			if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
			{
				vehicleid = GetPlayerVehicleID(playerid);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Вы должны быть на месте водителя !");
				ShowPlayerDialog(playerid, 53, DIALOG_STYLE_LIST, "Удалить детали транспорта", "Капот\nБагажник\nКапот и багажник\
				\nЛевую дверь\nЛевую дверь и капот\nЛевую дверь и багажник\nЛевую дверь ' капот и багажник\nПравую дверь\
				\nПравую дверь и капот\nПравую дверь и багажник\nПравую дверь ' капот и багажник\nОбе двери\nОбе двери и капот\
				\nОбе двери и багажник\nОбе двери ' капот и багажник\nВосстановить все детали", "OK", "Отмена");
				dlgcont[playerid] = 53;
				return 1;
			}
			new panels, doors, lights, tires;
			GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
			new dop;
			if(listitem == 0) dop = 4;
			if(listitem == 1) dop = 1024;
			if(listitem == 2) dop = 1028;
			if(listitem == 3) dop = 262144;
			if(listitem == 4) dop = 262148;
			if(listitem == 5) dop = 263168;
			if(listitem == 6) dop = 263172;
			if(listitem == 7) dop = 67108864;
			if(listitem == 8) dop = 67108868;
			if(listitem == 9) dop = 67109888;
			if(listitem == 10) dop = 67109892;
			if(listitem == 11) dop = 67371008;
			if(listitem == 12) dop = 67371012;
			if(listitem == 13) dop = 67372032;
			if(listitem == 14) dop = 67372036;
			if(listitem >= 0 && listitem <= 14)
			{
				autorepair[playerid] = 0;
				UpdateVehicleDamageStatus(vehicleid, panels, 0, lights, tires);
				UpdateVehicleDamageStatus(vehicleid, panels, dop, lights, tires);
				PlayerPlaySound(playerid, 5202, 0.0, 0.0, 0.0);

				ShowPlayerDialog(playerid, 53, DIALOG_STYLE_LIST, "Удалить детали транспорта", "Капот\nБагажник\nКапот и багажник\
				\nЛевую дверь\nЛевую дверь и капот\nЛевую дверь и багажник\nЛевую дверь ' капот и багажник\nПравую дверь\
				\nПравую дверь и капот\nПравую дверь и багажник\nПравую дверь ' капот и багажник\nОбе двери\nОбе двери и капот\
				\nОбе двери и багажник\nОбе двери ' капот и багажник\nВосстановить все детали", "OK", "Отмена");
				dlgcont[playerid] = 53;
				return 1;
			}
			if(listitem == 15)
			{
				autorepair[playerid] = 1;
				if(doors != 0)
				{
					UpdateVehicleDamageStatus(vehicleid, panels, 0, lights, tires);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				}

				ShowPlayerDialog(playerid, 53, DIALOG_STYLE_LIST, "Удалить детали транспорта", "Капот\nБагажник\nКапот и багажник\
				\nЛевую дверь\nЛевую дверь и капот\nЛевую дверь и багажник\nЛевую дверь ' капот и багажник\nПравую дверь\
				\nПравую дверь и капот\nПравую дверь и багажник\nПравую дверь ' капот и багажник\nОбе двери\nОбе двери и капот\
				\nОбе двери и багажник\nОбе двери ' капот и багажник\nВосстановить все детали", "OK", "Отмена");
				dlgcont[playerid] = 53;
			}
		}else{
			ShowPlayerDialog(playerid, 19, DIALOG_STYLE_LIST, "Тюнинг", "Диски\nГидравлика\nУдалить гидравлику\nЦвет\
		\nВинилы\nАрхангел тюнинг\nНеон, дополнительно\nВыключить фары\nУдалить детали транспорта\
		\nУдалить бампера\nПроколоть шины", "Выбор", "Отмена");
			dlgcont[playerid] = 19;
		}
		return 1;
	}
	if(dialogid == 54)//меню Удалить бампера
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new vehicleid;
			if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
			{
				vehicleid = GetPlayerVehicleID(playerid);
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, " Вы должны быть на месте водителя !");
				ShowPlayerDialog(playerid, 54, DIALOG_STYLE_LIST, "Удалить бампера", "Передний\nЗадний\nОба\
				\nВосстановить бампера", "OK", "Отмена");
				dlgcont[playerid] = 54;
				return 1;
			}
			new panels, doors, lights, tires;
			GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
			new dop;
			if(listitem == 0) dop = 3145728;
			if(listitem == 1) dop = 50331648;
			if(listitem == 2) dop = 53477376;
			if(listitem >= 0 && listitem <= 2)
			{
				autorepair[playerid] = 0;
				UpdateVehicleDamageStatus(vehicleid, 0, doors, lights, tires);
				UpdateVehicleDamageStatus(vehicleid, dop, doors, lights, tires);
				PlayerPlaySound(playerid, 5202, 0.0, 0.0, 0.0);

				ShowPlayerDialog(playerid, 54, DIALOG_STYLE_LIST, "Удалить бампера", "Передний\nЗадний\nОба\
				\nВосстановить бампера", "OK", "Отмена");
				dlgcont[playerid] = 54;
				return 1;
			}
			if(listitem == 3)
			{
				autorepair[playerid] = 1;
				if(panels != 0)
				{
					UpdateVehicleDamageStatus(vehicleid, 0, doors, lights, tires);
					PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				}

				ShowPlayerDialog(playerid, 54, DIALOG_STYLE_LIST, "Удалить бампера", "Передний\nЗадний\nОба\
				\nВосстановить бампера", "OK", "Отмена");
				dlgcont[playerid] = 54;
			}
		}else{
			ShowPlayerDialog(playerid, 19, DIALOG_STYLE_LIST, "Тюнинг", "Диски\nГидравлика\nУдалить гидравлику\nЦвет\
			\nВинилы\nАрхангел тюнинг\nНеон, дополнительно\nВыключить фары\nУдалить детали транспорта\
			\nУдалить бампера\nПроколоть шины", "Выбор", "Отмена");
			dlgcont[playerid] = 19;
		}
		return 1;
	}
	if(dialogid == 11)//меню Телепорты
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(listitem == 0)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = -2189.741699, Float:cor2 = 215.108718,
Float:cor3 = 166.666671+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//KTA CITY #1
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, -2189.741699, 215.108718, 166.666671+1);//KTA CITY #1
				}
				return 1;
			}
			if(listitem == 1)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = 2492.007568, Float:cor2 = -1666.290527,
Float:cor3 = 13.343750+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//KTA CITY #2 - В разработке еще
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, 2492.007568, -1666.290527, 13.343750+1);//KTA CITY #2 - В разработке еще
				}
				return 1;
			}
			if(listitem == 2)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = 1861.5938, Float:cor2 = -3872.6772,
Float:cor3 = 6.1355+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//гоночная трасса
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, 1861.5938, -3872.6772, 6.1355);//НЛО
					SetPlayerFacingAngle(playerid, 26.1056);
					SetCameraBehindPlayer(playerid);
				}
				return 1;
			}
			if(listitem == 3)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = 1533.5804, Float:cor2 = -1671.2289,
Float:cor3 = 13.3828+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Los-Santos
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, 1533.5804, -1671.2289, 13.3828+1);//Los-Santos
				}
				return 1;
			}
			if(listitem == 4)
			{
				DestrCar(playerid);
				SetPlayerInterior(playerid, 0);
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { SetPlayerVirtualWorld(playerid, 0); }
				SetPlayerPos(playerid, -49.9084, -292.6440, 5.4297+1);//Работа Дальнобойщика
				SetPlayerFacingAngle(playerid, 179.2402);
				SetCameraBehindPlayer(playerid);
				SendClientMessage(playerid,-1,"{FF0000}INFO:{FFFFFF} Для того чтобы начать работать подцепите \
				прицеп и введите [ {FF0000}/delivery {FFFFFF}]");
				return 1;
			}
			if(listitem == 5)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = -1979.0369, Float:cor2 = 884.4814,
Float:cor3 = 45.2031+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//San-Fierro
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, -1979.0369, 884.4814, 45.2031+1);//San-Fierro
				}
				return 1;
			}
			if(listitem == 6)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = 2216.6304, Float:cor2 = -1164.1626,
Float:cor3 = 25.7266+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Публичный дом
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, 2216.6304, -1164.1626, 25.7266+1);//Публичный дом
				}
				return 1;
			}
			if(listitem == 7)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = 2167.5251, Float:cor2 = 1680.6271,
Float:cor3 = 10.8203+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Las-Venturas
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, 2167.5251, 1680.6271, 10.8203+1);//Las-Venturas
				}
				return 1;
			}
			if(listitem == 8)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = -1309.1504, Float:cor2 = -193.5864,
Float:cor3 = 14.1484+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Аэропорт SF
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, -1309.1504, -193.5864, 14.1484);//Аэропорт SF
				}
				return 1;
			}
			if(listitem == 9)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = -1677.6132, Float:cor2 = -185.3914,
Float:cor3 = 14.1484+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Драг SF
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, -1677.6132, -185.3914, 14.1484);//Драг SF
				}
				return 1;
			}
			if(listitem == 10)
			{
				DestrCar(playerid);
				SetPlayerInterior(playerid, 0);
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { SetPlayerVirtualWorld(playerid, 0); }
				SetPlayerPos(playerid, -1523.867065, 808.849121, 7.187500);//Остров
				SetPlayerFacingAngle(playerid, 221.8081);
				return 1;
			}
			if(listitem == 11)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = -197.3836, Float:cor2 = 4118.6855,
Float:cor3 = 40.6392+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Сумо
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, -197.3836, 4118.6855, 40.6392+1);//Сумо
				}
				return 1;
			}
			if(listitem == 12)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = 406.1716, Float:cor2 = 2442.7126,
Float:cor3 = 16.5000+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Заброшенный Аэропорт
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, 406.1716, 2442.7126, 16.5000+1);//Заброшенный Аэропорт
				}
				return 1;
			}
			if(listitem == 13)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = -2322.2446, Float:cor2 = -1621.0658,
Float:cor3 = 483.7108+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Кавказские Горы
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, -2322.2446, -1621.0658, 483.7108+1);//Кавказские Горы
				}
				return 1;
			}
			if(listitem == 14)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = -2047.1281, Float:cor2 = -112.4230,
Float:cor3 = 35.2444+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Автошкола
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, -2047.1281, -112.4230, 35.2444+1);//Автошкола
				}
				return 1;
			}
			if(listitem == 15)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = 331.761199, Float:cor2 = -1846.912353,
Float:cor3 = 3.420019+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Каспийское Море
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, 331.761199, -1846.912353, 3.420019+1);//Каспийское Море
				}
				return 1;
			}
			if(listitem == 16)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = 370.03, Float:cor2 = -2026.16, Float:cor3 = 7.67+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Драг LS
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, 370.03, -2026.16, 7.67+1);//Драг LS
				}
				return 1;
			}
			if(listitem == 17)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = 5853.88, Float:cor2 = 894.52, Float:cor3 = 11.00+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//не  работает
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, 5853.88, 894.52, 11.00+1);//не  работает
				}
				return 1;
			}
			if(listitem == 18)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = 1520.302368, Float:cor2 = 1190.935913,
Float:cor3 = 10.812500+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Аэропорт LV
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, 1520.302368, 1190.935913, 10.812500+1);//Аэропорт LV
				}
				return 1;
			}
			if(listitem == 19)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = -1665.142822, Float:cor2 = 289.960113,
Float:cor3 = 7.187500+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Дрифт SF
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, -1665.142822, 289.960113, 7.187500+1);//Дрифт SF
				}
				return 1;
			}
			if(listitem == 20)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = 5813.85, Float:cor2 = 2907.17, Float:cor3 = 11.03+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//не  работает
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, 5813.85, 2907.17, 11.03+1);//не  работает
				}
				return 1;
			}
			if(listitem == 21)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = 6276.00, Float:cor2 = -3292.84, Float:cor3 = 11.63+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//не  работает
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, 6276.00, -3292.84, 11.63+1);//не  работает
				}
				return 1;
			}
			if(listitem == 22)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = -2589.0078, Float:cor2 = 1351.3533,
Float:cor3 = 7.0462+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Клуб Джиззи
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, -2589.0078, 1351.3533, 7.0462+1);//Клуб Джиззи
				}
				return 1;
			}
			if(listitem == 23)
			{
				DestrCar(playerid);
				SetPlayerInterior(playerid, 10);
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { SetPlayerVirtualWorld(playerid, 0); }
				SetPlayerPos(playerid, 1993.5897, 1017.8528, 994.8906+1);//Казино
				return 1;
			}
			if(listitem == 24)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = 2611.990722, Float:cor2 = -2240.047607,
Float:cor3 = 13.539176+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Спринт
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, 2611.990722, -2240.047607, 13.539176+1);//Спринт
				}
				return 1;
			}
			if(listitem == 25)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = 2028.4491, Float:cor2 = 1915.2181,
Float:cor3 = 11.9810+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Дрифт LV
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, 2028.4491, 1915.2181, 11.9810+1);//Дрифт LV
				}
				return 1;
			}
			if(listitem == 26)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = -1528.9232, Float:cor2 = 690.6976, Float:cor3 = 7.1875+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Акушинка №2
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, -1528.9232, 690.6976, 7.1875+1);//Акушинка №2
				}
				return 1;
			}
			if(listitem == 27)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = 1070.6412, Float:cor2 = 1302.4437,
Float:cor3 = 10.8203+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Гаражи LV
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, 1070.6412, 1302.4437, 10.8203+1);//Гаражи LV
				}
				return 1;
			}
			if(listitem == 28)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = 2326.265869, Float:cor2 = 1405.049682,
Float:cor3 = 42.820312+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Парковка LV
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, 2326.265869, 1405.049682, 42.820312+1);//Парковка LV
				}
				return 1;
			}
			if(listitem == 29)
			{
				DestrCar(playerid);
				ResetPlayerWeapons(playerid);
				GivePlayerWeapon(playerid, 46, 1);
				SetPlayerInterior(playerid, 0);
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { SetPlayerVirtualWorld(playerid, 0); }
				SetPlayerPos(playerid, -5.4018, 7533.9150, 3042.2119+1);//не  работает
				SetPlayerFacingAngle(playerid, 338.9953);
				return 1;
			}
			if(listitem == 30)
			{
				DestrCar(playerid);
				SetPlayerInterior(playerid, 0);
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { SetPlayerVirtualWorld(playerid, 0); }
				SetPlayerPos(playerid, 2804.8875, 1975.4552, 10.8203);//BMX Stunt
				SetPlayerFacingAngle(playerid, 332.9909);
				SetCameraBehindPlayer(playerid);
				return 1;
			}
			if(listitem == 31)
			{
				DestrCar(playerid);
				SetPlayerInterior(playerid, 0);
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { SetPlayerVirtualWorld(playerid, 0); }
				SetPlayerPos(playerid, -2675.2, 1221.7, 55);//Акушинка №1-Грозный
				SetPlayerFacingAngle(playerid, 90.0000);
				return 1;
			}
			if(listitem == 32)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = 2818.26, Float:cor2 = -5739.77, Float:cor3 = 11.99+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//не  работает
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, 2818.26, -5739.77, 11.99+1);//не  работает
					
				}
				return 1;
			}
			if(listitem == 33)
			{
				DestrCar(playerid);
				SetPlayerInterior(playerid, 4);
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { SetPlayerVirtualWorld(playerid, 0); }
				SetPlayerPos(playerid, -1298.4087, -700.3272, 1056.3361+1);//Cobra Gym
				return 1;
			}
			if(listitem == 34)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = 1962.7495, Float:cor2 = -2207.7957,
Float:cor3 = 13.5469+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//Аэропорт LS
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, 1962.7495, -2207.7957, 13.5469+1);//Аэропорт LS
				}
				return 1;
			}
			if(listitem == 35)
			{
				DestrCar(playerid);
				ResetPlayerWeapons(playerid);
				GivePlayerWeapon(playerid, 46, 1);
				SetPlayerInterior(playerid, 0);
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { SetPlayerVirtualWorld(playerid, 0); }
				SetPlayerPos(playerid, -2931.5227, -1876.5403, 3.3257+1);//не  работает
				SetPlayerFacingAngle(playerid, 89.7757);
				return 1;
			}
			if(listitem == 36)
			{
				DestrCar(playerid);
				ResetPlayerWeapons(playerid);
				GivePlayerWeapon(playerid, 46, 1);
				SetPlayerInterior(playerid, 0);
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { SetPlayerVirtualWorld(playerid, 0); }
				SetPlayerPos(playerid, -1468.8, 1489.3, 8.2);//корабль
				SetPlayerFacingAngle(playerid, 89.7757);
				return 1;
			}
			if(listitem == 37)
			{
				DestrCar(playerid);
				ResetPlayerWeapons(playerid);
				GivePlayerWeapon(playerid, 46, 1);
				SetPlayerInterior(playerid, 0);
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { SetPlayerVirtualWorld(playerid, 0); }
				SetPlayerPos(playerid, 1441.3021, -1707.8010, 915.3951+1);//не  работает
				SetPlayerFacingAngle(playerid, 359.5905);
				return 1;
			}
			if(listitem == 38)
			{
				DestrCar(playerid);
				SetPlayerInterior(playerid, 0);
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { SetPlayerVirtualWorld(playerid, 0); }
				SetPlayerPos(playerid, 3747.4922, -2227.7864, 561.10476+1);//не  работает
				SetPlayerFacingAngle(playerid, 0.1342);
				return 1;
			}
			if(listitem == 39)
			{
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { vw = 0; }
				if(GetPlayerState(playerid) == 2)//если игрок на месте водителя, то:
				{
					new regm = 1, per1, per2 = vw, Float:per3, Float:cor1 = -6027.63, Float:cor2 = 2858.69, Float:cor3 = 48.70+1;
					LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);//не  работает
				}
				else//иначе:
				{
					SetPlayerInterior(playerid, 0);
					SetPlayerVirtualWorld(playerid, vw);
					SetPlayerPos(playerid, -6027.63, 2858.69, 48.70+1);//не  работает
				}
				return 1;
			}
			if(listitem == 40)
			{
				DestrCar(playerid);
				SetPlayerInterior(playerid, 0);
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { SetPlayerVirtualWorld(playerid, 0); }
				SetPlayerPos(playerid, 2409.6289, 4175.1948, 54.3087+1);//не  работает
				SetPlayerFacingAngle(playerid, 90.1955);
				return 1;
			}
			if(listitem == 41)
			{
				DestrCar(playerid);
				ResetPlayerWeapons(playerid);
				GivePlayerWeapon(playerid, 46, 1);
				SetPlayerInterior(playerid, 0);
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { SetPlayerVirtualWorld(playerid, 0); }
				SetPlayerPos(playerid, -275.3545, -634.4316, 16500.8613+1);//не  работает
				SetPlayerFacingAngle(playerid, 357.7201);
				return 1;
			}
			if(listitem == 42)
			{
				DestrCar(playerid);
				SetPlayerInterior(playerid, 16);
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { SetPlayerVirtualWorld(playerid, 0); }
				SetPlayerPos(playerid, -1397.5270, 1251.5652, 1039.8672+1);//Vice Stadium
				return 1;
			}
			if(listitem == 43)
   			{
				DestrCar(playerid);
				SetPlayerInterior(playerid, 0);
				new vw = GetPlayerVirtualWorld(playerid);
				if(vw < 0 || vw > 990) { SetPlayerVirtualWorld(playerid, 0); }
				SetPlayerPos(playerid, -1712.6581,1055.0543,17.5859+1);//Fun Cars
				SetPlayerFacingAngle(playerid, 181.3420);
				SetCameraBehindPlayer(playerid);
				return 1;
			}
		}else{
			gettime(timedata[0], timedata[1]);
			format(string, sizeof(string), "{FFFFFF}Игровое меню. Точное время: {FF0000}%02d{FFFFFF}:{FF0000}%02d", timedata[0], timedata[1]);
			ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, string, "{FF0000}» Транспортное средство\n{FF0000}» Предметы\
			\n{FF0000}» Оружие\n{FF0000}» Телепорты\n{FF0000}» Аксессуары\n{FF0000}» Действия\n{FF0000}» Радио\n{FF0000}» DeathMatch\
			\n{FF0000}» Платные услуги\n{FF0000}» On-Line Администраторы\n{FF0000}» Правила сервера\n{FF0000}» Система банд", "Выбор", "Отмена");
			dlgcont[playerid] = 4;
		}
		return 1;
	}
	if(dialogid == 551)
	{
	    if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
		    if(listitem == 0)
		    {
		        SetPlayerPos(playerid, -2450.5779, -618.9788, 132.5571);
		        SetPlayerFacingAngle(playerid, 282.8377);
				SendClientMessage(playerid, COLOR_GREEN, "Вы успешно телепортировались на Двойной спот SF!");
			}
			if(listitem == 1)
			{
   				SetPlayerPos(playerid, -1357.2673,-1402.6748,110.9077);
		        SetPlayerFacingAngle(playerid, 113.4249);
				SendClientMessage(playerid, COLOR_GREEN, "Вы успешно телепортировались на Серпантин за городом!");
			}
			if(listitem == 2)
			{
   				SetPlayerPos(playerid, -766.1820,-1417.7314,85.1058);
		        SetPlayerFacingAngle(playerid, 358.2928);
				SendClientMessage(playerid, COLOR_GREEN, "Вы успешно телепортировались на Серпантин за городом 2!");
			}
			if(listitem == 3)
			{
   				SetPlayerPos(playerid, -293.6005,1476.8850,75.2149);
		        SetPlayerFacingAngle(playerid, 180.3178);
				SendClientMessage(playerid, COLOR_GREEN, "Вы успешно телепортировались на Серпантин в LV (KTA CITY #1)!");
			}
			if(listitem == 4)
			{
   				SetPlayerPos(playerid, -1481.2731,-491.5123,14.1416);
		        SetPlayerFacingAngle(playerid, 295.6371);
				SendClientMessage(playerid, COLOR_GREEN, "Вы успешно телепортировались на Круговой дрифт - аэропорт SF!");
			}
			if(listitem == 5)
			{
				SetPlayerPos(playerid, 1421.1486,-2278.3127,13.5469);
		        SetPlayerFacingAngle(playerid, 217.5585);
				SendClientMessage(playerid, COLOR_GREEN, "Вы успешно телепортировались на Круговой дрифт - аэропорт LS!");
			}
			if(listitem == 6)
			{
				SetPlayerPos(playerid, 1311.6256,-2049.1309,58.1726);
		        SetPlayerFacingAngle(playerid, 258.2520);
				SendClientMessage(playerid, COLOR_GREEN, "Вы успешно телепортировались на Мини-Серпантин LS!");
			}
			return 1;
		}
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(NRadio[playerid] == listitem && listitem == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя, у Вас уже выключено радио !");
				format(strdln, sizeof(strdln), "{027FFE}Выключить радио\n%s\n%s\n%s\n%s\n%s",
				NMRadio[1], NMRadio[2], NMRadio[3], NMRadio[4], NMRadio[5]);
				ShowPlayerDialog(playerid, 15, DIALOG_STYLE_LIST, "{91EF03}Радио", strdln, "OK", "Отмена");
				dlgcont[playerid] = 15;
				return 1;
			}
			if(NRadio[playerid] == listitem && listitem != 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Нельзя, у Вас уже включено выбранное Вами радио !");
				format(strdln, sizeof(strdln), "{027FFE}Выключить радио\n%s\n%s\n%s\n%s\n%s",
				NMRadio[1], NMRadio[2], NMRadio[3], NMRadio[4], NMRadio[5]);
				ShowPlayerDialog(playerid, 15, DIALOG_STYLE_LIST, "{91EF03}Радио", strdln, "OK", "Отмена");
				dlgcont[playerid] = 15;
				return 1;
			}
			if(listitem == 0)
			{
				NRadio[playerid] = 0;//несуществующее радио
				StopAudioStreamForPlayer(playerid);//отключим любой поток
				SendClientMessage(playerid, COLOR_GREY, " Вы выключили радио");
				printf("[radio] Игрок %s выключил радио.", RealName[playerid]);
			}
			else
			{
				NRadio[playerid] = listitem;//номер подключаемого радио
				StopAudioStreamForPlayer(playerid);//отключим любой другой поток
				PlayAudioStreamForPlayer(playerid, STRadio[listitem]);//подключим поток с музыкой
				format(string, sizeof(string), " Вы включили радио %s", NMRadio[listitem]);
				SendClientMessage(playerid, COLOR_GREY, string);
				printf("[radio] Игрок %s включил радио %s .", RealName[playerid], NMRadio[listitem]);
			}
		}else{
			gettime(timedata[0], timedata[1]);
			format(string, sizeof(string), "{FFFFFF}Игровое меню. Точное время: {FF0000}%02d{FFFFFF}:{FF0000}%02d", timedata[0], timedata[1]);
			ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, string, "{FF0000}» Транспортное средство\n{FF0000}» Предметы\
			\n{FF0000}» Оружие\n{FF0000}» Телепорты\n{FF0000}» Аксессуары\n{FF0000}» Действия\n{FF0000}» Радио\n{FF0000}» DeathMatch\
			\n{FF0000}» Платные услуги\n{FF0000}» On-Line Администраторы\n{FF0000}» Правила сервера\n{FF0000}» Система банд", "Выбор", "Отмена");
			dlgcont[playerid] = 4;
		}
		return 1;
	}
	if(dialogid == 43)//меню Анимации
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			SetTimerEx("DopAnim", 300, 0, "ii", playerid, listitem);
			if(listitem == 0)
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_HANDSUP);//поднять руки
				return 1;
			}
			if(listitem == 1)
			{
				ApplyAnimation(playerid,"PED", "SEAT_down", 4.1, 0, 0, 0, 1, 0, 0);//сесть-1
				return 1;
			}
			if(listitem == 2)
			{
				ApplyAnimation(playerid,"Attractors", "Stepsit_in", 4.1, 0, 0, 0, 1, 0, 0);//сесть-2
				return 1;
			}
			if(listitem == 3)
			{
				ApplyAnimation(playerid,"CRACK", "crckidle2", 4.1 ,0 ,0 ,0 ,1 ,0 ,0);//лечь
				return 1;
			}
			if(listitem == 4)
			{
				ApplyAnimation(playerid,"PED", "IDLE_chat", 4.1, 1, 1, 1, 0, 0, 0);//разговаривать
				return 1;
			}
			if(listitem == 5)
			{
				new Float:x, Float:y, Float:z, Float:x2, Float:y2, Float:z2, Float:angle, Float:angle2, Float:anglexx;
				GetPlayerPos(playerid, x, y, z);
				GetPlayerFacingAngle(playerid, angle);
				for(new i=0;i<MAX_PLAYERS;i++)
				{
					if(IsPlayerConnected(i))
					{
						GetPlayerPos(i, x2, y2, z2);
						GetPlayerFacingAngle(i, angle2);
						anglexx = angle - angle2;
						if(anglexx < 0) { anglexx = anglexx * -1; }
						if((-1 < (x-x2) < 1 && -1 < (y-y2) < 1 && -1 < (z-z2) < 1) &&
								(x != x2 || y != y2 || z != z2) && (anglexx > 150 && anglexx < 210))
						{
							ApplyAnimation(playerid,"GANGS", "hndshkfa", 4.1, 0, 0, 0, 0, 0, 0);//рукопожатие
							ApplyAnimation(i,"GANGS", "hndshkfa", 4.1, 0, 0, 0, 0, 0, 0);//рукопожатие
							return 1;
						}
					}
				}
				return 1;
			}
			if(listitem == 6)
			{
				new Float:x, Float:y, Float:z, Float:x2, Float:y2, Float:z2, Float:angle, Float:angle2, Float:anglexx;
				GetPlayerPos(playerid, x, y, z);
				GetPlayerFacingAngle(playerid, angle);
				for(new i=0;i<MAX_PLAYERS;i++)
				{
					if(IsPlayerConnected(i))
					{
						GetPlayerPos(i, x2, y2, z2);
						GetPlayerFacingAngle(i, angle2);
						anglexx = angle - angle2;
						if(anglexx < 0){anglexx = anglexx * -1;}
						if((-1 < (x-x2) < 1 && -1 < (y-y2) < 1 && -1 < (z-z2) < 1) &&
								(x != x2 || y != y2 || z != z2) && (anglexx > 150 && anglexx < 210))
						{
							ApplyAnimation(playerid,"KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0, 0);//поцелуй
							ApplyAnimation(i,"KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0, 0);//поцелуй
							SetTimerEx("DopAnim22", 400, 0, "ii", playerid, i);
							return 1;
						}
					}
				}
				return 1;
			}
			if(listitem == 7)
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);//звонить по телефону
				return 1;
			}
			if(listitem == 8)
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);//убрать телефон
				return 1;
			}
			if(listitem == 9)
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE1);//танец-1
				return 1;
			}
			if(listitem == 10)
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE2);//танец-2
				return 1;
			}
			if(listitem == 11)
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE3);//танец-3
				return 1;
			}
			if(listitem == 12)
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DANCE4);//танец-4
				return 1;
			}
			if(listitem == 13)
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);//спрайт
				return 1;
			}
			if(listitem == 14)
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);//сигарета
				return 1;
			}
			if(listitem == 15)
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);//пиво
				return 1;
			}
			if(listitem == 16)
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE);//вино
				return 1;
			}
			if(listitem == 17)
			{
				ApplyAnimation(playerid,"PED", "WALK_drunk", 4.1, 1, 1, 1, 0, 0, 0);//набухаться
				return 1;
			}
			if(listitem == 18)
			{
				SetPlayerSpecialAction(playerid, 68);//справить малую нужду
				return 1;
			}
			if(listitem == 19)
			{
				ClearAnimations(playerid);//остановить анимацию
				return 1;
			}
			if(listitem == 20)
			{
				SetPlayerDrunkLevel(playerid, 0);//убрать степень опьянения
				return 1;
			}
			if(listitem == 21)
			{
				SetPlayerAttachedObject(playerid, 2, 19066, 2, 0.13, 0.0, 0.0, 0.0, 80.0, 80.0);//новогодняя шапка
				return 1;
			}
			if(listitem == 22)
			{
				RemovePlayerAttachedObject(playerid, 2);//убрать новогоднюю шапку
			}
		}else{
			ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Действия", "Пополнить жизнь\nАнимации\nСменить цвет ника\
			\nСменить скин\nСменить время\nСменить стиль боя\nСамоубийство\
			\nПросмотреть собственную статистику", "Выбор", "Отмена");
			dlgcont[playerid] = 12;
		}
		return 1;
	}
	if(dialogid == 44)//смена цвета ника
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			ColorPlay[playerid] = ColNick[listitem];
			SetPlayerColor(playerid, ColorPlay[playerid]);
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				SetPlayerMarkerForPlayer(i, playerid, ColorPlay[playerid]);
			}
			if(PGang[playerid] > 0)//Gangs system
			{
				ShowPlayerDialog(playerid, 2, 0, "Информация.", "У Вас поменялся цвет ника, но цвет в чате\
				\nостался в цвете Вашей банды.", "OK", "");
			}
		}else{
			ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Действия", "Пополнить жизнь\nАнимации\nСменить цвет ника\
			\nСменить скин\nСменить время\nСменить стиль боя\nСамоубийство\
			\nПросмотреть собственную статистику", "Выбор", "Отмена");
			dlgcont[playerid] = 12;
		}
		return 1;
	}
	if(dialogid == 12)//меню Действия
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(listitem == 0)
			{
				SetPlayerHealth(playerid, 100);
				return 1;
			}
			if(listitem == 1)
			{
				ShowPlayerDialog(playerid, 43, DIALOG_STYLE_LIST, "Анимации", "Поднять руки\nСесть-1\nСесть-2\nЛечь\nРазговаривать\
				\nРукопожатие\nПоцелуй\nЗвонить по телефону\nУбрать телефон\nТанец-1\nТанец-2\nТанец-3\nТанец-4\nСпрайт\
				\nСигарета\nПиво\nВино\nНабухаться\nСправить малую нужду\nОстановить анимацию   / для малой нужды 'F' /\
				\nУбрать степень опьянения\nНовогодняя шапка\nУбрать новогоднюю шапку", "OK", "Отмена");
				dlgcont[playerid] = 43;
				return 1;
			}
			if(listitem == 2)
			{
				if(PGang[playerid] > 0 && PlayerInfo[playerid][pAdmin] == 0)//Gangs system
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка!", "Если Вы состоите в банде, то для изменения цвета\
					\nВам нужно быть админом!", "OK", "");
					return 1;
				}
				ShowPlayerDialog(playerid, 44, DIALOG_STYLE_LIST, "Цвет ника", "{FF0000}Красный\n{FF3F3F}Светло-красный\
				\n{FF3F00}Кирпичный\n{BF3F00}Коричневый\n{FF7F3F}Светло-коричневый\n{FF7F00}Оранжевый\n{FFFF00}Жёлтый\
				\n{3FFF3F}Светло-зелёный\n{FF0000}Зелёный\n{00BF00}Тёмно-зелёный\n{00FFFF}Бирюзовый\n{00BFFF}Голубой\
				\n{3F3FFF}Светло-синий\n{0000FF}Синий\n{7F3FFF}Светло-фиолетовый\n{7F00FF}Фиолетовый\
				\n{FF00FF}Сиреневый\n{7F7F7F}Серый\n{FFFFFF}Невидимый", "OK", "Отмена");
				dlgcont[playerid] = 44;
				return 1;
			}
			if(listitem == 3)
			{
				if(PGang[playerid] > 0 && GSkin[PGang[playerid]][GangLvl[playerid]-1] < 500 && PlayerInfo[playerid][pAdmin] == 0)//Gangs system
				{
					ShowPlayerDialog(playerid, 2, 0, "Ошибка!","Если Вы состоите в банде, и на Вашем уровне\
					\nустановлен скин, то для изменения скина\nВам нужно быть админом!","OK","");
					return 1;
				}
				ShowPlayerDialog(playerid, 16, DIALOG_STYLE_INPUT, "Смена скина", "Введите ид скина, на который Вы хотите сменить:",
				"Сменить", "Отмена");
				dlgcont[playerid] = 16;
				return 1;
			}
			if(listitem == 4)
			{
				ShowPlayerDialog(playerid, 18, DIALOG_STYLE_LIST, "Установка времени", "00:00\n01:00\n02:00\n03:00\n04:00\n05:00\
				\n06:00\n07:00\n08:00\n09:00\n10:00\n11:00\n12:00\n13:00\n14:00\n15:00\n16:00\n17:00\n18:00\n19:00\n20:00\n21:00\
				\n22:00\n23:00", "OK", "Отмена");
				dlgcont[playerid] = 18;
				return 1;
			}
			if(listitem == 5)
			{
				ShowPlayerDialog(playerid, 50, DIALOG_STYLE_LIST, "Смена стиля боя", "Normal\nBoxing\nKung Fu\nKnee-head\
				\nGrab-kick\nElbow", "OK", "Отмена");
				dlgcont[playerid] = 50;
				return 1;
			}
			if(listitem == 6)
			{
				SetPlayerArmour(playerid, 0);
				SetPlayerHealth(playerid, 0);
				return 1;
			}
			if(listitem == 7)
			{
				STATPlayer(playerid);
			}
		}else{
			gettime(timedata[0], timedata[1]);
			format(string, sizeof(string), "{FFFFFF}Игровое меню. Точное время: {FF0000}%02d{FFFFFF}:{FF0000}%02d", timedata[0], timedata[1]);
			ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, string, "{FF0000}» Транспортное средство\n{FF0000}» Предметы\
			\n{FF0000}» Оружие\n{FF0000}» Телепорты\n{FF0000}» Аксессуары\n{FF0000}» Действия\n{FF0000}» Радио\n{FF0000}» DeathMatch\
			\n{FF0000}» Платные услуги\n{FF0000}» On-Line Администраторы\n{FF0000}» Правила сервера\n{FF0000}» Система банд", "Выбор", "Отмена");
			dlgcont[playerid] = 4;
		}
		return 1;
	}
	if(dialogid == 49)
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(strlen(inputtext) < 3 || strlen(inputtext) > 20)
			{
				SendClientMessage(playerid, COLOR_RED, " Длина пароля должна быть от 3 до 20 символов !");
				ShowPlayerDialog(playerid, 49, DIALOG_STYLE_INPUT, "Смена пароля", "Введите новый пароль:", "Сменить", "Отмена");
				dlgcont[playerid] = 49;
				return 1;
			}
			if(PassControl(inputtext) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " В пароле можно использовать ТОЛЬКО латинские");
				SendClientMessage(playerid, COLOR_RED, " символы: от a до z , от A до Z , и цифры от 0 до 9 !");
				ShowPlayerDialog(playerid, 49, DIALOG_STYLE_INPUT, "Смена пароля", "Введите новый пароль:", "Сменить", "Отмена");
				dlgcont[playerid] = 49;
				return 1;
			}
			if(strlen(inputtext) > 0 && strcmp(inputtext, PlayerInfo[playerid][pKey], false) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Вы ввели свой старый пароль!!!");
				ShowPlayerDialog(playerid, 49, DIALOG_STYLE_INPUT, "Смена пароля", "Введите новый пароль:", "Сменить", "Отмена");
				dlgcont[playerid] = 49;
				return 1;
			}
			format(string, 256, " Игрок %s [%d] сменил свой пароль на (%s)", RealName[playerid], playerid, inputtext);
			print(string);
			format(string, 256, " Вы сменили свой пароль на (%s)", inputtext);
			SendClientMessage(playerid, COLOR_GREEN, string);
			strmid(PlayerInfo[playerid][pKey], inputtext, 0, strlen(inputtext), 255);
		}else{
			ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Действия", "Пополнить жизнь\nАнимации\nСменить цвет ника\
			\nСменить скин\nСменить время\nСменить стиль боя\nСамоубийство\
			\nПросмотреть собственную статистику", "Выбор", "Отмена");
			dlgcont[playerid] = 12;
		}
		return 1;
	}
	if(dialogid == 50)
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(listitem == 0)
			{
				SetPlayerFightingStyle(playerid, FIGHT_STYLE_NORMAL);
				return 1;
			}
			if(listitem == 1)
			{
				SetPlayerFightingStyle(playerid, FIGHT_STYLE_BOXING);
				return 1;
			}
			if(listitem == 2)
			{
				SetPlayerFightingStyle(playerid, FIGHT_STYLE_KUNGFU);
				return 1;
			}
			if(listitem == 3)
			{
				SetPlayerFightingStyle(playerid, FIGHT_STYLE_KNEEHEAD);
				return 1;
			}
			if(listitem == 4)
			{
				SetPlayerFightingStyle(playerid, FIGHT_STYLE_GRABKICK);
				return 1;
			}
			if(listitem == 5)
			{
				SetPlayerFightingStyle(playerid, FIGHT_STYLE_ELBOW);
			}
		}else{
			ShowPlayerDialog(playerid, 12, DIALOG_STYLE_LIST, "Действия", "Пополнить жизнь\nАнимации\nСменить цвет ника\
			\nСменить скин\nСменить время\nСменить стиль боя\nСамоубийство\
			\nПросмотреть собственную статистику", "Выбор", "Отмена");
			dlgcont[playerid] = 12;
		}
		return 1;
	}
	if(dialogid == 14)//Street JDM
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new locper = col4car[random(8)];
			if(listitem == 0)
			{
				new vehid = 562, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Elegy");
				return 1;
			}
			if(listitem == 1)
			{
				new vehid = 565, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Flash");
				return 1;
			}
			if(listitem == 2)
			{
				new vehid = 559, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Jester");
				return 1;
			}
			if(listitem == 3)
			{
				new vehid = 561, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Stratum");
				return 1;
			}
			if(listitem == 4)
			{
				new vehid = 560, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Sultan");
				return 1;
			}
			if(listitem == 5)
			{
				new vehid = 558, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Uranus");
			}
		}else{
			format(strdln, sizeof(strdln), "{FF0000}Street JDM\n{FFFFFF}Японские\n{FF0000}Легендарные Авто\
				\n{FFFFFF}JDM Pandem\n{FF0000}JDM Жигули\n{FFFFFF}Korch Жигули\n{FF0000}Китайцы\
				\n{FFFFFF}Камаз\n{FF0000}Американцы\n{FFFFFF}Транспорт для развлечения\
				\n{FF0000}Велосипеды и мотоциклы");
			format(strdln, sizeof(strdln), "%s\n{FFFFFF}Авто для транспортировки\
				\n{FF0000}Коммерческий и государственный транспорт\n{FFFFFF}Воздушный транспорт\n{FF0000}Водный транспорт\
				\n{FFFFFF}Радиоуправляемые авто", strdln);
			ShowPlayerDialog(playerid, 21, DIALOG_STYLE_LIST, "Тип транспорта", strdln, "Выбор", "Отмена");
			dlgcont[playerid] = 21;
		}
		return 1;
	}
	if(dialogid == 22)//Японские
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new locper = col4car[random(8)];
			if(listitem == 0)
			{
				new vehid = 429, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Banshee");
				return 1;
			}
			if(listitem == 1)
			{
				new vehid = 541, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Bullet");
				return 1;
			}
			if(listitem == 2)
			{
				new vehid = 415, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Cheetah");
				return 1;
			}
			if(listitem == 3)
			{
				new vehid = 480, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Comet");
				return 1;
			}
			if(listitem == 4)
			{
				new vehid = 434, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Hotknife");
				return 1;
			}
			if(listitem == 5)
			{
				new vehid = 494, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Hotring");
				return 1;
			}
			if(listitem == 6)
			{
				new vehid = 502, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Hotring A");
				return 1;
			}
			if(listitem == 7)
			{
				new vehid = 503, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Hotring B");
				return 1;
			}
			if(listitem == 8)
			{
				new vehid = 411, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Infernus");
				return 1;
			}
			if(listitem == 9)
			{
				new vehid = 506, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Super GT");
				return 1;
			}
			if(listitem == 10)
			{
				new vehid = 451, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Turismo");
				return 1;
			}
			if(listitem == 11)
			{
				new vehid = 477, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  ZR-350");
			}
		}else{
			format(strdln, sizeof(strdln), "{FF0000}Street JDM\n{FFFFFF}Японские\n{FF0000}Легендарные Авто\
				\n{FFFFFF}JDM Pandem\n{FF0000}JDM Жигули\n{FFFFFF}Korch Жигули\n{FF0000}Китайцы\
				\n{FFFFFF}Камаз\n{FF0000}Американцы\n{FFFFFF}Транспорт для развлечения\
				\n{FF0000}Велосипеды и мотоциклы");
			format(strdln, sizeof(strdln), "%s\n{FFFFFF}Авто для транспортировки\
				\n{FF0000}Коммерческий и государственный транспорт\n{FFFFFF}Воздушный транспорт\n{FF0000}Водный транспорт\
				\n{FFFFFF}Радиоуправляемые авто", strdln);
			ShowPlayerDialog(playerid, 21, DIALOG_STYLE_LIST, "Тип транспорта", strdln, "Выбор", "Отмена");
			dlgcont[playerid] = 21;
		}
		return 1;
	}
	if(dialogid == 23)//Легендарные Авто
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new locper = col4car[random(8)];
			if(listitem == 0)
			{
				new vehid = 536, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Blade");
				return 1;
			}
			if(listitem == 1)
			{
				new vehid = 575, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Broadway");
				return 1;
			}
			if(listitem == 2)
			{
				new vehid = 534, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Remington");
				return 1;
			}
			if(listitem == 3)
			{
				new vehid = 567, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Savanna");
				return 1;
			}
			if(listitem == 4)
			{
				new vehid = 535, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Slamvan");
				return 1;
			}
			if(listitem == 5)
			{
				new vehid = 576, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Tornado");
				return 1;
			}
			if(listitem == 6)
			{
				new vehid = 412, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Voodoo");
			}
		}else{
			format(strdln, sizeof(strdln), "{FF0000}Street JDM\n{FFFFFF}Японские\n{FF0000}Легендарные Авто\
				\n{FFFFFF}JDM Pandem\n{FF0000}JDM Жигули\n{FFFFFFKorch Жигули\n{FF0000}Китайцы\
				\n{FFFFFF}Камаз\n{FF0000}Американцы\n{FFFFFF}Транспорт для развлечения\
				\n{FF0000}Велосипеды и мотоциклы");
			format(strdln, sizeof(strdln), "%s\n{FFFFFF}Авто для транспортировки\
				\n{FF0000}Коммерческий и государственный транспорт\n{FFFFFF}Воздушный транспорт\n{FF0000}Водный транспорт\
				\n{FFFFFF}Радиоуправляемые авто", strdln);
			ShowPlayerDialog(playerid, 21, DIALOG_STYLE_LIST, "Тип транспорта", strdln, "Выбор", "Отмена");
			dlgcont[playerid] = 21;
		}
		return 1;
	}
	if(dialogid == 24)//JDM Pandem
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new locper = col4car[random(8)];
			if(listitem == 0)
			{
				new vehid = 602, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Alpha");
				return 1;
			}
			if(listitem == 1)
			{
				new vehid = 496, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Blista");
				return 1;
			}
			if(listitem == 2)
			{
				new vehid = 401, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Bravura");
				return 1;
			}
			if(listitem == 3)
			{
				new vehid = 518, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Buccaneer");
				return 1;
			}
			if(listitem == 4)
			{
				new vehid = 527, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Cadrona");
				return 1;
			}
			if(listitem == 5)
			{
				new vehid = 589, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Club");
				return 1;
			}
			if(listitem == 6)
			{
				new vehid = 419, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Esperanto");
				return 1;
			}
			if(listitem == 7)
			{
				new vehid = 587, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Euros");
				return 1;
			}
			if(listitem == 8)
			{
				new vehid = 533, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Feltzer");
				return 1;
			}
			if(listitem == 9)
			{
				new vehid = 526, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Fortune");
				return 1;
			}
			if(listitem == 10)
			{
				new vehid = 474, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Hermes");
				return 1;
			}
			if(listitem == 11)
			{
				new vehid = 545, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Hustler");
				return 1;
			}
			if(listitem == 12)
			{
				new vehid = 517, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Majestic");
				return 1;
			}
			if(listitem == 13)
			{
				new vehid = 600, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Picador");
				return 1;
			}
			if(listitem == 14)
			{
				new vehid = 491, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Virgo");
			}
		}else{
			format(strdln, sizeof(strdln), "{FF0000}Street JDM\n{FFFFFF}Японские\n{FF0000}Легендарные Авто\
				\n{FFFFFF}JDM Pandem\n{FF0000}JDM Жигули\n{FFFFFF}Korch Жигули\n{FF0000}Китайцы\
				\n{FFFFFF}Камаз\n{FF0000}Американцы\n{FFFFFF}Транспорт для развлечения\
				\n{FF0000}Велосипеды и мотоциклы");
			format(strdln, sizeof(strdln), "%s\n{FFFFFF}Авто для транспортировки\
				\n{FF0000}Коммерческий и государственный транспорт\n{FFFFFF}Воздушный транспорт\n{FF0000}Водный транспорт\
				\n{FFFFFF}Радиоуправляемые авто", strdln);
			ShowPlayerDialog(playerid, 21, DIALOG_STYLE_LIST, "Тип транспорта", strdln, "Выбор", "Отмена");
			dlgcont[playerid] = 21;
		}
		return 1;
	}
	if(dialogid == 25)//JDM Жигули
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new locper = col4car[random(8)];
			if(listitem == 0)
			{
				new vehid = 445, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Audi RS7");
				return 1;
			}
			if(listitem == 1)
			{
				new vehid = 507, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Nissan Skyline GT");
				return 1;
			}
			if(listitem == 2)
			{
				new vehid = 585, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Mazda RX-7");
				return 1;
			}
			if(listitem == 3)
			{
				new vehid = 466, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  BMW E30");
				return 1;
			}
			if(listitem == 4)
			{
				new vehid = 492, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Toyota Camry");
				return 1;
			}
			if(listitem == 5)
			{
				new vehid = 546, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Nissan Silvia Nismo");
				return 1;
			}
			if(listitem == 6)
			{
				new vehid = 551, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Toyota Mark 2");
				return 1;
			}
			if(listitem == 7)
			{
				new vehid = 516, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  ВАЗ Sport");
				return 1;
			}
			if(listitem == 8)
			{
				new vehid = 467, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Range Rover");
				return 1;
			}
			if(listitem == 9)
			{
				new vehid = 426, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Porsche 930 Turbo");
				return 1;
			}
			if(listitem == 10)
			{
				new vehid = 547, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Subaru Impreza");
				return 1;
			}
			if(listitem == 11)
			{
				new vehid = 405, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Priora Sport");
				return 1;
			}
			if(listitem == 12)
			{
				new vehid = 580, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  BMW M5 F90");
				return 1;
			}
			if(listitem == 13)
			{
				new vehid = 409, vehcol1 = 8, vehcol2 = 15, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Mercedes-Benz G63 AMG");
				return 1;
			}
			if(listitem == 14)
			{
				new vehid = 550, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Lamborghini Huracan");
				return 1;
			}
			if(listitem == 15)
			{
				new vehid = 566, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Nissan GT-R");
				return 1;
			}
			if(listitem == 16)
			{
				new vehid = 540, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Nissan Silvia S13");
				return 1;
			}
			if(listitem == 17)
			{
				new vehid = 421, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Porsche Cayman");
				return 1;
			}
			if(listitem == 18)
			{
				new vehid = 529, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Toyota Supra");
			}
			if(listitem == 19)
			{
				new vehid = 555, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Dodge Challenger SRT8");
				return 1;
			}
			if(listitem == 20)
			{
				new vehid = 410, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Toyota AE86");
				return 1;
			}
			if(listitem == 21)
			{
				new vehid = 436, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Mercedes GLE 63 AMG");
				return 1;
			}
			if(listitem == 22)
			{
				new vehid = 549, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Tesla Model S");
				return 1;
			}
			if(listitem == 23)
			{
				new vehid = 439, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Mersedes GT63S AMG");
				return 1;
			}
			if(listitem == 24)
			{
				new vehid = 597, vehcol1 = 0, vehcol2 = 1, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Nissan GT-R Police");
				return 1;
			}
		}else{
			format(strdln, sizeof(strdln), "{FF0000}Street JDM\n{FFFFFF}Японские\n{FF0000}Легендарные Авто\
				\n{FFFFFF}JDM Pandem\n{FF0000}JDM Жигули\n{FFFFFF}Korch Жигули\n{FF0000}Китайцы\
				\n{FFFFFF}Камаз\n{FF0000}Американцы\n{FFFFFF}Транспорт для развлечения\
				\n{FF0000}Велосипеды и мотоциклы");
			format(strdln, sizeof(strdln), "%s\n{FFFFFF}Авто для транспортировки\
				\n{FF0000}Коммерческий и государственный транспорт\n{FFFFFF}Воздушный транспорт\n{FF0000}Водный транспорт\
				\n{FFFFFF}Радиоуправляемые авто", strdln);
			ShowPlayerDialog(playerid, 21, DIALOG_STYLE_LIST, "Тип транспорта", strdln, "Выбор", "Отмена");
			dlgcont[playerid] = 21;
		}
		return 1;
	}
	if(dialogid == 26)//Korch Жигули
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new locper = col4car[random(8)];
			if(listitem == 0)
			{
				new vehid = 579, vehcol1 = 8, vehcol2 = 15, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Huntley");
				return 1;
			}
			if(listitem == 1)
			{
				new vehid = 400, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Landstalker");
				return 1;
			}
			if(listitem == 2)
			{
				new vehid = 404, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Perrenial");
				return 1;
			}
			if(listitem == 3)
			{
				new vehid = 489, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Rancher A");
				return 1;
			}
			if(listitem == 4)
			{
				new vehid = 505, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Rancher B");
				return 1;
			}
			if(listitem == 5)
			{
				new vehid = 479, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Regina");
				return 1;
			}
			if(listitem == 6)
			{
				new vehid = 442, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Romero");
				return 1;
			}
			if(listitem == 7)
			{
				new vehid = 458, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Solair");
			}
		}else{
			format(strdln, sizeof(strdln), "{FF0000}Street JDM\n{FFFFFF}Японские\n{FF0000}Легендарные Авто\
				\n{FFFFFF}JDM Pandem\n{FF0000}JDM Жигули\n{FFFFFF}Korch Жигули\n{FF0000}Китайцы\
				\n{FFFFFF}Камаз\n{FF0000}Американцы\n{FFFFFF}Транспорт для развлечения\
				\n{FF0000}Велосипеды и мотоциклы");
			format(strdln, sizeof(strdln), "%s\n{FFFFFF}Авто для транспортировки\
				\n{FF0000}Коммерческий и государственный транспорт\n{FFFFFF}Воздушный транспорт\n{FF0000}Водный транспорт\
				\n{FFFFFF}Радиоуправляемые авто", strdln);
			ShowPlayerDialog(playerid, 21, DIALOG_STYLE_LIST, "Тип транспорта", strdln, "Выбор", "Отмена");
			dlgcont[playerid] = 21;
		}
		return 1;
	}
	if(dialogid == 27)//Китайцы
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new locper = col4car[random(8)];
			if(listitem == 0)
			{
				new vehid = 402, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Buffalo");
				return 1;
			}
			if(listitem == 1)
			{
				new vehid = 542, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Clover");
				return 1;
			}
			if(listitem == 2)
			{
				new vehid = 603, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Phoenix");
				return 1;
			}
			if(listitem == 3)
			{
				new vehid = 475, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Sabre");
			}
		}else{
			format(strdln, sizeof(strdln), "{FF0000}Street JDM\n{FFFFFF}Японские\n{FF0000}Легендарные Авто\
				\n{FFFFFF}JDM Pandem\n{FF0000}JDM Жигули\n{FFFFFF}Korch Жигули\n{FF0000}Китайцы\
				\n{FFFFFF}Камаз\n{FF0000}Американцы\n{FFFFFF}Транспорт для развлечения\
				\n{FF0000}Велосипеды и мотоциклы");
			format(strdln, sizeof(strdln), "%s\n{FFFFFF}Авто для транспортировки\
				\n{FF0000}Коммерческий и государственный транспорт\n{FFFFFF}Воздушный транспорт\n{FF0000}Водный транспорт\
				\n{FFFFFF}Радиоуправляемые авто", strdln);
			ShowPlayerDialog(playerid, 21, DIALOG_STYLE_LIST, "Тип транспорта", strdln, "Выбор", "Отмена");
			dlgcont[playerid] = 21;
		}
		return 1;
	}
	if(dialogid == 28)//Камаз
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new locper = col4car[random(8)];
			if(listitem == 0)
			{
				new vehid = 499, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Benson");
				return 1;
			}
			if(listitem == 1)
			{
				new vehid = 498, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Boxville");
				return 1;
			}
			if(listitem == 2)
			{
				new vehid = 609, vehcol1 = 0, vehcol2 = 0, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Boxville-Black");
				return 1;
			}
			if(listitem == 3)
			{
				new vehid = 524, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Cement Truck");
				return 1;
			}
			if(listitem == 4)
			{
				new vehid = 532, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Combine Harvestor");
				return 1;
			}
			if(listitem == 5)
			{
				new vehid = 578, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  DFT-30");
				return 1;
			}
			if(listitem == 6)
			{
				new vehid = 486, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Dozer");
				return 1;
			}
			if(listitem == 7)
			{
				new vehid = 406, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Dumper");
				return 1;
			}
			if(listitem == 8)
			{
				new vehid = 573, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Dune");
				return 1;
			}
			if(listitem == 9)
			{
				new vehid = 455, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Flatbed");
				return 1;
			}
			if(listitem == 10)
			{
				new vehid = 588, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Hotdog");
				return 1;
			}
			if(listitem == 11)
			{
				new vehid = 403, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Linerunner");
				return 1;
			}
			if(listitem == 12)
			{
				new vehid = 423, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Mr Woopee");
				return 1;
			}
			if(listitem == 13)
			{
				new vehid = 414, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Mule");
				return 1;
			}
			if(listitem == 14)
			{
				new vehid = 443, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Packer");
				return 1;
			}
			if(listitem == 15)
			{
				new vehid = 515, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Roadtrain");
				return 1;
			}
			if(listitem == 16)
			{
				new vehid = 514, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Tanker");
				return 1;
			}
			if(listitem == 17)
			{
				new vehid = 531, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Tractor");
				return 1;
			}
			if(listitem == 18)
			{
				new vehid = 456, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Yankee");
			}
		}else{
			format(strdln, sizeof(strdln), "{FF0000}Street JDM\n{FFFFFF}Японские\n{FF0000}Легендарные Авто\
				\n{FFFFFF}JDM Pandem\n{FF0000}JDM Жигули\n{FFFFFF}Korch Жигули\n{FF0000}Китайцы\
				\n{FFFFFF}Камаз\n{FF0000}Американцы\n{FFFFFF}Транспорт для развлечения\
				\n{FF0000}Велосипеды и мотоциклы");
			format(strdln, sizeof(strdln), "%s\n{FFFFFF}Авто для транспортировки\
				\n{FF0000}Коммерческий и государственный транспорт\n{FFFFFF}Воздушный транспорт\n{FF0000}Водный транспорт\
				\n{FFFFFF}Радиоуправляемые авто", strdln);
			ShowPlayerDialog(playerid, 21, DIALOG_STYLE_LIST, "Тип транспорта", strdln, "Выбор", "Отмена");
			dlgcont[playerid] = 21;
		}
		return 1;
	}
	if(dialogid == 29)//Американцы
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new locper = col4car[random(8)];
			if(listitem == 0)
			{
				new vehid = 459, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Topfun");
				return 1;
			}
			if(listitem == 1)
			{
				new vehid = 422, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Bobcat");
				return 1;
			}
			if(listitem == 2)
			{
				new vehid = 482, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Burrito");
				return 1;
			}
			if(listitem == 3)
			{
				new vehid = 530, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Forklift");
				return 1;
			}
			if(listitem == 4)
			{
				new vehid = 418, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Moonbeam");
				return 1;
			}
			if(listitem == 5)
			{
				new vehid = 572, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Mower");
				return 1;
			}
			if(listitem == 6)
			{
				new vehid = 582, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Newsvan");
				return 1;
			}
			if(listitem == 7)
			{
				new vehid = 413, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Pony");
				return 1;
			}
			if(listitem == 8)
			{
				new vehid = 440, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Rumpo");
				return 1;
			}
			if(listitem == 9)
			{
				new vehid = 543, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Sadler");
				return 1;
			}
			if(listitem == 10)
			{
				new vehid = 583, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Tug");
				return 1;
			}
			if(listitem == 11)
			{
				new vehid = 478, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Walton");
				return 1;
			}
			if(listitem == 12)
			{
				new vehid = 554, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Yosemite");
			}
		}else{
			format(strdln, sizeof(strdln), "{FF0000}Street JDM\n{FFFFFF}Японские\n{FF0000}Легендарные Авто\
				\n{FFFFFF}JDM Pandem\n{FF0000}JDM Жигули\n{FFFFFF}Korch Жигули\n{FF0000}Китайцы\
				\n{FFFFFF}Камаз\n{FF0000}Американцы\n{FFFFFF}Транспорт для развлечения\
				\n{FF0000}Велосипеды и мотоциклы");
			format(strdln, sizeof(strdln), "%s\n{FFFFFF}Авто для транспортировки\
				\n{FF0000}Коммерческий и государственный транспорт\n{FFFFFF}Воздушный транспорт\n{FF0000}Водный транспорт\
				\n{FFFFFF}Радиоуправляемые авто", strdln);
			ShowPlayerDialog(playerid, 21, DIALOG_STYLE_LIST, "Тип транспорта", strdln, "Выбор", "Отмена");
			dlgcont[playerid] = 21;
		}
		return 1;
	}
	if(dialogid == 30)//транспорт для развлечения
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new locper = col4car[random(8)];
			if(listitem == 0)
			{
				new vehid = 568, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Bandito");
				return 1;
			}
			if(listitem == 1)
			{
				new vehid = 424, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  BF Injection");
				return 1;
			}
			if(listitem == 2)
			{
				new vehid = 504, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Bloodring Banger");
				return 1;
			}
			if(listitem == 3)
			{
				new vehid = 457, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Caddy");
				return 1;
			}
			if(listitem == 4)
			{
				new vehid = 483, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Camper");
				return 1;
			}
			if(listitem == 5)
			{
				new vehid = 508, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Journey");
				return 1;
			}
			if(listitem == 6)
			{
				new vehid = 571, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Kart");
				return 1;
			}
			if(listitem == 7)
			{
				new vehid = 500, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Mesa");
				return 1;
			}
			if(listitem == 8)
			{
				new vehid = 444, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Monster");
				return 1;
			}
			if(listitem == 9)
			{
				new vehid = 556, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Monster A");
				return 1;
			}
			if(listitem == 10)
			{
				new vehid = 557, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Monster B");
				return 1;
			}
			if(listitem == 11)
			{
				new vehid = 471, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Quad");
				return 1;
			}
			if(listitem == 12)
			{
				new vehid = 495, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Sandking");
				return 1;
			}
			if(listitem == 13)
			{
				new vehid = 539, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Vortex");
				return 1;
			}
			if(listitem == 14)
			{
				if(playcar[playerid] == 0)
				{
					SetPlayerSpecialAction(playerid, 2);
					SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  JetPack");
				}else{
					if(neon[playerid][0] != 0) { DestroyObject(neon[playerid][0]); }//убрать неон
					if(neon[playerid][1] != 0) { DestroyObject(neon[playerid][1]); }//убрать неон
					neon[playerid][0] = 0;//присваиваем неону несуществующий номер объекта
					neon[playerid][1] = 0;//присваиваем неону несуществующий номер объекта
					neon[playerid][2] = 0;//несуществующий ид транспорта с неоном
					for(new i = 0; i < MAX_PLAYERS; i++)//поиск и удаление чужого неона
					{
						if(playcar[playerid] == neon[i][2])
						{
							DestroyObject(neon[i][0]);//убрать неон
							DestroyObject(neon[i][1]);//убрать неон
							neon[i][0] = 0;//присваиваем неону несуществующий номер объекта
							neon[i][1] = 0;//присваиваем неону несуществующий номер объекта
							neon[i][2] = 0;//несуществующий ид транспорта с неоном
						}
					}
					DestroyVehicle(playcar[playerid]);//уничтожить свой транспорт
					playcar[playerid] = 0;//несуществующий ид транспорта
					SetPlayerSpecialAction(playerid, 2);
					SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  JetPack");
				}
			}
		}else{
			format(strdln, sizeof(strdln), "{FF0000}отечественные\n{FFFFFF}спорткары\n{FF0000}отечественные №2\
				\n{FFFFFF}отечественные №3\n{FF0000}иномарки\n{FFFFFF}# Niva меню\n{FF0000}•Легенды - Известные авто\
				\n{FFFFFF}Korch Жигули\n{FF0000}Лёгкие грузовики и фургоны\n{FFFFFF}Транспорт для развлечения\
				\n{FF0000}Велосипеды и мотоциклы");
			format(strdln, sizeof(strdln), "%s\n{FFFFFF}Авто для транспортировки\
				\n{FF0000}Коммерческий и государственный транспорт\n{FFFFFF}Воздушный транспорт\n{FF0000}Водный транспорт\
				\n{FFFFFF}Радиоуправляемые авто", strdln);
			ShowPlayerDialog(playerid, 21, DIALOG_STYLE_LIST, "Тип транспорта", strdln, "Выбор", "Отмена");
			dlgcont[playerid] = 21;
		}
		return 1;
	}
	if(dialogid == 31)//велосипеды и мотоциклы
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new locper = col4car[random(8)];
			if(listitem == 0)
			{
				new vehid = 481, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  BMX");
				return 1;
			}
			if(listitem == 1)
			{
				new vehid = 509, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Bike");
				return 1;
			}
			if(listitem == 2)
			{
				new vehid = 510, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Mountain Bike");
				return 1;
			}
			if(listitem == 3)
			{
				new vehid = 581, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  BF-400");
				return 1;
			}
			if(listitem == 4)
			{
				new vehid = 462, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Faggio");
				return 1;
			}
			if(listitem == 5)
			{
				new vehid = 521, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  FCR-900");
				return 1;
			}
			if(listitem == 6)
			{
				new vehid = 463, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Freeway");
				return 1;
			}
			if(listitem == 7)
			{
				new vehid = 522, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  NRG-500");
				return 1;
			}
			if(listitem == 8)
			{
				new vehid = 461, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  PCJ-600");
				return 1;
			}
			if(listitem == 9)
			{
				new vehid = 448, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Pizzaboy");
				return 1;
			}
			if(listitem == 10)
			{
				new vehid = 468, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Sanchez");
				return 1;
			}
			if(listitem == 11)
			{
				new vehid = 586, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Wayfarer");
			}
		}else{
			format(strdln, sizeof(strdln), "{FF0000}отечественные\n{FFFFFF}спорткары\n{FF0000}отечественные №2\
				\n{FFFFFF}отечественные №3\n{FF0000}иномарки\n{FFFFFF}# Niva меню\n{FF0000}•Легенды - Известные авто\
				\n{FFFFFF}Korch Жигули\n{FF0000}Лёгкие грузовики и фургоны\n{FFFFFF}Транспорт для развлечения\
				\n{FF0000}Велосипеды и мотоциклы");
			format(strdln, sizeof(strdln), "%s\n{FFFFFF}Авто для транспортировки\
				\n{FF0000}Коммерческий и государственный транспорт\n{FFFFFF}Воздушный транспорт\n{FF0000}Водный транспорт\
				\n{FFFFFF}Радиоуправляемые авто", strdln);
			ShowPlayerDialog(playerid, 21, DIALOG_STYLE_LIST, "Тип транспорта", strdln, "Выбор", "Отмена");
			dlgcont[playerid] = 21;
		}
		return 1;
	}
	if(dialogid == 32)//авто для транспортировки
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new locper = col4car[random(8)];
			if(listitem == 0)
			{
				new vehid = 485, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Baggage");
				return 1;
			}
			if(listitem == 1)
			{
				new vehid = 431, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Bus");
				return 1;
			}
			if(listitem == 2)
			{
				new vehid = 438, vehcol1 = 6, vehcol2 = 6, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Cabbie");
				return 1;
			}
			if(listitem == 3)
			{
				new vehid = 437, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Coach");
				return 1;
			}
			if(listitem == 4)
			{
				new vehid = 574, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Sweeper");
				return 1;
			}
			if(listitem == 5)
			{
				new vehid = 420, vehcol1 = 6, vehcol2 = 6, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Taxi");
				return 1;
			}
			if(listitem == 6)
			{
				new vehid = 525, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Towtruck");
				return 1;
			}
			if(listitem == 7)
			{
				new vehid = 408, vehcol1 = locper, vehcol2 = locper, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Trashmaster");
				return 1;
			}
			if(listitem == 8)
			{
				new vehid = 552, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Utility Van");
			}
		}else{
			format(strdln, sizeof(strdln), "{FF0000}отечественные\n{FFFFFF}спорткары\n{FF0000}отечественные №2\
				\n{FFFFFF}отечественные №3\n{FF0000}иномарки\n{FFFFFF}# Niva меню\n{FF0000}•Легенды - Известные авто\
				\n{FFFFFF}Korch Жигули\n{FF0000}Лёгкие грузовики и фургоны\n{FFFFFF}Транспорт для развлечения\
				\n{FF0000}Велосипеды и мотоциклы");
			format(strdln, sizeof(strdln), "%s\n{FFFFFF}Авто для транспортировки\
				\n{FF0000}Коммерческий и государственный транспорт\n{FFFFFF}Воздушный транспорт\n{FF0000}Водный транспорт\
				\n{FFFFFF}Радиоуправляемые авто", strdln);
			ShowPlayerDialog(playerid, 21, DIALOG_STYLE_LIST, "Тип транспорта", strdln, "Выбор", "Отмена");
			dlgcont[playerid] = 21;
		}
		return 1;
	}
	if(dialogid == 33)//коммерческий и государственный транспорт
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(listitem == 0)
			{
				new vehid = 416, vehcol1 = 8, vehcol2 = 3, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Ambulance");
				return 1;
			}
			if(listitem == 1)
			{
				new vehid = 433, vehcol1 = 0, vehcol2 = 1, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Barracks");
				return 1;
			}
			if(listitem == 2)
			{
				new vehid = 427, vehcol1 = 0, vehcol2 = 1, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Enforcer");
				return 1;
			}
			if(listitem == 3)
			{
				new vehid = 490, vehcol1 = 0, vehcol2 = 1, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  FBI Rancher");
				return 1;
			}
			if(listitem == 4)
			{
				new vehid = 528, vehcol1 = 0, vehcol2 = 1, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  FBI Truck");
				return 1;
			}
			if(listitem == 5)
			{
				new vehid = 407, vehcol1 = 3, vehcol2 = 8, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Fire Truck");
				return 1;
			}
			if(listitem == 6)
			{
				new vehid = 544, vehcol1 = 3, vehcol2 = 8, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Fire Truck A");
				return 1;
			}
			if(listitem == 7)
			{
				new vehid = 523, vehcol1 = 0, vehcol2 = 1, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  HPV-1000");
				return 1;
			}
			if(listitem == 8)
			{
				new vehid = 470, vehcol1 = 0, vehcol2 = 1, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Patriot");
				return 1;
			}
			if(listitem == 9)
			{
				new vehid = 596, vehcol1 = 0, vehcol2 = 1, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Police Los Santos");
				return 1;
			}
			if(listitem == 10)
			{
				new vehid = 598, vehcol1 = 0, vehcol2 = 1, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Police Las Venturas");
				return 1;
			}
			if(listitem == 11)
			{
				new vehid = 599, vehcol1 = 0, vehcol2 = 1, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Police Ranger");
				return 1;
			}
			if(listitem == 12)
			{
				if(GetPlayerMoney(playerid) < 1000000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					SetPVarInt(playerid, "MonControl", 1);
					GivePlayerMoney(playerid, -1000000);
					new vehid = 564, vehcol1 = 0, vehcol2 = 1, dispz = 0;
					VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
					SendClientMessage(playerid, COLOR_LIGHTRED, "ХА-ХА-ХА {FFFFFF}:)");
					printf(" Игрок %s [%d] купил Rhino за 1000000 $ .", RealName[playerid], playerid);
				}
				return 1;
			}
			if(listitem == 13)
			{
				new vehid = 428, vehcol1 = 0, vehcol2 = 1, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Securicar");
				return 1;
			}
			if(listitem == 14)
			{
				new vehid = 601, vehcol1 = 0, vehcol2 = 1, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Swat Tank");
			}
		}else{
			format(strdln, sizeof(strdln), "{FF0000}отечественные\n{FFFFFF}спорткары\n{FF0000}отечественные №2\
				\n{FFFFFF}отечественные №3\n{FF0000}иномарки\n{FFFFFF}# Niva меню\n{FF0000}•Легенды - Известные авто\
				\n{FFFFFF}Korch Жигули\n{FF0000}Лёгкие грузовики и фургоны\n{FFFFFF}Транспорт для развлечения\
				\n{FF0000}Велосипеды и мотоциклы");
			format(strdln, sizeof(strdln), "%s\n{FFFFFF}Авто для транспортировки\
				\n{FF0000}Коммерческий и государственный транспорт\n{FFFFFF}Воздушный транспорт\n{FF0000}Водный транспорт\
				\n{FFFFFF}Радиоуправляемые авто", strdln);
			ShowPlayerDialog(playerid, 21, DIALOG_STYLE_LIST, "Тип транспорта", strdln, "Выбор", "Отмена");
			dlgcont[playerid] = 21;
		}
		return 1;
	}
	if(dialogid == 34)//воздушный транспорт
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(listitem == 0)
			{
				new vehid = 592, vehcol1 = 8, vehcol2 = 15, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Andromada");
				return 1;
			}
			if(listitem == 1)
			{
				new vehid = 577, vehcol1 = 8, vehcol2 = 15, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  AT-400");
				return 1;
			}
			if(listitem == 2)
			{
				new vehid = 511, vehcol1 = 8, vehcol2 = 15, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Beagle");
				return 1;
			}
			if(listitem == 3)
			{
				new vehid = 548, vehcol1 = 8, vehcol2 = 15, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Cargobob");
				return 1;
			}
			if(listitem == 4)
			{
				new vehid = 512, vehcol1 = 8, vehcol2 = 15, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Cropduster");
				return 1;
			}
			if(listitem == 5)
			{
				new vehid = 593, vehcol1 = 8, vehcol2 = 15, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Dodo");
				return 1;
			}
			if(listitem == 6)
			{
				if(GetPlayerMoney(playerid) < 1000000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					SetPVarInt(playerid, "MonControl", 1);
					GivePlayerMoney(playerid, -1000000);
					new vehid = 465, vehcol1 = 8, vehcol2 = 15, dispz = 1;
					VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
					SendClientMessage(playerid, COLOR_LIGHTRED, "ХА-ХА-ХА {FFFFFF}:)");
					printf(" Игрок %s [%d] купил Hunter за 1000000 $ .", RealName[playerid], playerid);
				}
				return 1;
			}
			if(listitem == 7)
			{
				new vehid = 417, vehcol1 = 8, vehcol2 = 15, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Leviathan");
				return 1;
			}
			if(listitem == 8)
			{
				new vehid = 487, vehcol1 = 8, vehcol2 = 15, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Maverick");
				return 1;
			}
			if(listitem == 9)
			{
				new vehid = 553, vehcol1 = 8, vehcol2 = 15, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Nevada");
				return 1;
			}
			if(listitem == 10)
			{
				new vehid = 488, vehcol1 = 8, vehcol2 = 15, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  News Maverick");
				return 1;
			}
			if(listitem == 11)
			{
				new vehid = 497, vehcol1 = 0, vehcol2 = 1, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Police Maverick");
				return 1;
			}
			if(listitem == 12)
			{
				new vehid = 563, vehcol1 = 8, vehcol2 = 15, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Raindance");
				return 1;
			}
			if(listitem == 13)
			{
				new vehid = 476, vehcol1 = 8, vehcol2 = 15, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Rustler");
				return 1;
			}
			if(listitem == 14)
			{
				new vehid = 447, vehcol1 = 8, vehcol2 = 15, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Seasparrow");
				return 1;
			}
			if(listitem == 15)
			{
				new vehid = 519, vehcol1 = 8, vehcol2 = 15, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Shamal");
				return 1;
			}
			if(listitem == 16)
			{
				new vehid = 460, vehcol1 = 8, vehcol2 = 15, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Skimmer");
				return 1;
			}
			if(listitem == 17)
			{
				new vehid = 469, vehcol1 = 8, vehcol2 = 15, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Sparrow");
				return 1;
			}
			if(listitem == 18)
			{
				new vehid = 513, vehcol1 = 8, vehcol2 = 15, dispz = 1;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Stunt Plane");
				return 1;
			}
			if(listitem == 19)
			{
				if(GetPlayerMoney(playerid) < 1000000)
				{
					SendClientMessage(playerid, COLOR_RED, "У Вас недостаточно денег.");
				}
				else
				{
					SetPVarInt(playerid, "MonControl", 1);
					GivePlayerMoney(playerid, -1000000);
					new vehid = 464, vehcol1 = 8, vehcol2 = 15, dispz = 1;
					VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
					SendClientMessage(playerid, COLOR_LIGHTRED, "ХА-ХА-ХА {FFFFFF}:)");
					printf(" Игрок %s [%d] купил Hydra за 1000000 $ .", RealName[playerid], playerid);
				}
			}
		}else{
			format(strdln, sizeof(strdln), "{FF0000}отечественные\n{FFFFFF}спорткары\n{FF0000}отечественные №2\
				\n{FFFFFF}отечественные №3\n{FF0000}иномарки\n{FFFFFF}# Niva меню\n{FF0000}•Легенды - Известные авто\
				\n{FFFFFF}Korch Жигули\n{FF0000}Лёгкие грузовики и фургоны\n{FFFFFF}Транспорт для развлечения\
				\n{FF0000}Велосипеды и мотоциклы");
			format(strdln, sizeof(strdln), "%s\n{FFFFFF}Авто для транспортировки\
				\n{FF0000}Коммерческий и государственный транспорт\n{FFFFFF}Воздушный транспорт\n{FF0000}Водный транспорт\
				\n{FFFFFF}Радиоуправляемые авто", strdln);
			ShowPlayerDialog(playerid, 21, DIALOG_STYLE_LIST, "Тип транспорта", strdln, "Выбор", "Отмена");
			dlgcont[playerid] = 21;
		}
		return 1;
	}
	if(dialogid == 35)//водный транспорт
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(listitem == 0)
			{
				new vehid = 472, vehcol1 = 8, vehcol2 = 15, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Coastguard");
				return 1;
			}
			if(listitem == 1)
			{
				new vehid = 473, vehcol1 = 8, vehcol2 = 15, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Dingy");
				return 1;
			}
			if(listitem == 2)
			{
				new vehid = 493, vehcol1 = 8, vehcol2 = 15, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Jetmax");
				return 1;
			}
			if(listitem == 3)
			{
				new vehid = 595, vehcol1 = 8, vehcol2 = 15, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Launch");
				return 1;
			}
			if(listitem == 4)
			{
				new vehid = 484, vehcol1 = 8, vehcol2 = 15, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Marquis");
				return 1;
			}
			if(listitem == 5)
			{
				new vehid = 430, vehcol1 = 0, vehcol2 = 1, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Predator");
				return 1;
			}
			if(listitem == 6)
			{
				new vehid = 453, vehcol1 = 8, vehcol2 = 15, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Reefer");
				return 1;
			}
			if(listitem == 7)
			{
				new vehid = 452, vehcol1 = 8, vehcol2 = 15, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Speeder");
				return 1;
			}
			if(listitem == 8)
			{
				new vehid = 446, vehcol1 = 8, vehcol2 = 15, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Squallo");
				return 1;
			}
			if(listitem == 9)
			{
				new vehid = 454, vehcol1 = 8, vehcol2 = 15, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Tropic");
			}
		}else{
			format(strdln, sizeof(strdln), "{FF0000}отечественные\n{FFFFFF}спорткары\n{FF0000}отечественные №2\
				\n{FFFFFF}отечественные №3\n{FF0000}иномарки\n{FFFFFF}# Niva меню\n{FF0000}•Легенды - Известные авто\
				\n{FFFFFF}Korch Жигули\n{FF0000}Лёгкие грузовики и фургоны\n{FFFFFF}Транспорт для развлечения\
				\n{FF0000}Велосипеды и мотоциклы");
			format(strdln, sizeof(strdln), "%s\n{FFFFFF}Авто для транспортировки\
				\n{FF0000}Коммерческий и государственный транспорт\n{FFFFFF}Воздушный транспорт\n{FF0000}Водный транспорт\
				\n{FFFFFF}Радиоуправляемые авто", strdln);
			ShowPlayerDialog(playerid, 21, DIALOG_STYLE_LIST, "Тип транспорта", strdln, "Выбор", "Отмена");
			dlgcont[playerid] = 21;
		}
		return 1;
	}
	if(dialogid == 36)//Радиоуправляемые авто
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new locper = col4car[random(8)];
			if(listitem == 0)
			{
				new vehid = 441, vehcol1 = 8, vehcol2 = 15, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  RC Bandit");
				return 1;
			}
			if(listitem == 1)
			{
				new vehid = 464, vehcol1 = 8, vehcol2 = 15, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  RC Baron");
				return 1;
			}
			if(listitem == 2)
			{
				new vehid = 594, vehcol1 = 8, vehcol2 = 15, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  RC Cam");
				return 1;
			}
			if(listitem == 3)
			{
				new vehid = 465, vehcol1 = 8, vehcol2 = 15, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  RC Goblin");
				return 1;
			}
			if(listitem == 4)
			{
				new vehid = 564, vehcol1 = 8, vehcol2 = 15, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  RC Tiger");
				return 1;
			}
			if(listitem == 5)
			{
				new vehid = 604, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Glendale");
				return 1;
			}
			if(listitem == 6)
			{
				new vehid = 605, vehcol1 = locper, vehcol2 = locper, dispz = 0;
				VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
				SendClientMessage(playerid, COLOR_GREENISHGOLD, "Выбран  Sadler");
			}
		}else{
			format(strdln, sizeof(strdln), "{FF0000}отечественные\n{FFFFFF}спорткары\n{FF0000}отечественные №2\
				\n{FFFFFF}отечественные №3\n{FF0000}иномарки\n{FFFFFF}# Niva меню\n{FF0000}•Легенды - Известные авто\
				\n{FFFFFF}Korch Жигули\n{FF0000}Лёгкие грузовики и фургоны\n{FFFFFF}Транспорт для развлечения\
				\n{FF0000}Велосипеды и мотоциклы");
			format(strdln, sizeof(strdln), "%s\n{FFFFFF}Авто для транспортировки\
				\n{FF0000}Коммерческий и государственный транспорт\n{FFFFFF}Воздушный транспорт\n{FF0000}Водный транспорт\
				\n{FFFFFF}Радиоуправляемые авто", strdln);
			ShowPlayerDialog(playerid, 21, DIALOG_STYLE_LIST, "Тип транспорта", strdln, "Выбор", "Отмена");
			dlgcont[playerid] = 21;
		}
		return 1;
	}
	if(dialogid == 1001)//Gangs system
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			switch(listitem)
			{
			case 0:
				{
					if((PGang[playerid] == 0 || PGang[playerid] == -600) && GetPlayerScore(playerid) >= 1000)
					{
						if(GetFreeGang() >= (MAX_GANGS - 1))
						{
							printf("[GangsSystem] %s [%d] не смог создать банду (лимит банд исчерпан).", RealName[playerid],
							playerid);
							SendClientMessage(playerid, 0xFF0000FF, "Банда не может быть создана ( лимит банд исчерпан )");
							return true;
						}
						ShowPlayerDialog(playerid, 1002, DIALOG_STYLE_INPUT, "Создание банды",
						"Введите название банды:", "Принять", "Отмена");
						dlgcont[playerid] = 1002;
						return true;
					}else{
						SendClientMessage(playerid, 0xFF0000FF, "Ошибка | Вы состоите в какой-либо банде.");
						SendClientMessage(playerid, 0xFF0000FF, "Ошибка | У вас должно быть как минимум 1000 очков (SCORE).");
						return true;
					}
				}
			case 1:
				{
					if(PGang[playerid] > 0 && GangLvl[playerid] == 6)
					{
						ShowPlayerDialog(playerid, 1016, DIALOG_STYLE_MSGBOX, "Удаление банды",
						"Вы точно хотите удалить свою банду?", "Принять", "Отмена");
						dlgcont[playerid] = 1016;
						return true;
					}else return SendClientMessage(playerid, 0xFF0000FF,
					"Вы должны состоять в банде, и у Вас должен быть уровень лидера.");
				}
			case 2:
				{
					if(PGang[playerid] > 0 && GangLvl[playerid] == 6)
					{
						ShowPlayerDialog(playerid, 1011, DIALOG_STYLE_LIST, "Назначение скинов банды", "1 - Начинающий\
						\n2 - Игрок\n3 - Про игрок\n4 - Элита\n5 - Зам лидера\n6 - Лидер", "Принять", "Отмена");
						dlgcont[playerid] = 1011;
						return true;
					}else return SendClientMessage(playerid, 0xFF0000FF,
					"Вы должны состоять в банде, и у Вас должен быть уровень лидера.");
				}
			case 3:
				{
					if(PGang[playerid] > 0 && GangLvl[playerid] == 6)
					{
						ShowPlayerDialog(playerid, 1010, DIALOG_STYLE_MSGBOX, "Назначение спавна банды",
						"Вы точно хотите назначить место спавна на этом месте?", "Принять", "Отмена");
						dlgcont[playerid] = 1010;
						return true;
					}else return SendClientMessage(playerid, 0xFF0000FF,
					"Вы должны состоять в банде, и у Вас должен быть уровень лидера.");
				}
			case 4:
				{
					if(PGang[playerid] > 0 && GangLvl[playerid] == 6)
					{
						if(GSpawnX[PGang[playerid]] == 0.00 && GSpawnY[PGang[playerid]] == 0.00 && GSpawnZ[PGang[playerid]] == 0.00 &&
								GInter[PGang[playerid]] == 0 && GWorld[PGang[playerid]] == 0)
						{
							SendClientMessage(playerid, 0xFF0000FF, " Спавн банды ранее не был назначен !");
							return 1;
						}
						ShowPlayerDialog(playerid, 1015, DIALOG_STYLE_MSGBOX, "Отмена спавна банды",
						"Вы точно хотите отменить спавн банды?", "Принять", "Отмена");
						dlgcont[playerid] = 1015;
						return true;
					}else return SendClientMessage(playerid, 0xFF0000FF,
					"Вы должны состоять в банде, и у Вас должен быть уровень лидера.");
				}
			case 5:
				{
					if(PGang[playerid] > 0 && GangLvl[playerid] == 6)
					{
						ShowPlayerDialog(playerid, 1013, DIALOG_STYLE_INPUT, "Назначение уровня",
						"Введите id игрока, которому хотите назначить уровень:", "Принять", "Отмена");
						dlgcont[playerid] = 1013;
						return true;
					}else return SendClientMessage(playerid, 0xFF0000FF,
					"Вы должны состоять в банде, и у Вас должен быть уровень лидера.");
				}
			case 6:
				{
					if(PGang[playerid] > 0 && GangLvl[playerid] >= 4)
					{
						ShowPlayerDialog(playerid, 1004, DIALOG_STYLE_INPUT, "Приглашение в банду",
						"Введите id игрока, которого хотите пригласить:", "Принять", "Отмена");
						dlgcont[playerid] = 1004;
						return true;
					}else return SendClientMessage(playerid, 0xFF0000FF,
					"Вы должны состоять в банде, и у Вас должен быть как минимум 4 уровень.");
				}
			case 7:
				{
					if(PGang[playerid] > 0 && GangLvl[playerid] >= 5)
					{
						ShowPlayerDialog(playerid, 1006, DIALOG_STYLE_INPUT, "Изгнание из банды",
						"Введите id игрока, которого хотите выгнать:", "Принять", "Отмена");
						dlgcont[playerid] = 1006;
						return true;
					}else return SendClientMessage(playerid, 0xFF0000FF,
					"Вы должны состоять в банде, и у Вас должен быть как минимум 5 уровень.");
				}
			case 8:
				{
					if(PGang[playerid] == 0 || PGang[playerid] == -600)
					{
						if(PGang[playerid] == 0)
						{
							PGang[playerid] = -600;
							SendClientMessage(playerid, 0xFF0000FF, "Вы отключили разрешение приглашать Вас в банду.");
							return 1;
						}
						else
						{
							PGang[playerid] = 0;
							SendClientMessage(playerid, 0x00FF00FF, "Вы включили разрешение приглашать Вас в банду.");
							return 1;
						}
					}else return SendClientMessage(playerid, 0xFFFF00FF,
					"Вы уже состоите в банде ! (откл. / вкл. разрешения - не актуально) .");
				}
			case 9:
				{
					if(PGang[playerid] > 0 && GangLvl[playerid] == 6)
					{
						ShowPlayerDialog(playerid, 1007, DIALOG_STYLE_INPUT, "Смена названия банды",
						"Введите новое название банды:", "Принять", "Отмена");
						dlgcont[playerid] = 1007;
						return true;
					}else return SendClientMessage(playerid, 0xFF0000FF,
					"Вы должны состоять в банде, и у Вас должен быть уровень лидера.");
				}
			case 10:
				{
					if(PGang[playerid] > 0 && GangLvl[playerid] == 6)
					{
						ShowPlayerDialog(playerid, 1008, DIALOG_STYLE_INPUT, "Смена цвета банды",
						"Введите новый цвет банды: (формат RRGGBB)", "Принять", "Отмена");
						dlgcont[playerid] = 1008;
						return true;
					}else return SendClientMessage(playerid, 0xFF0000FF,
					"Вы должны состоять в банде, и у Вас должен быть уровень лидера.");
				}
			case 11:
				{
					if(PGang[playerid] > 0 && GangLvl[playerid] == 6)
					{
						ShowPlayerDialog(playerid, 1016, DIALOG_STYLE_MSGBOX, "Уход из банды", "Вы являетесь лидером банды !\
						\nПосле Вашего ухода банда будет удалена !\nВы точно хотите уйти из банды?", "Да", "Нет");
						dlgcont[playerid] = 1016;
						return true;
					}
					if(PGang[playerid] > 0 && GangLvl[playerid] != 6)
					{
						ShowPlayerDialog(playerid, 1009, DIALOG_STYLE_MSGBOX, "Уход из банды",
						"Вы точно хотите уйти из банды?", "Да", "Нет");
						dlgcont[playerid] = 1009;
						return true;
					}
					if(PGang[playerid] == 0 || PGang[playerid] == -600) return SendClientMessage(playerid, 0xFF0000FF,
					"Вы должны состоять в банде !");
				}
			case 12:
				{
					if(PGang[playerid] > 0)
					{
						new string11[32], string22[128], string33[128], string44[128], string55[128], string99[512];
						switch(GangLvl[playerid])
						{
						case 1: format(string11, sizeof(string11), "Начинающий");
						case 2: format(string11, sizeof(string11), "Игрок");
						case 3: format(string11, sizeof(string11), "Про игрок");
						case 4: format(string11, sizeof(string11), "Элита");
						case 5: format(string11, sizeof(string11), "Зам лидера");
						case 6: format(string11, sizeof(string11), "Лидер");
						}
						format(string22, sizeof(string22), "Время и дата регистрации: [ %s ]", GTDReg[PGang[playerid]]);
						format(string33, sizeof(string33), "Мой уровень в банде: %d ( %s )", GangLvl[playerid], string11);
						format(string44, sizeof(string44), "Лидер банды: %s", GHead[PGang[playerid]]);
						format(string55, sizeof(string55), "Число игроков в банде: %d", GPlayers[PGang[playerid]]);
						format(string99, sizeof(string99), "%s\n%s\n%s\n%s", string22, string33, string44, string55);
						ShowPlayerDialog(playerid,2,0,"Информация о банде.",string99,"OK","");
						return 1;
					}else return SendClientMessage(playerid, 0xFF0000FF, "Вы должны состоять в банде !");
				}
			}
		}else{
			gettime(timedata[0], timedata[1]);
			format(string, sizeof(string), "{FFFFFF}Игровое меню. Точное время: {FF0000}%02d{FFFFFF}:{FF0000}%02d", timedata[0], timedata[1]);
			ShowPlayerDialog(playerid, 4, DIALOG_STYLE_LIST, string, "{FF0000}» Транспортное средство\n{FF0000}» Предметы\
			\n{FF0000}» Оружие\n{FF0000}» Телепорты\n{FF0000}» Аксессуары\n{FF0000}» Действия\n{FF0000}» Радио\n{FF0000}» DeathMatch\
			\n{FF0000}» Платные услуги\n{FF0000}» On-Line Администраторы\n{FF0000}» Правила сервера\n{FF0000}» Система банд", "Выбор", "Отмена");
			dlgcont[playerid] = 4;
		}
		return true;
	}
	if(dialogid == 1002)//создание банды
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(InpTxtControl(inputtext) == 0)
			{
				SendClientMessage(playerid, 0xFF0000FF, "Ошибка, недопустимый символ:");
				SendClientMessage(playerid, 0xFF0000FF, "запрещённые коды, или знак процентов, или ~ !");
				ShowPlayerDialog(playerid, 1002, DIALOG_STYLE_INPUT, "Создание банды", "Введите название банды:",
				"Принять", "Отмена");
				dlgcont[playerid] = 1002;
				return 1;
			}
			if(strlen(inputtext) == 0)
			{
				SendClientMessage(playerid, 0xFF0000FF, "В названии банды должен быть хотябы 1 символ !");
				return true;
			}
			if(strlen(inputtext) > 128)
			{
				SendClientMessage(playerid, 0xFF0000FF, "В названии банды должно быть не больше 128 символов !");
				return true;
			}
			format(GangName[playerid], 130, inputtext);
			for(new i=1; i<(MAX_GANGS - 1); i++)
			{
				if(strcmp(GangName[playerid],GName[i],false) == 0 && strlen(GName[i]) != 0)
				{
					ShowPlayerDialog(playerid,2,0,"Информация.","Банда с таким именем была создана ранее !","OK","");
					return true;
				}
			}
			ShowPlayerDialog(playerid, 1003, DIALOG_STYLE_INPUT, "Создание банды", "Введите цвет банды: (формат RRGGBB)",
			"Принять", "Отмена");
			dlgcont[playerid] = 1003;
		}
		else
		{
			ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_LIST, "Система банд", "Создать банду\nУдалить банду\
			\nНазначить скины\nНазначить место спавна\nОтменить спавн банды\nНазначить уровень\nПригласить в банду\
			\nВыгнать из банды\nОткл. / вкл. разрешение приглашать Вас в банду\nИзменить название банды\
			\nИзменить цвет банды\nУйти из банды\nИнформация о банде", "Выбор", "Отмена");
			dlgcont[playerid] = 1001;
		}
		return true;
	}
	if(dialogid == 1003)
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(InpTxtControl(inputtext) == 0)
			{
				SendClientMessage(playerid, 0xFF0000FF, "Ошибка, недопустимый символ:");
				SendClientMessage(playerid, 0xFF0000FF, "запрещённые коды, или знак процентов, или ~ !");
				ShowPlayerDialog(playerid, 1003, DIALOG_STYLE_INPUT, "Создание банды",
				"Введите цвет банды: (формат RRGGBB)", "Принять", "Отмена");
				dlgcont[playerid] = 1003;
				return 1;
			}
			if(strlen(inputtext) != 6)
			{
				SendClientMessage(playerid, 0xFF0000FF, "Цвет банды должен состоять из 6 символов формата RRGGBB !");
				return true;
			}
			new gangdata;
			gangdata = GetFreeGang();
			Gang[gangdata] = 1;
			PGang[playerid] = gangdata;
			GangLvl[playerid] = 6;
			format(GName[PGang[playerid]], 130, GangName[playerid]);
			format(GColor[PGang[playerid]], 16, "%sFF", inputtext);
			GColorDec[PGang[playerid]] = HexToInt(GColor[PGang[playerid]]);
			strdel(GColorHex[PGang[playerid]], 0, 16);
			strcat(GColorHex[PGang[playerid]], ColorRes(GColor[PGang[playerid]]));
			ColorPlay[playerid] = GColorDec[PGang[playerid]];
			SetPlayerColor(playerid, ColorPlay[playerid]);//устанавливаем цвет ника
			for(new i=0;i<MAX_PLAYERS;i++)//устанавливаем цвет маркера для всех игроков
			{
				SetPlayerMarkerForPlayer(i, playerid, GColorDec[PGang[playerid]]);
			}
			format(string, sizeof(string), "Банда успешно создана!\r\nНазвание банды: %s\r\n{A9C4E4}Цвет банды: %s",
			GName[PGang[playerid]], GColor[PGang[playerid]]);
			ShowPlayerDialog(playerid, 2, DIALOG_STYLE_MSGBOX, "Создание банды", string, "Принять", "");
			strdel(GHead[PGang[playerid]], 0, 64);
			strcat(GHead[PGang[playerid]], RealName[playerid]);
			printf("[GangsSystem] %s [%d] создал банду %s (цвет банды %s).", RealName[playerid], playerid,
			GName[PGang[playerid]], GColor[PGang[playerid]]);
			GPlayers[PGang[playerid]] = 1;
			strdel(GTDReg[PGang[playerid]], 0, 32);//очистка времени и даты регистрации банды
			gettime(timedata[0], timedata[1]);
			getdate(timedata[2], timedata[3], timedata[4]);
			format(GTDReg[PGang[playerid]], 32, "%02d:%02d - %02d/%02d/%04d", timedata[0], timedata[1],
			timedata[4], timedata[3], timedata[2]);
			GSpawnX[PGang[playerid]] = 0.00;//заполнение массивов банды
			GSpawnY[PGang[playerid]] = 0.00;
			GSpawnZ[PGang[playerid]] = 0.00;
			GInter[PGang[playerid]] = 0;
			GWorld[PGang[playerid]] = 0;
			GSkin[PGang[playerid]][0] = 500;
			GSkin[PGang[playerid]][1] = 500;
			GSkin[PGang[playerid]][2] = 500;
			GSkin[PGang[playerid]][3] = 500;
			GSkin[PGang[playerid]][4] = 500;
			GSkin[PGang[playerid]][5] = 500;
			new f[256];
			format(f, 256, "gangs/%i.ini", gangdata);
			new cfile = ini_createFile(f);
			if(cfile == INI_OK)
			{
				ini_setString(cfile, "Gang TDReg", GTDReg[PGang[playerid]]);
				ini_setString(cfile, "Gang head", GHead[PGang[playerid]]);
				ini_setString(cfile, "Gang name", GName[PGang[playerid]]);
				ini_setString(cfile, "Gang color", GColor[PGang[playerid]]);
				ini_setFloat(cfile, "SpawnX", GSpawnX[PGang[playerid]]);
				ini_setFloat(cfile, "SpawnY", GSpawnY[PGang[playerid]]);
				ini_setFloat(cfile, "SpawnZ", GSpawnZ[PGang[playerid]]);
				ini_setInteger(cfile, "GInter", GInter[PGang[playerid]]);
				ini_setInteger(cfile, "GWorld", GWorld[PGang[playerid]]);
				ini_setInteger(cfile, "Skin1", GSkin[PGang[playerid]][0]);
				ini_setInteger(cfile, "Skin2", GSkin[PGang[playerid]][1]);
				ini_setInteger(cfile, "Skin3", GSkin[PGang[playerid]][2]);
				ini_setInteger(cfile, "Skin4", GSkin[PGang[playerid]][3]);
				ini_setInteger(cfile, "Skin5", GSkin[PGang[playerid]][4]);
				ini_setInteger(cfile, "Skin6", GSkin[PGang[playerid]][5]);
				ini_setInteger(cfile, "Players", GPlayers[PGang[playerid]]);
				ini_closeFile(cfile);
			}
			idgangsave[playerid] = PGang[playerid];//записываем в список ID банды игрока
			SetTimerEx("SaveGangOn", 300, 0, "i", gangdata);
		}
		else
		{
			ShowPlayerDialog(playerid, 1002, DIALOG_STYLE_INPUT, "Создание банды", "Введите название банды:", "Принять", "Отмена");
			dlgcont[playerid] = 1002;
		}
		return true;
	}
	if(dialogid == 1016)//удаление банды
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			for(new i = 0; i < MAX_PLAYERS; i++)//цикл для всех игроков
			{
				if(PGang[playerid] == idgangsave[i])
				{//поиск ID банды в списке:
					idgangsave[i] = 0;//очистка ID банды для записи
				}
			}
			GangSA[PGang[playerid]] = 0;
			SetTimerEx("SaveGangOff", 300, 0, "i", playerid);
		}
		else
		{
			ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_LIST, "Система банд", "Создать банду\nУдалить банду\
			\nНазначить скины\nНазначить место спавна\nОтменить спавн банды\nНазначить уровень\nПригласить в банду\
			\nВыгнать из банды\nОткл. / вкл. разрешение приглашать Вас в банду\nИзменить название банды\
			\nИзменить цвет банды\nУйти из банды\nИнформация о банде", "Выбор", "Отмена");
			dlgcont[playerid] = 1001;
		}
		return true;
	}
	if(dialogid == 1004)//приглашение в банду
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(InpTxtControl(inputtext) == 0)
			{
				SendClientMessage(playerid, 0xFF0000FF, "Ошибка, недопустимый символ:");
				SendClientMessage(playerid, 0xFF0000FF, "запрещённые коды, или знак процентов, или ~ !");
				ShowPlayerDialog(playerid, 1004, DIALOG_STYLE_INPUT, "Приглашение в банду",
				"Введите id игрока, которого хотите пригласить:", "Принять", "Отмена");
				dlgcont[playerid] = 1004;
				return 1;
			}
			new id22;
			id22 = strval(inputtext);
			if(IsPlayerConnected(id22))
			{
				if(PGang[id22] == -600)
				{
					SendClientMessage(playerid, 0xFF0000FF, "Этот игрок отключил разрешение приглашать себя в банду !");
					return 1;
				}
				if(playspa[id22] == 1)
				{
					if(PGang[id22] == 0)
					{
						format(string, sizeof(string), "Игрок %s пригласил Вас в банду %s", RealName[playerid], GName[PGang[playerid]]);
						ShowPlayerDialog(id22, 1005, DIALOG_STYLE_MSGBOX, "Приглашение в банду", string, "Принять", "Отказать");
						dlgcont[id22] = 1005;
						format(string, sizeof(string), "Игрок %s пригласил игрока %s в банду.", RealName[playerid], RealName[id22]);
						printf("[GangsSystem] %s [%d] пригласил игрока %s в банду.", RealName[playerid], playerid, RealName[id22]);
						for(new i; i<MAX_PLAYERS; i++)
						{
							if(IsPlayerConnected(i))
							{
								if(PGang[i] == PGang[playerid])
								{
									SendClientMessage(i, 0x00FF00FF, string);
								}
							}
						}
						tgang[id22] = PGang[playerid];
					}else return SendClientMessage(playerid, 0xFF0000FF, "Этот игрок уже в банде !");
				}else return SendClientMessage(playerid, 0xFF0000FF, "Этот игрок ещё не заспавнился !");
			}else return SendClientMessage(playerid, 0xFF0000FF, "Этот игрок не в игре !");
		}
		else
		{
			ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_LIST, "Система банд", "Создать банду\nУдалить банду\
			\nНазначить скины\nНазначить место спавна\nОтменить спавн банды\nНазначить уровень\nПригласить в банду\
			\nВыгнать из банды\nОткл. / вкл. разрешение приглашать Вас в банду\nИзменить название банды\
			\nИзменить цвет банды\nУйти из банды\nИнформация о банде", "Выбор", "Отмена");
			dlgcont[playerid] = 1001;
		}
		return true;
	}
	if(dialogid == 1005)
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			PGang[playerid] = tgang[playerid];
			GangLvl[playerid] = 1;
			if(GSkin[PGang[playerid]][GangLvl[playerid]-1] < 500)
			{//если у 1-го уровня установлен скин, то сменить скин вступившему игроку
				SetPVarInt(playerid, "PlSkin", GSkin[PGang[playerid]][GangLvl[playerid]-1]);
				SetPlayerSkin(playerid, GetPVarInt(playerid, "PlSkin"));
			}
			ColorPlay[playerid] = GColorDec[PGang[playerid]];
			SetPlayerColor(playerid, ColorPlay[playerid]);//устанавливаем цвет ника
			for(new i=0;i<MAX_PLAYERS;i++)//устанавливаем цвет маркера для всех игроков
			{
				SetPlayerMarkerForPlayer(i, playerid, GColorDec[PGang[playerid]]);
			}
			format(string, sizeof(string), "Вы вступили в банду: {FF0000}%s", GName[PGang[playerid]]);
			SendClientMessage(playerid, 0xFFFF00FF, string);
			format(string, sizeof(string), "Игрок %s вступил в Вашу банду !", RealName[playerid]);
			printf("[GangsSystem] %s [%d] вступил в банду %s.", RealName[playerid], playerid, GName[PGang[playerid]]);
			for(new i; i<MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(PGang[i] == PGang[playerid] && playerid != i)
					{
						SendClientMessage(i, 0xFFFF00FF, string);
					}
				}
			}
			GPlayers[PGang[playerid]]++;
			GangSave(PGang[playerid]);//запись ID банды в файл
		}
		else
		{
			tgang[playerid] = 0;
		}
		return true;
	}
	if(dialogid == 1006)//изгнание из банды
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(InpTxtControl(inputtext) == 0)
			{
				SendClientMessage(playerid, 0xFF0000FF, "Ошибка, недопустимый символ:");
				SendClientMessage(playerid, 0xFF0000FF, "запрещённые коды, или знак процентов, или ~ !");
				ShowPlayerDialog(playerid, 1006, DIALOG_STYLE_INPUT, "Изгнание из банды",
				"Введите id игрока, которого хотите выгнать:", "Принять", "Отмена");
				dlgcont[playerid] = 1006;
				return 1;
			}
			new dopper333;
			dopper333 = strval(inputtext);
			if(IsPlayerConnected(dopper333))
			{
				if(PGang[dopper333] == PGang[playerid])
				{
					if(dopper333 != playerid)
					{
						if(GangLvl[dopper333] <= GangLvl[playerid])
						{
							if(idgangsave[dopper333] > 0)//если ID банды для записи - активен, то:
							{
								new perloc;
								idgangsave[dopper333] = 0;//очистка ID банды для записи
								perloc = 0;
								while(perloc < MAX_PLAYERS)//цикл для всех игроков
								{
									if(PGang[dopper333] == PGang[perloc] && dopper333 != perloc)
									{//если есть хотя бы один игрок из банды выходящего, то:
										idgangsave[perloc] = PGang[dopper333];
										break;
									}
									perloc++;
								}
							}
							idgangsave[dopper333] = 0;//очистка ID банды для записи
							PGang[dopper333] = 0;
							GangLvl[dopper333] = 0;
							format(string, 256, "Вы были выгнаны из банды игроком %s !", RealName[playerid]);
							SendClientMessage(dopper333, 0xFF0000FF, string);
							format(string, sizeof(string), "Игрок %s выгнал из банды игрока %s !",
							RealName[playerid], RealName[dopper333]);
							printf("[GangsSystem] %s [%d] выгнал из банды игрока %s.",
							RealName[playerid], playerid, RealName[dopper333]);
							for(new i; i<MAX_PLAYERS; i++)
							{
								if(IsPlayerConnected(i))
								{
									if(PGang[i] == PGang[playerid])
									{
										SendClientMessage(i, 0xFF0000FF, string);
									}
								}
							}
							GPlayers[PGang[playerid]]--;
							GangSave(PGang[playerid]);//запись ID банды в файл
						}else return SendClientMessage(playerid, 0xFF0000FF, "Вы не можете выгнать лидера банды !");
					}else return SendClientMessage(playerid, 0xFF0000FF, "Вы не можете выгнать самого себя !");
				}else return SendClientMessage(playerid, 0xFF0000FF, "Этот игрок не в Вашей банде !");
			}else return SendClientMessage(playerid, 0xFF0000FF, "Этот игрок не в игре !");
		}
		else
		{
			ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_LIST, "Система банд", "Создать банду\nУдалить банду\
			\nНазначить скины\nНазначить место спавна\nОтменить спавн банды\nНазначить уровень\nПригласить в банду\
			\nВыгнать из банды\nОткл. / вкл. разрешение приглашать Вас в банду\nИзменить название банды\
			\nИзменить цвет банды\nУйти из банды\nИнформация о банде", "Выбор", "Отмена");
			dlgcont[playerid] = 1001;
		}
		return true;
	}
	if(dialogid == 1007)//смена названия банды
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(InpTxtControl(inputtext) == 0)
			{
				SendClientMessage(playerid, 0xFF0000FF, "Ошибка, недопустимый символ:");
				SendClientMessage(playerid, 0xFF0000FF, "запрещённые коды, или знак процентов, или ~ !");
				ShowPlayerDialog(playerid, 1007, DIALOG_STYLE_INPUT, "Смена названия банды",
				"Введите новое название банды:", "Принять", "Отмена");
				dlgcont[playerid] = 1007;
				return 1;
			}
			if(strlen(inputtext) == 0)
			{
				SendClientMessage(playerid, 0xFF0000FF, "В названии банды должен быть хотябы 1 символ !");
				return true;
			}
			if(strlen(inputtext) > 128)
			{
				SendClientMessage(playerid, 0xFF0000FF, "В названии банды должно быть не больше 128 символов !");
				return true;
			}
			format(GangName[playerid], 130, inputtext);
			for(new i=1; i<(MAX_GANGS - 1); i++)
			{
				if(strcmp(GangName[playerid],GName[i],false) == 0 && strlen(GName[i]) != 0)
				{
					ShowPlayerDialog(playerid,2,0,"Информация.","Банда с таким именем была создана ранее !","OK","");
					return true;
				}
			}
			format(GName[PGang[playerid]], 130, GangName[playerid]);
			format(string, sizeof(string), "Теперь название Вашей банды: %s", GName[PGang[playerid]]);
			SendClientMessage(playerid, 0x00FF00FF, string);
			printf("[GangsSystem] %s [%d] сменил название банды на %s.", RealName[playerid], playerid, GName[PGang[playerid]]);
			GangSave(PGang[playerid]);//запись ID банды в файл
		}
		else
		{
			ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_LIST, "Система банд", "Создать банду\nУдалить банду\
			\nНазначить скины\nНазначить место спавна\nОтменить спавн банды\nНазначить уровень\nПригласить в банду\
			\nВыгнать из банды\nОткл. / вкл. разрешение приглашать Вас в банду\nИзменить название банды\
			\nИзменить цвет банды\nУйти из банды\nИнформация о банде", "Выбор", "Отмена");
			dlgcont[playerid] = 1001;
		}
		return true;
	}
	if(dialogid == 1008)//смена цвета банды
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(InpTxtControl(inputtext) == 0)
			{
				SendClientMessage(playerid, 0xFF0000FF, "Ошибка, недопустимый символ:");
				SendClientMessage(playerid, 0xFF0000FF, "запрещённые коды, или знак процентов, или ~ !");
				ShowPlayerDialog(playerid, 1008, DIALOG_STYLE_INPUT, "Смена цвета банды",
				"Введите новый цвет банды: (формат RRGGBB)", "Принять", "Отмена");
				dlgcont[playerid] = 1008;
				return 1;
			}
			if(strlen(inputtext) != 6)
			{
				SendClientMessage(playerid, 0xFF0000FF, "Цвет банды должен состоять из 6 символов формата RRGGBB !");
				return true;
			}
			format(GColor[PGang[playerid]], 16, "%sFF", inputtext);
			GColorDec[PGang[playerid]] = HexToInt(GColor[PGang[playerid]]);
			strdel(GColorHex[PGang[playerid]], 0, 16);
			strcat(GColorHex[PGang[playerid]], ColorRes(GColor[PGang[playerid]]));
			format(string, sizeof(string), "Теперь цвет Вашей банды: %s", GColor[PGang[playerid]]);
			SendClientMessage(playerid, 0x00FF00FF, string);
			printf("[GangsSystem] %s [%d] сменил цвет банды на %s.", RealName[playerid], playerid, GColor[PGang[playerid]]);
			GangSave(PGang[playerid]);//запись ID банды в файл
			for(new i=0; i<MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(PGang[i] == PGang[playerid])//если игрок состоит в Вашей банде, то:
					{
						ColorPlay[i] = GColorDec[PGang[playerid]];
						SetPlayerColor(i, ColorPlay[i]);//устанавливаем цвет ника
						for(new j=0;j<MAX_PLAYERS;j++)//устанавливаем цвет маркера для всех игроков
						{
							SetPlayerMarkerForPlayer(j, i, GColorDec[PGang[playerid]]);
						}
					}
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_LIST, "Система банд", "Создать банду\nУдалить банду\
			\nНазначить скины\nНазначить место спавна\nОтменить спавн банды\nНазначить уровень\nПригласить в банду\
			\nВыгнать из банды\nОткл. / вкл. разрешение приглашать Вас в банду\nИзменить название банды\
			\nИзменить цвет банды\nУйти из банды\nИнформация о банде", "Выбор", "Отмена");
			dlgcont[playerid] = 1001;
		}
		return true;
	}
	if(dialogid == 1009)//уход из банды
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(idgangsave[playerid] > 0)//если ID банды для записи - активен, то:
			{
				new perloc;
				idgangsave[playerid] = 0;//очистка ID банды для записи
				perloc = 0;
				while(perloc < MAX_PLAYERS)//цикл для всех игроков
				{
					if(PGang[playerid] == PGang[perloc] && playerid != perloc)
					{//если есть хотя бы один игрок из банды выходящего, то:
						idgangsave[perloc] = PGang[playerid];
						break;
					}
					perloc++;
				}
			}
			idgangsave[playerid] = 0;//очистка ID банды для записи
			format(string,sizeof(string), "Игрок %s ушёл из Вашей банды !", RealName[playerid]);
			for(new i; i<MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(PGang[i] == PGang[playerid] && i != playerid)
					{
						SendClientMessage(i, 0xFF0000FF, string);
					}
				}
			}
			format(string,sizeof(string), "Вы ушли из банды: {FF0000}%s", GName[PGang[playerid]]);
			SendClientMessage(playerid, 0xFFFF00FF, string);
			printf("[GangsSystem] %s [%d] ушёл из банды.", RealName[playerid], playerid);
			GPlayers[PGang[playerid]]--;
			GangSave(PGang[playerid]);//запись ID банды в файл
			PGang[playerid] = 0;
			GangLvl[playerid] = 0;
		}
		else
		{
			ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_LIST, "Система банд", "Создать банду\nУдалить банду\
			\nНазначить скины\nНазначить место спавна\nОтменить спавн банды\nНазначить уровень\nПригласить в банду\
			\nВыгнать из банды\nОткл. / вкл. разрешение приглашать Вас в банду\nИзменить название банды\
			\nИзменить цвет банды\nУйти из банды\nИнформация о банде", "Выбор", "Отмена");
			dlgcont[playerid] = 1001;
		}
		return true;
	}
	if(dialogid == 1010)//назначение спавна банды
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new Float:x, Float:y, Float:z, Interpl, Worldpl;
			GetPlayerPos(playerid, x, y, z);
			Interpl = GetPlayerInterior(playerid);
			Worldpl = GetPlayerVirtualWorld(playerid);
			if(PlayerInfo[playerid][pAdmin] == 0)
			{
				if((-15500 >= x >= -20000 && 15500 <= y <= 20000) ||
						((Worldpl < 6000 || Worldpl > 6999) && z > 1200) ||
						(6000 <= Worldpl <= 6999 && (z < 2900 || z > 3500)))
				{
					ShowPlayerDialog(playerid,2,0,"Ошибка.","В выбранном месте нельзя назначить спавн банды !","OK","");
					return 1;
				}
			}
			GSpawnX[PGang[playerid]] = x;
			GSpawnY[PGang[playerid]] = y;
			GSpawnZ[PGang[playerid]] = z;
			GInter[PGang[playerid]] = Interpl;
			GWorld[PGang[playerid]] = Worldpl;
			printf("[GangsSystem] %s [%d] назначил спавн банды.", RealName[playerid], playerid);
			GangSave(PGang[playerid]);//запись ID банды в файл
		}
		else
		{
			ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_LIST, "Система банд", "Создать банду\nУдалить банду\
			\nНазначить скины\nНазначить место спавна\nОтменить спавн банды\nНазначить уровень\nПригласить в банду\
			\nВыгнать из банды\nОткл. / вкл. разрешение приглашать Вас в банду\nИзменить название банды\
			\nИзменить цвет банды\nУйти из банды\nИнформация о банде", "Выбор", "Отмена");
			dlgcont[playerid] = 1001;
		}
		return true;
	}
	if(dialogid == 1015)//отмена спавна банды
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			new Float:x, Float:y, Float:z, Interpl, Worldpl;
			GSpawnX[PGang[playerid]] = x;
			GSpawnY[PGang[playerid]] = y;
			GSpawnZ[PGang[playerid]] = z;
			GInter[PGang[playerid]] = Interpl;
			GWorld[PGang[playerid]] = Worldpl;
			printf("[GangsSystem] %s [%d] отменил спавн банды.", RealName[playerid], playerid);
			GangSave(PGang[playerid]);//запись ID банды в файл
		}
		else
		{
			ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_LIST, "Система банд", "Создать банду\nУдалить банду\
			\nНазначить скины\nНазначить место спавна\nОтменить спавн банды\nНазначить уровень\nПригласить в банду\
			\nВыгнать из банды\nОткл. / вкл. разрешение приглашать Вас в банду\nИзменить название банды\
			\nИзменить цвет банды\nУйти из банды\nИнформация о банде", "Выбор", "Отмена");
			dlgcont[playerid] = 1001;
		}
		return true;
	}
	if(dialogid == 1011)//назначение скинов банды
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			switch(listitem)
			{
			case 0: gangskin[playerid] = 1;
			case 1: gangskin[playerid] = 2;
			case 2: gangskin[playerid] = 3;
			case 3: gangskin[playerid] = 4;
			case 4: gangskin[playerid] = 5;
			case 5: gangskin[playerid] = 6;
			}
			ShowPlayerDialog(playerid, 1012, DIALOG_STYLE_INPUT, "Назначение скинов банде",
			"Введите id скина, который хотите назначить:\
			\n(id = 500  отменит назначение скина в выбранном слоте)", "Принять", "Отмена");
			dlgcont[playerid] = 1012;
		}
		else
		{
			ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_LIST, "Система банд", "Создать банду\nУдалить банду\
			\nНазначить скины\nНазначить место спавна\nОтменить спавн банды\nНазначить уровень\nПригласить в банду\
			\nВыгнать из банды\nОткл. / вкл. разрешение приглашать Вас в банду\nИзменить название банды\
			\nИзменить цвет банды\nУйти из банды\nИнформация о банде", "Выбор", "Отмена");
			dlgcont[playerid] = 1001;
		}
		return true;
	}
	if(dialogid == 1012)
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(InpTxtControl(inputtext) == 0)
			{
				SendClientMessage(playerid, 0xFF0000FF, "Ошибка, недопустимый символ:");
				SendClientMessage(playerid, 0xFF0000FF, "запрещённые коды, или знак процентов, или ~ !");
				ShowPlayerDialog(playerid, 1012, DIALOG_STYLE_INPUT, "Назначение скинов банде",
				"Введите id скина, который хотите назначить:\
				\n(id = 500  отменит назначение скина в выбранном слоте)", "Принять", "Отмена");
				dlgcont[playerid] = 1012;
				return 1;
			}
			new level = strval(inputtext);
			if((level > 311 || level < 0) && level != 500)
			{
				SendClientMessage(playerid, 0xFF0000FF, "Неправильный id скина !");
				ShowPlayerDialog(playerid, 1012, DIALOG_STYLE_INPUT, "Назначение скинов банде",
				"Введите id скина, который хотите назначить:\
				\n(id = 500  отменит назначение скина в выбранном слоте)", "Принять", "Отмена");
				dlgcont[playerid] = 1012;
				return 1;
			}
			if(level == GSkin[PGang[playerid]][gangskin[playerid]-1])
			{
				SendClientMessage(playerid, 0xFF0000FF, "Выбранный id скина уже записан в выбранном слоте !");
				ShowPlayerDialog(playerid, 1012, DIALOG_STYLE_INPUT, "Назначение скинов банде",
				"Введите id скина, который хотите назначить:\
				\n(id = 500  отменит назначение скина в выбранном слоте)", "Принять", "Отмена");
				dlgcont[playerid] = 1012;
				return 1;
			}
			GSkin[PGang[playerid]][gangskin[playerid]-1] = level;
			for(new i; i<MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i))
				{
					if(PGang[i] == PGang[playerid] && GangLvl[i] == gangskin[playerid] && level != 500)
					{
						SetPVarInt(i, "PlSkin", level);
						SetPlayerSkin(i, GetPVarInt(i, "PlSkin"));
					}
				}
			}
			format(string, sizeof(string), "Скин успешно установлен !   id скина: %i (слот: %d)", level, gangskin[playerid]);
			SendClientMessage(playerid, 0xFFFF00FF, string);
			printf("[GangsSystem] %s [%d] сменил ID скина банды на %i (слот: %d).", RealName[playerid], playerid,
			level, gangskin[playerid]);
			gangskin[playerid] = 0;
			GangSave(PGang[playerid]);//запись ID банды в файл
			ShowPlayerDialog(playerid, 1011, DIALOG_STYLE_LIST, "Назначение скинов банды", "1 - Начинающий\n2 - Игрок\
			\n3 - Про игрок\n4 - Элита\n5 - Зам лидера\n6 - Лидер", "Принять", "Отмена");
			dlgcont[playerid] = 1011;
		}
		else
		{
			ShowPlayerDialog(playerid, 1011, DIALOG_STYLE_LIST, "Назначение скинов банды", "1 - Начинающий\n2 - Игрок\
			\n3 - Про игрок\n4 - Элита\n5 - Зам лидера\n6 - Лидер", "Принять", "Отмена");
			dlgcont[playerid] = 1011;
		}
		return true;
	}
	if(dialogid == 1013)//назначение уровня
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			if(InpTxtControl(inputtext) == 0)
			{
				SendClientMessage(playerid, 0xFF0000FF, "Ошибка, недопустимый символ:");
				SendClientMessage(playerid, 0xFF0000FF, "запрещённые коды, или знак процентов, или ~ !");
				ShowPlayerDialog(playerid, 1013, DIALOG_STYLE_INPUT, "Назначение уровня",
				"Введите id игрока, которому хотите назначить уровень:", "Принять", "Отмена");
				dlgcont[playerid] = 1013;
				return 1;
			}
			if(IsPlayerConnected(strval(inputtext)))
			{
				if(PGang[strval(inputtext)] != PGang[playerid])
				{
					SendClientMessage(playerid, 0xFF0000FF, "Этот игрок не в Вашей банде !");
					return true;
				}
				play333[playerid] = strval(inputtext);
				if(play333[playerid] == playerid)
				{
					SendClientMessage(playerid, 0xFF0000FF,
					"Вы являетесь лидером банды, и не можете назначить уровень сам себе !");
					return true;
				}
				ShowPlayerDialog(playerid, 1014, DIALOG_STYLE_LIST, "Назначение уровня", "1 - Начинающий\n2 - Игрок\
				\n3 - Про игрок\n4 - Элита\n5 - Зам лидера\n6 - Лидер", "Принять", "Отмена");
				dlgcont[playerid] = 1014;
			}else return SendClientMessage(playerid, 0xFF0000FF, "Этот игрок не в игре !");
		}
		else
		{
			ShowPlayerDialog(playerid, 1001, DIALOG_STYLE_LIST, "Система банд", "Создать банду\nУдалить банду\
			\nНазначить скины\nНазначить место спавна\nОтменить спавн банды\nНазначить уровень\nПригласить в банду\
			\nВыгнать из банды\nОткл. / вкл. разрешение приглашать Вас в банду\nИзменить название банды\
			\nИзменить цвет банды\nУйти из банды\nИнформация о банде", "Выбор", "Отмена");
			dlgcont[playerid] = 1001;
		}
		return true;
	}
	if(dialogid == 1014)
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		if(response)
		{
			GangDopper[playerid] = 0;
			if((listitem + 1) == GangLvl[play333[playerid]])
			{
				SendClientMessage(playerid, 0xFF0000FF, "У выбранного игрока уже есть выбранный уровень !");
				play333[playerid] = -1;
				ShowPlayerDialog(playerid, 1013, DIALOG_STYLE_INPUT, "Назначение уровня",
				"Введите id игрока, которому хотите назначить уровень:", "Принять", "Отмена");
				dlgcont[playerid] = 1013;
				return 1;
			}
			switch(listitem)
			{
			case 0: GangLvl[play333[playerid]] = 1;
			case 1: GangLvl[play333[playerid]] = 2;
			case 2: GangLvl[play333[playerid]] = 3;
			case 3: GangLvl[play333[playerid]] = 4;
			case 4: GangLvl[play333[playerid]] = 5;
			case 5: GangDopper[playerid] = 6;
			}
			if(GangDopper[playerid] == 6)
			{
				ShowPlayerDialog(playerid, 1017, DIALOG_STYLE_MSGBOX, "Внимание !!!", "В банде может быть только один лидер !!!\
				\nВыбранный игрок получит уровень лидера,\nа Вы - уровень зам лидера.", "Принять", "Отмена");
				dlgcont[playerid] = 1017;
			}
			else
			{
				format(string, sizeof(string), "Вы назначили игроку %s уровень %i",
				RealName[play333[playerid]], GangLvl[play333[playerid]]);
				SendClientMessage(playerid, 0xFFFF00FF, string);
				format(string, sizeof(string), "Лидер %s назначил Вам уровень %i",
				RealName[playerid], GangLvl[play333[playerid]]);
				SendClientMessage(play333[playerid], 0xFFFF00FF, string);
				printf("[GangsSystem] %s [%d] назначил игроку %s уровень %i.",
				RealName[playerid], playerid, RealName[play333[playerid]], GangLvl[play333[playerid]]);
				if(GSkin[PGang[playerid]][GangLvl[play333[playerid]]-1] < 500)
				{
					SetPVarInt(play333[playerid], "PlSkin", GSkin[PGang[playerid]][GangLvl[play333[playerid]]-1]);
					SetPlayerSkin(play333[playerid], GetPVarInt(play333[playerid], "PlSkin"));
				}
				play333[playerid] = -1;
				ShowPlayerDialog(playerid, 1013, DIALOG_STYLE_INPUT, "Назначение уровня",
				"Введите id игрока, которому хотите назначить уровень:", "Принять", "Отмена");
				dlgcont[playerid] = 1013;
			}
		}
		else
		{
			ShowPlayerDialog(playerid, 1013, DIALOG_STYLE_INPUT, "Назначение уровня",
			"Введите id игрока, которому хотите назначить уровень:", "Принять", "Отмена");
			dlgcont[playerid] = 1013;
		}
		return true;
	}
	if(dialogid == 1017)
	{
		if(dialogid != dlgcont[playerid])
		{
			dlgcont[playerid] = -600;//не существующий ИД диалога
			return 1;
		}
		dlgcont[playerid] = -600;//не существующий ИД диалога
		GangDopper[playerid] = 0;
		if(response)
		{
			strdel(GHead[PGang[play333[playerid]]], 0, 64);
			strcat(GHead[PGang[play333[playerid]]], RealName[play333[playerid]]);
			GangSave(PGang[play333[playerid]]);//запись ID банды в файл

			GangLvl[play333[playerid]] = 6;
			format(string, sizeof(string), "Вы назначили игроку %s уровень лидера.", RealName[play333[playerid]]);
			SendClientMessage(playerid, 0xFFFF00FF, string);
			format(string, sizeof(string), "Лидер %s назначил Вам уровень лидера.", RealName[playerid]);
			SendClientMessage(play333[playerid], 0xFFFF00FF, string);
			printf("[GangsSystem] %s [%d] назначил игроку %s уровень лидера.", RealName[playerid],
			playerid, RealName[play333[playerid]]);
			if(GSkin[PGang[playerid]][GangLvl[play333[playerid]]-1] < 500)
			{
				SetPVarInt(play333[playerid], "PlSkin", GSkin[PGang[playerid]][GangLvl[play333[playerid]]-1]);
				SetPlayerSkin(play333[playerid], GetPVarInt(play333[playerid], "PlSkin"));
			}

			GangLvl[playerid] = 5;
			SendClientMessage(playerid, 0xFFFF00FF, "Вы назначили себе уровень зам лидера.");
			format(string, sizeof(string), "Лидер %s назначил себе уровень зам лидера.", RealName[playerid]);
			SendClientMessage(play333[playerid], 0xFFFF00FF, string);
			printf("[GangsSystem] %s [%d] назначил себе уровень зам лидера.", RealName[playerid], playerid);
			if(GSkin[PGang[playerid]][GangLvl[playerid]-1] < 500)
			{
				SetPVarInt(playerid, "PlSkin", GSkin[PGang[playerid]][GangLvl[playerid]-1]);
				SetPlayerSkin(playerid, GetPVarInt(playerid, "PlSkin"));
			}

			play333[playerid] = -1;
		}
		else
		{
			ShowPlayerDialog(playerid, 1013, DIALOG_STYLE_INPUT, "Назначение уровня",
			"Введите id игрока, которому хотите назначить уровень:", "Принять", "Отмена");
			dlgcont[playerid] = 1013;
		}
		return true;
	}
	return 0;
}
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	player[playerid] = clickedplayerid;
	format(playtarget[playerid], MAX_PLAYER_NAME, "%s", RealName[player[playerid]]);
	if(PlayerInfo[playerid][pAdmin] >= 1 && PlayerInfo[playerid][pAdmin] <= 12 && PlayerInfo[player[playerid]][pAdmin] >= 13)
	{
		ShowPlayerDialog(playerid, 2, 0, "Информация.", "Выбранный игрок защищён !", "OK", "");
		return 1;
	}
	if(PlayerInfo[playerid][pAdmin] == 0 && PlayerInfo[player[playerid]][pAdmin] >= 1 &&
			PlayerInfo[player[playerid]][pAdmshad] == 0)
	{
		ShowPlayerDialog(playerid, 2, 0, "Информация.", "Нельзя !\nВыбранный игрок - админ !", "OK", "");
		return 1;
	}
	new string[128];
	new strdln[1024];
	if(PlayerInfo[playerid][pAdmin] >= 1)
	{
		format(strdln, sizeof(strdln), "Тп к нему (1)\nТп его к себе (1)\nНаблюдать (1)\nСнять наблюдение (1)\
		\nПополнить жизнь (3)\nБан (6)\nКик (5)\nЗаблокировать (2)\nРазблокировать (2)\nЗаморозить (2)\
		\nРазморозить (2)\nУбить (3)\nЗаткнуть (2)\nПосадить в тюрьму (2)\nТп себя в тюрьму (1)\
		\nТп себя в полицейский участок (1)\nПросмотреть статистику (1)\nСменить скин (3)\nУзнать IP (1)\nСлапнуть (1)");
		format(string, sizeof(string), "Админ-меню. ( %s [%d] )", playtarget[playerid], player[playerid]);
		ShowPlayerDialog(playerid, 5, DIALOG_STYLE_LIST, string, strdln, "Выбор", "Отмена");
		dlgcont[playerid] = 5;
	}else{
		if(PlayerInfo[player[playerid]][pAdmlive] == 0)
		{
			format(strdln, sizeof(strdln), "Статистика игрока %s [%d] :\n\nДенег: %d $\nОчков: %d\nУбийств: %d\
			\nСмертей: %d\nВремя затыка: %d секунд.\nВремя тюрьмы: %d секунд.\nБессмертие: {FF0000}нет.",
			playtarget[playerid], player[playerid], GetPlayerMoney(player[playerid]), GetPlayerScore(player[playerid]),
			PlayerInfo[player[playerid]][pKills], PlayerInfo[player[playerid]][pDeaths],
			PlayerInfo[player[playerid]][pMutedsec], PlayerInfo[player[playerid]][pPrisonsec]);
		}
		else
		{
			format(strdln, sizeof(strdln), "Статистика игрока %s [%d] :\n\nДенег: %d $\nОчков: %d\nУбийств: %d\
			\nСмертей: %d\nВремя затыка: %d секунд.\nВремя тюрьмы: %d секунд.\nБессмертие: {FFFF00}есть.",
			playtarget[playerid], player[playerid], GetPlayerMoney(player[playerid]), GetPlayerScore(player[playerid]),
			PlayerInfo[player[playerid]][pKills], PlayerInfo[player[playerid]][pDeaths],
			PlayerInfo[player[playerid]][pMutedsec], PlayerInfo[player[playerid]][pPrisonsec]);
		}
		ShowPlayerDialog(playerid, 2, 0, "Информация.", strdln, "OK", "");
	}
	return 1;
}
forward DelAkk22(para1);//Gangs system
public DelAkk22(para1)
{
	new string[256], ssss[256];
	format(string,sizeof(string),"gangs/%d.ini",para1);
	new para3[130];
	strdel(para3, 0, 130);
	strcat(para3, GName[para1]);
	strdel(GTDReg[para1], 0, 32);
	strdel(GHead[para1], 0, 64);
	strdel(GName[para1], 0, 130);
	strdel(GColor[para1], 0, 16);
	strdel(GColorHex[para1], 0, 16);
	GSpawnX[para1] = 0.00;
	GSpawnY[para1] = 0.00;
	GSpawnZ[para1] = 0.00;
	GInter[para1] = 0;
	GWorld[para1] = 0;
	GSkin[para1][0] = 500;
	GSkin[para1][1] = 500;
	GSkin[para1][2] = 500;
	GSkin[para1][3] = 500;
	GSkin[para1][4] = 500;
	GSkin[para1][5] = 500;
	GPlayers[para1] = 0;
	fremove(string);//удаляем банду
	format(ssss,sizeof(ssss)," и удалил банду [%s{33CCFF}] (автоматически) .", para3);
	print(ssss);
	SendClientMessageToAll(COLOR_LIGHTBLUE, ssss);
	for(new i; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PGang[i] == para1)
			{
				SendClientMessage(i, 0xFF0000FF, "Ваша банда была удалена !");
				PGang[i] = 0;
				GangLvl[i] = 0;
			}
		}
	}
	SetTimerEx("DelAkk33", 300, 0, "i", para1);
	return 1;
}

forward DelAkk33(para1);
public DelAkk33(para1)
{
	Gang[para1] = 0;
	return 1;
}

stock GetFreeGang()
{
	for(new i = 1; i < MAX_GANGS; i++)
	{
		if(Gang[i] == 0) { return i; }
	}
	return false;
}

forward SaveGangOn(gangid);
public SaveGangOn(gangid)
{
	GangSA[gangid] = 1;
	return true;
}

forward SaveGangOff(playerid);
public SaveGangOff(playerid)
{
	new gangdata;
	gangdata = PGang[playerid];
	strdel(GTDReg[PGang[playerid]], 0, 32);
	strdel(GHead[PGang[playerid]], 0, 64);
	strdel(GColor[PGang[playerid]], 0, 16);
	strdel(GColorHex[PGang[playerid]], 0, 16);
	GSpawnX[PGang[playerid]] = 0.00;
	GSpawnY[PGang[playerid]] = 0.00;
	GSpawnZ[PGang[playerid]] = 0.00;
	GInter[PGang[playerid]] = 0;
	GWorld[PGang[playerid]] = 0;
	GSkin[PGang[playerid]][0] = 500;
	GSkin[PGang[playerid]][1] = 500;
	GSkin[PGang[playerid]][2] = 500;
	GSkin[PGang[playerid]][3] = 500;
	GSkin[PGang[playerid]][4] = 500;
	GSkin[PGang[playerid]][5] = 500;
	GPlayers[PGang[playerid]] = 0;
	for(new i; i<MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PGang[i] == PGang[playerid] && i != playerid)
			{
				SendClientMessage(i, 0xFF0000FF, "Ваша банда была удалена !");
				PGang[i] = 0;
				GangLvl[i] = 0;
			}
		}
	}
	printf("[GangsSystem] %s [%d] удалил банду %s.", RealName[playerid], playerid, GName[PGang[playerid]]);
	new string[256];
	format(string,sizeof(string),"gangs/%d.ini",PGang[playerid]);
	fremove(string);
	SendClientMessage(playerid, 0xFF0000FF, "Ваша банда была удалена !");
	strdel(GName[PGang[playerid]], 0, 130);
	PGang[playerid] = 0;
	GangLvl[playerid] = 0;
	SetTimerEx("SaveGangOff22", 300, 0, "i", gangdata);
	return true;
}

forward SaveGangOff22(gangid);
public SaveGangOff22(gangid)
{
	Gang[gangid] = 0;
	return true;
}
public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
        if(PlayerInfo[playerid][pAdmin] >= 1)
        {
                new vehicleid = GetPlayerVehicleID(playerid); // Узнаем ID машины в которой сидит игрок
                if(vehicleid > 0 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) // Если игрок в транспорте и он водитель
                {
                        SetVehiclePos(vehicleid, fX, fY, fZ); // Телепорт транспорта
                }
                else // Если игрок НЕ находится в транспорте
                {
                        SetPlayerPos(playerid, fX, fY, fZ); // Телепорт игрока
                }
                SendClientMessage(playerid, -1, "Вы были успешно телепортированы."); // Сообщение о успешном телепорте
        }
        return 1;
}
forward GangLoad();
public GangLoad()
{
	new file, f[256];
	for(new i=1; i<(MAX_GANGS - 1); i++)
	{
		format(f, 256, "gangs/%i.ini", i);
		file = ini_openFile(f);
		if(file == INI_OK)
		{
			ini_getString(file, "Gang TDReg", GTDReg[i]);
			ini_getString(file, "Gang head", GHead[i]);
			ini_getString(file, "Gang name", GName[i]);
			ini_getString(file, "Gang color", GColor[i]);
			ini_getFloat(file, "SpawnX", GSpawnX[i]);
			ini_getFloat(file, "SpawnY", GSpawnY[i]);
			ini_getFloat(file, "SpawnZ", GSpawnZ[i]);
			ini_getInteger(file, "GInter", GInter[i]);
			ini_getInteger(file, "GWorld", GWorld[i]);
			ini_getInteger(file, "Skin1", GSkin[i][0]);
			ini_getInteger(file, "Skin2", GSkin[i][1]);
			ini_getInteger(file, "Skin3", GSkin[i][2]);
			ini_getInteger(file, "Skin4", GSkin[i][3]);
			ini_getInteger(file, "Skin5", GSkin[i][4]);
			ini_getInteger(file, "Skin6", GSkin[i][5]);
			ini_getInteger(file, "Players", GPlayers[i]);
			ini_closeFile(file);
			Gang[i] = 1;
			GangSA[i] = 1;
		}
		else
		{
			Gang[i] = 0;
			GangSA[i] = 0;
		}
		GColorDec[i] = HexToInt(GColor[i]);
		strdel(GColorHex[i], 0, 16);
		strcat(GColorHex[i], ColorRes(GColor[i]));
	}
	return true;
}

forward GangSave(gangid);
public GangSave(gangid)
{
	if(GangSA[gangid] == 1)
	{
		new f[256];
		format(f, 256, "gangs/%i.ini", gangid);
		new file = ini_openFile(f);
		if(file == INI_OK)
		{
			ini_setString(file, "Gang TDReg", GTDReg[gangid]);
			ini_setString(file, "Gang head", GHead[gangid]);
			ini_setString(file, "Gang name", GName[gangid]);
			ini_setString(file, "Gang color", GColor[gangid]);
			ini_setFloat(file, "SpawnX", GSpawnX[gangid]);
			ini_setFloat(file, "SpawnY", GSpawnY[gangid]);
			ini_setFloat(file, "SpawnZ", GSpawnZ[gangid]);
			ini_setInteger(file, "GInter", GInter[gangid]);
			ini_setInteger(file, "GWorld", GWorld[gangid]);
			ini_setInteger(file, "Skin1", GSkin[gangid][0]);
			ini_setInteger(file, "Skin2", GSkin[gangid][1]);
			ini_setInteger(file, "Skin3", GSkin[gangid][2]);
			ini_setInteger(file, "Skin4", GSkin[gangid][3]);
			ini_setInteger(file, "Skin5", GSkin[gangid][4]);
			ini_setInteger(file, "Skin6", GSkin[gangid][5]);
			ini_setInteger(file, "Players", GPlayers[gangid]);
			ini_closeFile(file);
		}
	}
	return true;
}

//Returns number of connected players
stock ConnectedPlayers()
{
	new count;
	for(new x=0; x<MAX_PLAYERS; x++) {
	    if(IsPlayerConnected(x)) {
			count++;
		}
	}
	return count;
}

stock adminspec_strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

stock HexToInt(string[])
{
	if(string[0] == 0) { return 0; }
	new i;
	new cur=1;
	new res=0;
	for(i = strlen(string); i > 0; i--)
	{
		if(string[i-1] < 58)
		{
			res = res  +cur * (string[i-1] - 48);
		}
		else
		{
			res = res + cur * (string[i-1] - 65 + 10);
		}
		cur = cur * 16;
	}
	return res;
}

stock ColorRes(string[])//восстановление цвета банды
{
	new string555[16];//преобразуем 32-битный цвет в 24-битный (что бы десятичное значение цвета было в
	strmid(string555, string, 0, 6, sizeof(string555));//положительном диапазоне чисел)
	new dop11;//переводим шестнадцатиричный цвет в десятичный стандартной функцией
	dop11 = HexToInt(string555);
	new dopper[7];//переводим десятичный цвет в шестнадцатиричный (для окраски названия банды)
	dopper[0] = 48;//самый старший разряд = 0 (на случай, если цвет в пределах 3-х байт)
	new dop22 = 0;
	if(dop11 > 16777215)//если цвет за пределами 3-х байт (один из вариантов не корректного цвета), то:
	{
		dop22 = dop11 / 16777216;//вычитаем переполнение...
		dop11 = dop11 - (dop22 * 16777216);
		if(dop22 > 9)//и записываем это переполнение в самый старший разряд
		{
			dopper[0] = dop22 + 55;
		}
		else
		{
			dopper[0] = dop22 + 48;
		}
	}
	new dop33 = 1048576;
	for(new j = 1; j < 7; j++)//перевод десятичного цвет в шестнадцатиричный
	{
		dop22 = dop11 / dop33;
		dop11 = dop11 - (dop22 * dop33);
		if(dop22 > 9)
		{
			dopper[j] = dop22 + 55;
		}
		else
		{
			dopper[j] = dop22 + 48;
		}
		dop33 = dop33 / 16;
	}
	strdel(string555, 0, 16);//очищаем переменную 24-битного цвета
	strmid(string555, dopper, 1, 7, sizeof(string555));//записываем в переменную 24-битного цвета восстановленный цвет
	return string555;
}

forward DestrCar(playerid);
public DestrCar(playerid)
{
	if(GetPlayerVehicleID(playerid) != 0)//если игрок в транспорте, то:
	{
		new Float:igx, Float:igy, Float:igz;//высадить игрока
		GetPlayerPos(playerid, igx, igy, igz);
		SetPlayerPos(playerid, igx+3, igy+3, igz+5);
	}
	if(playcar[playerid] != 0)//если у игрока есть свой транспорт, то:
	{
		for(new i = 0; i < MAX_PLAYERS; i++)//поиск и удаление чужого неона
		{
			if(playcar[playerid] == neon[i][2])
			{
				DestroyObject(neon[i][0]);//убрать неон
				DestroyObject(neon[i][1]);//убрать неон
				neon[i][0] = 0;//присваиваем неону несуществующий номер объекта
				neon[i][1] = 0;//присваиваем неону несуществующий номер объекта
				neon[i][2] = 0;//несуществующий ид транспорта с неоном
			}
		}
		if(neon[playerid][0] != 0) { DestroyObject(neon[playerid][0]); }//убрать неон
		if(neon[playerid][1] != 0) { DestroyObject(neon[playerid][1]); }//убрать неон
		neon[playerid][0] = 0;//присваиваем неону несуществующий номер объекта
		neon[playerid][1] = 0;//присваиваем неону несуществующий номер объекта
		neon[playerid][2] = 0;//несуществующий ид транспорта с неоном
		DestroyVehicle(playcar[playerid]);//уничтожить свой транспорт
		playcar[playerid] = 0;//несуществующий ид транспорта
	}
	return 1;
}

forward LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);
public LogTelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3)
{
	new carpl, modelcar;
	carpl = GetPlayerVehicleID(playerid);//получение ид авто инициатора
	modelcar = GetVehicleModel(carpl);//получение ид модели авто инициатора
	if(modelcar != 432)//если игрок НЕ в танке, то: тп 1 раз
	{
		SetTimerEx("TelPort", 300, 0, "ddddffff", playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2 ,Float:cor3);
	}
	else//иначе: тп 3 раза
	{
		SetTimerEx("TelPort", 300, 0, "ddddffff", playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);
		TelPortDop11(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);
		TelPortDop22(playerid, regm, per1, per2, Float:per3, Float:cor1 ,Float:cor2, Float:cor3);
	}
	return 1;
}

forward TelPortDop11(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);
public TelPortDop11(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3)
{
	SetTimerEx("TelPort", 600, 0, "ddddffff", playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);
	return 1;
}

forward TelPortDop22(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);
public TelPortDop22(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3)
{
	SetTimerEx("TelPort", 900, 0, "ddddffff", playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);
	return 1;
}

forward TelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3);
public TelPort(playerid, regm, per1, per2, Float:per3, Float:cor1, Float:cor2, Float:cor3)
{
	if(regm == 0)
	{
		new car;//флипнуть
		new Float:angle;
		car = GetPlayerVehicleID(playerid);
		GetVehicleZAngle(car, angle);
		SetVehicleZAngle(car, angle);
		return 1;
	}
	if(regm == 1)
	{
		SetPlayerInterior(playerid, per1);//телепортировать
		SetPlayerVirtualWorld(playerid, per2);
		new VID = GetPlayerVehicleID(playerid);
		new Float:angle;
		LinkVehicleToInterior(VID, per1);//подключить транспорт к ТП интерьеру
		SetVehicleVirtualWorld(VID, per2);//установить транспорту виртуальный мир игрока
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(GetPlayerVehicleID(i) == VID && i != playerid)
				{//установить пассажирам интерьер и виртуальный мир игрока
					SetPlayerInterior(i, per1);
					SetPlayerVirtualWorld(i, per2);
				}
			}
		}
		SetVehiclePos(VID, cor1, cor2, cor3);
		GetVehicleZAngle(VID, angle);//флипнуть
		SetVehicleZAngle(VID, angle);
		SetPlayerPos(playerid, cor1, cor2, cor3);
		PutPlayerInVehicle(playerid, VID, 0);
		return 1;
	}
	if(regm == 2)
	{
		SetPlayerInterior(playerid, per1);//телепортировать с углом авто
		SetPlayerVirtualWorld(playerid, per2);
		new VID = GetPlayerVehicleID(playerid);
		LinkVehicleToInterior(VID, per1);//подключить транспорт к ТП интерьеру
		SetVehicleVirtualWorld(VID, per2);//установить транспорту виртуальный мир игрока
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))
			{
				if(GetPlayerVehicleID(i) == VID && i != playerid)
				{//установить пассажирам интерьер и виртуальный мир игрока
					SetPlayerInterior(i, per1);
					SetPlayerVirtualWorld(i, per2);
				}
			}
		}
		SetVehiclePos(VID, cor1, cor2, cor3);
		SetVehicleZAngle(VID, per3);
		SetPlayerPos(playerid, cor1, cor2, cor3);
		PutPlayerInVehicle(playerid, VID, 0);
	}
	return 1;
}

forward entcar22(playerid, testcar);
public entcar22(playerid, testcar)
{
	new dopper = -600;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(GetPlayerVehicleID(i) == testcar && GetPlayerVehicleSeat(i) == 0)
			{//если в ТП-авто есть игрок, И этот игрок на месте водителя, то:
				dopper = i;//запомнить ИД игрока
			}
		}
	}
	if(dopper != -600)//если ИД игрока найден, то:
	{
		new Float:x, Float:y, Float:z;
		GetPlayerPos(dopper, x, y, z);//высадить игрока
		SetPlayerPos(dopper, x+3, y+3, z);
		new string[256];
		format(string, sizeof(string), " Админ %s высадил игрока %s [%d] из транспорта  ID: %d",
		RealName[playerid], RealName[dopper], dopper, testcar);
		print(string);
		SendAdminMessage(COLOR_YELLOW, string);
	}
	SetPlayerVirtualWorld(playerid, GetVehicleVirtualWorld(testcar));//установить игроку виртуальный мир транспорта
	SetTimerEx("entcar33", 300, 0, "ii", playerid, testcar);
	return 1;
}

forward entcar33(playerid, testcar);
public entcar33(playerid, testcar)
{
	new string[256];
	PutPlayerInVehicle(playerid, testcar, 0);
	format(string, sizeof(string), " Админ %s телепортировался в транспорт   ID: %d.", RealName[playerid], testcar);
	print(string);
	format(string, sizeof(string), " Вы были телепортированы в транспорт   ID: %d", testcar);
	SendClientMessage(playerid, COLOR_GRAD2, string);
	return 1;
}

forward RestartS();
public RestartS()
{
	restrest = 1;//переменная рестарта сервера
	new per;

	KillTimer(fivesectimer);
	KillTimer(restart);
	KillTimer(autorepaircar);
	KillTimer(onsectimer);
	KillTimer(minsertimer);
	KillTimer(timer200);
	KillTimer(timpolsec);

	SendClientMessageToAll(COLOR_ORANGE,"*** Restart");

	SetTimerEx("ResServ", 1000, 0, "i", per);
	return 1;
}

forward ResServ(per);
public ResServ(per)
{
	new string[256];
	for(new j = 0; j < 16; j++)
	{
		if(strlen(relFS[j]))//если строка НЕ пустая, то:
		{
			strdel(string, 0, 256);//очистка переменной string
			strcat(string, "unloadfs ");//сборка RCON-команды выгрузки фильтрскрипта
			strcat(string, relFS[j]);
			SendRconCommand(string);//RCON-команда выгрузки фильтрскрипта
		}
	}

	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		TextDrawHideForPlayer(i, TScore[i]);
		TextDrawDestroy(TScore[i]);
		if(mapiconid[i] != -600)//если ID мап иконки наблюдения НЕ пустой, то:
		{
			DestroyDynamicMapIcon(mapiconid[i]);//удаление мап иконки наблюдения
		}
		mapiconid[i] = -600;//очистка ID мап иконки наблюдения
		if(IsPlayerConnected(i))
		{
			PlayKick(i);
		}
	}

	DestroyDynamicPickup(Pic44[12]);//удаляем пикап входа в дом-бар Чилиад
	DestroyDynamicPickup(Pic44[13]);//удаляем пикап выхода дом-бар Чилиад
	for(new i = 0; i < 16; i++)
	{
		DestroyDynamicPickup(Pic44[i]);//удаляем пикапы
	}

	SetTimerEx("ResServ222", 5000, 0, "i", per);
	return 1;
}

forward ResServ222(per);
public ResServ222(per)
{
	SendRconCommand("gmx");
	return 1;
}

forward SecSpa(playerid);
public SecSpa(playerid)
{
	LockSpawn[playerid] = 1;//блокировка заполнения слотов оружия и предметов
	OnPlayerSpawn(playerid);
	return 1;
}

forward SecSpaDop(playerid);
public SecSpaDop(playerid)
{
	OnPlayerSpawn(playerid);
	return 1;
}

forward ClearChat(playerid, data);
public ClearChat(playerid, data)
{
	if(IsPlayerConnected(playerid))
	{
		for(new i = 0; i < 150; i++)
		{
			if(data == 0) { SendClientMessage(playerid, COLOR_WHITE, " "); }
			if(data == 1) { SendClientMessageToAll(COLOR_WHITE, " "); }
		}
	}
	return 1;
}

forward DopAdmtp(playerid, target);
public DopAdmtp(playerid, target)
{
	new Float:PosX, Float:PosY, Float:PosZ;
	SetPlayerInterior(target, GetPlayerInterior(playerid));
	SetPlayerVirtualWorld(target, GetPlayerVirtualWorld(playerid));
	GetPlayerPos(playerid, PosX, PosY, PosZ);
	SetPlayerPos(target, PosX, PosY+1, PosZ+1);
	return 1;
}
forward PlayKick(playerid);
public PlayKick(playerid)
{
	Kick(playerid);
	return 1;
}

forward PlayBan(playerid);
public PlayBan(playerid)
{
	BanEx(playerid, fbanreason[playerid]);
	return 1;
}

forward PassControl(string[]);
public PassControl(string[])//контроль пароля на посторонние символы
{
	new dln, dopper;
	dln = strlen(string);
	dopper = 1;
	for(new i = 0; i < dln; i++)
	{
		if(string[i] < 48 || (string[i] > 57 && string[i] < 65) ||
				(string[i] > 90 && string[i] < 97) || string[i] > 122) { dopper = 0; }
	}
	return dopper;
}

forward InpTxtControl(string[]);
public InpTxtControl(string[])//контроль вводимого текста на посторонние символы
{
	new dln, dopper;
	dln = strlen(string);
	dopper = 1;
	for(new i = 0; i < dln; i++)
	{
		if(string[i] < 32 || string[i] == 37 || string[i] == 126 ||
				string[i] == 127 || string[i] == 152 || string[i] == 160) { dopper = 0; }
	}
	return dopper;
}

forward VehicSpawnKK(playerid, vehid, vehcol1, vehcol2, dispz);
public VehicSpawnKK(playerid, vehid, vehcol1, vehcol2, dispz)
{
	if(admper1[playerid] != 600)
	{
		SendClientMessage(playerid, COLOR_RED, " В режиме наблюдения эта команда не работает !");
		return 1;
	}
	VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
	return 1;
}

forward VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
public VehicSpawn(playerid, vehid, vehcol1, vehcol2, dispz)
{
	if(GetPlayerVehicleID(playerid) == playcar[playerid] && playcar[playerid] != 0)
	{//если игрок в своём авто, и у игрока ТОЧНО есть свой авто, то:
		new Float:igx, Float:igy, Float:igz;
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))//дальнейшее выполняем если игрок в коннекте
			{
				if(GetPlayerVehicleID(i) == playcar[playerid] && playerid != i)
				{//если есть пассажир (пассажиры) в авто водителя, то:
					GetPlayerPos(i, igx, igy, igz);//высадить пассажира (пассажиров)
					SetPlayerPos(i, igx+3, igy+3, igz);
				}
				if(admper1[i] != 600 && admper1[i] == playerid)//если есть админ ведущий наблюдение,
				{//И этот админ наблюдает за игроком, то:
					admper5[i] = 2;//устанавливаем переключение наблюдения
				}
			}
		}
	}
	if(GetPlayerVehicleID(playerid) != playcar[playerid] && IsPlayerInAnyVehicle(playerid))
	{//если игрок НЕ в своём авто (но обязательно в авто), то:
		new Float:igx, Float:igy, Float:igz;
		GetPlayerPos(playerid, igx, igy, igz);//выйти самому из авто
		SetPlayerPos(playerid, igx+3, igy+3, igz);
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i))//дальнейшее выполняем если игрок в коннекте
			{
				if(admper1[i] != 600 && admper1[i] == playerid)//если есть админ ведущий наблюдение,
				{//И этот админ наблюдает за игроком, то:
					admper5[i] = 2;//устанавливаем переключение наблюдения
				}
			}
		}
	}
	SetTimerEx("VehicSecSpawn", 300, 0, "iiiii", playerid, vehid, vehcol1, vehcol2, dispz);
	return 1;
}

forward VehicSecSpawn(playerid, vehid, vehcol1, vehcol2, dispz);
public VehicSecSpawn(playerid, vehid, vehcol1, vehcol2, dispz)
{
	new Float:x, Float:y, Float:z, Float:Angle;
	GetPlayerPos(playerid, x, y, z);
	if (GetPlayerState(playerid) == 2 || GetPlayerState(playerid) == 3)
	{
		GetVehicleZAngle(GetPlayerVehicleID(playerid), Angle);
	}
	else
	{
		GetPlayerFacingAngle(playerid, Angle);
	}
	new plvw;
	plvw = GetPlayerVirtualWorld(playerid);
	if(playcar[playerid] == 0)//если у игрока нет своего транспорта, то:
	{
		playcar[playerid] = CreateVehicle(vehid, x, y, z+dispz, Angle, vehcol1, vehcol2, 90000);//создать новый транспорт
		LinkVehicleToInterior(playcar[playerid], GetPlayerInterior(playerid));//подключить транспорт к интерьеру игрока
		SetVehicleVirtualWorld(playcar[playerid], plvw);//установить транспорту виртуальный мир игрока
		PutPlayerInVehicle(playerid, playcar[playerid], 0);//посадить игрока на место водителя
	}else{//иначе: (если у игрока ЕСТЬ свой транспорт)
		if(playcar[playerid] == neon[playerid][2])//если у игрока установлен свой неон на транспорте, то:
		{
			DestroyVehicle(playcar[playerid]);//удалить старый транспорт
			playcar[playerid] = CreateVehicle(vehid, x, y, z+dispz, Angle, vehcol1, vehcol2, 90000);//создать новый транспорт
			LinkVehicleToInterior(playcar[playerid], GetPlayerInterior(playerid));//подключить транспорт к интерьеру игрока
			SetVehicleVirtualWorld(playcar[playerid], plvw);//установить транспорту виртуальный мир игрока
			PutPlayerInVehicle(playerid, playcar[playerid], 0);//посадить игрока на место водителя
			AttachObjectToVehicle(neon[playerid][0], playcar[playerid], -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);//прикрепить неон к транспорту
			AttachObjectToVehicle(neon[playerid][1], playcar[playerid], 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);//прикрепить неон к транспорту
			neon[playerid][2] = playcar[playerid];//заменить ид транспорта с неоном
		}
		else//иначе: (если у игрока НЕ установлен свой неон на транспорте)
		{
			new dopper = 0;
			new dopper22 = -600;
			while(dopper < MAX_PLAYERS)//поиск чужого неона на транспорте игрока
			{
				if(playcar[playerid] == neon[dopper][2] && playerid != dopper)
				{//если был найден чужой неон на транспорте игрока, то:
					dopper22 = dopper;
					break;
				}
				dopper++;
			}
			if(dopper22 != -600)//если был найден чужой неон на транспорте игрока, то:
			{
				DestroyVehicle(playcar[playerid]);//удалить старый транспорт
				playcar[playerid] = CreateVehicle(vehid, x, y, z+dispz, Angle, vehcol1, vehcol2, 90000);//создать новый транспорт
				LinkVehicleToInterior(playcar[playerid], GetPlayerInterior(playerid));//подключить транспорт к интерьеру игрока
				SetVehicleVirtualWorld(playcar[playerid], plvw);//установить транспорту виртуальный мир игрока
				PutPlayerInVehicle(playerid, playcar[playerid], 0);//посадить игрока на место водителя
				AttachObjectToVehicle(neon[dopper22][0], playcar[playerid], -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);//прикрепить неон к транспорту
				AttachObjectToVehicle(neon[dopper22][1], playcar[playerid], 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);//прикрепить неон к транспорту
				neon[dopper22][2] = playcar[playerid];//заменить ид транспорта с неоном
			}
			else//иначе: (если НЕ был найден чужой неон на транспорте игрока)
			{
				DestroyVehicle(playcar[playerid]);//удалить старый транспорт
				playcar[playerid] = CreateVehicle(vehid, x, y, z+dispz, Angle, vehcol1, vehcol2, 90000);//создать новый транспорт
				LinkVehicleToInterior(playcar[playerid], GetPlayerInterior(playerid));//подключить транспорт к интерьеру игрока
				SetVehicleVirtualWorld(playcar[playerid], plvw);//установить транспорту виртуальный мир игрока
				PutPlayerInVehicle(playerid, playcar[playerid], 0);//посадить игрока на место водителя
			}
		}
	}
	return 1;
}

forward DubTlp(playerid);
public DubTlp(playerid)
{
	if(GetPlayerState(playerid) == 2)
	{
		new regm = 2, per1, per2, Float:per3;
		per1 = TpPosP[playerid][0];
		per2 = TpPosP[playerid][1];
		per3 = TpDestP[playerid][3];
		LogTelPort(playerid, regm, per1, per2, Float:per3, Float:TpDestP[playerid][0], Float:TpDestP[playerid][1],
Float:TpDestP[playerid][2]+1);
	}
	else
	{
		SetPlayerInterior(playerid, TpPosP[playerid][0]);
		SetPlayerVirtualWorld(playerid, TpPosP[playerid][1]);
		SetPlayerPos(playerid, TpDestP[playerid][0], TpDestP[playerid][1], TpDestP[playerid][2]+1);
		SetPlayerFacingAngle(playerid, TpDestP[playerid][3]);
		SetCameraBehindPlayer(playerid);
	}
	SendClientMessage(playerid, COLOR_GREEN, " Вы были телепортированы на сохранённую позицию.");
	return 1;
}

forward DopAnim(playerid, nanim);
public DopAnim(playerid, nanim)
{
	if(nanim == 2)
	{
		ApplyAnimation(playerid, "Attractors", "Stepsit_in", 4.1, 0, 0, 0, 1, 0, 0);//сесть-2
		return 1;
	}
	if(nanim == 3)
	{
		ApplyAnimation(playerid, "CRACK", "crckidle2", 4.1 ,0 ,0 ,0 ,1 ,0 ,0);//лечь
	}
	return 1;
}

forward DopAnim22(playerid, playdop);
public DopAnim22(playerid, playdop)
{
	ApplyAnimation(playerid, "KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0, 0);//поцелуй
	ApplyAnimation(playdop, "KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0, 0);//поцелуй
	return 1;
}

forward AdminsLvl(playerid);
public AdminsLvl(playerid)
{
	new scou = 0;
	new string[2048];
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(IsPlayerAdmin(i) && PlayerInfo[i][pAdmshad] == 0)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "RCON-Admin: ", 0, 64);
				strins(NamAdm[scou], "     ", 0, 64);
				scou++;
			}
			if(PlayerInfo[playerid][pAdmin] >= 1 && IsPlayerAdmin(i) && PlayerInfo[i][pAdmshad] == 1)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "RCON-Admin: ", 0, 64);
				strins(NamAdm[scou], "(s) ", 0, 64);
				scou++;
			}
		}
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pAdmin] == 13 && PlayerInfo[i][pAdmshad] == 0)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "Основатель: ", 0, 64);
				strins(NamAdm[scou], "     ", 0, 64);
				scou++;
			}
			if(PlayerInfo[playerid][pAdmin] >= 1 && PlayerInfo[i][pAdmin] == 13 && PlayerInfo[i][pAdmshad] == 1)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "Основатель: ", 0, 64);
				strins(NamAdm[scou], "(s) ", 0, 64);
				scou++;
			}
		}
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pAdmin] == 12 && PlayerInfo[i][pAdmshad] == 0)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "Гл. Администратор: ", 0, 64);
				strins(NamAdm[scou], "     ", 0, 64);
				scou++;
			}
			if(PlayerInfo[playerid][pAdmin] >= 1 && PlayerInfo[i][pAdmin] == 12 && PlayerInfo[i][pAdmshad] == 1)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "Гл. Администратор: ", 0, 64);
				strins(NamAdm[scou], "(s) ", 0, 64);
				scou++;
			}
		}
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pAdmin] == 11 && PlayerInfo[i][pAdmshad] == 0)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "11 LVL: ", 0, 64);
				strins(NamAdm[scou], "     ", 0, 64);
				scou++;
			}
			if(PlayerInfo[playerid][pAdmin] >= 1 && PlayerInfo[i][pAdmin] == 11 && PlayerInfo[i][pAdmshad] == 1)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "11 LVL: ", 0, 64);
				strins(NamAdm[scou], "(s) ", 0, 64);
				scou++;
			}
		}
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pAdmin] == 10 && PlayerInfo[i][pAdmshad] == 0)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "10 LVL: ", 0, 64);
				strins(NamAdm[scou], "     ", 0, 64);
				scou++;
			}
			if(PlayerInfo[playerid][pAdmin] >= 1 && PlayerInfo[i][pAdmin] == 10 && PlayerInfo[i][pAdmshad] == 1)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "10 LVL: ", 0, 64);
				strins(NamAdm[scou], "(s) ", 0, 64);
				scou++;
			}
		}
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pAdmin] == 9 && PlayerInfo[i][pAdmshad] == 0)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "9 LVL: ", 0, 64);
				strins(NamAdm[scou], "     ", 0, 64);
				scou++;
			}
			if(PlayerInfo[playerid][pAdmin] >= 1 && PlayerInfo[i][pAdmin] == 9 && PlayerInfo[i][pAdmshad] == 1)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "9 LVL: ", 0, 64);
				strins(NamAdm[scou], "(s) ", 0, 64);
				scou++;
			}
		}
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pAdmin] == 8 && PlayerInfo[i][pAdmshad] == 0)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "8 LVL: ", 0, 64);
				strins(NamAdm[scou], "     ", 0, 64);
				scou++;
			}
			if(PlayerInfo[playerid][pAdmin] >= 1 && PlayerInfo[i][pAdmin] == 8 && PlayerInfo[i][pAdmshad] == 1)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "8 LVL: ", 0, 64);
				strins(NamAdm[scou], "(s) ", 0, 64);
				scou++;
			}
		}
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pAdmin] == 7 && PlayerInfo[i][pAdmshad] == 0)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "7 LVL: ", 0, 64);
				strins(NamAdm[scou], "     ", 0, 64);
				scou++;
			}
			if(PlayerInfo[playerid][pAdmin] >= 1 && PlayerInfo[i][pAdmin] == 7 && PlayerInfo[i][pAdmshad] == 1)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "7 LVL: ", 0, 64);
				strins(NamAdm[scou], "(s) ", 0, 64);
				scou++;
			}
		}
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pAdmin] == 6 && PlayerInfo[i][pAdmshad] == 0)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "6 LVL: ", 0, 64);
				strins(NamAdm[scou], "     ", 0, 64);
				scou++;
			}
			if(PlayerInfo[playerid][pAdmin] >= 1 && PlayerInfo[i][pAdmin] == 6 && PlayerInfo[i][pAdmshad] == 1)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "6 LVL: ", 0, 64);
				strins(NamAdm[scou], "(s) ", 0, 64);
				scou++;
			}
		}
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pAdmin] == 5 && PlayerInfo[i][pAdmshad] == 0)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "5 LVL: ", 0, 64);
				strins(NamAdm[scou], "     ", 0, 64);
				scou++;
			}
			if(PlayerInfo[playerid][pAdmin] >= 1 && PlayerInfo[i][pAdmin] == 5 && PlayerInfo[i][pAdmshad] == 1)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "5 LVL: ", 0, 64);
				strins(NamAdm[scou], "(s) ", 0, 64);
				scou++;
			}
		}
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pAdmin] == 4 && PlayerInfo[i][pAdmshad] == 0)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "4 LVL: ", 0, 64);
				strins(NamAdm[scou], "     ", 0, 64);
				scou++;
			}
			if(PlayerInfo[playerid][pAdmin] >= 1 && PlayerInfo[i][pAdmin] == 4 && PlayerInfo[i][pAdmshad] == 1)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "4 LVL: ", 0, 64);
				strins(NamAdm[scou], "(s) ", 0, 64);
				scou++;
			}
		}
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pAdmin] == 3 && PlayerInfo[i][pAdmshad] == 0)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "3 LVL: ", 0, 64);
				strins(NamAdm[scou], "     ", 0, 64);
				scou++;
			}
			if(PlayerInfo[playerid][pAdmin] >= 1 && PlayerInfo[i][pAdmin] == 3 && PlayerInfo[i][pAdmshad] == 1)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "3 LVL: ", 0, 64);
				strins(NamAdm[scou], "(s) ", 0, 64);
				scou++;
			}
		}
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pAdmin] == 2 && PlayerInfo[i][pAdmshad] == 0)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "2 LVL: ", 0, 64);
				strins(NamAdm[scou], "     ", 0, 64);
				scou++;
			}
			if(PlayerInfo[playerid][pAdmin] >= 1 && PlayerInfo[i][pAdmin] == 2 && PlayerInfo[i][pAdmshad] == 1)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "2 LVL: ", 0, 64);
				strins(NamAdm[scou], "(s) ", 0, 64);
				scou++;
			}
		}
	}
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(PlayerInfo[i][pAdmin] == 1 && PlayerInfo[i][pAdmshad] == 0)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "1 LVL: ", 0, 64);
				strins(NamAdm[scou], "     ", 0, 64);
				scou++;
			}
			if(PlayerInfo[playerid][pAdmin] >= 1 && PlayerInfo[i][pAdmin] == 1 && PlayerInfo[i][pAdmshad] == 1)
			{
				format(string, sizeof(string), " [%d]", i);
				strins(NamAdm[scou], string, 0, 64);
				strins(NamAdm[scou], RealName[i], 0, 64);
				strins(NamAdm[scou], "1 LVL: ", 0, 64);
				strins(NamAdm[scou], "(s) ", 0, 64);
				scou++;
			}
		}
	}
	format(string,sizeof(string),"%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s",
	NamAdm[0],NamAdm[1],NamAdm[2],NamAdm[3],NamAdm[4],NamAdm[5],NamAdm[6],NamAdm[7],NamAdm[8],NamAdm[9],
	NamAdm[10],NamAdm[11],NamAdm[12],NamAdm[13],NamAdm[14],NamAdm[15],NamAdm[16],NamAdm[17],NamAdm[18],NamAdm[19]);
	ShowPlayerDialog(playerid, 2, 0, "On-Line Администраторы:", string, "OK", "");

	for(new i = 0; i < 20; i++)
	{
		strdel(NamAdm[i],0,64);
	}
	return 1;
}

forward STATPlayer(playerid);
public STATPlayer(playerid)
{
	new string[512];
	new virtw;
	virtw = GetPlayerVirtualWorld(playerid);
	if(virtw > 990) { virtw = 0; }
	printf(" --> Игрок %s[%d] просмотрел собственную статистику.", RealName[playerid], playerid);
	SendClientMessage(playerid, COLOR_GRAD1, "---------------------------------------------------------------");
	format(string, sizeof(string), " Время и дата регистрации: {FFFFFF}[ %s ]", PlayerInfo[playerid][pTDReg]);
	SendClientMessage(playerid, COLOR_GREEN, string);
	format(string, sizeof(string), " Ваши деньги: {FFFFFF}%d$. {FF0000}Ваши очки: {FFFFFF}%d .",
	GetPlayerMoney(playerid), GetPlayerScore(playerid));
	SendClientMessage(playerid, COLOR_GREEN, string);
	format(string, sizeof(string), " Вы убили: {FFFFFF}%d игроков. {FF0000}Вас убили: {FFFFFF}%d раз.",
	PlayerInfo[playerid][pKills], PlayerInfo[playerid][pDeaths]);
	SendClientMessage(playerid, COLOR_GREEN, string);
	format(string, sizeof(string), " Ваше время затыка: {FFFFFF}%d секунд. {FF0000}Ваше время тюрьмы: {FFFFFF}%d секунд.",
	PlayerInfo[playerid][pMutedsec], PlayerInfo[playerid][pPrisonsec]);
	SendClientMessage(playerid, COLOR_GREEN, string);
	if(PlayerInfo[playerid][pAdmlive] == 0)
	{
		format(string, sizeof(string), " Вы отыграли на сервере: {FFFFFF}%d минут. {FF0000}Бессмертие: {FF0000}Нет.",
		PlayerInfo[playerid][pMinlog]);
	}
	else
	{
		format(string, sizeof(string), " Вы отыграли на сервере: {FFFFFF}%d минут. {FF0000}Бессмертие: {FF0000}Есть.",
		PlayerInfo[playerid][pMinlog]);
	}
	SendClientMessage(playerid, COLOR_GREEN, string);
	format(string, sizeof(string), " Ваш виртуальный мир: {FFFFFF}%d.", virtw);
	SendClientMessage(playerid, COLOR_GREEN, string);
	SendClientMessage(playerid, COLOR_GRAD1, "---------------------------------------------------------------");
	return 1;
}

forward ShowStats(playerid, targetid);
public ShowStats(playerid, targetid)
{
	if(IsPlayerConnected(playerid) && IsPlayerConnected(targetid))
	{
		new locstr[13][64], locstr44[64];
		for(new j = 0; j < 13; j++)//считать слоты оружия и слоты запаса патронов
		{
			GetPlayerWeaponData(targetid, j, playweap[targetid][j], playammo[targetid][j]);
			format(locstr44 ,sizeof(locstr44), "0");
			switch(playweap[targetid][j])
			{
			case 1: format(locstr44 ,sizeof(locstr44), "Кастет - %d", playammo[targetid][j]);
			case 2: format(locstr44 ,sizeof(locstr44), "Клюшка для гольфа - %d", playammo[targetid][j]);
			case 3: format(locstr44 ,sizeof(locstr44), "Резиновая дубинка - %d", playammo[targetid][j]);
			case 4: format(locstr44 ,sizeof(locstr44), "Нож - %d", playammo[targetid][j]);
			case 5: format(locstr44 ,sizeof(locstr44), "Бейсбольная бита - %d", playammo[targetid][j]);
			case 6: format(locstr44 ,sizeof(locstr44), "Лопата - %d", playammo[targetid][j]);
			case 7: format(locstr44 ,sizeof(locstr44), "Кий - %d", playammo[targetid][j]);
			case 8: format(locstr44 ,sizeof(locstr44), "Катана - %d", playammo[targetid][j]);
			case 9: format(locstr44 ,sizeof(locstr44), "Бензопила - %d", playammo[targetid][j]);
			case 14: format(locstr44 ,sizeof(locstr44), "Букет цветов - %d", playammo[targetid][j]);
			case 15: format(locstr44 ,sizeof(locstr44), "Трость - %d", playammo[targetid][j]);
			case 16: format(locstr44 ,sizeof(locstr44), "Grenades - %d", playammo[targetid][j]);
			case 17: format(locstr44 ,sizeof(locstr44), "Tear Gas - %d", playammo[targetid][j]);
			case 18: format(locstr44 ,sizeof(locstr44), "Molotov Cocktail - %d", playammo[targetid][j]);
			case 22: format(locstr44 ,sizeof(locstr44), "9mm Pistol - %d", playammo[targetid][j]);
			case 23: format(locstr44 ,sizeof(locstr44), "Silenced Pistol - %d", playammo[targetid][j]);
			case 24: format(locstr44 ,sizeof(locstr44), "Desert Eagle - %d", playammo[targetid][j]);
			case 25: format(locstr44 ,sizeof(locstr44), "ShotGun - %d", playammo[targetid][j]);
			case 26: format(locstr44 ,sizeof(locstr44), "Sawn-off Shotgun - %d", playammo[targetid][j]);
			case 27: format(locstr44 ,sizeof(locstr44), "SPAZ 12 - %d", playammo[targetid][j]);
			case 28: format(locstr44 ,sizeof(locstr44), "UZI - %d", playammo[targetid][j]);
			case 29: format(locstr44 ,sizeof(locstr44), "MP5 - %d", playammo[targetid][j]);
			case 30: format(locstr44 ,sizeof(locstr44), "АК-47 - %d", playammo[targetid][j]);
			case 31: format(locstr44 ,sizeof(locstr44), "М4 - %d", playammo[targetid][j]);
			case 32: format(locstr44 ,sizeof(locstr44), "Tec9 - %d", playammo[targetid][j]);
			case 33: format(locstr44 ,sizeof(locstr44), "Country rifle - %d", playammo[targetid][j]);
			case 34: format(locstr44 ,sizeof(locstr44), "Sniper rifle - %d", playammo[targetid][j]);
			case 35: format(locstr44 ,sizeof(locstr44), "RPG - %d", playammo[targetid][j]);
			case 36: format(locstr44 ,sizeof(locstr44), "Heat Seeking Rocket - %d", playammo[targetid][j]);
			case 37: format(locstr44 ,sizeof(locstr44), "Flame-Thrower - %d", playammo[targetid][j]);
			case 38: format(locstr44 ,sizeof(locstr44), "Mini-Gun - %d", playammo[targetid][j]);
			case 39: format(locstr44 ,sizeof(locstr44), "C4 - %d", playammo[targetid][j]);
			case 40: format(locstr44 ,sizeof(locstr44), "Кнопка для взрывчатки - %d", playammo[targetid][j]);
			case 41: format(locstr44 ,sizeof(locstr44), "Баллончик с краской - %d", playammo[targetid][j]);
			case 42: format(locstr44 ,sizeof(locstr44), "Огнетушитель - %d", playammo[targetid][j]);
			case 43: format(locstr44 ,sizeof(locstr44), "Фотоаппарат - %d", playammo[targetid][j]);
			case 44: format(locstr44 ,sizeof(locstr44), "Очки ночного видения - %d", playammo[targetid][j]);
			case 45: format(locstr44 ,sizeof(locstr44), "Инфракрасные очки - %d", playammo[targetid][j]);
			case 46: format(locstr44 ,sizeof(locstr44), "Парашют - %d", playammo[targetid][j]);
			}
			strdel(locstr[j], 0, 64);
			strcat(locstr[j], locstr44);
		}
		new per3 = 0, per4 = 0;
		if(PGang[targetid] == 0 || PGang[targetid] == -600) { per3 = 0; }
		if(PGang[targetid] > 0) { per3 = PGang[targetid]; }
		if(PGang[targetid] == 0) { per4 = 1; }
		new coordsstring[512];
		SendClientMessage(playerid, COLOR_GRAD1, " ---------------------------------------");
		format(coordsstring, sizeof(coordsstring), " Статистика игрока [%s]   Время и дата регистрации: [%s]",
		RealName[targetid], PlayerInfo[targetid][pTDReg]);
		SendClientMessage(playerid, COLOR_GREEN,coordsstring);
		format(coordsstring, sizeof(coordsstring), " Минут на сервере: [%d] Денег: [%d $] Очков: [%d] Убийств: [%d] Смертей: [%d] Админ LVL: [%d] Скрытость админа: [%d]",
		PlayerInfo[targetid][pMinlog], GetPlayerMoney(targetid), GetPlayerScore(targetid) ,PlayerInfo[targetid][pKills],
		PlayerInfo[targetid][pDeaths], PlayerInfo[targetid][pAdmin], PlayerInfo[targetid][pAdmshad]);
		SendClientMessage(playerid, COLOR_GREEN, coordsstring);
		format(coordsstring, sizeof(coordsstring), " Бессмертие [%d] Число затыков: [%d] Секунд затыка: [%d] Посадок в тюрьму: [%d] Секунд тюрьмы: [%d] Виртуальный мир: [%d]",
		PlayerInfo[targetid][pAdmlive], PlayerInfo[targetid][pMuted], PlayerInfo[targetid][pMutedsec], PlayerInfo[targetid][pPrison],
		PlayerInfo[targetid][pPrisonsec], GetPlayerVirtualWorld(targetid));
		SendClientMessage(playerid, COLOR_GREEN, coordsstring);
		format(coordsstring, sizeof(coordsstring)," Предметы: Слот-0: [%s] Слот-1: [%s] Слот-9: [%s]",
		locstr[0],locstr[1],locstr[9]);
		SendClientMessage(playerid, COLOR_GREEN,coordsstring);
		format(coordsstring, sizeof(coordsstring)," Предметы: Слот-10: [%s] Слот-11: [%s]",
		locstr[10],locstr[11]);
		SendClientMessage(playerid, COLOR_GREEN,coordsstring);
		format(coordsstring, sizeof(coordsstring)," Оружие: Слот-2: [%s] Слот-3: [%s] Слот-4: [%s]",
		locstr[2],locstr[3],locstr[4]);
		SendClientMessage(playerid, COLOR_GREEN,coordsstring);
		format(coordsstring, sizeof(coordsstring)," Оружие: Слот-5: [%s] Слот-6: [%s] Слот-7: [%s]",
		locstr[5],locstr[6],locstr[7]);
		SendClientMessage(playerid, COLOR_GREEN,coordsstring);
		format(coordsstring, sizeof(coordsstring)," Оружие: Слот-8: [%s] Слот-12: [%s]",
		locstr[8],locstr[12]);
		SendClientMessage(playerid, COLOR_GREEN,coordsstring);

		format(coordsstring, sizeof(coordsstring)," Банда:  Название: [%s{FF0000}] Регистрация: [ %s ]",//Gangs system
		GName[per3], GTDReg[per3]);
		SendClientMessage(playerid, COLOR_GREEN,coordsstring);
		format(coordsstring, sizeof(coordsstring)," Банда:  Лидер: [%s] Уровень: [%d] Число игроков: [%d] ID: [%d] Разрешение приглашения: [%d]",
		GHead[per3], GangLvl[targetid], GPlayers[per3], per3, per4);
		SendClientMessage(playerid, COLOR_GREEN,coordsstring);
		/*
		format(coordsstring, sizeof(coordsstring), " ID Фракции-2: [%d] Уровень во фракции-2: [%d] Текст фракции-2: [ %s ]",
		PlayerInfo[playerid][pFrac2], PlayerInfo[playerid][pFracLvl2], PlayerInfo[playerid][pFracTxt2]);
		SendClientMessage(playerid, COLOR_GRAD1, coordsstring);
		format(coordsstring, sizeof(coordsstring), " Координаты фракции-2: X = %f Y = %f Z = %f Угол фракции-2: %f",
		PlayerInfo[playerid][pFracCordX2], PlayerInfo[playerid][pFracCordY2], PlayerInfo[playerid][pFracCordZ2],
		PlayerInfo[playerid][pFracAngle2]);
		SendClientMessage(playerid, COLOR_GRAD1, coordsstring);
*/
		SendClientMessage(playerid, COLOR_GRAD1," ---------------------------------------");
	}
	return 1;
}

forward RepairCar();
public RepairCar()
{
	new swper, locmoney, locmoney22, locscore, locscore22;
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(autorepair[i] == 1 && GetPlayerState(i) == 2)//если авторемонт включен,
			{//И игрок на месте водителя, то:
				new car = GetPlayerVehicleID(i);
				RepairVehicle(car);
				SetVehicleHealth(car, 1000);
			}

			swper = 0;
			if(NETafkPl[i][0] > 5) {NETafkPl[i][0] = 5;}//выравнивание контрольной переменной AFK
			if(NETafkPl[i][0] < 5 && NETafkPl[i][3] == 5)//если игрок ТОЛЬКО вышел из AFK, то:
			{
				NETafkPl[i][4] = 1;//делаем отметку выхода из AFK
			}
			else//иначе:
			{
				NETafkPl[i][4] = 0;//НЕ делаем отметку выхода из AFK
			}
			NETafkPl[i][3] = NETafkPl[i][0];//запоминаем статус AFK
			if(NETafkPl[i][0] == 5)//если игрок в AFK, то:
			{
				NETafkPl[i][5] = 1;//запоминаем статус AFK для команды /pm
				if(PlayerInfo[i][pAdmin] == 0)//если игрок НЕ админ, то:
				{
					NETafkPl[i][1]++;//считаем время AFK
				}
				NETafkPl[i][2] = 0;
				if(NETafkPl[i][1] >= 450)//если время AFK >= 15 минут, то:
				{//кикаем игрока
					NETafkPl[i][1] = 0;//обнуляем счётчик AFK
					PlayerInfo[i][pMinlog] = PlayerInfo[i][pMinlog] - 14;//отнимаем у игрока 14 минут AFK
					swper = 1;//кик по AFK
				}
			}
			if(NETafkPl[i][0] < 5)//если игрок НЕ в AFK, то:
			{
				NETafkPl[i][5] = 0;//запоминаем статус AFK для команды /pm
				if(NETafkPl[i][2] <= 3 && NETafkPl[i][1] > 0)
				{
					NETafkPl[i][2]++;//задержка выхода из AFK
					if(PlayerInfo[i][pAdmin] == 0)//если игрок НЕ админ, то:
					{
						NETafkPl[i][1]++;//считаем время AFK
					}
				}
				else
				{
					NETafkPl[i][1] = 0;//выход из AFK
					NETafkPl[i][2] = 0;
				}
			}

			if(gPlayerLogged[i] == 1)
			{
				locmoney = GetPlayerMoney(i);
				locscore = GetPlayerScore(i);
				if(GetPVarInt(i, "MonControl") == 2)
				{
					moneycontrol[i] = locmoney;
					SetPVarInt(i, "MonControl", 0);
				}
				if(GetPVarInt(i, "MonControl") == 1)
				{
					SetPVarInt(i, "MonControl", 2);
				}
				if(GetPVarInt(i, "MonControl") == 0)
				{
					locmoney22 = locmoney - moneycontrol[i];
					if(locmoney22 > 1000000 || locmoney22 < -1000000)
					{
						swper = 2;//чит на деньги
						moneycontrol22[i] = 1;
					}
				}
				if(GetPVarInt(i, "ScorControl") == 2)
				{
					scorecontrol[i] = locscore;
					SetPVarInt(i, "ScorControl", 0);
				}
				if(GetPVarInt(i, "ScorControl") == 1)
				{
					SetPVarInt(i, "ScorControl", 2);
				}
				if(GetPVarInt(i, "ScorControl") == 0)
				{
					locscore22 = locscore - scorecontrol[i];
					if(locscore22 > 3 || locscore22 < -3)
					{
						swper = 3;//чит на очки (SCORE)
						scorecontrol22[i] = 1;
					}
				}
				if(swper != 0)//если указатель НЕ равен 0, то:
				{
					new string[256];
					switch(swper)
					{
					case 1: format(string, sizeof(string), "* {FFFFFF}Игрок %s[%d] был кикнут - {FF0000}15 минут был в AFK.", RealName[i], i);
					case 2: format(string, sizeof(string), "* {FFFFFF}Игрок %s[%d] был кикнут - {FF0000}чит на деньги.", RealName[i], i);
					case 3: format(string, sizeof(string), "* {FFFFFF}Игрок %s[%d] был кикнут - {FF0000}чит на очки (SCORE).", RealName[i], i);
					}
					print(string);
					SendClientMessageToAll(COLOR_RED, string);
					SetTimerEx("PlayKick", 300, 0, "i", i);
				}
			}
		}
	}
	return 1;
}

forward Timer200ms();
public Timer200ms()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			NETafkPl[i][0]++;//прибавить контрольную переменную AFK
			SetPVarInt(i, "AdmLvl", PlayerInfo[i][pAdmin]);//глобальная переменная уровня админки
			SetPVarInt(i, "PlGng", PGang[i]);//глобальная переменная ID банды игрока
			SetPVarInt(i, "PlGLvl", GangLvl[i]);//глобальная переменная Lvl игрока в банде
			if(PlayerInfo[i][pAdmlive] == 1)//обновление жизни и брони для бессмертия
			{
				SetPlayerHealth(i, 99999);
				livdop[i] = 1;
			}
			if(PlayerInfo[i][pAdmlive] == 0 && livdop[i] == 1)//выключение бессмертия
			{
				SetPlayerHealth(i, 100);
				SetPlayerArmour(i, 0);
				livdop[i] = 0;
			}
		}
	}
	return 1;
}

forward PolSec();
public PolSec()//вспомогательный таймер 450 мс
{
	new string[64];
	for(new i = 0; i < MAX_PLAYERS; i++)//цикл для всех игроков
	{
		if(IsPlayerConnected(i))//дальнейшее выполняем если игрок в коннекте
		{
			if(playspa[i] == 1)//если игрок заспавнился, то:
			{
				format(string, sizeof(string), "SCORE: %08d", GetPlayerScore(i));
				TextDrawSetString(TScore[i], string);
				TextDrawShowForPlayer(i, TScore[i]);
			}
			if(PlayLock1[0][i] != 600 && playspa[i] == 1)//если игрок заблокирован, И заспавнен, то:
			{
				SetPlayerInterior(i, PlayLock1[1][i]);//установка интерьера блокировки
				SetPlayerVirtualWorld(i, PlayLock1[2][i]);//установка виртуального мира блокировки
				SetPlayerPos(i, PlayLock2[0][i], PlayLock2[1][i], PlayLock2[2][i]);//установка координат блокировки
				SetPlayerFacingAngle(i, PlayLock2[3][i]);//установка угла блокировки
				SetCameraBehindPlayer(i);//расположить камеру за игроком
			}
		}
	}
	return 1;
}

forward OneSecOnd();
public OneSecOnd()
{
	gettime(timedata[0], timedata[1]);
	new PlayVeh;
	new swper;//античит
	new play333weap[13], play333ammo[13], dopper333;//контроль запаса патров
	new Float:PosX, Float:PosY, Float:PosZ;//проверка игрока в X-зоне
	new playnam333[MAX_PLAYER_NAME];
	new string[256];
	if(timedata[0] == resthour && timedata[1] == 0 && resauto == 0)
	{
		printf("* Запланированный рестарт сервера.");
		SendClientMessageToAll(COLOR_GRAD1,"-----------------------------------------");
		SendClientMessageToAll(COLOR_LIGHTRED,"* Запланированный рестарт сервера.");
		SendClientMessageToAll(COLOR_LIGHTRED," [ Внимание ] Через 2 минуты произойдёт рестарт сервера!!!");
		SendClientMessageToAll(COLOR_GRAD1,"-----------------------------------------");
		restart = SetTimer("RestartS", 120000, 1);
		resauto = 1;
	}
	if(nucexplos == 1)//если на сервере ядерный взрыв, то:
	{
		SetWeather(19);
		SetWorldTime(0);
		nucexptime++;
		if(nucexptime == 1200)//если прошло 20 минут с момента ядерного взрыва, то:
		{
			nucexplos = 0;//активировать автоматическую отмену ядерного взрыва
			nucexptime = -100;
		}
		if(nucexplos == 0 && nucexptime == -100)//если активна автоматическая отмена ядерного взрыва, то:
		{
			SetWeather(1);
			gettime(timedata[0], timedata[1]);
			SetWorldTime(timedata[0]);
		}
	}
	for(new i = 0; i < MAX_PLAYERS; i++)//цикл для всех игроков
	{
		if(IsPlayerConnected(i))//дальнейшее выполняем если игрок в коннекте
		{
			if(nucexplos == 1)//если на сервере ядерный взрыв, то:
			{
				if(SnowONOFF[i] == 1)
				{
					new Float:hp;
					SetPlayerArmour(i, 0);
					GetPlayerHealth(i, hp);
					SetPlayerHealth(i, hp-10);
					GetPlayerCameraPos(i, PosX, PosY, PosZ);
					MovePlayerObject(i, snowobj[i], PosX, PosY, PosZ-5, 9999.0);
				}
			}
			if(nucexplos == 0 && nucexptime == -100)//если активна автоматическая отмена ядерного взрыва, то:
			{
				SnowONOFF[i] = 0;
				DestroyPlayerObject(i,snowobj[i]);
			}
			PlayVeh = GetPlayerVehicleID(admper1[i]);
			if(admper1[i] != 600)//если игрок - админ ведущий наблюдение, то:
			{
				if(PlayVeh != 0 && admper5[i] == 0)//если игрок в транспорте,
				{//И мы наблюдали за игроком, то:
					PlayerSpectateVehicle(i, PlayVeh, SPECTATE_MODE_NORMAL);
					admper5[i] = 1;//наблюдаем за транспортом
				}
				if(PlayVeh == 0 && admper5[i] == 1)//если игрок НЕ в транспорте,
				{//И мы наблюдали за транспортом, то:
					PlayerSpectatePlayer(i, admper1[i], SPECTATE_MODE_NORMAL);
					admper5[i] = 0;//наблюдаем за игроком
				}
				if(admper5[i] == 3)//если устанавлен второй цикл переключение наблюдения, то:
				{
					PlayerSpectateVehicle(i, PlayVeh, SPECTATE_MODE_NORMAL);
					admper5[i] = 1;//наблюдаем за транспортом
				}
				if(admper5[i] == 2)//если устанавленно переключение наблюдения, то:
				{
					PlayerSpectatePlayer(i, admper1[i], SPECTATE_MODE_NORMAL);//наблюдаем за игроком
					admper5[i] = 3;//устанавливаем второй цикл переключения наблюдения
				}
				if(admper6[i] == 2)//если переключение наблюдения состоялось, то:
				{
					admper6[i] = 0;//обнуляем отметку о переключении наблюдения
				}
				if(admper6[i] == 1)//если отметка о переключении наблюдения активна, то:
				{
					SetPlayerInterior(i, GetPlayerInterior(admper1[i]));//установить интерьер админу
					SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(admper1[i]));//установить мир админу
					if(PlayVeh != 0)//если игрок в транспорте, то:
					{
						PlayerSpectateVehicle(i, PlayVeh, SPECTATE_MODE_NORMAL);
						admper5[i] = 1;//наблюдаем за транспортом
					}
					else
					{
						PlayerSpectatePlayer(i, admper1[i], SPECTATE_MODE_NORMAL);//включить наблюдение
						admper5[i] = 0;//наблюдаем за игроком
					}
					admper6[i] = 2;//делаем отметку о переключении наблюдения
				}
				if(((GetPlayerInterior(i) != GetPlayerInterior(admper1[i])) ||
							(GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(admper1[i]))) && admper6[i] == 0)
				{//если у игрока (за кем наблюдает админ) изменился интерьер ИЛИ виртуальный мир, И отметка о переключении наблюдения НЕ активна, то:
					admper6[i] = 1;//активируем отметку о переключении наблюдения
				}
			}
			if(PlayerInfo[i][pMutedsec] > 0)//если игрок заткнут, то:
			{
				PlayerInfo[i][pMutedsec]--;
				if(PlayerInfo[i][pMutedsec] <= 0)
				{
					PlayerInfo[i][pMutedsec] = 0;
					format(string, sizeof(string), "* Игрок %s разоткнут.", RealName[i], i);
					print(string);
					SendClientMessageToAll(COLOR_GREEN, string);
				}
			}
			if(PlayerInfo[i][pPrisonsec] > 0)//если игрок в тюрьме, то:
			{
				PlayerInfo[i][pPrisonsec]--;
				if(PlayerInfo[i][pPrisonsec] <= 0)
				{
					PlayerInfo[i][pPrisonsec] = 0;
					format(string, sizeof(string), "* Игрок %s освобождён.", RealName[i], i);
					print(string);
					SendClientMessageToAll(COLOR_GREEN, string);
					weapstatplay[i] = 0;
					OnPlayerSpawn(i);
				}
			}
			if(countdown[i]>0)//если игрок запустил обратный отсчёт, то:
			{
				countdown[i]-=1;
				new str[6];
				format(str,6,"...%d",countdown[i]);
				GameTextForPlayer(i,str,950,4);
				PlayerPlaySound(i,1056,0.0,0.0,0.0);
				if(countdown[i]<4)TogglePlayerControllable(i,0);
			}
			if(countdown[i]==0)
			{
				TogglePlayerControllable(i,1);
				GameTextForPlayer(i,"~b~GO GO GO !",700,4);
				PlayerPlaySound(i,1057,0.0,0.0,0.0);
				countdown[i]=-1;
			}
			swper = 0;//античит
			if(playspa[i] == 0)
			{//если игрок не заспавнился, то:
				oneminkick[i]++;
				if(oneminkick[i] >= 22)
				{
					swper = 1;//не заспавнился в течение трёх минут
					oneminkick[i] = 0;
				}
			}
			else//иначе
			{
				oneminkick[i] = 0;//обнуляем переменную
			}
			GetPlayerName(i, playnam333, sizeof(playnam333));
			if(strcmp(playnam333, RealName[i], false) != 0)
			{
				swper = 2;//чит на смену ника
			}
			GetPlayerPos(i, PosX, PosY, PosZ);
			if(PlayerInfo[i][pPrisonsec] == 0 && prisoncount[i] != 0)
			{//обнуление задержки контроля игрока в тюрьме, если она НЕ равна нулю
				prisoncount[i] = 0;
			}
			if((chatcon[i] > 1 || GetPVarInt(i, "CComAc0") > 1 || GetPVarInt(i, "CComAc1") > 1 ||
						GetPVarInt(i, "CComAc2") > 1 || GetPVarInt(i, "CComAc3") > 1 || GetPVarInt(i, "CComAc4") > 1 ||
						GetPVarInt(i, "CComAc5") > 1 || GetPVarInt(i, "CComAc6") > 1 || GetPVarInt(i, "CComAc7") > 1 ||
						GetPVarInt(i, "CComAc8") > 1 || GetPVarInt(i, "CComAc9") > 1 || GetPVarInt(i, "CComAc10") > 1 ||
						GetPVarInt(i, "CComAc11") > 1 || GetPVarInt(i, "CComAc12") > 1 || GetPVarInt(i, "CComAc13") > 1 ||
						GetPVarInt(i, "CComAc14") > 1 || GetPVarInt(i, "CComAc15") > 1) &&
					PlayerInfo[i][pAdmin] == 0)//если игрок написал более 1-й строки за 1 секунду,
			{//и если игрок НЕ админ, то:
				swper = 6;//спам в чате (или в командах)
			}
			chatcon[i] = 0;//обнуляем контрольную переменную чата
			SetPVarInt(i, "CComAc0", 0);
			SetPVarInt(i, "CComAc1", 0);
			SetPVarInt(i, "CComAc2", 0);
			SetPVarInt(i, "CComAc3", 0);
			SetPVarInt(i, "CComAc4", 0);
			SetPVarInt(i, "CComAc5", 0);
			SetPVarInt(i, "CComAc6", 0);
			SetPVarInt(i, "CComAc7", 0);
			SetPVarInt(i, "CComAc8", 0);
			SetPVarInt(i, "CComAc9", 0);
			SetPVarInt(i, "CComAc10", 0);
			SetPVarInt(i, "CComAc11", 0);
			SetPVarInt(i, "CComAc12", 0);
			SetPVarInt(i, "CComAc13", 0);
			SetPVarInt(i, "CComAc14", 0);
			SetPVarInt(i, "CComAc15", 0);
			if(functioncon[i] > 5)//если игрок вызвал функции более 5-и раз за 1 секунду, то:
			{
				swper = 7;//чит вызова функций
				functioncon[i] = 0;//обнуляем контрольную переменную функций
			}
			else//иначе
			{
				functioncon[i] = 0;//обнуляем контрольную переменную функций
			}
			if(dialogcon[i] > 15)//если игрок вызвал диалоги более 15-и раз за 1 секунду, то:
			{
				swper = 8;//чит вызова диалогов
				dialogcon[i] = 0;//обнуляем контрольную переменную диалогов
			}
			else//иначе
			{
				dialogcon[i] = 0;//обнуляем контрольную переменную диалогов
			}
			if(dialogadm[i] == 1)//если игрок вызвал админ-меню, то:
			{
				swper = 9;//чит вызова админ-меню
				dialogadm[i] = 0;//обнуляем контрольную переменную админ-меню
			}
			dopper333 = 0;//контроль запаса патров и удаление чит-слотов
			for(new j = 0; j < 13; j++)//читаем все слоты
			{
				GetPlayerWeaponData(i, j, play333weap[j], play333ammo[j]);
			}
			if(play333ammo[0] > 1) { play333ammo[0] = 1; dopper333 = 1; }//выравнивание запаса патронов
			if(play333ammo[1] > 1) { play333ammo[1] = 1; dopper333 = 1; }
			if(play333ammo[2] > 400) { play333ammo[2] = 400; dopper333 = 1; }
			if(play333ammo[3] > 400) { play333ammo[3] = 400; dopper333 = 1; }
			if(play333ammo[4] > 1200) { play333ammo[4] = 1200; dopper333 = 1; }
			if(play333ammo[5] > 1200) { play333ammo[5] = 1200; dopper333 = 1; }
			if(play333ammo[6] > 400) { play333ammo[6] = 400; dopper333 = 1; }
			if((play333weap[7] == 35 || play333weap[7] == 36) && play333ammo[7] > 400) { play333ammo[7] = 400; dopper333 = 1; }
			if((play333weap[7] == 37 || play333weap[7] == 38) && play333ammo[7] > 2000) { play333ammo[7] = 2000; dopper333 = 1; }
			if(play333ammo[8] > 400) { play333ammo[8] = 400; dopper333 = 1; }
			if(play333ammo[9] > 2000) { play333ammo[9] = 2000; dopper333 = 1; }
			if(play333weap[10] >= 10 && play333weap[10] <= 13) { play333weap[10] = 0; play333ammo[10] = 0; dopper333 = 1; }//удаление ВООБЩЕ ЗАПРЕЩЁННЫХ предметов
			if(play333ammo[10] > 1) { play333ammo[10] = 1; dopper333 = 1; }
			if((play333weap[11] == 44 || play333weap[11] == 45) && PlayerInfo[i][pAdmin] == 0) { play333weap[11] = 0; play333ammo[11] = 0; dopper333 = 1; }
			if(play333ammo[11] > 1) { play333ammo[11] = 1; dopper333 = 1; }
			if(dopper333 == 1)
			{
				ResetPlayerWeapons(i);//отбираем оружие и предметы
				for(new j = 0; j < 13; j++)//сохраняем все слоты
				{
					GivePlayerWeapon(i, play333weap[j], play333ammo[j]);
				}
			}
			if(swper != 0)//если указатель НЕ равен 0, то:
			{
				switch(swper)
				{
				case 1: format(string, sizeof(string), "* Игрок %s[%d] был кикнут - не заспавнился в течение 30 секунд.", playnam333, i);
				case 2: format(string, sizeof(string), "* Игрок %s[%d] был кикнут за смену ника ( f. %s ).", playnam333, i, RealName[i]);
				case 5: format(string, sizeof(string), "* Игрок %s[%d] был кикнут за побег из тюрьмы (или из-под стражи).", playnam333, i);
				case 6: format(string, sizeof(string), "* Игрок %s[%d] был кикнут за спам в чате (или в командах).", playnam333, i);
				case 7: format(string, sizeof(string), "* Игрок %s[%d] был кикнут за чит флуда функций.", playnam333, i);
				case 8: format(string, sizeof(string), "* Игрок %s[%d] был кикнут за чит флуда диалогов.", playnam333, i);
				case 9: format(string, sizeof(string), "* Игрок %s[%d] был кикнут за чит вызова админ-меню.", playnam333, i);
				}
				print(string);
				SendClientMessageToAll(COLOR_RED, string);
				SetTimerEx("PlayKick", 300, 0, "i", i);
			}
			if(i >= Wind1SA && i < Wind2SA)//если ИД игрока "попадает" в "окно" автосохранения аккаунтов, то:
			{//делаем автосохранение этого аккаунта
				for(new j = 0; j < 13; j++)
				{
					if(PlayerInfo[i][pPrisonsec] > 0)//если игрок в тюрьме,
					{//то: сохраняем в файле слоты оружия из вспомогательных переменных
						playweap[i][j] = play2weap[i][j];
						playammo[i][j] = play2ammo[i][j];
					}
					else
					{
						GetPlayerWeaponData(i, j, playweap[i][j], playammo[i][j]);//если игрок НЕ в тюрьме, и НЕ на территории X-зоны,
					}//и НЕ в зоне дерби, то: то сохраняем в файле его текущие слоты оружия
				}
				PlayerInfo[i][pCordX] = PosX;
				PlayerInfo[i][pCordY] = PosY;
				PlayerInfo[i][pCordZ] = PosZ;
				new Float:Angle;
				GetPlayerFacingAngle(i, Angle);
				PlayerInfo[i][pAngle] = Angle;
				OnPlayerSaveA(i);
				if(idgangsave[i] > 0)
				{
					GangSave(idgangsave[i]);//запись ID банды в файл
				}
			}
		}
	}
	if(nucexplos == 0 && nucexptime == -100)//если активна автоматическая отмена ядерного взрыва, то:
	{
		format(string, sizeof(string), "* Последствия ядерного взрыва были автоматически ликвидированы.");
		print(string);
		SendClientMessageToAll(COLOR_GREEN, string);
		nucexplos = 0;
		nucexptime = 0;
	}
	if(Wind2SA < (MAX_PLAYERS - 1))//если конец "окна" автосохранения аккаунтов меньше числа слотов сервера, то:
	{//сдвигаем "окно" в сторону увеличения ИД игроков
		Wind1SA = Wind1SA + WWindSA;
		Wind2SA = Wind2SA + WWindSA;
	}
	else//иначе:
	{
		Wind1SA = 0;//обнуляем начало "окна" автосохранения аккаунтов
		Wind2SA = WWindSA;//задаём конец "окна" автосохранения аккаунтов
	}
	return 1;
}

forward FiveSecTimer();
public FiveSecTimer()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(SnowONOFF[i] == 1)//если на сервере ядерный взрыв, то:
			{
				SendClientMessage(i, COLOR_RED, " Внимание !!! На сервере был произведён ядерный взрыв !!!");
				SendClientMessage(i, COLOR_RED, " Радиационный фон превышен в тысячи раз !!! Спасайтесь, кто как может.....");
			}
		}
	}
	return 1;
}

forward ReloadFS();
public ReloadFS()//перезагрузка фильтрскриптов
{
	new string[256];
	for(new j = 0; j < 16; j++)
	{
		if(strlen(relFS[j]))//если строка НЕ пустая, то:
		{
			strdel(string, 0, 256);//очистка переменной string
			strcat(string, "reloadfs ");//сборка RCON-команды перезагрузки фильтрскрипта
			strcat(string, relFS[j]);
			SendRconCommand(string);//RCON-команда перезагрузки фильтрскрипта
		}
	}
	return 1;
}

forward MinServ();
public MinServ()//таймер минут на сервере
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			PlayerInfo[i][pMinlog]++;
		}
	}
	gettime(timedata[0], timedata[1]);
	if(oldhour != timedata[0])
	{
		oldhour = timedata[0];
		SetWorldTime(timedata[0]);
	}
	return 1;
}

forward RazgruzFurui(playerid);
public RazgruzFurui(playerid)
{
	TogglePlayerControllable(playerid,1);
	SendClientMessage(playerid, COLOR_WHITE,"{FF0000}INFO:{FFFFFF} Разгрузка фургона завершена!");
	SendClientMessage(playerid,-1,"{FF0000}INFO:{FFFFFF} Сдаоте путеводный лист на базу и получите зарплату.");
	Checkpoint[playerid] = 2;
	SetPlayerCheckpoint(playerid,-1.0519, -244.9220, 5.4297, 8.00);
	return true;
}

/*
forward Reklama1();
public Reklama1()
{
	SendClientMessageToAll(0xFFFFFFFF, " ");
	SendClientMessageToAll(0xFFFFFFFF, "[{FF0000}DAGESTAN MOBILE{FFFFFF}] Как заcпавнить тачку: {FF0000}/car");
	SendClientMessageToAll(0xFFFFFFFF, "[{FF0000}DAGESTAN MOBILE{FFFFFF}] Изменить скин: {FF0000}/skin");
	SendClientMessageToAll(0xFFFFFFFF, "[{FF0000}DAGESTAN MOBILE{FFFFFF}] Платные услуги сервера: {FF0000}/donate");
	SendClientMessageToAll(0xFFFFFFFF, "[{FF0000}DAGESTAN MOBILE{FFFFFF}] Наш TG канал: {FF0000}t.me/JDM Pandem MOBILE");
	SendClientMessageToAll(0xFFFFFFFF, "[{FF0000}DAGESTAN MOBILE{FFFFFF}] Приятной игры: {FF0000}> Наводи суету на MTA");
	SendClientMessageToAll(0xFFFFFFFF, "[{FF0000}DAGESTAN MOBILE{FFFFFF}] TG Канал владельца: {FF0000}> @svoidvij");
    SendClientMessageToAll(0xFFFFFFFF, "[{FF0000}DAGESTAN MOBILE{FFFFFF}] Основатели: {FF0000} @pandem jdm mobile");
	SendClientMessageToAll(0xFFFFFFFF, " ");
	return 1;
}
*/

forward DriftCancellation(playerid);
public DriftCancellation(playerid){
	new locper;
	new driftzarplata;
	driftzarplata = DriftPointsNow[playerid] * 2;
	PlayerDriftCancellation[playerid] = 0;
	GameTextForPlayer(playerid, Split("~n~~n~~n~~n~~n~~n~~n~~n~~w~~w~Money ~g~+", tostr(driftzarplata), "~w~"), 3000, 3);
	SetPVarInt(playerid, "MonControl", 1);
	GivePlayerMoney(playerid, driftzarplata);
	locper = GetPlayerScore(playerid);
	new string[256];
	format(string, 256, "{00ff7f}DAGESTAN MOBILE: {ffffff}игрок %s[%d] вошёл в дрифт на %d очков", RealName[playerid], playerid, DriftPointsNow[playerid]);
	if(DriftPointsNow[playerid] > 100000) SendClientMessageToAll(-1, string);
	SetPVarInt(playerid, "ScorControl", 1);
	SetPlayerScore(playerid, (locper + (DriftPointsNow[playerid] / 1000)));
	DriftPointsNow[playerid] = 0;
	dddrift[playerid] = 0;
	return 1;
}

Float:ReturnPlayerAngle(playerid){
	new Float:Ang;
	if(IsPlayerInAnyVehicle(playerid))GetVehicleZAngle(GetPlayerVehicleID(playerid), Ang); else GetPlayerFacingAngle(playerid, Ang);
	return Ang;
}

forward IsVehicleOccupied(vehicleid);
public IsVehicleOccupied(vehicleid)
{
    for(new i=0;i<MAX_PLAYERS;i++)
    {
        if(IsPlayerInVehicle(i,vehicleid)) return 1;
    }
    return 0;
}

forward Drift();
public Drift(){
	new Float:Angle1, Float:Angle2, Float:BySpeed, s[256];
	new Float:Z;
	new Float:X;
	new Float:Y;
	new Float:SpeedX;
	for(new g=0;g<MAX_PLAYERS;g++){
		if(IsPlayerConnected(g))
		{
			GetPlayerPos(g, X, Y, Z);
			SavedPos[ g ][ dltX ] = floatsub(X,SavedPos[ g ][ sX ]);
			SavedPos[ g ][ dltY ] = floatsub(Y,SavedPos[ g ][ sY ]);
			SavedPos[ g ][ dltZ ] = floatsub(Z,SavedPos[ g ][ sZ ]);
			SpeedX = floatsqroot(floatadd(floatadd(floatmul(SavedPos[ g ][ dltX ],SavedPos[ g ][ dltX ]),floatmul(SavedPos[ g ][ dltY ],SavedPos[ g ][ dltY ])),floatmul(SavedPos[ g ][ dltZ ],SavedPos[ g ][ dltZ ])));
			Angle1 = ReturnPlayerAngle(g);
			Angle2 = GetPlayerTheoreticAngle(g);
			BySpeed = floatmul(SpeedX, 12);
			if(IsPlayerInAnyVehicle(g) && floatabs(floatsub(Angle1, Angle2)) > DRIFT_MINKAT && floatabs(floatsub(Angle1, Angle2)) < DRIFT_MAXKAT && BySpeed > DRIFT_SPEED){
				if(PlayerDriftCancellation[g] > 0)KillTimer(PlayerDriftCancellation[g]);
				PlayerDriftCancellation[g] = 0;
				dddrift[g] += floatval( floatabs(floatsub(Angle1, Angle2)) * 3 * (BySpeed*0.1) )/10;
				if((dddrift[g] - DriftPointsNow[g]) > 2000)//если дрифт больше xxx, то:
				{
					dddrift[g] = 0;//обнуляем дрифт-очки
				}
				DriftPointsNow[g] = dddrift[g];//запоминаем последний дрифт
				PlayerDriftCancellation[g] = SetTimerEx("DriftCancellation", 3000, 0, "d", g);
			}
			if(DriftPointsNow[g] > 0){
				format(s, sizeof(s), "~n~~n~~n~~n~~n~~n~~n~~n~~w~Drift: ~g~%d~w~", DriftPointsNow[g]);
				GameTextForPlayer(g, s, 3000, 3);
			}
			SavedPos[ g ][ sX ] = X;
			SavedPos[ g ][ sY ] = Y;
			SavedPos[ g ][ sZ ] = Z;

			new Float:x333, Float:y333, Float:z333;
			if(IsPlayerInAnyVehicle(g))GetVehiclePos(GetPlayerVehicleID(g), x333, y333, z333); else GetPlayerPos(g, x333, y333, z333);
			ppos[g][0] = x333;
			ppos[g][1] = y333;
			ppos[g][2] = z333;

		}
	}
	return 1;
}

Split(s1[], s2[], s3[]=""){
	new rxx[256];
	format(rxx, 256, "%s%s%s", s1, s2, s3);
	return rxx;
}

tostr(int){
	new st[256];
	format(st, 256, "%d", int);
	return st;
}

floatval(Float:val){
	new str[256];
	format(str, 256, "%.0f", val);
	return todec(str);
}

todec(str[]){
	return strval(str);
}
forward IsStringAName(string[]);
public IsStringAName(string[])
{
	for(new i = 0; i <= MAX_PLAYERS; i++)
	{
	if(IsPlayerConnected(i) == 1)
	{
		new testname[MAX_PLAYER_NAME];
		GetPlayerName(i, testname, sizeof(testname));
		if(strcmp(testname, string, true, strlen(string)) == 0)
		{
			return 1;
		}
	}
}
	return 0;
}
forward GetPlayerID(string[]);
public GetPlayerID(string[])
{
	for(new i = 0; i <= MAX_PLAYERS; i++)
	{
	if(IsPlayerConnected(i) == 1)
	{
		new testname[MAX_PLAYER_NAME];
		GetPlayerName(i, testname, sizeof(testname));
		if(strcmp(testname, string, true, strlen(string)) == 0)
		{
			return i;
		}
	}
}
	return INVALID_PLAYER_ID;
}
forward ClockSync(playerid);
public ClockSync(playerid)
{
new string[256];
new hour, minute, second;
gettime(hour,minute,second);
if(hour < 10 && minute < 10)
  {
   format(string, sizeof(string), "0%d:0%d", hour, minute);
   }
   else if(hour < 10 && minute > 9)
   {
    format(string, sizeof(string), "0%d:%d", hour, minute);
   }
   else if(hour > 9 && minute < 10)
   {
    format(string, sizeof(string), "%d:0%d", hour, minute);
   }
   else
   {
   format(string, sizeof(string), "%d:%d", hour, minute);
}
TextDrawSetString(Text:Clock, string);
}
stock SpawnNewCar(playerid, modelid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    
    // Удаляем старый личный транспорт, если есть
    if(playcar[playerid] != 0)
    {
        if(GetVehicleModel(playcar[playerid]) != 0) // проверка, существует ли транспорт
        {
            DestroyVehicle(playcar[playerid]);
        }
        playcar[playerid] = 0;
    }
    
    new Float:x, Float:y, Float:z, Float:angle;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, angle);
    
    new color1 = random(256);
    new color2 = random(256);
    
    new veh = CreateVehicle(modelid, x + 2, y + 2, z, angle, color1, color2, 90000);
    if(veh != INVALID_VEHICLE_ID)
    {
        playcar[playerid] = veh;
        LinkVehicleToInterior(veh, GetPlayerInterior(playerid));
        SetVehicleVirtualWorld(veh, GetPlayerVirtualWorld(playerid));
        PutPlayerInVehicle(playerid, veh, 0);
        SendClientMessage(playerid, COLOR_GREEN, "| {ffffff}Транспорт создан! Используйте /tune для тюнинга.");
        return 1;
    }
    else
    {
        SendClientMessage(playerid, COLOR_RED, "| {ffffff}Не удалось создать транспорт.");
        return 0;
    }
}