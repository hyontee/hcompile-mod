#if defined _hospital_inc
	#endinput
#endif
#define _hospital_inc

enum E_HOSPITAL_INFO 
{
    hPlayerID,
    hInterior,
    hWorld,
    Float: hText[4],  
    Float: hPlayer[4],  
    Text3D: hLabel
}
new HospitalInfo[][E_HOSPITAL_INFO] = { 
    /* 1 Палата Больница ЛС */
    {INVALID_PLAYER_ID, 7, 1, {811.5884, 1348.6438, 1071.4810, 180.5541}, {812.5744, 1348.9613, 1072.1285, 268.6017}, Text3D:0},
    {INVALID_PLAYER_ID, 7, 1, {815.6836, 1348.6442, 1071.4810, 180.2409}, {816.5178, 1349.0098, 1072.1285, 268.6017}, Text3D:0},
    {INVALID_PLAYER_ID, 7, 1, {819.6554, 1348.6461, 1071.4810, 179.9275}, {820.6637, 1348.9084, 1072.1285, 268.6017}, Text3D:0},
    {INVALID_PLAYER_ID, 7, 1, {813.6715, 1354.9332, 1071.4810, 356.0225}, {812.8163, 1354.6270, 1072.1285, 93.1334}, Text3D:0},
    {INVALID_PLAYER_ID, 7, 1, {817.9150, 1354.9298, 1071.4810, 1.0358},   {816.9213, 1354.5382, 1072.1285, 93.1334}, Text3D:0},
    {INVALID_PLAYER_ID, 7, 1, {821.7255, 1354.9294, 1071.4810, 10.1226},  {820.8943, 1354.7549, 1072.1285, 93.1334}, Text3D:0},
    /* 2 Палата Больница ЛС */
    {INVALID_PLAYER_ID, 7, 1, {811.6367,1338.6038,1071.4810,173.3242}, {812.4793,1338.9978,1072.1105,277.0618}, Text3D:0},
    {INVALID_PLAYER_ID, 7, 1, {815.5729,1338.5928,1071.4810,175.8309}, {816.5450,1338.7983,1072.1105,277.0618}, Text3D:0},
    {INVALID_PLAYER_ID, 7, 1, {819.6591,1338.5939,1071.4810,177.3975}, {820.5872,1338.9017,1072.1105,277.0618}, Text3D:0},
    {INVALID_PLAYER_ID, 7, 1, {813.7549,1344.8823,1071.4810,353.4925}, {812.7332,1344.7307,1072.1105,94.0733}, Text3D:0},
    {INVALID_PLAYER_ID, 7, 1, {817.7249,1344.8790,1071.4810,352.2392}, {816.8978,1344.6257,1072.1105,94.0733}, Text3D:0},
    {INVALID_PLAYER_ID, 7, 1, {821.8901,1344.8818,1071.4790, 4.4593},  {820.8511,1344.4768,1072.1105,94.0733}, Text3D:0},
    /* Hospital SF*/
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2615.8169,617.1572,1338.9734,273.3281}, {-2616.0273,617.8207,1339.6229,5.7857}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2615.8188,614.1288,1338.9753,268.6281}, {-2616.0032,614.9598,1339.6229,5.7857}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2615.8196,611.1565,1338.9753,272.0748}, {-2616.0530,611.9619,1339.6229,5.7857}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2623.9097,612.9947,1338.9753,93.1831 }, {-2623.5293,612.2713,1339.6229,181.5674}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2623.9075,615.9927,1338.9753,94.4365 }, {-2623.6091,615.1318,1339.6229,181.5674}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2623.9089,618.9927,1338.9753,93.4965 }, {-2623.6917,618.1385,1339.6229,181.5674}, Text3D:0},
    /* 2 Палата */
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2615.8181,601.6763,1338.9753,272.1452}, {-2616.0322,602.5167,1339.6229,352.9859}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2615.8181,598.6580,1338.9753,268.3852}, {-2616.0681,599.4321,1339.6229,352.9859}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2615.8196,595.6772,1338.9753,271.8318}, {-2616.0291,596.5320,1339.6229,352.9859}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2623.9092,597.5118,1338.9753,95.4235 }, {-2623.6038,596.7080,1339.6229,171.8774}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2623.9092,600.5118,1338.9753,91.0368 }, {-2623.7429,599.7659,1339.6229,171.8774}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2623.9080,603.5129,1338.9753,90.7235 }, {-2623.6582,602.6500,1339.6229,171.8774}, Text3D:0},
    /* 3 Палата */
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2636.3801,613.0186,1338.9773,91.3500 }, {-2636.1799,612.3428,1339.6229,188.5076}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2636.3770,615.9927,1338.9753,93.2300 }, {-2636.2212,615.3435,1339.6229,188.5076}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2636.3784,618.9927,1338.9753,97.3034 }, {-2636.2158,618.3760,1339.6229,188.5076}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2628.4614,617.1581,1338.9753,270.8917}, {-2628.4846,617.8900,1339.6229,357.7092}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2628.4578,614.1569,1338.9753,271.2050}, {-2628.6060,614.8648,1339.6229,357.7092}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2628.4578,611.1563,1338.9753,279.0384}, {-2628.5623,611.8214,1339.6229,357.7092}, Text3D:0},
    /* 4 Палата */
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2628.4573,601.6757,1338.9753,269.9984}, {-2628.5474,602.4580,1339.6229,352.1159}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2628.4597,598.6331,1338.9753,267.8049}, {-2628.6426,599.4761,1339.6229,352.1159}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2628.4587,595.6748,1338.9753,272.8184}, {-2628.6118,596.4885,1339.6229,352.1159}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2636.3787,597.5109,1338.9773,90.7933 }, {-2636.2617,596.7714,1339.6229,181.6845}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2636.3792,600.5109,1338.9773,91.7333 }, {-2636.2644,599.7954,1339.6229,181.6845}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_SF_INT, 1, {-2636.3801,603.5140,1338.9773,98.0001 }, {-2636.3516,602.7659,1339.6229,181.6845}, Text3D:0},
    /* Hospital LV */
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1667.2505,1793.3042,1098.1624,92.9634}, {1667.3627,1792.6975,1098.8099,181.9509}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1667.2509,1796.3042,1098.1624,92.9634}, {1667.3798,1795.5776,1098.8099,181.9509}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1667.2524,1799.3190,1098.1624,88.2633}, {1667.2462,1798.5508,1098.8099,181.9509}, Text3D:0}, 
    
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1677.9755,1799.3345,1098.1624,267.1783}, {1677.7000,1798.2065,1098.8099,7.1093}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1677.9714,1796.3120,1098.1624,270.9384}, {1677.8352,1795.1847,1098.8099,7.1093}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1677.9741,1793.3076,1098.1624,265.9250}, {1677.8311,1792.1869,1098.8099,7.1093}, Text3D:0},
    /* 1 Палата */
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1681.6425,1793.3042,1098.1624,95.1569}, {1681.7683,1792.5906,1098.8099,182.8911}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1681.6442,1796.3042,1098.1624,91.7102}, {1681.6693,1795.5438,1098.8099,182.8911}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1681.6429,1799.3068,1098.1624,91.7103}, {1681.6846,1798.6298,1098.8099,182.8911}, Text3D:0},

    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1692.4176,1799.3077,1098.1624,266.8653}, {1692.2839,1798.2196,1098.8099,358.9629}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1692.4150,1796.3109,1098.1624,270.6254}, {1692.2291,1795.2030,1098.8099,358.9629}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1692.4155,1793.3077,1098.1624,269.0587}, {1692.1746,1792.2018,1098.8099,358.9629}, Text3D:0},
    /* 2 Палата */
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1667.2521, 1764.2971, 1098.1624, 81.5865}, {1667.3051, 1765.1952, 1098.8099, 171.5140}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1667.2505, 1767.2974, 1098.1624, 86.2865}, {1667.4609, 1768.3630, 1098.8099, 171.5140}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1667.2517, 1770.2981, 1098.1624, 88.4799}, {1667.4181, 1771.2727, 1098.8099, 171.5140}, Text3D:0},

    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1677.9761, 1770.2998, 1098.1624, 273.9749}, {1677.8530,1770.9434,1098.3071,3.5656}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1677.9762, 1767.3007, 1098.1624, 267.3948}, {1677.8811,1768.0262,1098.3071,3.5656}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1677.9768, 1764.3015, 1098.1624, 270.2149}, {1677.8873,1765.0865,1098.3071,3.5656}, Text3D:0},
    /* 3 Палата */
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1681.6428, 1764.2964, 1098.1624, 86.8893}, {1681.9945, 1765.2413, 1098.8099, 172.0934}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1681.6434, 1767.2867, 1098.1624, 90.9627}, {1681.7931, 1768.2722, 1098.8099, 172.0934}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1681.6459, 1770.2974, 1098.1624, 87.8294}, {1681.9015, 1771.3892, 1098.8099, 172.0934}, Text3D:0},

    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1692.4154, 1770.3005, 1098.1624, 273.3010}, {1692.1510, 1771.1260, 1098.8099, 352.2617}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1692.4171, 1767.2998, 1098.1624, 271.7343}, {1692.1787, 1768.1188, 1098.8099, 352.2617}, Text3D:0},
    {INVALID_PLAYER_ID, HOSPITAL_LV_INT, 1, {1692.4182, 1764.2998, 1098.1624, 269.8543}, {1692.2046, 1765.0967, 1098.8099, 352.2617}, Text3D:0}
};  
hospital_OnGameModeInit()
{
    for(new i; i < sizeof(HospitalInfo); i++)
    {
        HospitalInfo[i][hLabel] = CreateDynamic3DTextLabel("[Койка свободна]\n\n"colserver"Используйте ALT, чтобы занять его!",-1,
            HospitalInfo[i][hText][0], HospitalInfo[i][hText][1], HospitalInfo[i][hText][2] + 0.5,
            10.0, .testlos = 1,
            .worldid = HospitalInfo[i][hWorld], .interiorid = HospitalInfo[i][hInterior]
        );
    }
}

