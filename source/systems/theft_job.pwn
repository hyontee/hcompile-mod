#if defined _theft_inc
	#endinput
#endif
#define _theft_inc
//ALTER TABLE `s_vehicle_player` ADD `vJakcer` INT(11) NOT NULL DEFAULT '0' AFTER `vAmmo`;
/*
pInfo

pTheftQuest 1 - Принесл закладку 0 - false
pTheftLevel 
pTheftExp

pTemp

tQuestTheft
tTheftIDCar = INVALID_VEHICLE_ID
tTheftTime  =   0
tTheftGZ    =   INVALID_GANGZONE_ID

VehicleInfo

VehicleInfo[ V_IDX - 1 ][vJacker] - Проверяем в угоне машина или нет 1 в угоне - 0 нет
- Metki
//savetheft
*/
//////////////////////////////
new Float:acarsd[][3] = {
	{2120.0693,2718.2942,10.8203},
	{-1931.6606,271.5569,41.0469},
	{2507.9807,-2113.6448,13.5469}
}; 
new bool: rabotaon[MAX_PLAYERS];
new nachalvzlom[MAX_PLAYERS]; 
new timervzlom[MAX_PLAYERS]; 

new pickcars[4];
/*
#if defined _theft_inc
    theft_OnGameModeInit();
#endif 
*/
theft_OnGameModeInit()
{
    //Автоугонщик
	pickcars[0] = CreateDynamicPickup(19134, 23, acarsd[0][0], acarsd[0][1], acarsd[0][2]);// Выдача мопеда автоугонщикам.
	pickcars[1] = CreateDynamicPickup(19134, 23, acarsd[1][0], acarsd[1][1], acarsd[1][2]);// Выдача мопеда автоугонщикам.
	pickcars[2] = CreateDynamicPickup(19134, 23, acarsd[2][0], acarsd[2][1], acarsd[2][2]);// Выдача мопеда автоугонщикам.
	
	pickcars[3] = CreateDynamicPickup(19134, 23, 2515.4497, -1465.3451, 23.9989);// Выдача мопеда автоугонщикам. 
}
/*
#if defined _theft_inc
    theft_OnPlayerPickUpDynamicPickup(playerid, pickupid);
#endif
*/
/*theft_OnPlayerPickUpDynamicPickup(playerid, pickupid)
{ 
	
    return 0;
}*/
/*
#if defined _theft_inc
    theft_OnPlayerConnect(playerid);
#endif
*/
theft_OnPlayerConnect(playerid)
{
    rabotaon[playerid] = false;
    nachalvzlom[playerid] = 0; 
   	timervzlom[playerid] = 0;
    /*pTemp[playerid][tTheftSkladID] = -1;
	pTemp[playerid][tTheftIDCar] = INVALID_VEHICLE_ID;
    pTemp[playerid][tTheftTime] = 0;
    pTemp[playerid][tTheftGZ] = INVALID_GANGZONE_ID;
    pTemp[playerid][tQuestTheft] = false;*/
    /*pInfo[playerid][pTheftQuest] = 0;
    pInfo[playerid][pTheftLevel] = 1;
    pInfo[playerid][pTheftExp] = 0;*/
}
/*
#if defined _theft_inc
    theft_OnPlayerDisconnect(playerid, reason);
#endif
*/
theft_OnPlayerDisconnect(playerid, reason) {
    #pragma unused reason
    if (pTemp[playerid][tTheftIDCar] != INVALID_VEHICLE_ID)
	{//VehicleInfo[ vehicleid - 1 ][vJackerOff] = true;
	    /*if (VehicleInfo[ pTemp[playerid][tTheftIDCar] - 1 ][vJackerOff] == true)
		{
			_DestroyVehicle(pTemp[playerid][tTheftIDCar]);
		}*/
	    pTemp[playerid][tTheftIDCar] = INVALID_VEHICLE_ID;
	    if (pInfo[playerid][pSkilla] > 0) {
			pInfo[playerid][pSkilla]--;
            pTemp[playerid][tTheftSkladID] = -1;
			SavePlayerInteger(playerid, "pSkilla", pInfo[playerid][pSkilla]);
		}
	}
}
/*
#if defined _theft_inc
    theft_OnDialogResponse(playerid, dialogid, response, listitem, const inputtext[]);
#endif
*/
theft_OnDialogResponse(playerid, dialogid, response, listitem, const inputtext[]) {
	#pragma unused listitem, inputtext
	switch (dialogid){
		case D_THEFT_CAR_0:
        {
            if (!response) return 1;
            if (pTemp[playerid][tQuestTheft]) return SendClientMessage(playerid, COLOR_GREY, !"Доставь посылку Данте, он ждет тебя");
            pTemp[playerid][tQuestTheft] = true;
            SendClientMessage(playerid, COLOR_GREY, !"Доставь пакет, Данте");
            CP[playerid] = 777;
            SetPlayerCheckpoint(playerid, 1105.7283,-1311.2351,13.6550, 4.0);
        }
        case D_THEFT_CAR_1:
        {
            if (!response) return 1;
           // if (pInfo[playerid][pJob] != 10) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете взять контракт!");
            new car[20], string_[128];
            new sss = 0;
            for(new i = 1; i < MAX_VEHICLES ; i ++)
            {
                if (IsVehicleOccupied(i) != -1) continue;//VehicleInfo[ i - 1 ][vFraction] != pInfo[playerid][pID]
                if (VehicleInfo[ i - 1 ][vFraction] == pInfo[playerid][pID]) continue;
                if (IsAVehicle(i) && sss < 20 && VehicleInfo[ i - 1 ][vType] == VEHICLE_TYPE_PLAYER && VehicleInfo[ i - 1 ][vSellCost] == 0)
                { 
                    car[sss] = i;
                    sss++; 
                }
            }
            if (sss == 0) return SendClientMessage(playerid, COLOR_GREY, !"На данный момент на сервере нет машин");
            new
                randomik = RandomFIX(0, sss);
            pTemp[playerid][tTheftIDCar] = car[randomik];
            new Float:X, Float:Y, Float:Z;
            GetVehiclePos(pTemp[playerid][tTheftIDCar], X, Y, Z);
            SendMes(playerid, -1, "SERVER ID:%d | COUNT: %d", pTemp[playerid][tTheftIDCar], sss);
            format(string_, sizeof string_, "Пригони нам тачку марки %s, и мы тебе хорошо заплатим.", VehicleNames[GetVehicleModel( pTemp[playerid][tTheftIDCar] ) - 400]);
            SendClientMessage(playerid, 0x6495EDFF, string_);

            SendClientMessage(playerid, 0x6495EDFF, !"(( Чтобы взломать замок зажми Спринт (по умолчанию пробел) ))");
            SendClientMessage(playerid, 0x6495EDFF, !"Подобную тачку наши парни недавно видели. Я обозначил её на твоей карте.");
            PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
            pTemp[playerid][tTheftGZ] = GangZoneCreate(X-95,Y-80,X+70,Y+85);
            GangZoneShowForPlayer(playerid, pTemp[playerid][tTheftGZ], COLOR_BLACK);
            pTemp[playerid][tTheftSkladID] = -1;
            pTemp[playerid][tTheftTime] = 1200;
        }
        case D_THEFT_CAR_2:
        {
            if (!response) return 1;
            new car[20], string_[128];
            new sss = 0;
            for(new i = 1; i < MAX_VEHICLES ; i ++)
            {
                if (IsVehicleOccupied(i) != -1) continue;//VehicleInfo[ i - 1 ][vFraction] != pInfo[playerid][pID]
                if (VehicleInfo[ i - 1 ][vFraction] == pInfo[playerid][pID]) continue;
                if (IsAVehicle(i) && sss < 20 && VehicleInfo[ i - 1 ][vType] == VEHICLE_TYPE_PLAYER && VehicleInfo[ i - 1 ][vSellCost] == 0)
                { 
                    car[sss] = i;
                    sss++; 
                }
            }
            if (sss == 0) return SendClientMessage(playerid, COLOR_GREY, !"На данный момент на сервере нет машин");
            new
                randomik = RandomFIX(0, sss);
            pTemp[playerid][tTheftIDCar] = car[randomik];
            new Float:X, Float:Y, Float:Z;
            GetVehiclePos(pTemp[playerid][tTheftIDCar], X, Y, Z);
            SendMes(playerid, -1, "SERVER ID:%d | COUNT: %d", pTemp[playerid][tTheftIDCar], sss);
            format(string_, sizeof string_, "Пригони нам тачку марки %s, и мы тебе хорошо заплатим.", VehicleNames[GetVehicleModel( pTemp[playerid][tTheftIDCar] ) - 400]);
            SendClientMessage(playerid, 0x6495EDFF, string_);

            SendClientMessage(playerid, 0x6495EDFF, !"(( Чтобы взломать замок зажми Спринт (по умолчанию пробел) ))");
            SendClientMessage(playerid, 0x6495EDFF, !"Подобную тачку наши парни недавно видели. Я обозначил её на твоей карте.");
            PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
            pTemp[playerid][tTheftGZ] = GangZoneCreate(X-95,Y-80,X+70,Y+85);
            GangZoneShowForPlayer(playerid, pTemp[playerid][tTheftGZ], COLOR_BLACK);
            pTemp[playerid][tTheftTime] = 1200;
        }
	}
	return false;
}


