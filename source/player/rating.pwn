enum E_PLAYER_RATING { 
    rRating,
    rLevel,
    rCash,
    rDonateAll, 
    rBank,
    rDeposit, 
    rGovHouse,
    rRank,
    rQuestAll,//--
    rRewardAll,//--
    rVIP,
    rSupport,
    rWarn,
    rMail,
    rVKGuard,
    rTelegram,
    rTaxiSkill,//--pInfo[playerid][pTaxiLevel]
    rTruckerSkill,//--pInfo[playerid][pDLevel]
    rDeliverySkill,//--
    rTheftCar,//--
    rReferal,
    rSkin//--
}
stock Float: GetPlayerRatingBusinesses(idx) {
    new 
        Float: return_value = 0.00; 
    new Float: amount = (BusinessInfo[idx][bBuyPrice]*0.00001); 
    return_value = amount; 
    return return_value;
}
stock Float:GetPlayerRatingCountBusinesses(playerid) {
    new 
        Float: return_value = 0.00; 
    if (!GetPlayerBusinesses(playerid)) {
        return_value = 0.00;
    } else { 
        new 
            Float: countVehicleRating = 0.00;
        for (new i = 0; i < MAX_PLAYER_BUSINESS; i++) {
            if (!pInfo[playerid][pBusinessID][i]) continue;
            new id = pInfo[playerid][pBusinessID][i] - 1; 
            countVehicleRating += GetPlayerRatingBusinesses(id);
        } 
        return_value = countVehicleRating;
    } 
    return return_value;
}
stock Float: GetPlayerRatingVehicle(model) {
    new 
        Float: return_value = 0.00; 
    new Float: amount = (GetModelGovPrice(model)*0.000005); 
    return_value = amount;
    return return_value;
}
stock Float:GetPlayerRatingCountVehicle(playerid) {
    new 
        Float: return_value = 0.00; 
    if (Iter_Count(PlayerListVehicle[playerid]) == 0) {
        return_value = 0.00;
    } else {
        new 
            Float: countVehicleRating = 0.00;
        foreach(new veh_id:PlayerListVehicle[playerid]) { 
            countVehicleRating += GetPlayerRatingVehicle(VehicleInfo[ veh_id - 1 ][vModel]);
        }
        return_value = countVehicleRating;
    }
    return return_value;
}
stock Float:GetPlayerRating(E_PLAYER_RATING:type, current/*, playerid = INVALID_PLAYER_ID*/) {
    new 
        Float: return_value = 0.00;
    switch(type) { 
        case rLevel, rRank: {
            if (!current) {
                return_value = 0.00;
            } else return_value = floatround(current);
        }
        case rTaxiSkill, rTruckerSkill: {
            if (!current) {
                return_value = 0.00;
            } else return_value = floatround(current*2);
        }
        case rCash, rBank, rDeposit: { 
            new Float: amount = (current*0.000002); 
            return_value = amount; 
        }
        case rDonateAll: {
            if (!current) {
                return_value = 0.00;
            } else return_value = floatround(current);
        }
        case rGovHouse: {
            if (current == -1) {
                return_value = 0.00;
            } else {
                if (HouseInfo[current][hValue] < 1_000_000) return_value = 0.0;
                else {
                    new amount = (HouseInfo[current][hValue]/1000_000); 
                    return_value = float(amount*5);
                } 
            }
        } 
        case rVIP: {
            if (!current) {
                return_value = 0.00;
            } else {
                new
                    Float: countRating[] = {10.00, 20.00, 40.00, 60.00, 80.00};
                return_value = countRating[ current - 1 ];
            }
        }
        case rSupport: {
            if (!current) {
                return_value = 0.00;
            } else {
                return_value = 100.00;
            }
        }
        case rWarn: {
            if (!current) {
                return_value = 0.00;
            } else {
                return_value = float(-20*current);
            }
        }
        case rMail, rVKGuard, rTelegram: {
            if (!current) {
                return_value = 0.00;
            } else {
                return_value = 10.00;
            }
        }
    }
    return return_value;
}
stock GivePlayerRating(playerid, float:rating) {
    pInfo[playerid][pRating] += rating;
    if (pInfo[playerid][pRating] < 0) pInfo[playerid][pRating] = 0;

}
stock GetPlayerDonateCount(playerid)
{
	new donate_count = 0,
		query_[78]; 
	format(query_, sizeof query_,"SELECT u_donate_all FROM s_users WHERE pID = '%d'", pInfo[playerid][pID]);
	new Cache: result = mysql_query(dbHandle, query_);
	cache_get_value_name_int(0, "u_donate_all", donate_count);
	if (cache_is_valid(result)) cache_delete(result);
	return donate_count;
} 
 /*
CMD:testrating(playerid) {
    ShowRating(playerid, playerid);
    return 1;
}*/