OnHospitalTimer()
{ 
    foreach(new i: PlayerInLogin)
    {
        if (pInfo[i][pHospital] == 4 || pInfo[i][pHospital] == 5) {
            SetPVarInt(i,"timer_heal",GetPVarInt(i,"timer_heal") + 1);
            if (GetPVarInt(i,"timer_heal") >= 3 && IsPlayerAFK(i) <= 3) {
                SetPlayerHealth(i, GetPlayerHP(i) + 3), GameTextForPlayer(i, !"~p~ +3 HP", 500, 4);
                DeletePVar(i,"timer_heal");
            }
            if (GetPlayerHP(i) >= 100) {
                if (pInfo[i][pHospital]) {
                    SendClientMessage(i, COLOR_YELLOW, !"[Подсказка] "colwhi"Вы успешно прошли курс лечения в госпитале!");
                }
                pInfo[i][pHospital] = 0;
                SetPlayerHealth(i, 100.0);
                DeletePVar(i, "timer_heal");
            }
        }
        if (pInfo[i][pHospital] && pTemp[i][tHospitalBed] != -1 && GetPVarInt(i, #PlayerAnimation) == 1)
        {
            if (GetPlayerHP(i) + 5.0 < 100.0 ) {
                PlayerPlaySound(i, 17803, 0.0, 0.0, 0.0);
                SetPlayerHealth(i, GetPlayerHP(i) + 5.0), GameTextForPlayer(i, !"~p~ +5 HP", 500, 4);
            }
		    else {
                pTemp[i][tDeathReason] = 0;
                pInfo[i][pHospital] = 0; 
                SetPlayerHealth(i, 100.0);
                SendClientMessage(i, COLOR_YELLOW, !"[Подсказка] "colwhi"Ваш курс лечения окончен!");  
                SetPlayerPosAC(i, HospitalInfo[pTemp[i][tHospitalBed]][hText][0], HospitalInfo[pTemp[i][tHospitalBed]][hText][1], HospitalInfo[pTemp[i][tHospitalBed]][hText][2], pTemp[i][tVirtualWorld], pTemp[i][tInterior]);
                SetPlayerFacingAngle(i, HospitalInfo[pTemp[i][tHospitalBed]][hText][3]);               
                TogglePlayerControllable(i, true);
                TextDrawHideForPlayer(i, InfoAnimDraw);
			    SetPVarInt(i, #PlayerAnimation , 0);
                HospitalInfo[ pTemp[i][tHospitalBed] ][hPlayerID] = INVALID_PLAYER_ID;
                pTemp[i][tHospitalBed] = -1; 
            }  
        } 
    }
    for(new i; i < sizeof(HospitalInfo); i++)
    {
        if (HospitalInfo[i][hPlayerID] == INVALID_PLAYER_ID)  {
           UpdateDynamic3DTextLabelText(HospitalInfo[i][hLabel], -1, "Койка свободна\n\n"colserver"Используйте ALT, чтобы занять его!"); 
        }
        else {
            new 
                id = HospitalInfo[i][hPlayerID]; 
            format(t_string, sizeof t_string, ""colserver"[Карточка пациента]\n\
                "colwhi"Имя: "colserver"%s\n\
                "colwhi"Причина: "colserver"%s\n\
                "colwhi"Состояние: "colserver"%0.1f%%", 
                pInfo[ id ][pName], 
                GetReasonDeath( id ), GetPlayerHP( id )
            ); 
            UpdateDynamic3DTextLabelText(HospitalInfo[i][hLabel], -1, t_string), t_string[0] = EOS;
        }
        
    }
}
hospital_OnPlayerDisconnect(playerid)
{
    if (pTemp[playerid][tHospitalBed] != -1) { 
        new 
            idx_bed = pTemp[playerid][tHospitalBed];
        UpdateDynamic3DTextLabelText(HospitalInfo[ idx_bed ][hLabel], -1, "Койка свободна\n\n"colserver"Используйте ALT, чтобы занять его!");
        HospitalInfo[ idx_bed ][ hPlayerID ] = INVALID_PLAYER_ID;
        pTemp[playerid][tHospitalBed] = -1; 
    }
}  
hospital_OnPlayerSpawn(playerid) {
    if (pTemp[playerid][tHospitalBed] != -1) { 
        new 
            idx_bed = pTemp[playerid][tHospitalBed];
        UpdateDynamic3DTextLabelText(HospitalInfo[ idx_bed ][hLabel], -1, "Койка свободна\n\n"colserver"Используйте ALT, чтобы занять его!");
        HospitalInfo[ idx_bed ][ hPlayerID ] = INVALID_PLAYER_ID;
        pTemp[playerid][tHospitalBed] = -1; 
    }
    return 1;
}
hospital_OnPlayerDeath(playerid, reason) {
	if (!pInfo[playerid][pLogin]) return 1; 
	//SettingSpawn(playerid); 
	pTemp[playerid][tDeathReason] = reason; 
	if (pInfo[playerid][pMember] == FRACTION_ARMY_SF && pTemp[playerid][tDutyWork]) {
		pInfo[playerid][pHospital] = 4;
		SetPlayerHealth(playerid, 50 + random(7));
		return 1;
	}
	else if (pInfo[playerid][pMember] == FRACTION_ARMY_LV && pTemp[playerid][tDutyWork]) {
		pInfo[playerid][pHospital] = 5;
		SetPlayerHealth(playerid, 50 + random(7));
		return 1;
	}
	else {///* 255 Error, 1 SF, 2 LS, 3 LV */
	    pInfo[playerid][pHospital] = GetPlayerPosPlace(playerid);
		printf("hospital_OnPlayerDeath: place: %d, ", GetPlayerPosPlace(playerid));
	}
	SetPlayerHealth(playerid, 20 + random(7));
	return 0;
} 
hospital_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) 
{
    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
		return false;
    if (newkeys & 1024 && !(oldkeys & 1024)) 
    {
        for(new i = 0; i < sizeof(HospitalInfo); i++)
        { 
            if (IsPlayerInRangeOfPoint(playerid, 0.5, HospitalInfo[i][hText][0], HospitalInfo[i][hText][1], HospitalInfo[i][hText][2]) && pTemp[playerid][tHospitalBed] == -1)
            {   
                if (HospitalInfo[i][hPlayerID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, !"Данная койка уже занята!");
                if (GetPlayerHP(playerid) >= 100.0) return SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Вы абсолютно здоровы!"); 
                SetPlayerPosAC(playerid, HospitalInfo[i][hPlayer][0], HospitalInfo[i][hPlayer][1], HospitalInfo[i][hPlayer][2] );
                SetPlayerFacingAngle(playerid, HospitalInfo[i][hPlayer][3]);
                TogglePlayerControllable(playerid, false); 
                ApplyAnimation(playerid,"CRACK","Crckidle2",4.1,1,0,0,0,0,0);
                TextDrawShowForPlayer(playerid, InfoAnimDraw);
			    SetPVarInt(playerid, #PlayerAnimation , 1);  
                HospitalInfo[i][hPlayerID] = playerid;
                pTemp[playerid][tHospitalBed] = i; 
                SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Вы заняли койку. Что бы освободить её, используйте "colserver"\"Enter\""); 
                SetPlayerCameraPos(playerid, HospitalInfo[i][hPlayer][0], HospitalInfo[i][hPlayer][1], HospitalInfo[i][hPlayer][2]+1.5); 
                InterpolateCameraLookAt(playerid, 
                    HospitalInfo[i][hPlayer][0], HospitalInfo[i][hPlayer][1], HospitalInfo[i][hPlayer][2], 
                    HospitalInfo[i][hText][0], HospitalInfo[i][hText][1], HospitalInfo[i][hText][2], 
                    5000, CAMERA_MOVE 
                );

                pInfo[playerid][pHospital] = true;
                break; 
            }
        }
    }
    return false;
} 
GetReasonDeath(playerid) {
    new 
        str_[36];
    switch(pTemp[playerid][tDeathReason]) {
        case 0: str_ =  "избиение"; // Кулак
        case 1 .. 3, 5: str_ =  "избиение тупым предметом"; // Тупое оружие
        case 4,8: str_ =  "ножевые ранения";// Острое оружие
        case 22 .. 34: str_ =  "пулевые отверстия"; // Застрелен
        case 49: str_ =  "многочисленные переломы"; //Сбила машина
        case 51: str_ =  "сильные ожоги";// Взрыв
        case 54: str_ =  "многочисленные переломы"; // Упал с высоты
        case 255: {
            str_ =  "отравление"; //Самоубийство (когда убийцы нет)
        }
        default: str_ =  "отравление"; //Самоубийство (когда убийцы нет
    }
    return str_;
} 
/*CMD:healaddict(playerid, params[])
{
	if (!((pInfo[playerid][pMember] == 4 || pInfo[playerid][pMember] == 22 || pInfo[playerid][pMember] == 23) && pTemp[playerid][tDutyWork]))
		return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна данная команда или Вы не начали рабочий день!");
	if (sscanf(params, "ud", params[0], params[1]))  return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /healaddict [id/name] [цена]");
    if (params[1] < 2500 || params[1] > 10000) return SendClientMessage(playerid, COLOR_GREY, !"Цена должна быть от 2500$ до 10000$");
    if (!IsPlayerConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не найден"); 
    if (kLibGetPlayerMoney(params[0]) < params[1]) return SendClientMessage(playerid, COLOR_GREY, !"У игрока нет столько денег!");

    if(
        IsPlayerInRangeOfPoint(playerid, 100.0,835.0920,1348.3275,1071.479) &&  GetPlayerInterior(playerid) == 7 ||
        IsPlayerInRangeOfPoint(playerid, 100.0,-2601.2571,603.7801,1338.9753) &&  GetPlayerInterior(playerid) == HOSPITAL_SF_INT ||
        IsPlayerInRangeOfPoint(playerid, 100.0,1672.6567,1781.9744,1098.1624) &&  GetPlayerInterior(playerid) == HOSPITAL_LV_INT
    )
    {
        new
		    string_[128]; 
        if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!"); 
        if (!IsPlayerInRangeOfPlayer(7.0, playerid, params[0]) 
            || GetPlayerVirtualWorld(params[0]) != GetPlayerVirtualWorld(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, !"Человек далеко от вас!");
        if (seans[params[0]] == true) return SendClientMessage(playerid,COLOR_GREEN, !"Следующий сеанс можно провести через час");
        if (pInfo[params[0]][pAddiction] < 1000) return SendClientMessage(playerid,COLOR_GREEN, !"У пациента меньше чем 1000 зависимости");
        format(string_, sizeof string_,"Вы предложили вылечиться %s за "collime"$%d",pInfo[params[0]][pName], params[1]);
		SendClientMessage(playerid, COLOR_GREEN, string_);

		format(t_string, sizeof t_string, ""colwhi"Сотрудник Больницы "colmaline"%s"colwhi" хочет вылечить вас за "collime"$%d\n\nВы согласны принять предложение?", pInfo[playerid][pName], params[1]);
		ShowPlayerDialog(params[0], D_MEDIC_HEAL_NARCO, DIALOG_STYLE_MSGBOX, ""colserver"Предложение: "colwhi"Лечение", t_string, "Да", "Нет"), t_string[0] = EOS;

        pInfo[params[0]][pAddiction] -= 500;
        kLibGivePlayerMoney(params[0], -params[1], "/healaddict");
        if(GetPlayerDrunkLevel(params[0]) > 0) SetPlayerDrunkLevel(params[0], 0);
        new
            Float: c_Seans = (pInfo[params[0]][pAddiction] / 500) > 0 ? pInfo[params[0]][pAddiction] / 500 + 1: pInfo[params[0]][pAddiction] / 500;
        SendMes(params[0], COLOR_GREEN, "Доктор %s провёл с вами сеанс от наркозависимости",pInfo[playerid][pName]);
        SendMes(playerid, COLOR_GREEN, "Вы провели сеанс от наркозависимости с %s. Необходимо провести %d сеансов с этим человеком, до полного выздоровления!",pInfo[params[0]][pName], floatround(c_Seans, floatround_floor));
        seans[params[0]] = true;
        pInfo[params[0]][pNarcoLomka] = 2;
    }
    else  SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться в больнице!");
	return 1;
}*/
CMD:aheal(playerid, params[]) {
	if (!pTemp[playerid][tArmyHospitalJob]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не работаете в мед. блоке"); 
	if (sscanf(params,"u", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /aheal [id]");
	if (params[0] == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не найден");
	if (!IsPlayerConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не найден");
	if (!IsPlayerInRangeOfPlayer(4.0, playerid, params[0]) || GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Вы далеко друг от друга!");
	SendMes(params[0], COLOR_GREY, "Мед. работник %s[%d], оказал Вам первую помощь", pInfo[playerid][pName], playerid); 
	SetPlayerHealth(params[0], 100.0);
	pInfo[params[0]][pHospital] = 0;  
	MeAction(playerid, "оказал(а) первую помощь", SELECT_ACTION_IN_BUBBLE); 
	return 1;
}


CMD:heal(playerid, params[])
{ 
    if (!((pInfo[playerid][pMember] == 4 || pInfo[playerid][pMember] == 22 || pInfo[playerid][pMember] == 23) && pTemp[playerid][tDutyWork]))
		return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна данная команда или Вы не начали рабочий день!");
	if (sscanf(params, "ud", params[0], params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /heal [id] [цена]"); 
    if (params[0] == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не найден");
	if (!IsPlayerConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не найден");
    if (pTemp[params[0]][tHospitalBed] != -1) return SendClientMessage(playerid, COLOR_GREY, !"Игрок проходит бесплатное лечение");
	if (params[1] < 50 || params[1] > 250) return SendClientMessage(playerid, COLOR_GREY, !"Цена должна быть от $50 до $250");  
	if (pInfo[params[0]][pNarcoLomka] == 1)
	{
        new string_[256];
		pInfo[params[0]][pNarcoLomka] = 0;
		SavePlayerInteger(params[0], "pNarcoLomka", pInfo[params[0]][pNarcoLomka]);
		SetPlayerWeather(params[0], 10);
		format(string_, sizeof string_, "Вы спасли %s от ломки",pInfo[params[0]][pName]);
		SendClientMessage(playerid, COLOR_GREEN, string_);
		format(string_, sizeof string_, "Доктор %s спас вас от ломки",pInfo[playerid][pName]);
		SendClientMessage(params[0], COLOR_GREEN, string_);
		pTemp[params[0]][StartAddiction] = false;
        //pTemp[params[0]][tTimeAddiction] = ( gettime()+10800 )?;
        pTemp[params[0]][tTimeAddiction] = (gettime()+10800);
        pInfo[params[0]][pAddiction] -= 500;
		ApplyAnimation(params[0], "CARRY", "crry_prtial",4.0,0,0,0,0,0,1);
		return 1;
	}
    new string_[256];
	if (GetPlayerHP(params[0]) >= 100) return SendClientMessage(playerid, COLOR_GREY, !"Человек здоров!"); 
	format(string_, sizeof string_,"Вы предложили вылечиться %s за "collime"$%d",pInfo[params[0]][pName], params[1]);
	SendClientMessage(playerid, COLOR_GREEN, string_);
	format(t_string, sizeof t_string, ""colwhi"Сотрудник Больницы "colmaline"%s"colwhi" хочет вылечить вас за "collime"$%d\n\nВы согласны принять предложение?", pInfo[playerid][pName], params[1]);
	ShowPlayerDialog(params[0], 9998, DIALOG_STYLE_MSGBOX, ""colserver"Предложение: "colwhi"Лечение", t_string, "Да", "Нет"), t_string[0] = EOS;
    pInfo[playerid][pCash] += params[1];
    SendClientMessage(playerid, -1, "Вы вылечили пациента. Деньги за лечение начислятся авансом.!");
	HealOffer[params[0]] = playerid;
	HealPrice[params[0]] = params[1];
	return 1;
} 

CMD:checkheal(playerid, params[])
{
	if (!IsAMedic(playerid) && pTemp[playerid][tDutyWork])
		return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна данная команда или Вы не начали рабочий день!");
	if (sscanf(params,"u", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /checkheal [id игрока]");
    if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден/Вы указали свой ID!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом друг с другом"); 

    cache_get_value_name_int(0, "pAddiction", pInfo[playerid][pAddiction]);

    if (params[1] <= pInfo[params[0]][pAddiction])
	{
	    new string_[128];
	    format(string_, sizeof string_, "У игрока %d наркозависимости.",pInfo[params[0]][pAddiction]);
	    return scm(playerid, COLOR_GREY, string_);
	}
	return 1;
}

CMD:setmemleader(playerid, params[])
{
    if (pInfo[playerid][pAdmin] < 5 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "u",params[0])) {
		SendClientMessage(playerid, COLOR_WHITE, !"Введите: /setleader [playerid]");
		return 1;
	}
    if (!IsPlayerConnected(params[0])) return 1;
	if (IsPlayerInAnyVehicle(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не должен находиться в транспорте!");
	if (pInfo[params[0]][pLeader] > 0)
	{
		SaveFractionString(pInfo[params[0]][pLeader], "fLeader", "None");
		strmid(fInfo[pInfo[params[0]][pLeader]][fLeader],"None",0,strlen("None"),MAX_PLAYER_NAME);
	    if (pInfo[params[0]][pLeader] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не находиться в организации!");
	    uninvite_player(params[0]);
		SendMes(params[0], COLOR_WHITE, "Администратор "colserver"%s "colwhi"снял с вас контроль организации", pInfo[playerid][pName]);
		if (pTemp[params[0]][tDutyWork] == 1) SendClientMessage(params[0], 0x6BB3FFAA, !"Рабочий день окончен");
		SendMes(playerid, COLOR_WHITE, "Вы сняли с "colserver"%s "colwhi"контроль организации.", pInfo[params[0]][pName]);

		if (IsANews(params[0]))
		{
			new
				query[ 78 ]; 
			mysql_format(dbHandle, query, sizeof query, "UPDATE s_users SET edited_ads = '0' WHERE Name = '%e'", pInfo[params[0]][pName]);
			mysql_tquery(dbHandle, query);
		}
	}
	else
	{
   		if (pInfo[params[0]][pLeader] > 0) return SendClientMessage(playerid, COLOR_GREY, !"Игрок лидер другой организации!");
		if (pInfo[params[0]][pMember] > 0) return SendClientMessage(playerid, COLOR_GREY, !"Игрок находиться в другой организации!");
		
	 	new str_[128], string_[64];
	 	t_string[0] = EOS ;
	 	strcat(t_string, ""colserver"[№] Организация\t"colserver"Лидер\t"colserver"Заместитель\n");
	 	for(new i = 1; i <= TOTAL_FRACTION; i++)
		{
			format(str_, sizeof str_,""colwhi"[%d] %s\t%s\t%s\n", i, fInfo[i][fName], fInfo[i][fLeader], fInfo[i][fAssistant]);
			strcat(t_string, str_);
		}
		SetPVarInt(playerid, #SelectLeaderID, params[0]);
		format(string_, sizeof string_, ""colserver"Назначить лидера организации: "colwhi"%s", pInfo[params[0]][pName]);
		ShowPlayerDialog(playerid, D_FRACTION_FUNC_0, DIALOG_STYLE_TABLIST_HEADERS, string_, t_string, "Выбрать", "Закрыть");
	}
	return 1;
}
/*
//amount
GetNearstFractionVehicle(playerid, fractionid) { 
    new isReturn = false;
    foreach(new V_IDX:StreamedVehicles[playerid])
    { 
        new Float:pl_pos_x,
			Float:pl_pos_y,
			Float:pl_pos_z;
		GetPlayerPos( playerid, pl_pos_x, pl_pos_y, pl_pos_z );
        if (IsVehicleInRangeOfPoint(V_IDX, 7.0, pl_pos_x, pl_pos_y, pl_pos_z) ) { }
        else continue ;
        if (VehicleInfo[V_IDX -1 ][vType] != VEHICLE_TYPE_FRACTION || VehicleInfo[V_IDX -1 ][vFraction] != fractionid) continue ; 
        isReturn = true;
        break;
    }
    return isReturn;

}*/
/*stock IsAnAmbulance(vehicleid)
{
	if (vehicleid == INVALID_VEHICLE_ID) return 0;
	else if (VehicleInfo[ vehicleid - 1 ][vType] == VEHICLE_TYPE_FRACTION &&
		( VehicleInfo[ vehicleid - 1 ][vFraction] == 4)) return 1;
	return 0;
}
stock GetPlayerDriverVehicleModel(playerid, fractionid, model) { 
    new isReturn = 0;
    new
        V_IDX = GetPlayerVehicleID(playerid)
    foreach(new V_IDX:StreamedVehicles[playerid])
    { 
        new Float:pl_pos_x,
			Float:pl_pos_y,
			Float:pl_pos_z;
		GetPlayerPos( playerid, pl_pos_x, pl_pos_y, pl_pos_z );
        if (IsVehicleInRangeOfPoint(V_IDX, 7.0, pl_pos_x, pl_pos_y, pl_pos_z) ) { }
        else continue ;
        if (VehicleInfo[V_IDX -1 ][vType] != VEHICLE_TYPE_FRACTION || VehicleInfo[V_IDX -1 ][vFraction] != fractionid || VehicleInfo[V_IDX -1 ][vModel] != model) continue ; 
        isReturn = V_IDX;
        break;
    }
    return isReturn;

}*/
stock GetNearstVehicleReturnID(playerid, fractionid, model) { 
    new isReturn = INVALID_VEHICLE_ID;
    foreach(new V_IDX:StreamedVehicles[playerid])
    { 
        new Float:pl_pos_x,
			Float:pl_pos_y,
			Float:pl_pos_z;
		GetPlayerPos( playerid, pl_pos_x, pl_pos_y, pl_pos_z );
        if (IsVehicleInRangeOfPoint(V_IDX, 7.0, pl_pos_x, pl_pos_y, pl_pos_z) ) { }
        else continue ;
        if (VehicleInfo[V_IDX -1 ][vType] != VEHICLE_TYPE_FRACTION || VehicleInfo[V_IDX -1 ][vFraction] != fractionid) continue ; 
        if (VehicleInfo[V_IDX -1 ][vModel] == model) {
            isReturn = V_IDX;
            break;
        }
        return isReturn = INVALID_VEHICLE_ID;
        
    }
    return isReturn;

}
CMD:empty(playerid) {
    if(!IsABiker(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна данная команда");
    if (GetNearstVehicleReturnID(playerid, FRACTION_ARMY_LV, 433) == INVALID_VEHICLE_ID) {
        SendClientMessage(playerid, COLOR_GREY, !"Рядом с Вами нет военного фургона");
        return 1;
    }
    new
        V_IDX = GetNearstVehicleReturnID(playerid, FRACTION_ARMY_LV, 433);
    //if (GetPlayerState(playerid))
    if (!gVehicleGun[V_IDX][vGunAmmo]) return SendClientMessage(playerid, COLOR_GREY, "Фургон пуст");
    if(VehicleInfo[ V_IDX - 1 ][vJobLoad] == true) return SendClientMessage(playerid, COLOR_GREY, "Фургон уже на разгрузке");
    new Float:angle,Float:distance,Float:vehx, Float:vehy, Float:vehz;
    GetVehicleModelInfo(VehicleInfo[ V_IDX - 1 ][vModel], 1, vehx, distance, vehz);
    distance = distance/2 + 0.3;
    GetVehiclePos(V_IDX, vehx, vehy, vehz); 
    GetVehicleZAngle(V_IDX, angle);
    vehx += (distance * floatsin(-angle+180, degrees));
    vehy += (distance * floatcos(-angle+180, degrees));
    VehicleInfo[ V_IDX - 1 ][vJobMaterials] = gVehicleGun[V_IDX][vGunAmmo];
    new 
        string_[128];  
    format(string_, sizeof string_, ""colwhi"Материалы: "colmaline"%d", 
        VehicleInfo[ V_IDX - 1 ][vJobMaterials]
    );
    if (VehicleInfo[ V_IDX - 1 ][vFarmText] == Text3D:-1) { 
        VehicleInfo[ V_IDX - 1 ][vFarmText] = CreateDynamic3DTextLabel(string_, COLOR_WHITE, vehx, vehy, vehz+0.5, 15.0);
    }  
    VehicleInfo[ V_IDX - 1 ][vJobPickup] = CreateDynamicPickup(2358,1, vehx, vehy, vehz-0.5);


    VehicleInfo[ V_IDX - 1 ][vJobArea] = CreateDynamicSphere(vehx, vehy, vehz, 1.0, 0, INTERIOR_NONE);
    SetDynamicAreaType(VehicleInfo[ V_IDX - 1 ][vJobArea], AREA_TYPE_EMPTY_BIKERS, V_IDX); 

    VehicleInfo[ V_IDX - 1 ][vJobLoad] = true;
    return 1;
}
CMD:bunload(playerid) {
	if (!IsABiker(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вам не доступна данная команда");
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, !"Вы не за рулем фургона");
    new
        V_IDX = GetPlayerVehicleID(playerid);
    if (VehicleInfo[ V_IDX - 1][vType] == VEHICLE_TYPE_FRACTION && VehicleInfo[ V_IDX - 1][vFraction] == pInfo[playerid][pMember] && VehicleInfo[ V_IDX - 1][vModel] == 459) {
        if (VehicleInfo[ V_IDX - 1 ][vJobMaterials] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Фургон пуст");
        if (pInfo[playerid][pMember] == FRACTION_MONGOLS_MC) {
            SetPlayerCheckpoint(playerid, 681.4519, -441.9955, 16.3359, 10.0);
            SendClientMessage(playerid, COLOR_WHITE, !"Доставьте фургон с материалами на склад с оружием.");
            MatsArmyCar[playerid] = 60; 
        }
        else if (pInfo[playerid][pMember] == FRACTION_BANDIDOS_MC) {
            SetPlayerCheckpoint(playerid, -1271.8679, 2731.6252, 50.0625, 10.0);
            SendClientMessage(playerid, COLOR_WHITE, !"Доставьте фургон с материалами на склад с оружием.");
            MatsArmyCar[playerid] = 61;
        }
        else if (pInfo[playerid][pMember] == FRACTION_OUTLAWS_MC) {
            SetPlayerCheckpoint(playerid, -318.4073, 1761.9882, 42.7654, 10.0);
            SendClientMessage(playerid, COLOR_WHITE, !"Доставьте фургон с материалами на склад с оружием.");
            MatsArmyCar[playerid] = 62;
        }
    }
	return 1;
}
CMD:bput(playerid) {
    if (!IsABiker(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна данная команда");
    if (!pTemp[playerid][tTakeEmptyBikers]) return SendClientMessage(playerid, COLOR_GREY, !"У Вас нет в руках ящика");
    new
        fraction_id = pInfo[playerid][pMember];
    if (GetNearstVehicleReturnID(playerid, fraction_id, 459) == INVALID_VEHICLE_ID) {
        SendClientMessage(playerid, COLOR_GREY, !"Рядом с Вами нет фургона");
        return 1;
    }
    new
        V_IDX = GetNearstVehicleReturnID(playerid, fraction_id, 459);
    if (VehicleInfo[ V_IDX - 1 ][vJobMaterials] + 700 > 5_000) {
        SendClientMessage(playerid, COLOR_GREY, !"Фургон полон");
        return 1;
    }
    if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACHED_SLOT_JOB_1)) RemovePlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1);
    
    VehicleInfo[ V_IDX - 1 ][vJobMaterials] += 700;
    pTemp[playerid][tTakeEmptyBikers] = 0;
    new 
        string_[128];
    format(string_, sizeof string_, "Вы положили ящик | Состояние фургона: %d/5000", VehicleInfo[ V_IDX - 1 ][vJobMaterials]);
    SendClientMessage(playerid, COLOR_GREEN, string_);
    return 1;
}