publics: PlayerJacker(playerid, vehicleid)
{
	nachalvzlom[playerid] = 0;
	pInfo[playerid][pWantedLevel] ++;
	SetPlayerWantedLevelEx(playerid, pInfo[playerid][pWantedLevel]);
	pInfo[playerid][pZakonp] -= 1;
	if (pInfo[playerid][pZakonp] < -100) pInfo[playerid][pZakonp] = -100;
	SetPlayerCriminal(playerid, "Неизвестный", "Угон автомобиля");
	SendClientMessage(playerid,COLOR_BLUE, !"Замок автомобиля открыт, пора уносить ноги!");
	ClearAnimations(playerid, 1);
	UnLockCar(vehicleid);
	return 1;
}

stock IsANope(carid)
{
	switch(GetVehicleModel(carid))
	{
		case 400,404,436,439,458,466,475,478,479,492,516,517,518,526,527,542,543,546,547,549,567: return 1;
 		default: return 0;
	}
	return 0;
}
stock IsAB(carid)
{
	switch(GetVehicleModel(carid))
	{
		case 419,421,445,489,491,533,534,554,555,561,579,580,589,603,418,461,581,586,401,405,412,422,426,467,474,496,507,529,536,540,550,551,566,575,576,585,600: return 1;
 		default: return 0;
	}
	return 0;
}
stock IsAA(carid)
{
	switch(GetVehicleModel(carid))
	{
		case 541,522,434,477,480,535,545,558,559,560,562,565,587,602,521,463,468,402,411,415,429,451,506: return 1;
 		default: return 0;
	}
	return 0;
}