stock ShowRating(playerid, targetid) {
    SetPlayerUpdateRating(playerid);
    new
        string_[148];
    t_string[0] = EOS;
    strcat(t_string, ""colserver"Наименование\t"colserver"Начислено\t"colserver"Опционная выдача\n"); 
    format(string_, sizeof string_, ""colwhi"Уровень:\t%.2f\t1.00\n", GetPlayerRating(rLevel, pInfo[targetid][pLevel]) );
	strcat(t_string, string_);
    format(string_, sizeof string_, "Наличные:\t%.2f\t2.00\nДонат копилка:\t%.2f\t1.00\n", 
        GetPlayerRating(rCash, pInfo[targetid][pCash]), GetPlayerRating(rDonateAll, GetPlayerDonateCount(targetid))
    );
	strcat(t_string, string_); 
    format(string_, sizeof string_, "Деньги в банке:\t%.2f\t2.00\nДепозит:\t%.2f\t2.00\n", GetPlayerRating(rBank, pInfo[targetid][pBank]), GetPlayerRating(rDeposit, pInfo[targetid][pDeposit]));
	strcat(t_string, string_); 
    format(string_, sizeof string_, "Гос. стоимость дома:\t%.2f\t5.00\nРанг во фракции:\t%.2f\t1.00\n", GetPlayerRating(rGovHouse, pInfo[targetid][pHouseID]), GetPlayerRating(rRank, pInfo[targetid][pRank]));
	strcat(t_string, string_); 
    format(string_, sizeof string_, "V.I.P:\t%.2f\t10.00 / 20.00 / 40.00 / 60.00 / 80.00\n", GetPlayerRating(rVIP, pInfo[targetid][VIPRank]));
	strcat(t_string, string_); 
    format(string_, sizeof string_, "Полномочия помощника(Support):\t%.2f\t100.00\n", GetPlayerRating(rSupport, GetPlayerSupportSearch(targetid)));
	strcat(t_string, string_); 
    format(string_, sizeof string_, "Выговор(Warn):\t%.2f\t-20.00\n", GetPlayerRating(rWarn, pInfo[targetid][pWarns]));
	strcat(t_string, string_); 
    format(string_, sizeof string_, "Подключенный E-Mail:\t%.2f\t10.00\nПодключенный VK Guard:\t%.2f\t10.00\n", GetPlayerRating(rMail, pInfo[targetid][MailConfirm]), GetPlayerRating(rVKGuard, pInfo[targetid][pConfirmVK]));
	strcat(t_string, string_); 
    format(string_, sizeof string_, "Подключенный Telegram Guard:\t%.2f\t10.00\n", GetPlayerRating(rTelegram, pInfo[targetid][pConfirmTG]));
	strcat(t_string, string_); 
    format(string_, sizeof string_, "Уровень таксиста:\t%.2f\t2.00\n", GetPlayerRating(rTaxiSkill, pInfo[targetid][pTaxiLevel]));
	strcat(t_string, string_); 
    format(string_, sizeof string_, "Уровень дальнобойщика:\t%.2f\t2.00\n", GetPlayerRating(rTruckerSkill, pInfo[targetid][pDLevel]));
	strcat(t_string, string_); 
    strcat(t_string, ""colserver"Одежда\n"colwhi""); 
    format(string_, sizeof string_, ""colwhi"Одежда: %d "collime"[Текущая]\t6.00\n", GetPlayerCountClothes(pInfo[playerid][pChar])); 
	strcat(t_string, string_); 
    strcat(t_string, ""colserver"Личный транспорт\n"colwhi"");  

    if (Iter_Count(PlayerListVehicle[targetid]) == 0) {
        strcat(t_string, "Нет транспорта\n");
    } else {
        foreach(new veh_id:PlayerListVehicle[targetid]) {
            format(string_, sizeof string_, "%s(%d)\t%.2f\t5.00\n", VehicleNames[ VehicleInfo[ veh_id - 1 ][vModel] - 400 ], VehicleInfo[ veh_id - 1 ][vModel], GetPlayerRatingVehicle(VehicleInfo[ veh_id - 1 ][vModel]));
            strcat(t_string, string_);
        }
    }
    strcat(t_string, ""colserver"Бизнесы\n"colwhi"");
    if (!GetPlayerBusinesses(targetid)) {
        strcat(t_string, "Нет бизнесов\n");
    } else { 
        for (new i = 0; i < MAX_PLAYER_BUSINESS; i++) {
            if (!pInfo[targetid][pBusinessID][i]) continue;
            new id = pInfo[targetid][pBusinessID][i] - 1; 
            format(string_, sizeof string_, "%s(%s)\t%.2f\t10.00\n", GetBussinessTypeName(id), BusinessInfo[id][bName], GetPlayerRatingBusinesses(id));
            strcat(t_string, string_); 
        } 
    }
    new
        strTitle[90]; 
    format(strTitle, sizeof strTitle, ""colserver"Рейтинг: "colwhi"%.2f "colserver"| %s", pInfo[targetid][pRating], pInfo[targetid][pName]);
    ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_TABLIST_HEADERS, strTitle, t_string, "Закрыть", "");
}

