/* Общие настройки, касающиеся анти-чита */
#define AC_MAX_CODES                    53 // Количество кодов анти-чита (на данный момент их 53)
#define AC_MAX_CODE_LENGTH              (3 + 1) // Максимальное количество символов в "коде" анти-чита (001/002/003, etc.)
#define AC_MAX_CODE_NAME_LENGTH         (33 + 1) // Максимальное количество символов в полном названии чита, за который отвечает какой-либо код
    
#define AC_MAX_TRIGGER_TYPES            3 // Количество типов срабатываний (наказаний) анти-чита. По мере добавления типов срабатываний (наказаний), увеличивайте данное значение.
#define AC_MAX_TRIGGER_TYPE_NAME_LENGTH (8 + 1) // Максимальное количество символов в названии типа срабатывания (наказания) анти-чита

// Типы срабатываний объявлены макросами, чтобы было проще ориентироваться в OnCheatDetected.
#define AC_CODE_TRIGGER_TYPE_DISABLED   0 // AC_CODE_TRIGGER_TYPE_DISABLED - Тип наказания: Отключён
#define AC_CODE_TRIGGER_TYPE_WARNING    1 // AC_CODE_TRIGGER_TYPE_WARNING - Тип наказания: Warning
#define AC_CODE_TRIGGER_TYPE_KICK       2 // AC_CODE_TRIGGER_TYPE_KICK - Тип наказания: Kick

#define AC_TRIGGER_ANTIFLOOD_TIME       20 // Время для анти-флуда срабатываниями (в секундах)
#define AC_MAX_CODES_ON_PAGE            15 // Максимальное количество элементов на странице настроек анти-чита

// Настройки мода
#define 	MODE_NAME 			"Hell Role Play" 
#define 	MODE_MAIL 			"dimachiter121w17@gmail.com" 
#define 	NameServer 			"Hell Role Play"
#define     OfficialUrl         "Hell Role Play | t.me/HellRolePlay | Тех.Работы"//  
#define     NameURLForum        "t.me/ForumHellRolePlay"
#define 	Namesait			"t.me/Devil_Deatns"
#define 	DonatePoint			"Coins"

#define 	HostName 			"Hell Role Play | Играй вместе с нами!"	
#define 	HostNameBonus 		"Hell Role Play | Акции"
#define 	COLOWES_SERVER 		"Hell Role Play | Обновление сервера"
#define  	RECON_PASSWORD 		"password cheattop"
#define 	IsAdmin(%0) 					if(pInfo[playerid][pAdmin] < %0) return 1;

 
#define MYSQL_LOAD_CASINO   		5  
#define MYSQL_LOAD_FRACTION_BANK    8
#define MYSQL_LOAD_GRAFFITI     	9 
#define MYSQL_LOAD_GANGZONE  		11
#define MYSQL_LOAD_OTHER_STALL  	12
#define MYSQL_LOAD_FARMS    		13  
#define MYSQL_LOGIN_ADMINS  		16 
#define MYSQL_SELECT_GETON      	18  
#define MYSQL_LOAD_FRACTION     	22 

#define MAX_REPORT_SLOTS    			50 
#define PRICE_PHONE_MIN     			10//Цена звонка


new
	string_chat_[144],
	t_string[2000];
#define ASSERT(%0)				if (%0) return true
#define SCMF(%0,%1,%2,%3)           					format(string_chat_, 144, %2,%3) && SendClientMessage(%0, %1, string_chat_)
#define SendMes(%1,%2,%3) 		format(string_chat_, sizeof(string_chat_), %3), SendClientMessage(%1, %2, string_chat_), string_chat_[0] = EOS
#define SendMesAll(%1,%2) 		format(string_chat_, sizeof(string_chat_), %2), SendClientMessageToAll(%1, string_chat_), string_chat_[0] = EOS
#define RandomEx(%1)            (random(%1)+1)
#define RandomFIX(%1,%2) 		(random(%2-%1)+%1)
#define f(%0, 					%0[0] = EOS, format(%0,sizeof(%0),
#define scm 					SendClientMessage
#define err(%0) 				SendClientMessage(playerid, COLOR_GREY, %0)
#define SendInfo(%0)            SendClientMessage(playerid, COLOR_INF, %0) 
#define publics:%0(%1)			forward %0(%1); public %0(%1)
forward ArmourUpdate();
#define GivePVarInt(%0,%1,%2) 	SetPVarInt(%0,%1,(GetPVarInt(%0,%1) + %2))
#define ClearChatbox(%0,%1) 	for(new d; d<%1; ++d) SendClientMessage(%0, -1, "")
#define ClearChatboxAll(%1) 	for(new i; i<%1; ++i) SendClientMessageToAll(-1, "")
#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define PlayerInConnected(%0) (IsPlayerConnected(%0) && pInfo[%0][pLogin])
#define INVALID_GANGZONE_ID     -1
My5DynamicObject(modelid, Float:X, Float:Y, Float:Z, Float:rX, Float:rY, Float:rZ,worldid = -1, interiorid= -1,Float:disntge = 200.0) return CreateDynamicObject(modelid, X, Y, Z, rX, rY, rZ,worldid,interiorid,-1,disntge, disntge);
 
#define     FRACTION_COUNT          26  //Точно кол-во фракций
#define 	SETTINGS_COUNT 			13 	//Макс кол-во настроек 
#define     STALL_COUNT             20  // Макс кол-во закусочных
#define 	FRACTIONBANK_COUNT      27  // Макс кол-во складов 
#define 	BILLBORDS_COUNT 		51	//Точное кол-во билбордов  
#define 	GRAFFITI_COUNT 			53  //Макс. к-во граффити 

#define 	SWEEPER_DIALOG_ID 	745545 // работа уборщик улиц

#define CAPTURE_EXTENSION_MIN_PLAYER    	(1) 
#define MAFIAWAR_EXTENSION_MIN_PLAYER    	(1)
#define BIKERWAR_EXTENSION_MIN_PLAYER    	(2)
#define MAX_DIALOG_LIST_ITEMS	(30)
#define MAX_DIALOG_LIST_BLACK_LIST	(5)
#define REFERAL_LEVEL_AWARD 	5
#define REFERAL_MONEY_AWARD		100000

#define PromoCode:          PR_
#define Fraction:			FIS_


#define GetPlayerTemp(%0,%1)				pTemp[%0][%1]
#define GetPlayerTempArr(%0,%1,%2)			pTemp[%0][%1][%2]
#define SetPlayerTemp(%0,%1,%2)				pTemp[%0][%1] = %2
#define	SetPlayerTempArr(%0,%1,%2,%3)		pTemp[%0][%1][%2] = %3

#define GetPlayerData(%0,%1)				pInfo[%0][%1]
#define GetPlayerDataArr(%0,%1,%2)			pInfo[%0][%1][%2]
#define SetPlayerData(%0,%1,%2)				pInfo[%0][%1] = %2
#define	SetPlayerDataArr(%0,%1,%2,%3)		pInfo[%0][%1][%2] = %3

#define GetPlayerFraction(%0)				pInfo[%0][pMember]

#define P_OFFLINE                           "данный игрок не в игре"

#define ErrorMessage(%0,%1)                 SendMes(%0, COLOR_LIGHTRED, "• [Ошибка]: "colgrey"%s", %1)

#define GetPlayerAccountID(%0)              pInfo[%0][pID]
#define GetName(%0)                         pInfo[%0][pName]
#define SCM                                 SendClientMessage

#define Hud:%0(							    HUD_%0(

	