theft_timer(playerid)
{
    if (pTemp[playerid][tTheftTime] > 0)
    {
        pTemp[playerid][tTheftTime]--;
        new str_[16];
        if (nachalvzlom[playerid] == 0) format(str_, sizeof str_,"~r~%s",Convert(pTemp[playerid][tTheftTime]));
        else format(str_, sizeof str_, "~g~BREAK");
        GameTextForPlayer(playerid, str_, 2000, 6);
        if (pTemp[playerid][tTheftTime] == 1)
        {
            if (pInfo[playerid][pSkilla] > 0)
            {
                pInfo[playerid][pSkilla]--;
                SavePlayerInteger(playerid, "pSkilla", pInfo[playerid][pSkilla]);
            }
            SendClientMessage(playerid, COLOR_BLUE, !"[SMS]: Ты нас разочаровал! Миссия провалена");
            VehicleInfo[ pTemp[playerid][tTheftIDCar] - 1 ][vJacker] = 0;
            pTemp[playerid][tTheftIDCar] = INVALID_VEHICLE_ID;
            pTemp[playerid][tTheftSkladID] = -1;
            rabotaon[playerid] = false;
            GangZoneDestroy(pTemp[playerid][tTheftGZ]);
            pTemp[playerid][tTheftGZ] = INVALID_GANGZONE_ID;
        }
    }
}
/*
#if defined _theft_inc
    theft_OnPlayerExitVehicle(playerid, vehicleid);
#endif
*/
theft_OnPlayerExitVehicle(playerid, vehicleid)
{
    #pragma unused vehicleid
    if (rabotaon[playerid] == true)
	{
		DisablePlayerCheckpoint(playerid);
	}
}
/*
#if defined _theft_inc
    theft_OnPlayerEnterCheckpoint(playerid);
#endif
*/
theft_OnPlayerEnterCheckpoint(playerid)
{
    new
		vehicleid = GetPlayerVehicleID(playerid);
    if (rabotaon[playerid] == true)
	{
		if (pTemp[playerid][tTheftIDCar] != GetPlayerVehicleID(playerid)) return SendClientMessage(playerid,COLOR_BLUE,!"Это не та машина, которую мы заказывали!");
		new Float:hp;
		GetVehicleHealth(vehicleid,hp);
		if (hp < 700) return SendClientMessage(playerid,COLOR_BLUE, !"Нам не нужен металлолом!");
		if (IsANope(vehicleid))
		{
			SendClientMessage(playerid, COLOR_BLUE, !"[SMS]: Отличная работа. Приходи ещё.");
			kLibGivePlayerMoney(playerid, 500, "угон авто 1");
			GameTextForPlayer(playerid,"~b~+$500", 3000, 1);
			pTemp[playerid][tTheftTime] = 0;
			if (pInfo[playerid][pSkilla] < 1000)
			{
				pInfo[playerid][pSkilla] += GetVipBoostMaxPlayerValue(playerid, vSkillTheftCar, bSkillTheftCar, 1);//vSkillTheftCar
				SavePlayerInteger(playerid, "pSkilla", pInfo[playerid][pSkilla]);
			}
		}
		else if (IsAB(vehicleid))
		{
			SendClientMessage(playerid, COLOR_BLUE, !"[SMS]: Отличная работа. Приходи ещё.");
			kLibGivePlayerMoney(playerid, 3000," угон авто 2");
			GameTextForPlayer(playerid,"~b~+$3000", 3000, 1);
			pTemp[playerid][tTheftTime] = 0;
			if (pInfo[playerid][pSkilla] < 1000)
			{
				pInfo[playerid][pSkilla] += GetVipBoostMaxPlayerValue(playerid, vSkillTheftCar, bSkillTheftCar, 2); // vSkillTheftCar
				SavePlayerInteger(playerid, "pSkilla", pInfo[playerid][pSkilla]);
			}
		}
		else if (IsAA(vehicleid))
		{
			SendClientMessage(playerid, COLOR_BLUE, !"[SMS]: Отличная работа. Приходи ещё.");
			kLibGivePlayerMoney(playerid, 7000, "угон авто 3");
			GameTextForPlayer(playerid,"~b~+$7000", 3000, 1);
			pTemp[playerid][tTheftTime] = 0;
			if (pInfo[playerid][pSkilla] < 1000)
			{
				pInfo[playerid][pSkilla] += GetVipBoostMaxPlayerValue(playerid, vSkillTheftCar, bSkillTheftCar, 3); // vSkillTheftCar
				SavePlayerInteger(playerid, "pSkilla", pInfo[playerid][pSkilla]);
			}
		} 
        else {
            SendClientMessage(playerid, COLOR_BLUE, !"[SMS]: Бро! Отличная работа. Приходи ещё.");
			kLibGivePlayerMoney(playerid, 4000, "угон авто 3");
			GameTextForPlayer(playerid,"~b~+$4000", 3000, 1);
			pTemp[playerid][tTheftTime] = 0;
			if (pInfo[playerid][pSkilla] < 1000)
			{
				pInfo[playerid][pSkilla] += GetVipBoostMaxPlayerValue(playerid, vSkillTheftCar, bSkillTheftCar, 3); // vSkillTheftCar
				SavePlayerInteger(playerid, "pSkilla", pInfo[playerid][pSkilla]);
			}
        }
        //OnPlayerQuestProgress(playerid, QUEST_GHETTO, QUEST_TASK_ROB_CAR);
		new query_[156];
		format(query_, sizeof query_,"UPDATE `s_vehicle_player` SET `vFuel` = '%f',`vMillage` = '%f',`vFine` = '1',`vDayFine` = '1' WHERE `vID` = '%d' LIMIT 1",
		VehicleInfo[ vehicleid - 1 ][vFuel],
		VehicleInfo[ vehicleid - 1 ][vMillage],
		VehicleInfo[ vehicleid - 1 ][vID]) ;
		mysql_tquery(dbHandle, query_);

		new t_playerid = - 1 ;
		foreach(new i: PlayerInLogin)
		{
			if (VehicleInfo[ vehicleid - 1 ][vFraction] == pInfo[i][pID])
			{
				t_playerid = i;
		    }
		}
		
		

		VehicleInfo[ vehicleid - 1 ][vFraction] = 0;
		VehicleInfo[ vehicleid - 1 ][vSubFraction] = 0;
		VehicleInfo[ vehicleid - 1 ][vRank] = 0;
		VehicleInfo[ vehicleid - 1 ][vType] = 0;
		VehicleInfo[ vehicleid - 1 ][vMoney] = 0;
		VehicleInfo[ vehicleid - 1 ][vFillBag] = 0;
		VehicleInfo[ vehicleid - 1 ][vRepair] = 0;
		VehicleInfo[ vehicleid - 1 ][vDrugs] = 0;
		VehicleInfo[ vehicleid - 1 ][vMaterials] = 0;
		for(new t = 0; t < 6; t++)
	    {
	        VehicleInfo[ vehicleid - 1 ][vBootGun][t] = 0;
	        VehicleInfo[ vehicleid - 1 ][vBootAmmo][t] = 0;
		}
	
		_DestroyVehicle(vehicleid);
		
        if (t_playerid != -1)
		{
		    if (VehicleInfo[ vehicleid - 1 ][vJacker] == 1)
		    {
			    Iter_Remove(StreamedVehicles[t_playerid], vehicleid);
				SendClientMessage(t_playerid, COLOR_WHITE, !"Ваш транспорт был угнан, забрать его можно на "colserver"Штрафстоянке");
				Iter_Remove(PlayerListVehicle[t_playerid], vehicleid);
				SetVehicleToRespawn(vehicleid);
				
			} else {
			    _DestroyVehicle(vehicleid); 
			}
            VehicleInfo[ vehicleid - 1 ][vJacker] = 0;
            VehicleInfo[ vehicleid - 1 ][vJackerOff] = false;
		}
		rabotaon[playerid] = false;
		pTemp[playerid][tTheftIDCar] = INVALID_VEHICLE_ID;
        pTemp[playerid][tTheftSkladID] = -1;
		DisablePlayerCheckpoint(playerid);
	}
    return 1;
}