stock SetPlayerUpdateRating(playerid, bool: save = true) {
    new 
        Float: r_Support = 0.00;
    if (SupportInfo[playerid][sDuty]) {
        r_Support = GetPlayerRating(rSupport, 1);
    } else {
        r_Support = GetPlayerRating(rSupport, GetPlayerSupportSearch(playerid));
    }
    new 
        Float: r_Level = GetPlayerRating(rLevel, pInfo[playerid][pLevel]),
        Float: r_Cash = GetPlayerRating(rCash, pInfo[playerid][pCash]),
        Float: r_DonateAll = GetPlayerRating(rDonateAll, GetPlayerDonateCount(playerid)),
        Float: r_Bank = GetPlayerRating(rBank, pInfo[playerid][pBank]),
        Float: r_Deposit = GetPlayerRating(rDeposit, pInfo[playerid][pDeposit]),
        Float: r_GovHouse = GetPlayerRating(rGovHouse, pInfo[playerid][pHouseID]),
        Float: r_Rank = GetPlayerRating(rRank, pInfo[playerid][pRank]),
        Float: r_VIP = GetPlayerRating(rVIP, pInfo[playerid][VIPRank]),
        Float: r_Warn = GetPlayerRating(rWarn, pInfo[playerid][pWarns]),
        Float: r_Mail = GetPlayerRating(rMail, pInfo[playerid][MailConfirm]),
        Float: r_VK_Guard = GetPlayerRating(rVKGuard, pInfo[playerid][pConfirmVK]),
        Float: r_TG_Guard = GetPlayerRating(rTelegram, pInfo[playerid][pConfirmTG]),
        Float: r_TaxiLevel = GetPlayerRating(rTaxiSkill, pInfo[playerid][pTaxiLevel]),
        Float: r_TruckerLevel = GetPlayerRating(rTruckerSkill, pInfo[playerid][pDLevel]),
        Float: r_VehicleAll = GetPlayerRatingCountVehicle(playerid),
        Float: r_BusinessesAll = GetPlayerRatingCountBusinesses(playerid)
        
        ; 
    new 
        Float: rCount = (r_Level+r_Cash+r_DonateAll+r_Bank+r_Deposit+r_GovHouse+r_Rank+r_VIP+r_Warn+r_Mail+r_VK_Guard+r_TG_Guard+r_Support+r_TaxiLevel+r_TruckerLevel+r_VehicleAll+r_BusinessesAll);
    pInfo[playerid][pRating] = rCount;
    if (save) {
        new query_[128];
	    format(query_, sizeof query_, "UPDATE `s_users` SET `pRating` = '%f' WHERE `pID` = '%d'", pInfo[playerid][pRating], pInfo[playerid][pID]);
	    mysql_tquery(dbHandle, query_, "", "");  
    }
    
}
stock GetModelGovPrice(model)
{
 	new null;
 	switch(model)
 	{ 
		case 400: null = 130_000;//n 0
		case 567: null = 200_000;
		case 549: null = 120_000;
		case 547: null = 110_000;
		case 546: null = 140_000;
		case 543: null = 100_000;
		case 527: null = 100_000;
		case 526: null = 110_000;
		case 518: null = 170_000;
		case 517: null = 150_000;
		case 516: null = 140_000;
		case 492: null = 140_000;
		case 479: null = 110_000;
		case 478: null = 100_000;
		case 475: null = 190_000;
		case 466: null = 110_000;
		case 458: null = 120_000;
		case 439: null = 150_000;
		case 436: null = 100_000;
		case 404: null = 100_000;
		case 419: null = 800_000;//c 
		case 586: null = 800_000;
		case 581: null = 1_000_000;
		case 461: null = 1_000_000;
		case 418: null = 700_000;
		case 603: null = 750_000;
		case 589: null = 770_000;
		case 580: null = 1_000_000;
		case 579: null = 940_000;
		case 561: null = 910_000;
		case 555: null = 940_000;
		case 554: null = 840_000;
		case 534: null = 760_000;
		case 533: null = 920_000;
		case 505: null = 880_000;
		case 491: null = 800_000;
		case 489: null = 880_000;
		case 445: null = 810_000;
		case 421: null = 830_000;//c 
		case 401: null = 340_000;//d 39
		case 600: null = 420_000;
		case 585: null = 360_000;
		case 576: null = 350_000;
		case 575: null = 460_000;
		case 566: null = 340_000;
		case 551: null = 480_000;
		case 550: null = 480_000;
		case 540: null = 330_000;
		case 536: null = 400_000;
		case 529: null = 440_000;
		case 507: null = 450_000;
		case 474: null = 370_000;
		case 467: null = 390_000;
		case 426: null = 420_000;
		case 422: null = 310_000;
		case 412: null = 390_000;
		case 405: null = 400_000;//d 56 
		case 477: null = 2_200_000;//b 57
		case 471: null = 2_100_000;
		case 468: null = 1_900_000;
		case 463: null = 2_000_000;
		case 521: null = 1_900_000;
		case 602: null = 2_000_000;
		case 587: null = 2_100_000;
		case 565: null = 2_100_000;
		case 562: null = 2_200_000;
		case 560: null = 2_250_000;
		case 559: null = 2_200_000;
		case 558: null = 2_100_000;
		case 545: null = 1_900_000;
		case 535: null = 2_000_000;
		case 480: null = 2_400_000;//b 71 
		case 402: null = 4_800_000;//a 72
		case 503: null = 6_000_000;
		case 502: null = 6_000_000;
		case 494: null = 6_000_000;
		case 495: null = 5_800_000; 
		case 434: null = 4_800_000;
		case 522: null = 4_600_000;
		case 541: null = 6_000_000;
		case 506: null = 5_100_000;
		case 451: null = 6_000_000;
		case 429: null = 5_400_000;
		case 415: null = 5_600_000;
		case 411: null = 6_000_000;//a 84
		case 454: null = 14_000_000;//Boat 
		case 446: null = 8_000_000; 
		case 484, 508: null = 12_000_000; 
		case 493: null = 10_000_000;// END BOAT
		case 513: null = 5_000_000; //Plane
		case 519: null = 30_000_000; 
		case 553: null = 25_000_000;
		case 511: null = 20_000_000; 
		case 487: null = 14_000_000; 
		case 469: null = 10_000_000; // END PLANE  
		default: null = floatround( 1.5 * 30000 );
 	}
 	return null;
}