/*
    case D_UGON_JOB_CAR_0:
    {
        if (!response) return SendClientMessage(playerid,COLOR_BLUE, !"Проваливай! Не дай бог настучишь копам!");
        LeavePlayerTaxi(playerid);
        pInfo[playerid][pJob] = 10;
        SendClientMessage(playerid, 0x6495EDFF, !"Добро пожаловать в команду!");
        SendClientMessage(playerid, 0x6495EDFF, !"На автомойке всегда найдется работа. Если тебе не на чем доехать, можешь взять скутер в гараже.");
        SendClientMessage(playerid, 0x6495EDFF, !"(( Для взлома авто, подойди к нужной машине и если авто закрыто, зажми SPACE (Спринт) ))");
        return 1;
    }
    case D_UGON_JOB_CAR_1:
    {
        if (!response) return 1;
        pTemp[playerid][tTheftTime] = 0;
        if (pInfo[playerid][pSkilla] > 0) pInfo[playerid][pSkilla]--;
        SavePlayerInteger(playerid, "pSkilla", pInfo[playerid][pSkilla]);
        SendClientMessage(playerid, COLOR_BLUE, !"[SMS]: Ты нас разочаровал! Миссия провалена");
        pTemp[playerid][tTheftIDCar] = INVALID_VEHICLE_ID;
        rabotaon[playerid] = false;
        GangZoneDestroy(pTemp[playerid][tTheftGZ]);
        pTemp[playerid][tTheftGZ] = INVALID_GANGZONE_ID;
        return 1;
    }
    case D_UGON_JOB_CAR_2:
    {
        if (!response) return 1;
        new string_[128];
        switch(listitem)
        {
            case 0:
            {
                if (pInfo[playerid][pJob] != 10) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете взять контракт!");
                new car[20];
                new sss = 0;
                for(new i = 1; i < MAX_VEHICLES ; i ++)
                {
                    if (IsVehicleOccupied(i) != -1) continue;
                    if (IsANope(i) && sss < 20 && VehicleInfo[ i - 1 ][vType] == VEHICLE_TYPE_PLAYER)
                    {
                        if (VehicleInfo[ i - 1 ][vFraction] != pInfo[playerid][pID])
                        {
                            car[sss] = i;
                            sss++;
                        }
                    }
                }
                if (sss == 0) return SendClientMessage(playerid, COLOR_GREY, !"На данный момент на сервере нет машин Nope Class'a");
                new
                    randomik = RandomFIX(0, sss);
                pTemp[playerid][tTheftIDCar] = car[randomik];
                new Float:X, Float:Y, Float:Z;
                GetVehiclePos(pTemp[playerid][tTheftIDCar], X, Y, Z);
                SendMes(playerid, -1, "SERVER ID:%d | COUNT: %d", pTemp[playerid][tTheftIDCar], sss);
                format(string_, sizeof string_, "Пригони нам тачку марки %s, и мы тебе хорошо заплатим.", VehicleNames[GetVehicleModel( pTemp[playerid][tTheftIDCar] ) - 400]);
                SendClientMessage(playerid, 0x6495EDFF, string_);

                SendClientMessage(playerid, 0x6495EDFF, !"(( Чтобы взломать замок зажми Спринт (по умолчанию пробел) ))");
                SendClientMessage(playerid, 0x6495EDFF, !"Подобную тачку наши парни недавно видели. Я обозначил её на твоей карте.");
                PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
                pTemp[playerid][tTheftGZ] = GangZoneCreate(X-95,Y-80,X+70,Y+85);
                GangZoneShowForPlayer(playerid, pTemp[playerid][tTheftGZ], COLOR_BLACK);
                pTemp[playerid][tTheftTime] = 1200;
            }
            case 1:
            {
                if (pInfo[playerid][pSkilla] < 50) return SendClientMessage(playerid, COLOR_GREY, !"Вам опыт слишком мал. (Минимум 50)");
                if (pInfo[playerid][pJob] != 10) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете взять контракт!");
                new car[20];
                new sss = 0;
                for(new i = 1; i < MAX_VEHICLES ; i ++)
                {
                    if (IsVehicleOccupied(i) != -1) continue;
                    if (IsAB(i) && sss < 20 && VehicleInfo[ i - 1 ][vType] == VEHICLE_TYPE_PLAYER)
                    {
                        car[sss] = i;
                        sss++;
                    }
                }
                if (sss == 0) return SendClientMessage(playerid, COLOR_GREY, !"На данный момент на сервере нет машин B Class'a");
                new randomik = RandomFIX(0, sss);
                pTemp[playerid][tTheftIDCar] = car[randomik];
                new Float:X,Float:Y,Float:Z;
                GetVehiclePos(pTemp[playerid][tTheftIDCar],X,Y,Z);
                format(string_, sizeof string_, "Пригони нам тачку марки %s, и мы тебе хорошо заплатим.",VehicleNames[GetVehicleModel(pTemp[playerid][tTheftIDCar])-400]);
                SendClientMessage(playerid,0x6495EDFF, string_);
                SendClientMessage(playerid,0x6495EDFF,"(( Чтобы взломать замок зажми Спринт ( по умолчанию пробел ) ))");
                SendClientMessage(playerid,0x6495EDFF,"Подобную тачку наши парни недавно видели. Я обозначил её на твоей карте.");
                PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
                pTemp[playerid][tTheftGZ] = GangZoneCreate(X-95,Y-80,X+70,Y+85);
                GangZoneShowForPlayer(playerid,pTemp[playerid][tTheftGZ],COLOR_BLACK);
                pTemp[playerid][tTheftTime] = 600;
            }
            case 2:
            {
                if (pInfo[playerid][pSkilla] < 150) return SendClientMessage(playerid, COLOR_GREY, !"Вам опыт слишком мал. (Минимум 150)");
                if (pInfo[playerid][pJob] != 10) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете взять контракт!");
                new car[20];
                new sss = 0;
                for(new i = 1; i < MAX_VEHICLES ; i ++)
                {
                    if (IsVehicleOccupied(i) != -1) continue;
                    if (IsAA(i) && sss < 20 && VehicleInfo[ i - 1 ][vType] == VEHICLE_TYPE_PLAYER)
                    {
                        car[sss] = i;
                        sss++;
                    }
                }
                if (sss == 0) return SendClientMessage(playerid, COLOR_GREY, !"На данный момент на сервере нет машин A Class'a");
                new randomik = RandomFIX(0, sss);
                pTemp[playerid][tTheftIDCar] = car[randomik];
                new Float:X, Float:Y, Float:Z;
                GetVehiclePos(pTemp[playerid][tTheftIDCar],X,Y,Z);
                format(string_, sizeof string_, "Пригони нам тачку марки %s, и мы тебе хорошо заплатим.", VehicleNames[GetVehicleModel(pTemp[playerid][tTheftIDCar])-400]);
                SendClientMessage(playerid,0x6495EDFF, string_);
                SendClientMessage(playerid,0x6495EDFF,!"(( Чтобы взломать замок зажми Спринт (по умолчанию пробел) ))");
                SendClientMessage(playerid,0x6495EDFF,!"Подобную тачку наши парни недавно видели. Я обозначил её на твоей карте.");
                PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
                pTemp[playerid][tTheftGZ] = GangZoneCreate(X-95,Y-80,X+70,Y+85);
                GangZoneShowForPlayer(playerid,pTemp[playerid][tTheftGZ],COLOR_BLACK);
                pTemp[playerid][tTheftTime] = 300;
            }
        }
        return 1;
    }*/


CMD:testvehcount(playerid)
{
    new
        count = 1;
    for(new i = 1; i < MAX_VEHICLES ; i ++)
    {
        if (!IsValidVehicle(i)) continue;
        count++;
    }
    SendMes(playerid, COLOR_GREY, "MAX_VEHICLE: %d | PoolSize: %d", count, GetVehiclePoolSize());
    return 1;
}        