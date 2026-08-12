#if defined _poffer_inc
	#endinput
#endif
#define _poffer_inc

new const time_clear_offer = 60*2*1000; // 30 сек
static const Float: RaceCheckpoint[][] = {
	{1484.4127, -1730.3090, 13.1099}, // Мэрия ЛС
	{1357.9187, -1282.1560, 13.0383},// Аммо ЛС
	{-2007.2410, 150.4385, 27.2661},// ЖД СФ
	{-2047.7600, -72.1597, 34.8936},//Автошкола
	{1798.5967, 846.7783, 10.3818}, // ЛВ
	{2048.0439, 1007.2633, 10.3990} // Казино 4 Дракона 
};
new RaceMapName[][] = {"Мэрия ЛС", "Аммо ЛС", "ЖД Сан-Фиерро", "Автошкола", "Лас-Вентурас", "Казино 4 Дракона"}; 

enum {
	//YN_TYPE_NONE = 0, // Нет предложений
	YN_TYPE_REFILL = 0, // заправка refill
	YN_TYPE_REPAIR, // починка авто repair
	YN_TYPE_DEBT, // крыша мафии
	YN_TYPE_CONTRACT, // прораб
	YN_TYPE_GUN, // оружие
	YN_TYPE_DRUGS,
	YN_TYPE_CAR, // авто личное
	YN_TYPE_HOUSE, // дом
	YN_TYPE_ZONE, // территория гетто
	YN_TYPE_WEDDING, // свадьба
	YN_TYPE_SKILL, // showkill
	YN_TYPE_TICKET, // штрафы
	YN_TYPE_APARTMENT, // подселится в дом
	YN_TYPE_BUSSINES, // обменятся бизнесами
	YN_TYPE_MEDICAL_CARD, // посмотреть мед. карту
	YN_TYPE_DICE, // Казино /dice
	YN_TYPE_RACE, //Гонка между игроками
	YN_TYPE_KISS, // Поцелуй
	YN_TYPE_SIM,
	YN_TYPE_POOL, // /pool
	YN_TYPE_GIFT,
	YN_TYPE_HEALADDICT,
	YN_TYPE_RATING, 

	YN_TYPE_LAST //
}

enum OFFER_TYPE_E
{
	TargetOfferID,
	TargetPrice,
	TargetParams[3],
	TargetTimer
}

new PlayerOffer[MAX_PLAYERS][YN_TYPE_LAST][OFFER_TYPE_E];

static const defaultPlayerOffer[OFFER_TYPE_E] =
{
	INVALID_PLAYER_ID,//TargetOfferID,
	0,//TargetPrice
	{0, 0, 0},//TargetParams[3],
	0//TargetTimer
};


poffer_OnPlayerConnect(playerid) { 
    for(new t_clear; t_clear < YN_TYPE_LAST; t_clear++) {
		PlayerOffer[playerid][t_clear] = defaultPlayerOffer;
	}
}

poffer_OnPlayerDisconnect(playerid) {
	if (pTemp[playerid][tRaceID] != INVALID_VEHICLE_ID) {
		srace_end(playerid,1);
	}
	for(new x; x < YN_TYPE_LAST; x ++)
	{
		PresedKeyYN(playerid, x, 0);
	}
}

CMD:testo(playerid)
{
	if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	for(new t_clear; t_clear < YN_TYPE_LAST; t_clear++)
	{
		PlayerOffer[playerid] [t_clear]  [TargetOfferID] = playerid;
	}
	ShowSelectStatusYN(playerid,1);
	for(new t_clear; t_clear < YN_TYPE_LAST; t_clear++)
	{
		PlayerOffer[playerid][t_clear] = defaultPlayerOffer;
	}
	return 1;
}

stock ShowSelectStatusYN(playerid,type)
{
	pTemp[playerid][status_offer_type] = 0;
	new
		temp_str[64], 
		idx;
	t_string[0] = EOS;
	static const select_offer[YN_TYPE_LAST][46] = {
		"Заправить автомобиль\t\t[key:refill]\n", //YN_TYPE_REFILL = 0, // заправка refill
		"Починить автомобиль\t\t[key:repair]\n", //YN_TYPE_REPAIR, // починка авто repair
		"Сотрудничать с мафией\t\t[key:debt]\n", //YN_TYPE_DEBT, // крыша мафии
		"Договор с прорабом\t\t[key:contract]\n",//YN_TYPE_CONTRACT, // прораб
		"Купить оружие\t\t\t[key:sellgun]\n",//YN_TYPE_GUN, // оружие
		"Купить наркотики\t\t\t[key:selldrugs]\n",//YN_TYPE_DRUGS,
		"Обменятся автомобилем\t\t[key:changecar]\n",//YN_TYPE_CAR, // авто личное
		"Обменятся домом\t\t\t[key:changehouse]\n", //YN_TYPE_HOUSE, // дом
		"Купить территорию\t\t\t[key:sellzone]\n", // //YN_TYPE_ZONE, // территория гетто
		"Предложение свадьбы\t\t[key:propose]\n", //YN_TYPE_WEDDING, // свадьба
		"Смотреть скиллы\t\t\t[key:myskill]\n", //YN_TYPE_SKILL, // showkill
		"Оплатить штраф\t\t\t[key:ticket]\n", //YN_TYPE_TICKET, // штрафы
		"Подселиться в дом\t\t[key:aparment]\n", //YN_TYPE_APARTMENT, // подселится в дом
		"Обменятся бизнесом\t\t[key:sellbiz]\n", //YN_TYPE_BUSSINES, // обменятся бизнесами
		"Смотреть мед. карту\t\t[key:mcard]\n",//YN_TYPE_MEDICAL_CARD, // посмотреть мед. карту
		"Играть в кости\t\t\t[key:dice]\n",//YN_TYPE_DICE, // Казино /dice
		"Участие в гонке\t\t\t[key:race]\n",//YN_TYPE_RACE
		"Поцеловать\t\t\t\t[key:kiss]\n",//YN_TYPE_KISS
		"Купить SIM-карту\t\t\t[key:sellsim]\n",//YN_TYPE_SIM
		"Играть в бильярд\t\t\t[key:pool]\n",//YN_TYPE_POOL
		"Купить подарки\t\t\t[key:gift]\n",//YN_TYPE_GIFT
		"Сеанс наркозависимости\t[key:healaddict]\n",//YN_TYPE_HEALADDICT
		"Посмотреть рейтинг\t\t[key:hrating]"//YN_TYPE_RATING
	};

	for(new i; i < YN_TYPE_LAST; i++)
	{
		if (PlayerOffer[playerid][i][TargetOfferID] != INVALID_PLAYER_ID)
		{
			if (i == YN_TYPE_DICE && i == YN_TYPE_POOL && PlayerOffer[playerid][i][TargetPrice] == 0) continue;
			idx++;
			//format(temp_str, sizeof temp_str,"[%d] ",idx);
			format(temp_str, sizeof (temp_str), "[%d] ", idx);
			strcat(temp_str, select_offer[i]);
			strcat(t_string, temp_str);
		}
	}

	pTemp[playerid][status_offer_type] = idx;


	if (idx < 1) return 1;
	if (type == 0) ShowPlayerDialog(playerid, D_STATUS_DEAL, DIALOG_STYLE_LIST , ""colserver"Отклонить", t_string, "Выбрать", "Закрыть");
	else ShowPlayerDialog(playerid, D_STATUS_DEAL2, DIALOG_STYLE_LIST , ""colserver"Принять", t_string, "Выбрать", "Закрыть");

	return 1;
}


stock PresedKeyYN(playerid,idx,type)
{
	if (playerid > MAX_PLAYERS-1 || !CheckPlayerOffer(playerid,idx,type)) return 1;
	new str_yn[140];
	new id_offer = PlayerOffer[playerid][idx][TargetOfferID],
		offer_price = PlayerOffer[playerid][idx][TargetPrice];
	if (type == 1)
	{
		switch(idx)
		{
			case YN_TYPE_REFILL: // заправка refill
			{
				if (pInfo[id_offer][pJob] != PLAYER_JOB_MECHANIC) {
					ResetTargetYN(playerid,idx);
					return SendClientMessage(playerid,CGRAY2,!"Этот игрок не механик");
				}
				if (pTemp[id_offer][gContract] == INVALID_PLAYER_ID) {
					ResetTargetYN(playerid,idx);
					return SendClientMessage(playerid, COLOR_GREY, !"У этого автомеханика не подписан контракт с заправкой!");
				}
				if (kLibGetPlayerMoney(playerid) < offer_price) {
					ResetTargetYN(playerid,idx);
					return SendClientMessage(playerid, CGRAY2, !"У Вас нет столько денег");
				}
				if (!IsPlayerInAnyVehicle(playerid)) {
					ResetTargetYN(playerid,idx);
					return SendClientMessage(playerid, CGRAY2, !"Вы не в автомобиле");
				}
				if (BusinessInfo[pTemp[id_offer][gContract]][bProducts] < 150) {
					SendClientMessage(playerid, COLOR_GREY, !"Недостаточно топлива !");
					SendClientMessage(id_offer, COLOR_GREY, !"Недостаточно продуктов (нужно сменить АЗС)!");
					ResetTargetYN(playerid,idx);
					return true;
				}

				kLibGivePlayerMoney(playerid, -offer_price, "KEY_YES accept refill");
				kLibGivePlayerMoney(id_offer, offer_price, "KEY_YES accept refill");

				VehicleInfo[ GetPlayerVehicleID(playerid) - 1 ][vFuel] = 100.0;
				BusinessInfo[pTemp[id_offer][gContract]][bProducts] -= 150;

				format(str_yn,93,"Автомеханик %s заправил ваш автомобиль на 300 литров за "collime"$%d",pInfo[id_offer][pName],offer_price);
				SendClientMessage(playerid, 0x6495EDFF, str_yn);

				format(str_yn,73,"Вы успешно заправили автомобиль игрока %s[%d]",pInfo[playerid][pName],playerid);
				SendClientMessage(id_offer, 0x6495EDFF, str_yn);

				OnPlayerAchievProgress(id_offer, 19);
				SetPlayerChatBubble(id_offer, "Refill", 0xB6B5F8FF, 20.0, 5000);
				SetPlayerChatBubble(playerid, "Refill", 0xB6B5F8FF, 20.0, 5000);

				OnPlayerQuestProgress(id_offer, QUEST_GUEST, QUEST_TASK_MEH);

				str_yn[0] = EOS;
				format(str_yn, sizeof (str_yn), "`bProducts` = '%i'", BusinessInfo[pTemp[id_offer][gContract]][bProducts]);
				SaveBusiness(pTemp[id_offer][gContract], str_yn);
			}
			case YN_TYPE_REPAIR: // починка авто repair
			{
				if (pInfo[id_offer][pJob] != PLAYER_JOB_MECHANIC){
					ResetTargetYN(playerid,idx);
					return SendClientMessage(playerid,CGRAY2,!"Этот игрок не механик");
				}
				if (kLibGetPlayerMoney(playerid) < offer_price){
					ResetTargetYN(playerid,idx);
					return SendClientMessage(playerid,CGRAY2,!"У Вас нет столько денег");
				}
				if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER/*!IsPlayerInAnyVehicle(playerid)*/){
					ResetTargetYN(playerid,idx);
					return SendClientMessage(playerid,CGRAY2,!"Вы не за рулем автомобиля");
				}
				kLibGivePlayerMoney(playerid, -offer_price, "KEY_YES accept refill");
				kLibGivePlayerMoney(id_offer, offer_price, "KEY_YES accept refill"); 
				_RepairVehicle(GetPlayerVehicleID(playerid));
				SetPlayerChatBubble(id_offer, "Repair", 0xB6B5F8FF, 20.0, 5000);
				SetPlayerChatBubble(playerid, "Repair", 0xB6B5F8FF, 20.0, 5000);

				OnPlayerAchievProgress(id_offer, 19);
				OnPlayerQuestProgress(id_offer, QUEST_GUEST, QUEST_TASK_MEH);
			}
			case YN_TYPE_DEBT: // крыша мафии
			{
				format(str_yn,sizeof(str_yn), "Вы приняли крышу от %s'a", pInfo[id_offer][pName]);
				SendClientMessage(playerid, 0x6495EDFF, str_yn);
				format(str_yn,sizeof(str_yn),  "%s согласился на вашу крышу", pInfo[playerid][pName]);
				SendClientMessage(id_offer, 0x6495EDFF, str_yn);

				pInfo[playerid][pUseKrisha] = 1;
				pInfo[playerid][pKrisha] = PlayerOffer[ playerid ][YN_TYPE_DEBT][TargetParams][0];
				PlayerOffer[ playerid ][YN_TYPE_DEBT][TargetParams][0] = 0;
				

				OnPlayerQuestProgress(id_offer, QUEST_MAFIA, QUEST_TASK_RACKET);
			}
			case YN_TYPE_GUN: // оружие
			{
				if (!IsAGang(id_offer)){
					ResetTargetYN(playerid,idx);
					return SendClientMessage(playerid,CGRAY2, !"Этот игрок не бандит");
				}
				if (kLibGetPlayerMoney(playerid) < offer_price){
					ResetTargetYN(playerid,idx);
					return SendClientMessage(playerid,CGRAY2, !"У Вас не хватает денег");
				}
				if (pInfo[ id_offer ][pMats] < PlayerOffer[playerid][YN_TYPE_GUN][TargetParams][2]){
					ResetTargetYN(playerid,idx);
					return SendClientMessage(playerid,CGRAY2, !"У опонента нет столько материалов");
				} 
				if (!GetIDOwnerGangZone(id_offer)) {
					SendClientMessage(id_offer, CGRAY2, !"Вы должны находиться на своей территории");
					SendClientMessage(playerid, CGRAY2, !"Бандит находиться не на своей территории");
					ResetTargetYN(playerid, idx);
					return 1;
				} 
				pInfo[ id_offer ][pMats] -= PlayerOffer[playerid][YN_TYPE_GUN][TargetParams][2];

				GivePlayerWeapon(playerid,PlayerOffer[playerid][YN_TYPE_GUN][TargetParams][0], PlayerOffer[playerid][YN_TYPE_GUN][TargetParams][1]);
 
				format(str_yn, sizeof str_yn, "Вы приобрели оружие у %s", pInfo[id_offer][pName]);
				SendClientMessage(playerid,C_OFFER,str_yn); 

				format(str_yn, sizeof str_yn, "%s приобрел у Вас оружие", pInfo[playerid][pName]);
				SendClientMessage(id_offer,C_OFFER, str_yn); 

				MeAction(playerid, "cделал(а) оружие из материалов", SELECT_ACTION_IN_BUBBLE); 

				// сохранение
				kLibGivePlayerMoney(playerid, -offer_price, "KEY_YES accept gun");
				kLibGivePlayerMoney(id_offer, offer_price, "KEY_YES accept gun"); 
			}
			case YN_TYPE_DRUGS: // оружие
			{
				if (kLibGetPlayerMoney(playerid) < offer_price ){
					ResetTargetYN(playerid,idx);
					return SendClientMessage(playerid, COLOR_GREY, !"У вас нет столько денег!");
				}
				new drugs = PlayerOffer[playerid][YN_TYPE_DRUGS][TargetParams][0];
				if (pInfo[playerid][pDrugs]+ drugs < GetVIPLimitDrugs(playerid))
				{
					pInfo[playerid][pDrugs] += drugs;
					pInfo[id_offer][pDrugs] -= drugs;
					format(str_yn,sizeof(str_yn),"Вы купили %d грамм наркотиков за $%d у %s.",
						drugs,offer_price,pInfo[id_offer][pName]);
					SendClientMessage(playerid,0x6495EDFF,str_yn);

					format(str_yn,sizeof(str_yn), "%s купил у Вас %d грамм наркотиков за $%d.",
						pInfo[playerid][pName],drugs,offer_price);
					SendClientMessage(id_offer,0x6495EDFF,str_yn); 

					kLibGivePlayerMoney(playerid, -offer_price , "KEY_YES /selldrugs");
					kLibGivePlayerMoney(id_offer, offer_price , "KEY_YES /selldrugs");
				}
				else { 
					format(str_yn, sizeof str_yn,"Нельзя носить с собой более %d грамм.", GetVIPLimitDrugs(playerid));
					SendClientMessage(playerid, CGRAY2, str_yn);
					format(str_yn, sizeof str_yn,"Игрок %s не может носить с собой более %d грамм.", pInfo[playerid][pName], GetVIPLimitDrugs(playerid));
					SendClientMessage(id_offer, CGRAY2, str_yn);
				}
			}
			case YN_TYPE_CAR: // авто личное
			{
				if (PlayerOffer[ id_offer ][YN_TYPE_CAR][TargetParams][2] == 0)// игрок который предложил еще не согласился
				{
					PlayerOffer[ playerid ][YN_TYPE_CAR][TargetParams][2] = 1; // игрок которому предложили согласился
					format(str_yn,sizeof(str_yn),"Игрок %s согласился продать/обменять транспорт",pInfo[playerid][pName]);
					SendClientMessage(id_offer, CGRAY2, str_yn);
					SendClientMessage(playerid, CGRAY2, !"Вы подтвердили обмен/продажу транспорта");
					return 1;
				}
				new player_owner, player_buyer;
				if (PlayerOffer[playerid][YN_TYPE_CAR][TargetParams][1] == 1) // которму предложили дом покупатель
				{
					player_owner = id_offer;  //id_offer  продавец
					player_buyer = playerid; // playerid покупатель
				} else { 
					player_buyer = id_offer; // id_offer покупатель
					player_owner = playerid;  // playerid продавец
				}
				offer_price = PlayerOffer[player_buyer][idx][TargetPrice];
				if (kLibGetPlayerMoney(player_buyer) < offer_price) {
					SendClientMessage(player_buyer, CGRAY2, !"У вас нет столько денег на руках!");
					SendClientMessage(player_owner,CGRAY2,!"У игрока с котором вы хотели обменятся недостаточно средств на руках");
					ResetTargetYN(playerid,idx);
					return 1;
				} 
				new 
					car_buyer = PlayerOffer[player_buyer][YN_TYPE_CAR][TargetParams][0] , // ид авто который покупает
					car_owner = PlayerOffer[player_owner][YN_TYPE_CAR][TargetParams][0]; // ид авто который отдает продовец
				if (!IsValidVehicle(car_buyer) || VehicleInfo[ car_buyer - 1 ][vFraction] != pInfo[player_owner][pID] || VehicleInfo[ car_buyer - 1 ][vType] != VEHICLE_TYPE_PLAYER) {
					SendClientMessage(player_buyer, CGRAY2, !"Произошла ошибка при обмене машин! #car_sell");
					SendClientMessage(player_owner,CGRAY2,!"Произошла ошибка при обмене машин! #car_sell");
					ResetTargetYN(player_buyer,idx); // если у продавца НЕТ АВТО
					return 1;
				}
				new query_[168];
				if (car_owner != 0) // авто у покупателя которое передается продавцу
				{
					if (!IsValidVehicle(car_owner) ||
					VehicleInfo[ car_owner - 1 ][vFraction] != pInfo[player_buyer][pID] ||
					VehicleInfo[ car_owner - 1 ][vType] != VEHICLE_TYPE_PLAYER)
					{
						SendClientMessage(player_buyer, CGRAY2, !"Произошла ошибка при обмене машин! #car_sell_x");
						SendClientMessage(player_owner, CGRAY2,!"Произошла ошибка при обмене машин! #car_sell_x");
						ResetTargetYN(player_buyer, idx); // если у продавца НЕТ АВТО
						return 1;
					}
					// выдает авто продавцу 
					format(query_, sizeof query_, "UPDATE `s_vehicle_player` SET `vOwner`='%d', `vWorld`='0', `vInt`='0' WHERE `vID` = '%d'", pInfo[player_owner][pID], VehicleInfo[ car_owner - 1 ][vID]);
					mysql_tquery(dbHandle, query_, "", "");

					Iter_Remove(PlayerListVehicle[player_buyer], car_owner);
					VehicleInfo[ car_owner - 1 ][vFraction] = pInfo[player_owner][pID];
					VehicleInfo[ car_owner - 1 ][vWorld] = 0;
					VehicleInfo[ car_owner - 1 ][vInt] = 0;
					Iter_Add(PlayerListVehicle[player_owner], car_owner);
					UpdateVehiclevText(player_owner, car_owner); 
				}
				kLibGivePlayerMoney(player_buyer, -offer_price, "KEY_YES /changecar");
				kLibGivePlayerMoney(player_owner, offer_price, "KEY_YES /changecar");
				// выдает авто покупателю //tytcar
				format(query_, sizeof query_, "UPDATE `s_vehicle_player` SET `vOwner`='%d', `vWorld`='0', `vInt`='0' WHERE `vID` = '%d'", pInfo[player_buyer][pID], VehicleInfo[ car_buyer - 1 ][vID]);
				mysql_tquery(dbHandle, query_, "", "");

				Iter_Remove(PlayerListVehicle[player_owner], car_buyer);
				VehicleInfo[ car_buyer - 1 ][vFraction] = pInfo[player_buyer][pID];
				VehicleInfo[ car_buyer - 1 ][vWorld] = 0;
				VehicleInfo[ car_buyer - 1 ][vInt] = 0;
				Iter_Add(PlayerListVehicle[player_buyer], car_buyer);
				UpdateVehiclevText(player_buyer, car_buyer);
				format(str_yn,sizeof(str_yn),"Вы обменялись личным транспортом с %s. Вы доплатили $%d!", pInfo[player_owner][pName], offer_price);
				SendClientMessage(player_buyer,C_OFFER,str_yn);

				format(str_yn,sizeof(str_yn),"Вы обменялись личным транспортом с %s. Вам доплатили $%d!",pInfo[player_buyer][pName],offer_price);
				SendClientMessage(player_owner,C_OFFER,str_yn);

				OnPlayerQuestProgress(player_buyer, QUEST_GUEST, QUEST_TASK_CAR);
			}
			case YN_TYPE_HOUSE: // дом
			{
				if (PlayerOffer[ id_offer ][YN_TYPE_HOUSE][TargetParams][2] == 0)// игрок который предложил еще не согласился
				{
					PlayerOffer[ playerid ][YN_TYPE_HOUSE][TargetParams][2] = 1; // игрок которому предложили согласился
					format(str_yn,sizeof(str_yn),"Игрок %s согласился продать/купить дом",pInfo[playerid][pName]);
					SendClientMessage(id_offer, CGRAY2, str_yn);
					SendClientMessage(playerid, CGRAY2, !"Вы подтвердили покупку/продажу дома");
					return 1;
				}
				else // замена домов
				{
					//PlayerOffer[params[0]][YN_TYPE_HOUSE][TargetParams][1] =  1;//  1 кому предложили
					new player_owner, player_buyer;
					if (PlayerOffer[playerid][YN_TYPE_HOUSE][TargetParams][1] == 1) // которму предложили дом покупатель
					{
						player_owner = id_offer;  //id_offer  продавец
						player_buyer = playerid; // playerid покупатель
					}
					else
					{
						player_buyer = id_offer; // id_offer покупатель
						player_owner = playerid;  // playerid продавец
					}
					offer_price = PlayerOffer[player_buyer][idx][TargetPrice];
					if (kLibGetPlayerMoney(player_buyer) < offer_price)
					{
						SendClientMessage(player_buyer, CGRAY2, !"У вас нет столько денег на руках!");
						SendClientMessage(player_owner,CGRAY2,!"У игрока с которому вы хотели продать дом недостаточно средств на руках");
						ResetTargetYN(playerid,idx);
						return 1;
					}

					new house_buyer = PlayerOffer[player_buyer][YN_TYPE_HOUSE][TargetParams][0] , // ид дома который покупает
						house_owner = PlayerOffer[player_owner][YN_TYPE_HOUSE][TargetParams][0]; // ид дома который отдает продовец

					// Проверка дома продавца (ДОМ КОТОРЫЙ ПОКУПАЕТ)
					if (strcmp(HouseInfo[ house_buyer ][hOwner],"None", true) == 0 || strcmp(HouseInfo[house_buyer][hOwner], pInfo[player_owner][pName], false) != 0)
					{
						SendClientMessage(player_buyer, CGRAY2, !"Произошла ошибка при покупке дома! #house_sell");
						SendClientMessage(player_owner, CGRAY2, !"Произошла ошибка при продаже дома! #house_sell");
						ResetTargetYN(player_buyer,idx); // если у продавца НЕТ ДОМА
						return 1;
					}
					kLibGivePlayerMoney(player_buyer, -offer_price, "/changehouse");
					kLibGivePlayerMoney(player_owner, offer_price, "/changehouse");
					// Проверка дома покупателя
					if (house_owner != -1) // Если у покупателя есть дом
					{
						if (strcmp(HouseInfo[ house_owner ][hOwner],"None", true) == 0 || strcmp(HouseInfo[house_owner][hOwner], pInfo[player_buyer][pName], false) != 0)
						{
							SendClientMessage(player_buyer, CGRAY2, !"Произошла ошибка при обмене домов! #house_sell_x");
							SendClientMessage(player_owner,CGRAY2,!"Произошла ошибка при обмене домов! #house_sell_x");
							ResetTargetYN(player_buyer,idx);
							return 1;
						}
					}
					else {
						pInfo[player_owner][pHouseID] = -1;
						SavePlayerInteger(player_owner, "pHouseID", pInfo[player_owner][pHouseID]);
					}
					// Покупатель получает дом

					strmid(HouseInfo[house_buyer][hOwner],pInfo[player_buyer][pName], 0, strlen(pInfo[player_buyer][pName]), MAX_PLAYER_NAME);
					SaveHouseID(house_buyer);
					UpdateHouseInfo(house_buyer, false);
					pInfo[player_buyer][pHouseID] = house_buyer; 
					SavePlayerInteger(player_buyer, "pHouseID", pInfo[player_buyer][pHouseID]);

					format(str_yn,sizeof(str_yn),"Вы обменялись домами с %s. Вы доплатили $%d!",
						pInfo[player_owner][pName], offer_price);
					SendClientMessage(player_buyer,0x6495EDFF,str_yn);

					format(str_yn,sizeof(str_yn),"Вы обменялись домами с %s. Вам доплатили $%d!",pInfo[player_buyer][pName],offer_price);
					SendClientMessage(player_owner,0x6495EDFF,str_yn);

					pInfo[player_buyer][PlayerSpawn] = 1;
					SavePlayerInteger(player_buyer, "playerspawn", pInfo[player_buyer][PlayerSpawn]);

					OnPlayerQuestProgress(player_buyer, QUEST_GUEST, QUEST_TASK_HOUSE);
				}
			}
			case YN_TYPE_ZONE:
			{
				if (kLibGetPlayerMoney(playerid) < offer_price)
				{
					SendClientMessage(id_offer,CGRAY2,!"У игрока которому вы хотели продать территорию недостаточно средств на руках");
					ResetTargetYN(playerid,idx);
					return SendClientMessage(playerid, CGRAY2, !"У вас нет столько денег на руках!");
				}
				new zone_sell = PlayerOffer[ playerid ][YN_TYPE_ZONE][TargetParams][0];
				if (GZInfo[zone_sell][gFrakVlad] != pInfo[id_offer][pMember] || !IsAGang(id_offer)){
					ResetTargetYN(playerid,idx);
					return SendClientMessage(playerid, COLOR_WHITE, !"Данная территория не предложить банде продавца!");
				}
				if (!IsAGang(playerid)){
					ResetTargetYN(playerid,idx);
					return SendClientMessage(playerid, COLOR_WHITE, !"Вы должно состоять в банде!");
				}
				if (GZInfo[zone_sell][gTimer] != 0){
					SendClientMessage(playerid, COLOR_GRAD1, !"Идет захват данной территории!");
					ResetTargetYN(playerid,idx);
					return 1;
				}
				kLibGivePlayerMoney(playerid, - offer_price, "KEY_YES /sellzone");
				kLibGivePlayerMoney(id_offer, offer_price, "KEY_YES /sellzone");

				new zone = PlayerOffer[playerid][YN_TYPE_ZONE][TargetParams][0];

				GZInfo[zone][gFrakVlad] = pInfo[playerid][pMember];
				GangZoneStopFlashForAll(GZInfo[zone][gZone]);

				SaveGangZone(zone);

				format(str_yn,sizeof(str_yn),"Вы купили территорию у %s за $%d.",pInfo[id_offer][pName], offer_price);
				SendClientMessage(playerid, 0x6495EDFF, str_yn);
				format(str_yn,sizeof(str_yn),"Вы продали территорию %s за $%d.",pInfo[playerid][pName], offer_price);
				SendClientMessage(id_offer, 0x6495EDFF, str_yn);
			}
			case YN_TYPE_WEDDING:
			{
				if (kLibGetPlayerMoney(id_offer) < 100000)
				{
					ResetTargetYN(playerid,idx);
					SendClientMessage(playerid, COLOR_GREY, !"У игрока который сделал Вам предложение недостаточно средств");
					SendClientMessage(id_offer, COLOR_GREY, !"У Вас недостаточно средств");
					return 1;
				}

				if (!GetString(pInfo[playerid][pMarriedTo],"-")){
					ResetTargetYN(playerid,idx);
					return SendClientMessage(playerid, COLOR_GREY, !"Вы уже в браке!");
				}
				if (!GetString(pInfo[ id_offer ][pMarriedTo],"-")){
					ResetTargetYN(playerid,idx);
					return SendClientMessage(playerid, COLOR_GREY, !"Игрок уже в браке!");
				}

				format(pInfo[playerid][pMarriedTo],MAX_PLAYER_NAME,"%s",pInfo[id_offer][pName]);
				format(pInfo[id_offer][pMarriedTo],MAX_PLAYER_NAME,"%s",pInfo[playerid][pName]);

				new query_[128];
				mysql_format(dbHandle,query_, sizeof(query_), "UPDATE `s_users` SET `pMarriedTo` = '%e' WHERE `pID` = '%d'",
				pInfo[ id_offer ][pName], pInfo[playerid][pID]);
				mysql_tquery(dbHandle, query_, "", "");

				mysql_format(dbHandle,query_, sizeof(query_), "UPDATE `s_users` SET `pMarriedTo` = '%e' WHERE `pID` = '%d'",
				pInfo[playerid][pName], pInfo[ id_offer ][pID]);
				mysql_tquery(dbHandle, query_, "", "");

				format(str_yn, 54, "Вы приняли предложение от %s'а", pInfo[id_offer][pName]);
				SendClientMessage(playerid,0x6495EDFF,str_yn);

				format(str_yn, 74, "%s принял(а) Ваш запрос быть Вашим(ей) Мужем(Женой)", pInfo[playerid][pName]);
				SendClientMessage(id_offer,0x6495EDFF,str_yn);

				kLibGivePlayerMoney(id_offer, -100000, "KEY_YES /propose");

			}
			case YN_TYPE_SKILL:
			{
				show_skill(playerid, id_offer);
				format(str_yn, 68,"%s просматривает ваши навыки владения оружия",  pInfo[playerid][pName]);
				SendClientMessage(id_offer,0x6495EDFF,str_yn);

				format(str_yn, 90, "%s показал свои навыки владения оружием %s", pInfo[id_offer][pName],pInfo[playerid][pName]);
				SendBeside(playerid, COLOR_PURPLE, str_yn,30.0);
			}
			case YN_TYPE_TICKET:
			{
				if (kLibGetPlayerMoney(playerid) < offer_price)
				{
					ResetTargetYN(playerid,idx);
					SendClientMessage(playerid, COLOR_GREY, !"У игрока недостаточно средств для оплаты штрафа");
					SendClientMessage(id_offer, COLOR_GREY, !"У Вас недостаточно средств для оплаты штрафа");
					return 1;
				}
				SendMes(playerid, COLOR_BLUE, "Вы оплатили штраф в размере $%d офицеру %s.", offer_price, pInfo[id_offer][pName]);
				SendMes(id_offer, COLOR_BLUE,"%s оплатил штраф в размере $%d.", pInfo[playerid][pName], offer_price);
				kLibGivePlayerMoney(playerid, -offer_price, "KEY_YES /ticket");
				kLibGivePlayerMoney(id_offer, offer_price, "KEY_YES /ticket");
			}
			case YN_TYPE_APARTMENT:
			{
				if (pInfo[playerid][pHouseID] != -1)
				{
					SendClientMessage(id_offer, COLOR_GREY, !"У Игрока есть жильё");
					SendClientMessage(playerid, COLOR_GREY, !"У Вас есть жильё");
					ResetTargetYN(playerid,idx);
					return 1;
				}
				//new house_id = PlayerOffer[playerid][YN_TYPE_APARTMENT][TargetParams][1];
				/*switch(PlayerOffer[playerid][YN_TYPE_APARTMENT][TargetParams][0])
				{ 
					default:{
						ResetTargetYN(playerid,idx);
						return 1;
					}
				}*/
				SendMes(playerid, 0x6495EDFF, "Вы приняли предложение от %s's", pInfo[id_offer][pName]);
				SendMes(id_offer, 0x6495EDFF, "%s принял(а) Ваш запрос жить в Вашем доме", pInfo[playerid][pName]);
			} 
			case YN_TYPE_DICE:
			{
				if (!IsPlayerNearDiceTable(playerid))
				{
					SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом с игровым столом!");
					SendClientMessage(id_offer, COLOR_GREY, !"Игрок отказался от игры в кости!");
					ResetTargetYN(playerid,idx);
					return true;
				}
				if (!IsPlayerNearDiceTable(id_offer)) {
					SendClientMessage(id_offer, COLOR_GREY, !"Вы должны находиться рядом с игровым столом!");
					SendClientMessage(playerid, COLOR_GREY, !"Игрок отказался от игры в кости!");
					ResetTargetYN(playerid,idx);
					return true;
				}
				if (kLibGetPlayerMoney(playerid) < offer_price || kLibGetPlayerMoney(id_offer) < offer_price) {
					SendClientMessage(id_offer, COLOR_GREY, !"У вас или игрока недостаточно средств для игры в кости!");
					SendClientMessage(playerid, COLOR_GREY, !"У вас или игрока недостаточно средств для игры в кости!");
					ResetTargetYN(playerid,idx);
					return true;
				}

				new dice_numbers[2];

				// #define Random(%0,%1) (random((%1)-(%0))+(%0))

				ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1);

				dice_numbers[0] = random(6) + 1;

				ApplyAnimation(id_offer, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1);

				dice_numbers[1] = random(6) + 1;

				new str_dice_one[11],str_dice_two[11];
				format(str_dice_one,sizeof(str_dice_one),"Выпало: %d",dice_numbers[0]);
				format(str_dice_two,sizeof(str_dice_two),"Выпало: %d",dice_numbers[1]);

				new win_bet = (offer_price*90)/100; // выигранную сумму  90 % от ставки выдает победителю


				if (dice_numbers[0]  > dice_numbers[1])
				{
					kLibGivePlayerMoney(id_offer, -offer_price, "/dice");
					kLibGivePlayerMoney(playerid, win_bet, "/dice");
					format(str_yn,132,"%s выйграл {008900}%i${F39612} у %s. \
					Числа ({FFFF00}%i{F39612}:{FFFF00}%i{F39612})",pInfo[playerid][pName],offer_price,pInfo[id_offer][pName],dice_numbers[0] ,dice_numbers[1]);
					SetPlayerChatBubble(playerid,str_dice_one,0x67DE3FFF, 20.0, 3000);
					SetPlayerChatBubble(id_offer,str_dice_two,0xFB5437FF, 20.0, 3000);
				}
				else if (dice_numbers[1]  > dice_numbers[0] )
				{
					kLibGivePlayerMoney(playerid, -offer_price, "/dice");
					kLibGivePlayerMoney(id_offer, win_bet, "/dice");
					format(str_yn,132,"%s выйграл {008900}%i${F39612} у %s. \
					Числа ({FFFF00}%i{F39612}:{FFFF00}%i{F39612})",pInfo[id_offer][pName],offer_price,pInfo[playerid][pName],dice_numbers[1],dice_numbers[0]);

					SetPlayerChatBubble(playerid,str_dice_one,0xFB5437FF, 20.0, 3000);
					SetPlayerChatBubble(id_offer,str_dice_two,0x67DE3FFF, 20.0, 3000);
				}
				else
				{
					format(str_yn,118,"Игра %s vs %s завершилась ничьей. Ставка {008900}%i${F39612} \
					(%i:%i)",pInfo[playerid][pName],pInfo[id_offer][pName],offer_price,dice_numbers[0] ,dice_numbers[1]);
					SetPlayerChatBubble(playerid,str_dice_one,0x67DE3FFF, 20.0, 3000);
					SetPlayerChatBubble(id_offer,str_dice_two,0x67DE3FFF, 20.0, 3000);
				}
				SendBeside(playerid,0xF39612FF,str_yn);

				win_bet = (offer_price*5)/100; // 5 % даем бизнесу


				new id = pTemp[playerid][tBusinessID];
				BusinessInfo[id][bBank] += win_bet;
				BusinessInfo[id][bBankToday] += win_bet;
				str_yn[0] = EOS;
				format(str_yn, sizeof (str_yn), "bBank = %i, bBankToday = %i", BusinessInfo[id][bBank], BusinessInfo[id][bBankToday]);
				SaveBusiness(id, str_yn); 
				static const Float:CasinoDiceAttachPosEx[6][3] = {
					{ -12.400, 79.40000, 3.90000 },
					{ -12.400, 169.8000, 3.90000 },
					{ 77.8000, 0.900000, 101.400 },
					{ 77.8000, 0.900000, -82.800 },
					{ -12.400, -12.4000, 3.90000 },
					{ -12.400, -100.700, 3.90000 }
				};

				SetPlayerAttachedObject(playerid, 9, 1851, 6, 0.028000, 0.126000, -0.199999, 
					CasinoDiceAttachPosEx[dice_numbers[0] - 1][0], CasinoDiceAttachPosEx[dice_numbers[0] - 1][1], 
					CasinoDiceAttachPosEx[dice_numbers[0] - 1][2], 1.000000, 1.000000, 1.100999
				);
				SetPlayerAttachedObject(id_offer, 9, 1851, 6, 0.028000, 0.126000, -0.199999, 
					CasinoDiceAttachPosEx[dice_numbers[1] - 1][0], CasinoDiceAttachPosEx[dice_numbers[1] - 1][1], 
					CasinoDiceAttachPosEx[dice_numbers[1] - 1][2], 1.000000, 1.000000, 1.100999
				);

				SetTimerEx("ClearDiceAnim", 3000, false, "d", playerid);
				SetTimerEx("ClearDiceAnim", 3000, false, "d", id_offer);
			}
			case YN_TYPE_RACE:
			{ 
				if (kLibGetPlayerMoney(playerid) < offer_price || kLibGetPlayerMoney(id_offer) < offer_price) {
					SendClientMessage(id_offer, COLOR_GREY, !"У вас или игрока недостаточно средств для участия в гонках!");
					SendClientMessage(playerid, COLOR_GREY, !"У вас или игрока недостаточно средств для участия в гонках!");
					ResetTargetYN(playerid, idx);
					return true;
				}  
				if (!IsPlayerInRangeOfPlayer(8.0, playerid, id_offer)) { 
					SendClientMessage(playerid, COLOR_GREY, !"Вы далеко друг от друга");
					ResetTargetYN(playerid, idx);
					return 1;
				}
				if (GetPlayerState(id_offer) != PLAYER_STATE_DRIVER || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) {
					SendClientMessage(playerid, COLOR_GREY, !"Игрок или Вы не за рулём транспорта");
					ResetTargetYN(playerid, idx);
					return 1;
				} 
				new	
					select_map = PlayerOffer[ id_offer ][idx][TargetParams][1];
				pTemp[playerid][tRaceCP] = CreateDynamicCP( RaceCheckpoint[select_map][0], RaceCheckpoint[select_map][1], RaceCheckpoint[select_map][2], 2.0,0,0, playerid); 
				CP[playerid] = 777;
				SetPlayerCheckpoint(playerid, RaceCheckpoint[select_map][0], RaceCheckpoint[select_map][1], RaceCheckpoint[select_map][2], 4.0);
				pTemp[id_offer][tRaceCP] = CreateDynamicCP( RaceCheckpoint[select_map][0], RaceCheckpoint[select_map][1], RaceCheckpoint[select_map][2], 2.0,0,0, id_offer);
				CP[id_offer] = 777;
				SetPlayerCheckpoint(id_offer, RaceCheckpoint[select_map][0], RaceCheckpoint[select_map][1], RaceCheckpoint[select_map][2], 4.0); 
				SendMes(playerid, COLOR_YELLOW, "Внимание! Место финиша %s отмечено в Вашем GPS", RaceMapName[ select_map ]);
				SendMes(id_offer, COLOR_YELLOW, "Внимание! Место финиша %s отмечено в Вашем GPS", RaceMapName[ select_map ]);
				pTemp[playerid][tRaceID] = id_offer;
				pTemp[id_offer][tRaceID] = playerid;
				kLibGivePlayerMoney(playerid, -offer_price, "взнос гонки");
				kLibGivePlayerMoney(id_offer, -offer_price, "взнос гонки"); 

				SendMes(playerid, 0x6495EDFF, "Вы приняли предложение гонке от %s's", pInfo[id_offer][pName]);
				SendMes(id_offer, 0x6495EDFF, "%s принял(а) Ваш запрос на гонку", pInfo[playerid][pName]);
			}
			case YN_TYPE_SIM: 
			{  
				new
					market_com = floatround(offer_price/100*MarketCurrentCommission[MARKET_NDS]),
					end_cost = (offer_price+market_com);

				if (kLibGetPlayerMoney(playerid) < end_cost) {
					SendClientMessage(id_offer, COLOR_GREY, !"У игрока недостаточно средств для сделки!");
					SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно средств для сделки!");
					ResetTargetYN(playerid, idx);
					return true;
				}  
				if (!IsPlayerInRangeOfPlayer(8.0, playerid, id_offer)) { 
					SendClientMessage(playerid, COLOR_GREY, !"Вы далеко друг от друга");
					SendClientMessage(id_offer, COLOR_GREY, !"Вы далеко друг от друга");
					ResetTargetYN(playerid, idx);
					return 1;
				}  

				kLibGivePlayerMoney(playerid, -end_cost, "Покупка SIM-Card");
				kLibGivePlayerMoney(id_offer, offer_price, "Продажа SIM-Card"); 
				SetMoveCashServer(OUT_COMMISSION, market_com);
				pInfo[playerid][PlayerNumber] = pInfo[id_offer][PlayerNumber];
				pInfo[id_offer][PlayerNumber] = 0;
				SavePlayerInteger(id_offer, "pPnumber", pInfo[id_offer][PlayerNumber]);
				SavePlayerInteger(playerid, "pPnumber", pInfo[playerid][PlayerNumber]);  
				SendMes(playerid, 0x6495EDFF, "Вы приобрели SIM-карту у %s's за "collime"$%d+"col_li_red"(Ком: $%d)", pInfo[id_offer][pName], offer_price, market_com);
				SendMes(playerid, COLOR_LI_RED, "[Оповещение] "colwhi"Ваш новый номер: "colrose"%d", pInfo[playerid][PlayerNumber]);
				SendMes(id_offer, 0x6495EDFF, "%s купил(а) у Вас SIM-карту за "collime"$%d", pInfo[playerid][pName], offer_price);
			} 
			case YN_TYPE_POOL: {
				if (!IsPlayerNearPoolTable(playerid))
				{
					SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом с игровым столом!");
					SendClientMessage(id_offer, COLOR_GREY, !"Игрок отказался от игры в бильярд!");
					ResetTargetYN(playerid,idx);
					return true;
				}
				if (!IsPlayerNearPoolTable(id_offer)) {
					SendClientMessage(id_offer, COLOR_GREY, !"Вы должны находиться рядом с игровым столом!");
					SendClientMessage(playerid, COLOR_GREY, !"Игрок отказался от игры в бильярд!");
					ResetTargetYN(playerid,idx);
					return true;
				}
				if (kLibGetPlayerMoney(playerid) < offer_price || kLibGetPlayerMoney(id_offer) < offer_price) {
					SendClientMessage(id_offer, COLOR_GREY, !"У вас или игрока недостаточно средств для игры в бильярд!");
					SendClientMessage(playerid, COLOR_GREY, !"У вас или игрока недостаточно средств для игры в бильярд!");
					ResetTargetYN(playerid,idx);
					return true;
				}

				new dice_numbers[2]; 
				ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1);
				dice_numbers[0] = random(6) + 1;
				ApplyAnimation(id_offer, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1);
				dice_numbers[1] = random(6) + 1; 

				new win_bet = (offer_price*90)/100; // выигранную сумму  90 % от ставки выдает победителю


				if (dice_numbers[0]  > dice_numbers[1])
				{
					kLibGivePlayerMoney(id_offer, -offer_price, "/pool");
					kLibGivePlayerMoney(playerid, win_bet, "/pool");
					format(str_yn,132,"%s выйграл {008900}%i${F39612} у %s. Загнав все шары в лунки!",pInfo[playerid][pName],offer_price,pInfo[id_offer][pName]); 
					SetPlayerAttachedObject(playerid, 9, 3101, 6, 
						0.069998, 0.047998, -0.166000, 158.499679, 109.299713, -87.800064, 3.771003, 4.204997, 3.597002
					);
					SetPlayerAttachedObject(id_offer, 9, 3106, 6, 
						0.069998, 0.047998, -0.166000, 158.499679, 109.299713, -87.800064, 3.771003, 4.204997, 3.597002
					);
				}
				else if (dice_numbers[1]  > dice_numbers[0] )
				{
					kLibGivePlayerMoney(playerid, -offer_price, "/pool");
					kLibGivePlayerMoney(id_offer, win_bet, "/pool");
					format(str_yn,132,"%s выйграл {008900}%i${F39612} у %s. Загнав все шары в лунки!",pInfo[id_offer][pName],offer_price,pInfo[playerid][pName]); 
					SetPlayerAttachedObject(playerid, 9, 3106, 6, 
						0.069998, 0.047998, -0.166000, 158.499679, 109.299713, -87.800064, 3.771003, 4.204997, 3.597002
					);
					SetPlayerAttachedObject(id_offer, 9, 3101, 6,  
						0.069998, 0.047998, -0.166000, 158.499679, 109.299713, -87.800064, 3.771003, 4.204997, 3.597002
					);
				}
				else
				{
					format(str_yn,118,"Партия %s vs %s завершилась ничьей. Ставка {008900}%i${F39612}",pInfo[playerid][pName],pInfo[id_offer][pName], offer_price); 
					SetPlayerAttachedObject(playerid, 9, 3003, 6, 
						0.069998, 0.047998, -0.166000, 158.499679, 109.299713, -87.800064, 3.771003, 4.204997, 3.597002
					);
					SetPlayerAttachedObject(id_offer, 9, 3003, 6,  
						0.069998, 0.047998, -0.166000, 158.499679, 109.299713, -87.800064, 3.771003, 4.204997, 3.597002
					);
				}
				SendBeside(playerid,0xF39612FF,str_yn);

				win_bet = (offer_price*5)/100; // 5 % даем бизнесу
				if (GetPlayerVirtualWorld(playerid) == 1) {
					FractionInfo[24][fMoney] += win_bet;
				}
				else if (GetPlayerVirtualWorld(playerid) == 2) {
					FractionInfo[25][fMoney] += win_bet;
				}
				else if (GetPlayerVirtualWorld(playerid) == 3) {
					FractionInfo[26][fMoney] += win_bet;
				} 

				SetTimerEx("ClearDiceAnim", 3000, false, "d", playerid);
				SetTimerEx("ClearDiceAnim", 3000, false, "d", id_offer);
			}
			case YN_TYPE_GIFT://
			{  
				new
					market_com = floatround(offer_price/100*MarketCurrentCommission[MARKET_NDS]),
					end_cost = (offer_price+market_com),
					count_gift = PlayerOffer[ playerid ][idx][TargetParams][0];

				if (kLibGetPlayerMoney(playerid) < end_cost) {
					SendClientMessage(id_offer, COLOR_GREY, !"У игрока недостаточно средств для сделки!");
					SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно средств для сделки!");
					ResetTargetYN(playerid, idx);
					return true;
				}  
				if (!IsPlayerInRangeOfPlayer(8.0, playerid, id_offer)) { 
					SendClientMessage(playerid, COLOR_GREY, !"Вы далеко друг от друга");
					SendClientMessage(id_offer, COLOR_GREY, !"Вы далеко друг от друга");
					ResetTargetYN(playerid, idx);
					return 1;
				}  
				if (ChristmasInfo[id_offer][cGift] < count_gift) {
					SendClientMessage(playerid, COLOR_GREY, !"У продовца нет столько подарков");
					SendClientMessage(id_offer, COLOR_GREY, !"У Вас нет столько подарков");
					ResetTargetYN(playerid, idx);
					return 1;
				}
				kLibGivePlayerMoney(playerid, -end_cost, "Покупка Gift");
				kLibGivePlayerMoney(id_offer, offer_price, "Продажа Gift"); 
				SetMoveCashServer(OUT_COMMISSION, market_com); 
				ChristmasInfo[playerid][cGift] += count_gift;
				ChristmasInfo[id_offer][cGift] -= count_gift;
				SavePlayerCristmasInteger(id_offer, "cGift", ChristmasInfo[id_offer][cGift]);
				SavePlayerCristmasInteger(playerid, "cGift", ChristmasInfo[playerid][cGift]); 
				SendMes(playerid, 0x6495EDFF, "Вы приобрели новогодние подарки у %s's за "collime"$%d+"col_li_red"(Ком: $%d)", pInfo[id_offer][pName], offer_price, market_com);
				SendMes(playerid, COLOR_LI_RED, "[Оповещение] "colwhi"У Вас новогодних подарков: "colrose"%d шт.", ChristmasInfo[playerid][cGift]);
				SendMes(id_offer, 0x6495EDFF, "%s купил(а) у Вас новогодние подарки за "collime"$%d", pInfo[playerid][pName], offer_price);
			}
			case YN_TYPE_HEALADDICT:
			{
				if (kLibGetPlayerMoney(playerid) < offer_price) {
					SendClientMessage(id_offer, COLOR_GREY, !"У игрока недостаточно средств для прохождения сеанса!");
					SendClientMessage(playerid, COLOR_GREY, !"У Вас недостаточно средств для прохождения сеанса!");
					ResetTargetYN(playerid,idx);
					return true;
				}
				if(!IsPlayerInMedical(playerid) ){
					ResetTargetYN(playerid,idx);
					return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться в больнице!");
				}
				if (!IsPlayerInRangeOfPlayer(8.0, playerid, id_offer))
				{ 
					SendClientMessage(playerid, COLOR_GREY, !"Вы далеко друг от друга");
					SendClientMessage(id_offer, COLOR_GREY, !"Вы далеко друг от друга");
					ResetTargetYN(playerid, idx);
					return 1;
				}  
				pInfo[playerid][pAddiction] -= 500;
				pInfo[id_offer][pCash] += 2500;
				pInfo[playerid][pCash] -= 2500;
				seans[playerid] = true;
				pInfo[playerid][pNarcoLomka] = 2;
			} 
			case YN_TYPE_RATING:
			{
				ShowRating(playerid, id_offer);
				format(str_yn, 68,"%s просматривает ваш рейтинг",  pInfo[playerid][pName]);
				SendClientMessage(id_offer,0x6495EDFF,str_yn);

				format(str_yn, 90, "%s показал(а) рейтин %s", pInfo[id_offer][pName],pInfo[playerid][pName]);
				SendBeside(playerid, COLOR_PURPLE, str_yn,30.0);
			}
		}

	}
	else
	{
		static const player_cancel_[YN_TYPE_LAST][32] =  {
			"заправить автомобиль", //YN_TYPE_REFILL = 0, // заправка refill
			"починить автомобиль", //YN_TYPE_REPAIR, // починка авто repair
			"сотрудничать с мафией",//YN_TYPE_DEBT, // крыша мафии
			"договора с прорабом",//YN_TYPE_CONTRACT, // прораб
			"от приобретения оружия",//YN_TYPE_GUN, // оружие
			"от приобретения наркотиков",//YN_TYPE_DRUGS,
			"от обмена/покупки автомобиля", //YN_TYPE_CAR, // авто личное
			"от обмена/покупки дома", //YN_TYPE_HOUSE, // дом
			"покупки территории", // //YN_TYPE_ZONE, // территория гетто
			"заключения брака", //YN_TYPE_WEDDING, // свадьба
			"просмотра навыков", //YN_TYPE_SKILL, // showkill
			"оплатить штраф", //YN_TYPE_TICKET, // штрафы
			"подселиться в дом", //YN_TYPE_APARTMENT, // подселится в дом
			"от обмена/покупки бизнеса", //YN_TYPE_BUSSINES, // обменятся бизнесами
			"просмотра  мед. карты",//YN_TYPE_MEDICAL_CARD, // посмотреть мед. карту
			"играть в кости",//YN_TYPE_DICE, // Казино /dice
			"от гонке",//YN_TYPE_RACE
			"от поцелуя",//YN_TYPE_KISS
			"от покупки SIM-карты",//YN_TYPE_SIM
			"от игры в бильярд",//YN_TYPE_POOL
			"от покупки подарков",//YN_TYPE_GIFT
			"от сеанса", // наркозависимости
			"от просмотра рейтинга"//YN_TYPE_RATING
		};
		str_yn[0] = EOS; 
		format(str_yn, sizeof str_yn, "Вы отказались %s", player_cancel_[idx]);
		SendClientMessage(playerid, CGRAY2, str_yn);
		format(str_yn, sizeof str_yn, "Игрок %s отказался %s", pInfo[playerid][pName], player_cancel_[idx]); 
		SendClientMessage(id_offer ,0xCECECEFF,str_yn);
	}
	ResetTargetYN(playerid,idx);
	return 1;
}

CMD:poolanim(playerid) {
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1);
	return 1;
}
stock OnPlayerConfirmDeal(playerid,idx) // orig_OnPlayerConfirmDeal
{
	if (playerid > MAX_PLAYERS-1 || !CheckPlayerOffer(playerid,idx,1)) return 1;
	new id_offer = PlayerOffer[playerid][idx][TargetOfferID],
		offer_price = PlayerOffer[playerid][idx][TargetPrice];
	//new confirm_str[340];
	switch(idx)
	{
	    case YN_TYPE_REFILL: // заправка refill
		{
		    format(t_string, sizeof t_string,
				"{FFFFFF}Автомеханик %s предложил заправить Ваш автомобиль на 300 литров за $%d\n\nЗаправить?",pInfo[id_offer][pName],offer_price
			);
	    }
		case YN_TYPE_REPAIR: // починка авто repair
		{
		    format(t_string, sizeof t_string,
				"{FFFFFF}Автомеханик %s предложил отремонтировать Ваш автомобиль за $%d\n\nРемонтировать?",pInfo[id_offer][pName],offer_price
			);
	    }
		case YN_TYPE_DEBT: // крыша мафии
		{
		    format(t_string, sizeof t_string, "Мафиози %s предложил Вам сотрудничество\n\nСогласны?",pInfo[id_offer][pName]);
	    }
		case YN_TYPE_CONTRACT: // прораб
		{
		    format(t_string, sizeof t_string, "Прораб %s предложил Вам контракт\n\nСогласны?",pInfo[id_offer][pName]);
	    }
		case YN_TYPE_GUN: // оружие
  		{
  		    enum _gun_confirm
			{
				gun_name_[9],
				gun_id_
			};
  		    static const guns_name_confirm[7][_gun_confirm] = {
				{"SDpistol",23},
				{"Deagle",24},
				{"ShotGun",25},
				{"SMG",29},
				{"AK-47",30},
				{"M4A1",31},
				{"Rifle",33}
			};
			new i;
			for(new x; x < 7; x ++)
			{
				if (guns_name_confirm[x][gun_id_] == PlayerOffer[playerid][YN_TYPE_GUN][TargetParams][0])
			    {
			        i = x;
			        break;
			    }
			}
			format(t_string, sizeof t_string,
				"{FFFFFF}Бандит %s предложил Вам купить оружие \"%s\"\n\
				- патроны:\t%d\n\
				- цена:\t\t%d\n\nКупить?",

				pInfo[ id_offer ][pName],guns_name_confirm[i][gun_name_],
				PlayerOffer[playerid][YN_TYPE_GUN][TargetParams][1],
				offer_price
			);
	    }
		case YN_TYPE_DRUGS:// покупка наркотиков
		{
			format(t_string, sizeof t_string,
				"{FFFFFF}Бандит %s предложил Вам купить оружие \"наркотики\"\n\
				- количество:\t%d\n\
				- цена:\t\t%d\n\nКупить?",
				pInfo[ id_offer ][pName],
				PlayerOffer[playerid][YN_TYPE_DRUGS][TargetParams][0],
				offer_price
			);
		}
		case YN_TYPE_CAR: // авто личное
		{
			//new str_debug[100];
			//SendClientMessage(playerid,CGRAY2,!"[debug] OnPlayerConfirmDeal YN_TYPE_CAR started ");
			if (PlayerOffer[playerid][YN_TYPE_CAR][TargetParams][2] == 1 ) return SendClientMessage(playerid,CGRAY2,!"Вы уже согласились на покупку/обмен транспортом");
			new player_owner, player_buyer;
			if (PlayerOffer[playerid][YN_TYPE_CAR][TargetParams][1] == 1) // которму предложили дом покупатель
			{
				player_owner = id_offer;  //id_offer  продавец
				player_buyer = playerid; // playerid покупатель
			}
			else
			{

				player_buyer = id_offer; // id_offer покупатель
				player_owner = playerid;  // playerid продавец
			}

			offer_price = PlayerOffer[player_buyer][idx][TargetPrice];
			//format(str_debug,sizeof(str_debug),"[debug] OnPlayerConfirmDeal  < player_owner = %d, player_buyer = %d >",player_owner,player_buyer);
			//SendClientMessage(playerid,CGRAY2,str_debug);


			offer_price = PlayerOffer[player_buyer][idx][TargetPrice];
			new car_buyer = PlayerOffer[player_buyer][YN_TYPE_CAR][TargetParams][0] , // ид авто который покупает
				car_owner = PlayerOffer[player_owner][YN_TYPE_CAR][TargetParams][0]; // ид авто который отдает продовец
			if (!IsValidVehicle(car_buyer) ||
				VehicleInfo[ car_buyer - 1 ][vFraction] != pInfo[player_owner][pID] ||
				VehicleInfo[ car_buyer - 1 ][vType] != VEHICLE_TYPE_PLAYER)
			{
				SendClientMessage(player_buyer, CGRAY2, !"Произошла ошибка при обмене домов! #car_sell");
				SendClientMessage(player_owner,CGRAY2,!"Произошла ошибка при обмене домов! #car_sell");
				ResetTargetYN(player_buyer,idx); // если у продавца НЕТ АВТО
				//SendClientMessage(playerid,CGRAY2,!"[debug] OnPlayerConfirmDeal  Проверка на авто у продавца ( НЕТ ) - end ");
				return 1;
			}
			//SendClientMessage(playerid,CGRAY2,!"[debug] OnPlayerConfirmDeal  Проверка на авто у продавца ( ЕСТЬ) - done ");
			if (car_owner != 0)
			{
				if (!IsValidVehicle(car_owner) ||
				VehicleInfo[ car_owner - 1 ][vFraction] != pInfo[player_buyer][pID] ||
				VehicleInfo[ car_owner - 1 ][vType] != VEHICLE_TYPE_PLAYER)
				{
					SendClientMessage(player_buyer, CGRAY2, !"Произошла ошибка при обмене домов! #car_sell_x");
					SendClientMessage(player_owner,CGRAY2,!"Произошла ошибка при обмене домов! #car_sell_x");
					ResetTargetYN(player_buyer,idx); // если у продавца НЕТ АВТО
					//SendClientMessage(playerid,CGRAY2,!"[debug] OnPlayerConfirmDeal <car_owner != 0> Проверка на авто у покупателя ( НЕТ ) - end ");
					return 1;
				}
				//SendClientMessage(playerid,CGRAY2,!"[debug] OnPlayerConfirmDeal  Проверка на авто у покупателя ( ЕСТЬ) - done ");

				if (playerid == player_buyer) // вывод диалога подтверждения ПОКУПАТЕЛЮ
				{
					//SendClientMessage(playerid,CGRAY2,!"[debug] OnPlayerConfirmDeal <car_owner != 0> format диалога покупателю start ");
					format(t_string, sizeof t_string,
						"{FFFFFF}Вы собираетесь обменяться личным транспортом с %s\n\n\
						Ваш автомобиль: %s\n\
						Автомобиль игрока: %s\n\n\
						\tВы заплатите: [$%d]\n\nСогласны?",
						pInfo[id_offer][pName],
						VehicleNames[ GetVehicleModel(car_owner) - 400 ],
						VehicleNames[ GetVehicleModel(car_buyer) - 400 ],
						offer_price

					);
					//SendClientMessage(playerid,CGRAY2,!"[debug] OnPlayerConfirmDeal <car_owner != 0> format диалога покупателю done ");
				}
				else  // ПРОДАВЦУ
				{
					//SendClientMessage(playerid,CGRAY2,!"[debug] OnPlayerConfirmDeal  <car_owner != 0> format диалога продавцу start ");
					format(t_string, sizeof t_string,
						"{FFFFFF}Вы собираетесь обменяться личным транспортом с %s\n\n\
						Ваш автомобиль: %s\n\
						Автомобиль игрока: %s\n\n\
						\tВам заплатят: [$%d]\n\nСогласны?",
						pInfo[id_offer][pName],
						VehicleNames[ GetVehicleModel(car_buyer) - 400 ],
						VehicleNames[ GetVehicleModel(car_owner) - 400 ],
						offer_price

					);
					//SendClientMessage(playerid,CGRAY2,!"[debug] OnPlayerConfirmDeal <car_owner != 0> format диалога продавцу done ");
				}
			}
			else
			{
				if (playerid == player_buyer) // вывод диалога подтверждения ПОКУПАТЕЛЮ
				{
					//SendClientMessage(playerid,CGRAY2,!"[debug] OnPlayerConfirmDeal  <car_owner = 0> format диалога ПОКУПАТЕЛЮ start ");
					format(t_string, sizeof t_string,
						"{FFFFFF}Вы собираетесь купить личный транспорт у с %s'а\n\n\
						Автомобиль игрока: %s\n\n\
						\tВы заплатите: [$%d]\n\nСогласны?",
						pInfo[id_offer][pName],
						VehicleNames[ GetVehicleModel(car_buyer) - 400 ],
						offer_price

					);
					//SendClientMessage(playerid,CGRAY2,!"[debug] OnPlayerConfirmDeal  <car_owner = 0> format диалога ПОКУПАТЕЛЮ done ");
				}
				else  // ПРОДАВЦУ
				{
					//SendClientMessage(playerid,CGRAY2,!"[debug] OnPlayerConfirmDeal  <car_owner = 0> format диалога ПРОДАВЦУ start ");
					format(t_string, sizeof t_string,
						"{FFFFFF}Вы собираетесь продать личный транспорт игроку %s\n\n\
						Ваш автомобиль: %s\n\
						\tВам заплатят: [$%d]\n\nСогласны?",
						pInfo[id_offer][pName],
						VehicleNames[ GetVehicleModel(car_buyer) - 400 ],
						offer_price

					);
					//SendClientMessage(playerid,CGRAY2,!"[debug] OnPlayerConfirmDeal  <car_owner = 0> format диалога ПРОДАВЦУ done ");
				}
			}
	    }
		case YN_TYPE_HOUSE: // дом
		{
			if (PlayerOffer[playerid][YN_TYPE_HOUSE][TargetParams][2] == 1 ) return SendClientMessage(playerid,CGRAY2,!"Вы уже согласились на покупку/обмен домами"); 
			new player_owner, player_buyer;
			if (PlayerOffer[playerid][YN_TYPE_HOUSE][TargetParams][1] == 1) // которму предложили дом покупатель
			{
				player_owner = id_offer;  //id_offer  продавец
				player_buyer = playerid; // playerid покупатель
			}
			else
			{

				player_buyer = id_offer; // id_offer покупатель
				player_owner = playerid;  // playerid продавец
			}
			offer_price = PlayerOffer[player_buyer][idx][TargetPrice];
			//format(str_debug,sizeof(str_debug),"[debug] OnPlayerConfirmDeal  < player_owner = %d, player_buyer = %d",player_owner,player_buyer);
			//SendClientMessage(playerid,CGRAY2,str_debug);
			new house_buyer = PlayerOffer[player_buyer][YN_TYPE_HOUSE][TargetParams][0] , // ид дома который покупает
				house_owner = PlayerOffer[player_owner][YN_TYPE_HOUSE][TargetParams][0]; // ид дома который отдает продовец

			// Проверка дома продавца (ДОМ КОТОРЫЙ ПОКУПАЕТ)
			if (strcmp(HouseInfo[ house_buyer ][hOwner],"None", true) == 0 || strcmp(HouseInfo[house_buyer][hOwner], pInfo[player_owner][pName], false) != 0)
			{
				SendClientMessage(player_buyer, CGRAY2, !"Произошла ошибка при обмене домов! #house_sell");
				SendClientMessage(player_owner, CGRAY2, !"Произошла ошибка при обмене домов! #house_sell");
				ResetTargetYN(player_buyer,idx); // если у продавца НЕТ ДОМА
				return 1;
			}
			//SendClientMessage(playerid,CGRAY2,!"[debug] OnPlayerConfirmDeal проверка дома продавца - done ");
			// Проверка дома покупателя
			new
				house_class_name_owner[MAX_HOUSE_CLASS_NAME + 1], // дом который отдает
				house_class_name_buyer[MAX_HOUSE_CLASS_NAME + 1]; // дом который будет покупать

			GetHouseClassName(house_buyer, house_class_name_owner);
			if (house_owner != -1) GetHouseClassName(house_owner, house_class_name_buyer);

			if (house_owner != -1) // Если у покупателя есть дом
			{
				if (strcmp(HouseInfo[ house_owner ][hOwner],"None", true) == 0 || strcmp(HouseInfo[house_owner][hOwner], pInfo[player_buyer][pName], false) != 0)
				{
					SendClientMessage(player_buyer, CGRAY2, !"Произошла ошибка при обмене домов! #house_sell_x");
					SendClientMessage(player_owner,CGRAY2,!"Произошла ошибка при обмене домов! #house_sell_x");
					ResetTargetYN(player_buyer,idx);
					return 1;
				}
				//SendClientMessage(playerid,CGRAY2,!"[debug] OnPlayerConfirmDeal проверка дома покупателя (ЕСТЬ) - done ");

				if (playerid == player_buyer) // вывод диалога подтверждения ПОКУПАТЕЛЮ
				{
					//SendClientMessage(playerid,CGRAY2,!"[debug] OnPlayerConfirmDeal playerid == player_buyer");
					format(t_string, sizeof t_string,
						"{FFFFFF}Вы собираетесь обменяться домами с %s\n\n\
						Ваш дом:\n\tНомер дома: [%d]\n\tКласс дома: [%s]\n\
						\tГос. цена: [$%d]\n\n\
						Дом игрока:\n\tНомер дома: [%d]\n\tКласс дома: [%s]\n\
						\tГос. цена: [$%d]\n\n\
						\tВы заплатите: [$%d]\n\nСогласны?",
						pInfo[id_offer][pName],
						house_owner,
						house_class_name_buyer,
						HouseInfo[ house_owner][hValue],

						house_buyer,
						house_class_name_owner,
						HouseInfo[house_buyer][hValue],
						offer_price
					);
					//SendClientMessage(playerid,CGRAY2,confirm_str);
				}
				else  // ПРОДАВЦУ
				{
					//SendClientMessage(playerid,CGRAY2,!"[debug] OnPlayerConfirmDeal playerid != player_buyer");
					format(t_string, sizeof t_string,
						"{FFFFFF}Вы собираетесь обменяться домами с %s\n\n\
						Ваш дом:\n\tНомер дома: [%d]\n\tКласс дома: [%s]\n\
						\tГос. цена: [$%d]\n\n\
						Дом игрока:\n\tНомер дома: [%d]\n\tКласс дома: [%s]\n\
						\tГос. цена: [$%d]\n\n\
						\tВам заплатят: [$%d]\n\nСогласны?",
						pInfo[id_offer][pName],
						house_buyer,
						house_class_name_buyer,
						HouseInfo[house_buyer][hValue],

						house_owner,
						house_class_name_owner,
						HouseInfo[ house_owner][hValue],
						PlayerOffer[player_buyer][YN_TYPE_HOUSE][TargetPrice]

					);
					//SendClientMessage(playerid,CGRAY2,confirm_str);
				}
			}
			else
			{
				format(t_string, sizeof t_string,
				"{FFFFFF}Вы собираетесь %s дом у %s\n\n\tНомер дома: [%d]\n\tКласс дома: [%s]\n\tЦена: [$%d]\n\tГос. цена: [$%d]\n\n%s дом?",
					playerid == player_buyer ? ("купить"):("продать"),
					pInfo[id_offer][pName],
					house_buyer,
					house_class_name_owner,
					offer_price,
					HouseInfo[ house_buyer ][hValue],
					playerid == player_buyer ? ("Купить"):("Продать")
				);
			}
		}
		case YN_TYPE_ZONE:
		{
			format(t_string, sizeof t_string,
				"{FFFFFF}Бандит %s предложил Вам купить территорию\n\
				- цена:\t\t%d\n\nКупить?",
				pInfo[id_offer][pName],
				offer_price
			);
		}
		case YN_TYPE_WEDDING:
		{
			format(t_string, sizeof t_string,
				"{FFFFFF}%s предложил Вам руку и сердце\n\n\
				Вы действительно хотите принять предложение?",
				pInfo[id_offer][pName]
			);
		}
		case YN_TYPE_SKILL:
		{
			show_skill(playerid, id_offer);
			new string_[80];
			format(string_, sizeof string_,"%s просматривает ваши навыки владения оружия",  pInfo[playerid][pName]);
			SendClientMessage(id_offer, 0x6495EDFF, string_); 
			format(string_, sizeof string_, "показал(а) свои навыки владения оружием %s'у",pInfo[playerid][pName]);
			MeAction(id_offer, string_, SELECT_ACTION_IN_BUBBLE);
			ResetTargetYN(playerid,idx);
			return 1;
		}
		case YN_TYPE_TICKET:
		{
			format(t_string, sizeof t_string,
				"{FFFFFF}Офицер %s выписал вам штраф в размере $%d.\n\n\
				Оплатить?",
				pInfo[id_offer][pName],
				offer_price
			);
		}
		case YN_TYPE_APARTMENT:
		{
			format(t_string, sizeof t_string,
				"{FFFFFF}Игрок %s предлагает Вам подселиться к нему в дом.\n\n\
				Согласны?",
				pInfo[id_offer][pName]
			);
		}
		case YN_TYPE_MEDICAL_CARD:
		{
			//if (!ShowMedcard(playerid, id_offer)) SendClientMessage(playerid, COLOR_GREY, !"У этого игрока нет мед. карты");
			ShowMedcard(id_offer, playerid);
			ResetTargetYN(playerid, idx);
			return 1;
		}
		
		case YN_TYPE_DICE:{
			format(t_string, sizeof t_string,
				"{FFFFFF}Игрок %s предложил Вам сыграть в кости\n\
				- Ставка:\t\t%d\n\nИграть?",
				pInfo[ id_offer ][pName],
				offer_price
			);
		}
		case YN_TYPE_RACE: {//PlayerOffer[ playerid ][YN_TYPE_RACE][TargetParams][1] = map_;
			new 
				map_ = PlayerOffer[ id_offer ][YN_TYPE_RACE][TargetParams][1];
			format(t_string, sizeof t_string,
				""colwhi"Игрок "colmaline"%s "colwhi"предложил Вам участие в гонке\n\
				"colwhi"- Ставка: "collime"$%d\n\
				"colwhi"- Точка финиша: "C_PODS"%s\n\n\
				"colwhi"Вы согласны принять гонку?",
				pInfo[ id_offer ][pName], offer_price, RaceMapName[ map_ ]
			);
		}
		case YN_TYPE_KISS:
		{ 
			SetActionKiss(id_offer, playerid); //(id_offer, playerid);
			ResetTargetYN(playerid, idx);
			return 1;
		}
		case YN_TYPE_SIM: { //YN_TYPE_GIFT
			new
				market_com = floatround(offer_price/100*MarketCurrentCommission[MARKET_NDS]);
			format(t_string, sizeof t_string,
				""colwhi"Игрок "colmaline"%s "colwhi"предложил Вам купить SIM-Карту\n\
				"colwhi"- SIM-Карту: "C_PODS"%d\n\
				"colwhi"- Цена от продовца: "collime"$%d\n\
				"colwhi"- Комиссия рынка: "collime"$%d "col_li_red"(%.1f%%)\n\
				"colwhi"- Общая цена: "collime"$%d\n\n\
				"colwhi"Вы согласны принять предложение?",
				pInfo[ id_offer ][pName], pInfo[ id_offer ][PlayerNumber], offer_price, market_com, MarketCurrentCommission[MARKET_NDS], (offer_price+market_com)
			);
		}
		case YN_TYPE_POOL: {
			format(t_string, sizeof t_string,
				""colwhi"Игрок "colmaline"%s "colwhi" предложил Вам сыграть в бильярд\n\
				"colwhi"- Ставка:\t\t"collime"$%d\n\n\
				"colwhi"Вы согласны принять предложение?",
				pInfo[ id_offer ][pName], offer_price
			);
		}
		case YN_TYPE_GIFT: { //
			new
				market_com = floatround(offer_price/100*MarketCurrentCommission[MARKET_NDS]),
				count_ = PlayerOffer[playerid][YN_TYPE_GIFT][TargetParams][0];
			format(t_string, sizeof t_string,
				""colwhi"Игрок "colmaline"%s "colwhi"предложил Вам купить новогодние подарки\n\
				"colwhi"- Кол-во подарков: "C_PODS"%d\n\
				"colwhi"- Цена от продовца: "collime"$%d\n\
				"colwhi"- Комиссия рынка: "collime"$%d "col_li_red"(%.1f%%)\n\
				"colwhi"- Общая цена: "collime"$%d\n\n\
				"colwhi"Вы согласны принять предложение?",
				pInfo[ id_offer ][pName], count_, offer_price, market_com, MarketCurrentCommission[MARKET_NDS], (offer_price+market_com)
			);
		}
		case YN_TYPE_HEALADDICT: // наркозависимость
		{
		    format(t_string, sizeof t_string,
				"{FFFFFF}Доктор %s предложил Вам провести сеанс от наркозависимости по цене $2500\n\nПройти сеанс?",pInfo[id_offer][pName]
			);
	    }
		case YN_TYPE_RATING:
		{
			ShowRating(playerid, id_offer);
			new string_[80];
			format(string_, sizeof string_,"%s просматривает ваш рейтинг",  pInfo[playerid][pName]);
			SendClientMessage(id_offer, 0x6495EDFF, string_); 
			format(string_, sizeof string_, "показал(а) свой рейтинг %s'у",pInfo[playerid][pName]);
			MeAction(id_offer, string_, SELECT_ACTION_IN_BUBBLE);
			ResetTargetYN(playerid,idx);
			return 1;
		}
	}
	pTemp[playerid][status_offer_confirm] = idx;
	ShowPlayerDialog(playerid, D_CONFIRM_DEAL, DIALOG_STYLE_MSGBOX, "Подтверждение", t_string, "Да", "Нет");
	return 1;
}


stock CheckPlayerOffer(playerid, idx, type)
{
	if (PlayerOffer[playerid][idx][TargetOfferID] == INVALID_PLAYER_ID) return 0;
	new id_offer = PlayerOffer[playerid][idx][TargetOfferID];
	switch(idx)
	{
		case YN_TYPE_HOUSE: {
			if (PlayerOffer[id_offer][idx][TargetOfferID] != playerid)
			{
				SendClientMessage(playerid, 0xCECECEFF, !"Игрок отказался от обмена домами/вышел из игры");
				ResetTargetYN(playerid, idx);
				return 0;
			}
		}
	}

	if (0 == IsPlayerConnected(id_offer) || !pInfo[ id_offer ][pLogin])
	{
		SendClientMessage(playerid, 0xCECECEFF, !"Игрок вышел из игры");
		ResetTargetYN(playerid, idx);
		return 0;
	}
	if (!IsPlayerInRangeOfPlayer(7.2, playerid, id_offer) && type == 1) {
		SendClientMessage(playerid, 0xCECECEFF, !"Игрок далеко от вас");
		return 0;
	}
	return 1;
}

 
publics: reset_yn(const playerid,const type)
{
	PlayerOffer[playerid][type][TargetTimer] = 0;
	ResetTargetYN(playerid, type);
	return 1;
}

stock ResetTargetYN(playerid, type = 0)
{

	switch(type)
	{
		case YN_TYPE_CAR, YN_TYPE_HOUSE, YN_TYPE_DICE, YN_TYPE_RACE, YN_TYPE_POOL:
		{
			new id = PlayerOffer[playerid][type][TargetOfferID];
			if (IsPlayerConnected(id) && pInfo[id][pLogin])
			{
				if (PlayerOffer[id][type][TargetOfferID] == playerid)
				{
					if (PlayerOffer[id][type][TargetTimer] != 0) {
						KillTimer(PlayerOffer[id][type][TargetTimer]);
						PlayerOffer[id][type][TargetTimer] = 0;
					}
					PlayerOffer[id][type] = defaultPlayerOffer;
				}
			}
		}
	}

	if (PlayerOffer[playerid][type][TargetTimer] != 0) {
		KillTimer(PlayerOffer[playerid][type][TargetTimer]);
		PlayerOffer[playerid][type][TargetTimer] = 0;
	}

	if (type != YN_TYPE_DEBT/* || type != YN_TYPE_KISS*/) {
		PlayerOffer[playerid][type] = defaultPlayerOffer;
	}
	else {

		PlayerOffer[playerid][type][TargetOfferID] = INVALID_PLAYER_ID;
		PlayerOffer[playerid][type][TargetPrice] =
		PlayerOffer[playerid][type][TargetParams][1] =
		PlayerOffer[playerid][type][TargetParams][2] = 0;
	}
	
	return 1;
}



poffer_OnDialogResponse(playerid, dialogid, response, listitem, const inputtext[]) {
	#pragma unused listitem
	switch (dialogid){
		/*case D_HOUSE_FUNC_11:
		{
			if (!response) return 1;
			new
				H_IDX = GetPVarInt(playerid,"PlayerHouseID");

			new friend_owner[MAX_PLAYER_NAME];

			switch(listitem)
			{
				case 0: strcat(friend_owner,HouseInfo[H_IDX][hFriend_0]);
				case 1: strcat(friend_owner,HouseInfo[H_IDX][hFriend_1]);
				case 2: strcat(friend_owner,HouseInfo[H_IDX][hFriend_2]);
				case 3: strcat(friend_owner,HouseInfo[H_IDX][hFriend_3]);
			}

			if (!strcmp(friend_owner, "None", true))
			{
				PlayerOffer[playerid][YN_TYPE_APARTMENT][TargetParams][1] = listitem+1;
				ShowPlayerDialog(playerid, D_HOUSE_FUNC_12,DIALOG_STYLE_INPUT,"Заселение","{FFFFFF}Введите ID, которого хотите подселить:" ,"Далее","Назад");
			}
			else
			{
				switch(listitem)
				{
					case 0:{
						strmid(HouseInfo[H_IDX][hFriend_0], "None", 0, strlen("None"), 32);
						SaveHouseString(H_IDX,"hFriend_0","None");
					}
					case 1:{
						strmid(HouseInfo[H_IDX][hFriend_1], "None", 0, strlen("None"), 32);
						SaveHouseString(H_IDX,"hFriend_1","None");
					}
					case 2:{
						strmid(HouseInfo[H_IDX][hFriend_2], "None", 0, strlen("None"), 32);
						SaveHouseString(H_IDX,"hFriend_2","None");
					}
					case 3:{
						strmid(HouseInfo[H_IDX][hFriend_3], "None", 0, strlen("None"), 32);
						SaveHouseString(H_IDX,"hFriend_3","None");
					}
				}
				SendClientMessage(playerid,COLOR_INF,!"Вы выселили игрока");
			}
			return true;
		}
		case D_HOUSE_FUNC_12:
		{
			if (!response) return 1;
		   	new targetid;
		    if (sscanf(inputtext,"i", targetid)) return ShowPlayerDialog(playerid, D_HOUSE_FUNC_12, DIALOG_STYLE_INPUT,"Заселение","{FFFFFF}Введите ID, которого хотите подселить:" ,"Далее","Назад");
		    new Float:x,
				Float:y,
				Float:z;
		    GetPlayerPos(targetid, x, y, z);
		    if (!PlayerInConnected(targetid)) return ShowPlayerDialog(playerid, D_HOUSE_FUNC_12,DIALOG_STYLE_INPUT,"Заселение","{FFFFFF}Введите ID, которого хотите подселить:" ,"Далее","Назад");
		    if (!IsPlayerInRangeOfPoint(playerid, 5.0, x,y,z))
			{
				SendClientMessage(playerid, COLOR_GREY, !"Вы не рядом с игроком");
				ShowPlayerDialog(playerid, D_HOUSE_FUNC_12,DIALOG_STYLE_INPUT,"Заселение","{FFFFFF}Введите ID, которого хотите подселить:" ,"Далее","Назад");
				return 1;
			}

			if (pInfo[playerid][pHouseID] != -1 || pTemp[targetid][PlayerRoomID] != -1)
			{
				SendClientMessage(playerid, COLOR_GREY, !"Игрок имеет жильё");
				ShowPlayerDialog(playerid, D_HOUSE_FUNC_12,DIALOG_STYLE_INPUT,"Заселение","{FFFFFF}Введите ID, которого хотите подселить:" ,"Далее","Назад");
				return 1;
			}

			if (PlayerOffer[targetid][YN_TYPE_APARTMENT][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid,CGRAY2,!"У этого игрока уже есть активное предложение");

			PlayerOffer[targetid][YN_TYPE_APARTMENT][TargetOfferID] = playerid;
			PlayerOffer[targetid][YN_TYPE_APARTMENT][TargetParams][0] = PlayerOffer[playerid][YN_TYPE_APARTMENT][TargetParams][1];
			PlayerOffer[targetid][YN_TYPE_APARTMENT][TargetParams][1] = GetPVarInt(playerid,"PlayerHouseID");
			PlayerOffer[targetid][YN_TYPE_APARTMENT][TargetTimer] = SetTimerEx("reset_yn",time_clear_offer,false,"ii",targetid,YN_TYPE_APARTMENT);


			SendMes(playerid, C_OFFER, "Вы предложили %s подселиться к Вам", pInfo[targetid][pName]);
			SendMes(targetid, C_OFFER, "%s предложил Вам подселиться к нему в дом", pInfo[playerid][pName]);
			SendClientMessage(targetid, C_OFFER, !"(( Нажмите: {33AA33}Y "c_offer"- согласиться или "colred"N "c_offer"- отказаться ))");


			pTemp[targetid][status_offer_type]++;
			return true;
		}*/
		case D_CONFIRM_DEAL:
		{
			PresedKeyYN(playerid,pTemp[playerid][status_offer_confirm],response);
			return true;
		}
		case D_STATUS_DEAL, D_STATUS_DEAL2:
		{
			if (!response) return true;
			new type_click = D_STATUS_DEAL2-dialogid; // 0 = Y , 1 = N
			new find_str[44];
			strcat(find_str, inputtext);
			//SendClientMessage(playerid, CGRAY2, find_str);

			new pos = strfind(find_str,"[key:", false,17);
			if (pos == -1) return 1;
			strdel(find_str, 0, pos+5);
			//SendClientMessage(playerid,CGRAY2,find_str);

			enum _name_and_type_
			{
				_find_name_[13],
				_find_type
			}
			static  _find_name[YN_TYPE_LAST][_name_and_type_] = {
				{"refill]",0}, // YN_TYPE_REFILL
				{"repair]",1}, // YN_TYPE_REPAIR
				{"debt]",2}, // YN_TYPE_DEBT
				{"contract]",3}, // YN_TYPE_CONTRACT
				{"sellgun]",4}, // YN_TYPE_GUN
				{"selldrugs]",5},// YN_TYPE_DRUGS
				{"changecar]",6}, // YN_TYPE_CAR
				{"changehouse]",7}, // YN_TYPE_HOUSE
				{"sellzone]",8}, // YN_TYPE_ZONE, // территория гетто
				{"propose]",9}, // YN_TYPE_WEDDING  // свадьба
				{"myskill]",10}, // YN_TYPE_SKILL, // showkill
				{"ticket]",11}, // YN_TYPE_TICKET, // штрафы
				{"aparment]",12}, // YN_TYPE_APARTMENT, // подселится в дом
				{"sellbiz]",13}, // YN_TYPE_BUSSINES, // обменятся бизнесами
				{"mcard]",14}, // YN_TYPE_MEDICAL_CARD, // посмотреть мед. карту
				{"dice]",15}, //YN_TYPE_DICE, // Казино /dice
				{"race]", 16}, // YN_TYPE_RACE /setrace
				{"kiss]", 17}, //YN_TYPE_KISS // /kiss
				{"sellsim]", 18}, // YN_TYPE_SIM // /sellsim
				{"pool]", 19}, //YN_TYPE_POOL /pool
				{"gift]", 20},//YN_TYPE_GIFT /sellgift
				{"healaddict]",21},//YN_TYPE_GIFT /healaddict
				{"hrating]", 22}//YN_TYPE_RATING
			};

			new type_select;
			for(new x; x < YN_TYPE_LAST; x++)
			{
				if (strcmp(find_str,_find_name[x][_find_name_],true) == 0)
				{
					type_select = _find_name[x][_find_type];
					break;
				}
			}


			if (type_click)
				PresedKeyYN(playerid,type_select,0);
			else
				OnPlayerConfirmDeal(playerid,type_select);
			return true;
		}
	}
	return false;
}



// команды которые используют подтверждение


CMD:refill(playerid, params[])
{
	if (isnull(params)) return SendClientMessage(playerid,COLOR_WHITE, !"Введите: /refill [ид игрока]");
    if (pInfo[playerid][pJob] != PLAYER_JOB_MECHANIC) return SendClientMessage(playerid, COLOR_GREY, !"Вы не механик!");
	if (pTemp[playerid][gContract] == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, !"У Вас не подписан контракт с заправкой!");
	new id = strval(params);
	if (id < 0 || id > MAX_PLAYERS-1 || id == playerid) return SendClientMessage(playerid, COLOR_GREY, !"Вы ввели не верный ид игрока");
    if (!PlayerInConnected(id) || playerid ==id) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 525) return SendClientMessage(playerid, COLOR_GREY, !"Вы не на эвакуаторе");

	if (!IsPlayerInRangeOfPlayer(7.0, playerid, id)) return SendClientMessage(playerid, COLOR_GREY, !"Игрок далеко от вас");
	if (GetPlayerState(id) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, !"Этот игрок не в автомобиле");

	new refil_cost = GetPVarInt(playerid,"CostBenzMeh");
	if (BusinessInfo[pTemp[playerid][gContract]][bProducts] < 150) {
		SendClientMessage(playerid, COLOR_GREY, !"Недостаточно продуктов (нужно сменить АЗС)!");
		return true;
	}

	if (PlayerOffer[id][YN_TYPE_REFILL][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid,CGRAY2,!"У этого игрока уже есть активное предложение, подождите пока он даст согласие/отклонит");
	
	PlayerOffer[id][YN_TYPE_REFILL][TargetOfferID] = playerid;
	PlayerOffer[id][YN_TYPE_REFILL][TargetPrice] = refil_cost;

	PlayerOffer[id][YN_TYPE_REFILL][TargetTimer] = SetTimerEx("reset_yn",time_clear_offer,false,"ii",id,YN_TYPE_REFILL);

	static refill_player[] = "Механик %s предложил Вам заправить автомобиль на 100 литров за %d$";
	new 
		str_refill[ sizeof(refill_player) + MAX_PLAYER_NAME + 11 ];

	format(str_refill, sizeof(str_refill), refill_player, pInfo[playerid][pName], refil_cost);
	SendClientMessage(id, C_OFFER, str_refill);

	SendClientMessage(id, C_OFFER, !"Подсказка: Используйте: {009900}Y"c_offer" - Согласиться. {FF0000}N"c_offer" - Отклонить.");
	format(str_refill, sizeof str_refill, "Вы предложили игроку %s заправить автомобиль за %d$", pInfo[id][pName], refil_cost);
	SendClientMessage(playerid, C_OFFER, str_refill);

	pTemp[id][status_offer_type]++;

	return 1;
}

CMD:repair(playerid, params[])
{
    if (pInfo[playerid][pJob] != PLAYER_JOB_MECHANIC) return SendClientMessage(playerid, COLOR_GREY, !"Вы не механик!");
	if (sscanf(params, "ud", params[0],params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /repair [id] [цена]");
	if (params[1] < 1 || params[1] > 10000) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя меньше 1, и больше $10000");
    if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (GetPlayerState(params[0]) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, !"Игрок должен быть за рулем ТС");
	if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 525) return SendClientMessage(playerid, COLOR_GREY, !"Вы не на эвакуаторе!");
	if (!IsPlayerInRangeOfPlayer(7.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок далеко от вас");
	
	if (PlayerOffer[ params[0] ][YN_TYPE_REPAIR][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid,CGRAY2,!"У этого игрока уже есть активное предложение, подождите пока он даст согласие/отклонит");
	
	PlayerOffer[params[0]][YN_TYPE_REPAIR][TargetOfferID] = playerid;
	PlayerOffer[params[0]][YN_TYPE_REPAIR][TargetPrice] = params[1];

	PlayerOffer[params[0]][YN_TYPE_REPAIR][TargetTimer] = SetTimerEx("reset_yn",time_clear_offer,false,"ii",params[0],YN_TYPE_REPAIR);

	pTemp[params[0]][status_offer_type]++;
	new
		string_[128]; 
	format(string_, sizeof string_, "Механик %s предложил Вам починить автомобиль за %d$", pInfo[playerid][pName], params[1]);
	SendClientMessage(params[0], C_OFFER, string_);
	SendClientMessage(params[0], C_OFFER, !"Подсказка: Используйте: {009900}Y"c_offer" - Согласиться. {FF0000}N"c_offer" - Отклонить.");

	format(string_, sizeof string_,"Вы предложили игроку %s авторемонт за %d$",pInfo[params[0]][pName],params[1]);
	SendClientMessage(playerid, C_OFFER, string_);

	return 1;
}

CMD:setdebt(playerid, params[])
{
    if (!IsAMafia(playerid)) return 1;
	if (pInfo[playerid][pRank] < 3) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны быть 3 рангом");
	if (sscanf(params, "u",params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /setdebt [id]");
    if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (!IsPlayerInRangeOfPlayer(7.0, playerid,params[0])) return SendClientMessage(playerid,CGRAY2,!"Вы далеко друг от друга");
	if (pInfo[params[0]][pJob] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Данный человек не работает");

	if (PlayerOffer[params[0]][YN_TYPE_DEBT][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid,CGRAY2,!"У этого игрока уже есть активное предложение, подождите пока он даст согласие/отклонит");

	PlayerOffer[ params[0] ][YN_TYPE_DEBT][TargetOfferID]  = playerid; // ид  кто предложил
	PlayerOffer[ params[0] ][YN_TYPE_DEBT][TargetParams][0]   = pInfo[playerid][pMember]; // крыша ид 

	PlayerOffer[ params[0] ][YN_TYPE_DEBT][TargetTimer]  = SetTimerEx("reset_yn",time_clear_offer,false,"ii",params[0],YN_TYPE_DEBT);

	new string_[128];
	format(string_, sizeof string_, "%s предлагает вам Крышу",pInfo[playerid][pName]);
	SendClientMessage(params[0], C_OFFER, string_);
	format(string_, sizeof string_, "%s предлагает крышу %s'у", pInfo[playerid][pName] ,pInfo[params[0]][pName]);
	SendBeside(playerid,COLOR_PURPLE, string_,30.0);
	SendClientMessage(params[0], C_OFFER, !"Используйте: {009900}Y"c_offer" - Принять. {FF0000}N"c_offer" - Отклонить.");
	pTemp[params[0]][status_offer_type]++;

	return 1;
}

CMD:sellgun(playerid,params[])
{
	if (IsPlayerDying(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"В данный момент Вы не можете использовать данную команду");
    if (!IsAGang(playerid)) return SendClientMessage(playerid,CGRAY2,!"Функция доступна только бандам");
	if (pInfo[playerid][pJailTime]) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать в тюрьме");
	if (isnull(params))
	{
	    SendClientMessage(playerid,0xFFFFFFFF,!"Используйте: /sellgun [название оружия] [патроны] [цена] [ид]");
	    return SendClientMessage(playerid,CGRAY2,!"Введите: /gunlist - что бы посмотреть название оружия");
	}
	new name_sellgun[10];
	if (strlen(name_sellgun) >= 10) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params,"s[10]iii",name_sellgun,params[0],params[1],params[2])) return SendClientMessage(playerid,0xFFFFFFFF,!"Введите: /sellgun [оружие] [патроны] [цена] [ид]");
	if (params[0] < 1 || params[0] > 200) return SendClientMessage(playerid,COLOR_GREY, !"Патроны от 1 до 200!");
    if (params[1] < 1 || params[1] > 50000) return SendClientMessage(playerid,COLOR_GREY, !"Цена должна быть от 1$ до 50 000$");
	if (params[2] < 0 || params[2] > MAX_PLAYERS-1)return SendClientMessage(playerid,COLOR_GREY, !"Вы ввели не верный ид игрока");
	if (!PlayerInConnected(params[2])) return SendClientMessage(playerid,COLOR_GREY, !"Игрок оффлайн");
	if (!PlayerInConnected(params[2])) return SendClientMessage(playerid,COLOR_GREY, !"Игрок не авторизирован"); 
	if (GetPlayerState(params[2]) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете сделать оружие в транспорте"); 

	enum _gun_
	{
		gun_name[9],
		gun_id,
		gun_mat
	};
	static const guns_name[7][_gun_] = {
		{"sdpistol",23,1},
		{"deagle",24,3},
		{"shotgun",25,3},
		{"smg",29,2},
		{"ak47",30,3},
		{"m4",31,3},
		{"rifle",33,5}
	};
	new weapon_id,weapon_mat;
	for(new x; x < 7; x++)
	{
		if (strcmp(name_sellgun,guns_name[x][gun_name],true) == 0)
		{
			weapon_id = guns_name[x][gun_id];
			weapon_mat = guns_name[x][gun_mat];
			break;
		}
	}
	if (weapon_id == 0 || weapon_mat == 0) return SendClientMessage(playerid,CGRAY2,!"Неизвестное оружие");
	if (params[0]*weapon_mat > pInfo[playerid][pMats]) return SendClientMessage(playerid,CGRAY2,!"У Вас недостаточно материалов");

	//if( !GetIDOwnerGangZone(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться на своей территории"); 
	if (playerid == params[2])
	{
	    pInfo[playerid][pMats] -= weapon_mat*params[0];
	    GivePlayerWeapon(playerid, weapon_id, params[0]);
	    SetPlayerChatBubble(playerid,"Сделал себе оружие из материалов",0xDD90FFFF,30.0,5000); 
		static mats[] = "Вы сделали себе оружие: %s Осталось материалов: %d";
		new str_m[sizeof(mats)+10];
		format(str_m,sizeof(str_m) ,mats,name_sellgun,pInfo[playerid][pMats]);
		SendClientMessage(playerid,C_OFFER,str_m);
		
		if (weapon_id == 24)
			OnPlayerQuestProgress(playerid, QUEST_GHETTO, QUEST_TASK_GUN,params[0]);

		return 1;
	}
	if (!IsPlayerInRangeOfPlayer(7.0, playerid,params[2])) return SendClientMessage(playerid,CGRAY2,!"Вы далеко друг от друга");

	if (PlayerOffer[ params[2] ][YN_TYPE_GUN][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid,CGRAY2,!"У этого игрока уже есть активное предложение, подождите пока он даст согласие/отклонит");

	PlayerOffer[params[2]][YN_TYPE_GUN][TargetOfferID] = playerid;
	PlayerOffer[params[2]][YN_TYPE_GUN][TargetPrice] = params[1];
	PlayerOffer[params[2]][YN_TYPE_GUN][TargetParams][0] = weapon_id;
	PlayerOffer[params[2]][YN_TYPE_GUN][TargetParams][1] = params[0];
	PlayerOffer[params[2]][YN_TYPE_GUN][TargetParams][2] = weapon_mat*params[0];

	PlayerOffer[params[2]][YN_TYPE_GUN][TargetTimer] = SetTimerEx("reset_yn",time_clear_offer,false,"ii",params[2],YN_TYPE_GUN);

	pTemp[params[2]][status_offer_type]++;

	static sell_guns[] = "Вы предложили игроку %s оружие %s патронов %d цена %d$";
	new str_sell_guns[sizeof(sell_guns)+(-2+MAX_PLAYERS)+11];
	format(str_sell_guns,sizeof(str_sell_guns),sell_guns,pInfo[params[2]][pName],name_sellgun,params[0],params[1]);
	SendClientMessage(playerid,C_OFFER,str_sell_guns);
	format(str_sell_guns,sizeof(str_sell_guns),"%s предложил вам оружие %s патронов %d цена %d",pInfo[playerid][pName],name_sellgun,params[0],params[1]);
	SendClientMessage(params[2],C_OFFER,str_sell_guns);
	SendClientMessage(params[2],C_OFFER,!"Используйте: {009900}Y"c_offer" - Купить. {FF0000}N"c_offer" - Отклонить.");
	return 1;
}

CMD:selldrugs(playerid, params[])
{
    //if (!IsAGang(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не бандит!");
	if (!IsAGang(playerid) && !IsAMafia(playerid) && !IsABiker(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не бандит / мафиози / байкер!");
	if (sscanf(params, "udd", params[0],params[1],params[2])) return SendClientMessage(playerid, COLOR_GRAD2, "Введите: /selldrugs [id] [кол-во] [Цена]");
	if (params[1] < 1 || params[1] > 150) return SendClientMessage(playerid, COLOR_GREY, !"Вес не может быть меньше 1 и больше 150!");
	if (params[2] < 1 || params[2] > 10000) return SendClientMessage(playerid, COLOR_GREY, !"Цена не может быть меньше 1 и больше $10000!");
	if (params[1] > pInfo[playerid][pDrugs]) return SendClientMessage(playerid, COLOR_GREY, !"У вас нет столько наркотиков!");
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден/Вы указали свой ID!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом друг с другом"); 
	if (pInfo[params[0]][pDrugs] + params[1] > GetVIPLimitDrugs(params[0])) {//GetVIPLimitDrugs(playerid) 
		SendMes(playerid, COLOR_GREY, "У %s[%d] не может быть более %d грамм наркотиков", pInfo[params[0]][pName], params[0], GetVIPLimitDrugs(params[0]));
		return 1;
	}

	if (PlayerOffer[ params[0] ][YN_TYPE_DRUGS][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid,CGRAY2,!"У этого игрока уже есть активное предложение, подождите пока он даст согласие/отклонит");
	
	PlayerOffer[params[0]][YN_TYPE_DRUGS][TargetOfferID] = playerid;
	PlayerOffer[params[0]][YN_TYPE_DRUGS][TargetPrice] = params[2];
	PlayerOffer[params[0]][YN_TYPE_DRUGS][TargetParams][0] = params[1];

	PlayerOffer[params[0]][YN_TYPE_DRUGS][TargetTimer] = SetTimerEx("reset_yn",time_clear_offer,false,"ii",params[0],YN_TYPE_DRUGS);

	SendMes(playerid, C_OFFER,"Вы предложили %s купить %d грамм наркоты по цене $%d", pInfo[params[0]][pName],params[1], params[2]);
	SendMes(params[0], C_OFFER,"%s предлагает Вам купить %d грамм наркоты за $%d", pInfo[playerid][pName],params[1],params[2]);
	SendClientMessage(params[0], C_OFFER,"(( Нажмите: {33AA33}Y"c_offer"- согласиться или "colred"N"c_offer"- отказаться ))");

	pTemp[params[0]][status_offer_type]++;
	return 1;
}
CMD:sellgift(playerid, params[]) {
	if (ChristmasInfo[playerid][cBlockGift] > gettime()) {
		SendClientMessage(playerid, COLOR_GREY, !"У Вас заблокирован сбор подарков / обмен / продажа!");
		return 1;
	}
	if (!IsPlayerInDynamicArea(playerid, gAreas[arGreenZone][31])) {
		SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Вы должны находиться на Центральном рынке");
		SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Используйте /gps - [0] Важные места - Центральный рынок");
		return 1;
	}
	if (sscanf(params, "udd",params[0], params[1], params[2])) return SendClientMessage(playerid,COLOR_WHITE, !"Введите: /sellgift [ID] [кол-во] [цена]");
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден/Вы указали свой ID!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом друг с другом");
	if (params[1] < 1 || params[1] > 100) return SendClientMessage(playerid, COLOR_GREY, !"Кол-во не может быть меньше 1 и более 100 за раз!");
	if (params[1] > ChristmasInfo[playerid][cGift]) return SendClientMessage(playerid, COLOR_GREY, !"У вас нет столько новогодних подарков!");
	if (params[2] < 1_000 || params[2] > 10_000_000) return SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Цена не может быть меньше "collime"$1.000 "colwhi"и больше "collime"$10.000.000"); 
	if (PlayerOffer[params[0]][YN_TYPE_GIFT][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, CGRAY2,  !"У этого игрока уже есть предложение!"); 
	if (PlayerOffer[playerid][YN_TYPE_GIFT][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, CGRAY2,  !"У Вас уже есть предложение!"); 

	PlayerOffer[params[0]][YN_TYPE_GIFT][TargetOfferID] = playerid;
	PlayerOffer[params[0]][YN_TYPE_GIFT][TargetPrice] = params[2]; 
	PlayerOffer[params[0]][YN_TYPE_GIFT][TargetParams][0] = params[1];
	PlayerOffer[params[0]][YN_TYPE_GIFT][TargetTimer] = SetTimerEx("reset_yn",time_clear_offer,false,"ii", params[0], YN_TYPE_GIFT); 

	SendMes(playerid, C_OFFER, "Вы предложили %s купить у Вас подарки %d ед. за "collime"$%d", pInfo[params[0]][pName], params[1], params[2]);
	SendMes(params[0], C_OFFER, "%s предлагает Вам купить подарки %d ед. за "collime"$%d", pInfo[playerid][pName], params[1], params[2]);
	SendClientMessage(params[0], C_OFFER,"(( Нажмите: {33AA33}Y"c_offer"- согласиться или "colred"N"c_offer"- отказаться ))");  

	pTemp[params[0]][status_offer_type]++;
	return 1;
}

CMD:sellsim(playerid,params[]) {

	//"Купить SIM-карту\t\t\t[key:sellsim]\n"//YN_TYPE_SIM
	if (!pInfo[playerid][PlayerNumber]) return SendClientMessage(playerid, COLOR_GREY, !"У Вас нет SIM-карты!"); 
	if (!IsPlayerInDynamicArea(playerid, gAreas[arGreenZone][31])) {
		SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Вы должны находиться на Центральном рынке");
		SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Используйте /gps - [0] Важные места - Центральный рынок");
		return 1;
	}
	if (sscanf(params, "ud",params[0], params[1])) return SendClientMessage(playerid,COLOR_WHITE, !"Введите: /sellsim [ID] [цена]");
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден/Вы указали свой ID!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом друг с другом");
	if (params[1] < 10_000 || params[1] > 30_000_000) return SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Цена не может быть меньше "collime"$10.000 "colwhi"и больше "collime"$30.000.000"); 
	if (PlayerOffer[params[0]][YN_TYPE_SIM][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, CGRAY2,  !"У этого игрока уже есть предложение!"); 
	if (PlayerOffer[playerid][YN_TYPE_SIM][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, CGRAY2,  !"У Вас уже есть предложение!"); 

	PlayerOffer[params[0]][YN_TYPE_SIM][TargetOfferID] = playerid;
	PlayerOffer[params[0]][YN_TYPE_SIM][TargetPrice] = params[1]; 
	PlayerOffer[params[0]][YN_TYPE_SIM][TargetTimer] = SetTimerEx("reset_yn",time_clear_offer,false,"ii", params[0], YN_TYPE_SIM); 

	SendMes(playerid, C_OFFER, "Вы предложили %s купить SIM-карту (%d) за "collime"$%d", pInfo[params[0]][pName], pInfo[playerid][PlayerNumber], params[1]);
	SendMes(params[0], C_OFFER, "%s предлагает Вам купить SIM-карту (%d) за "collime"$%d", pInfo[playerid][pName], pInfo[playerid][PlayerNumber], params[1]);
	SendClientMessage(params[0], C_OFFER,"(( Нажмите: {33AA33}Y"c_offer"- согласиться или "colred"N"c_offer"- отказаться ))");  

	pTemp[params[0]][status_offer_type]++;
	return 1;
}

CMD:changecar(playerid,params[])
{
	//if (pInfo[playerid][pHouseID] == -1) return SendClientMessage(playerid, COLOR_GREY, !"У Вас нет дома!");
	if (isnull(params)) return SendClientMessage(playerid,COLOR_WHITE, !"Введите: /changecar [ид игрока] [цена]");
	new V_IDX = GetPlayerVehicleID(playerid);
	if ((!IsValidVehicle(V_IDX))) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы должны находиться в Вашем личном транспорте!");
	if (VehicleInfo[ V_IDX - 1 ][vFraction] != pInfo[playerid][pID] || VehicleInfo[ V_IDX - 1 ][vType] != VEHICLE_TYPE_PLAYER) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы должны находиться в Вашем личном транспорте!");
	if (sscanf(params, "ud", params[0], params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /changecar [ид игрока] [цена]");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (params[1] < 1 || params[1] > 20_000_000) return SendClientMessage(playerid, COLOR_GREY, !"Доплата не может быть менее $1 и более $20.000.000");
	if (PlayerOffer[ playerid ][YN_TYPE_CAR][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid,CGRAY2,!"Вы уже предложили кому-то купить Ваш транспорт");
	if (PlayerOffer[ params[0] ][YN_TYPE_CAR][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid,CGRAY2,!"У этого игрока уже есть активное предложение, подождите пока он даст согласие/отклонит");
	new car_owner = GetPlayerVehicleID(params[0]);
	if (Iter_Count(PlayerListVehicle[params[0]]) != 0)
	{
		if (car_owner != 0 && VehicleInfo[ car_owner - 1 ][vFraction] == pInfo[params[0]][pID] && VehicleInfo[ car_owner - 1 ][vType] == VEHICLE_TYPE_PLAYER){
			PlayerOffer[playerid][YN_TYPE_CAR][TargetParams][0] = car_owner; // продавцу записываем ид авто который получит взамен
		}
		else {

			if (GetPlayerVehicleCount(params[0], TYPE_CAR) >= getPlayerMaxCarsNumber(params[0])) 
			{
				SendClientMessage(params[0], COLOR_GRAD1, !"Вы должны находиться в Вашем личном транспорте!");
				SendClientMessage(playerid, COLOR_GRAD1, !"Игрок которому вы предлагаете обмен автомобилем должен находиться личном транспорте!");
				return 1;
			}
			PlayerOffer[playerid][YN_TYPE_CAR][TargetParams][0] = 0;
		}
	}
	else PlayerOffer[playerid][YN_TYPE_CAR][TargetParams][0] = 0;
	
	PlayerOffer[params[0]][YN_TYPE_CAR][TargetOfferID] = playerid; // ид  кто предложил
	PlayerOffer[params[0]][YN_TYPE_CAR][TargetPrice] = params[1];// цена предложения
	PlayerOffer[params[0]][YN_TYPE_CAR][TargetParams][0] = V_IDX; // ид авто которого предложили купить
	PlayerOffer[params[0]][YN_TYPE_CAR][TargetParams][1] = 1;//  1 кому предложили
	PlayerOffer[params[0]][YN_TYPE_CAR][TargetParams][2] = 0;

	PlayerOffer[playerid][YN_TYPE_CAR][TargetOfferID] = params[0]; // ид  кто предложил
	//PlayerOffer[playerid][YN_TYPE_CAR][TargetParams][0] =  0; // ид дома который отдает
	PlayerOffer[playerid][YN_TYPE_CAR][TargetParams][1] =  0;//  0 кто предложил
	PlayerOffer[playerid][YN_TYPE_CAR][TargetParams][2] = 0;
	
	 
	PlayerOffer[params[0]][YN_TYPE_CAR][TargetTimer] = SetTimerEx("reset_yn",time_clear_offer,false,"ii",params[0],YN_TYPE_CAR);
	/*if (IsABoat(V_IDX) && pInfo[targetid][PlayerSpawn] == 4) {
				if (pInfo[targetid][pMember] != 0) {
					pInfo[targetid][PlayerSpawn] = 2;
				} else {
					pInfo[targetid][PlayerSpawn] = 0;
				}
			} 
			if (VehicleInfo[ V_IDX - 1 ][vModel] == 508 && pInfo[targetid][PlayerSpawn] == 3) {
				if (pInfo[targetid][pMember] != 0) {
					pInfo[targetid][PlayerSpawn] = 2;
				} else {
					pInfo[targetid][PlayerSpawn] = 0;
				}
			}*/
	
	new 
		string_[100]; 
	format(string_, sizeof string_, "Игрок %s предложил Вам купить/обмен личным транспортом",pInfo[playerid][pName]);
	SendClientMessage(params[0], C_OFFER, string_);
	format(string_, sizeof string_, "Вы предложили игроку %s купить/обмен личным транспортом",pInfo[params[0]][pName]);
	SendClientMessage(playerid, C_OFFER, string_);
	
	SendClientMessage(playerid, C_OFFER, !"Используйте: {009900}Y"c_offer" - Подтвердить. {FF0000}N"c_offer" - Отклонить.");
	SendClientMessage(params[0], C_OFFER, !"Используйте: {009900}Y"c_offer"- Купить/Обмен. {FF0000}N"c_offer"- Отклонить.");

	pTemp[params[0]][status_offer_type]++;
	pTemp[playerid][status_offer_type]++;

	return 1;
}


CMD:changehouse(playerid, params[])
{
    if (pInfo[playerid][pHouseID] == -1) return SendClientMessage(playerid, COLOR_GREY, !"У Вас нет дома!");
    new bouse = pInfo[playerid][pHouseID], string_[128];
	if (!HouseInfo[bouse][hValue]) {
		SendClientMessage(playerid, COLOR_GREY, !"Дом был куплен за сертификат, используйте /sellhouse");
        return 1;
	}
	if (sscanf(params, "ud", params[0],params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /changehouse [id] [цена]");
	if (!PlayerInConnected(params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (params[1] < 1 || params[1] > 100_000_000) return SendClientMessage(playerid, COLOR_GREY, !"Цена не может быть менее $1 и более $100.000.000");
	if (!IsPlayerInRangeOfPlayer(7.0, playerid,params[0]) || playerid == params[0]) return SendClientMessage(playerid,CGRAY2,!"Вы далеко друг от друга");
	new idx = HouseInfo[bouse][hIntID];
	if ((!IsPlayerInRangeOfPoint(playerid, 10, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2]) || GetPlayerVirtualWorld(playerid) != bouse+50)
		&& !IsPlayerInRangeOfPoint(playerid, 4.0, HouseInfo[bouse][hEnter][0], HouseInfo[bouse][hEnter][1], HouseInfo[bouse][hEnter][2]))
		return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться возле, или внутри вашего дома");
	
	if (PlayerOffer[ playerid ][YN_TYPE_HOUSE][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid,CGRAY2,!"У этого игрока уже есть активное предложение, подождите пока он даст согласие/отклонит");
	if (PlayerOffer[ params[0] ][YN_TYPE_HOUSE][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid,CGRAY2,!"У этого игрока уже есть активное предложение, подождите пока он даст согласие/отклонит");
	
	PlayerOffer[params[0]][YN_TYPE_HOUSE][TargetOfferID] = playerid; // ид  кто предложил
	PlayerOffer[params[0]][YN_TYPE_HOUSE][TargetPrice] = params[1];// цена предложения
	PlayerOffer[params[0]][YN_TYPE_HOUSE][TargetParams][0] =  bouse; // ид дома который предложили
	PlayerOffer[params[0]][YN_TYPE_HOUSE][TargetParams][1] =  1;//  1 кому предложили
	PlayerOffer[params[0]][YN_TYPE_HOUSE][TargetParams][2] = 0;

	PlayerOffer[playerid][YN_TYPE_HOUSE][TargetOfferID] = params[0]; // ид  кто предложил
	//PlayerOffer[playerid][YN_TYPE_HOUSE][TargetPrice] = params[1];// цена предложения
	PlayerOffer[playerid][YN_TYPE_HOUSE][TargetParams][0] =  -1; // ид дома который отдает
	PlayerOffer[playerid][YN_TYPE_HOUSE][TargetParams][1] =  0;//  0 кто предложил
	PlayerOffer[playerid][YN_TYPE_HOUSE][TargetParams][2] = 0;

	PlayerOffer[params[0]][YN_TYPE_HOUSE][TargetTimer] = SetTimerEx("reset_yn",time_clear_offer,false,"ii",params[0],YN_TYPE_HOUSE);  

	PlayerOffer[playerid][YN_TYPE_HOUSE][TargetParams][0] =  pInfo[params[0]][pHouseID]; 
	if (PlayerOffer[playerid][YN_TYPE_HOUSE][TargetParams][0] < 1) 
		PlayerOffer[playerid][YN_TYPE_HOUSE][TargetParams][0] = -1;


	pTemp[params[0]][status_offer_type]++;
	pTemp[playerid][status_offer_type]++;

	if (PlayerOffer[playerid][YN_TYPE_HOUSE][TargetParams][0]  != -1)
	{
		format(string_,sizeof(string_), "Вы предложили %s обменяться домами. Доплата: $%d",pInfo[params[0]][pName], params[1]);
		SendClientMessage(playerid,C_OFFER,string_);
	    format(string_,sizeof(string_), "%s предлагает вам обменяться домами. Ваша доплата: $%d",pInfo[playerid][pName], params[1]);
		SendClientMessage(params[0],C_OFFER,string_);
	}
	else
	{
	    format(string_,sizeof(string_), "Вы предложили %s купить ваш дом. Стоимость: $%d",pInfo[params[0]][pName], params[1]);
		SendClientMessage(playerid, C_OFFER,string_);
	    format(string_,sizeof(string_), "%s предлагает вам купить его дом. Стоимость: $%d",pInfo[playerid][pName], params[1]);
		SendClientMessage(params[0], C_OFFER,string_);
	}
	SendClientMessage(playerid, C_OFFER, !"Используйте: {009900}Y"c_offer" - Подтвердить. {FF0000}N"c_offer"- Отклонить.");
	SendClientMessage(params[0], C_OFFER, !"Используйте: {009900}Y"c_offer"- Согласен. {FF0000}N"c_offer" - Отклонить.");
	return 1;
}

CMD:sellzone(playerid, params[])
{
	if (!IsAGang(playerid)) return SendClientMessage(playerid,CGRAY2,!"Функция доступна только бандам");
	if (isnull(params)) return SendClientMessage(playerid,0xFFFFFFFF,!"Используйте: /sellzone [ид] [цена] ");
	new Float:xxp,Float:yyp,Float:zzp,i;
    GetPlayerPos(playerid, xxp, yyp, zzp);
	for(new idx = 1; idx <= TOTALGZ; idx++)
    {
        if ((xxp <= GZInfo[idx][gCoords][2] && xxp >= GZInfo[idx][gCoords][0]) && (yyp <= GZInfo[idx][gCoords][3] && yyp >= GZInfo[idx][gCoords][1]))
		{
		    if (GZInfo[idx][gFrakVlad] == pInfo[playerid][pMember])
		    {
			    i = idx;
		    }
			break;
		}
	}
	if (i == 0) return SendClientMessage(playerid,CGRAY2,!"Вы должны находиться на своей территории");
	if (pInfo[playerid][pLeader] != GZInfo[i][gFrakVlad]) return SendClientMessage(playerid, COLOR_GRAD1, !"Вы не на своей территории!");
	if (GZInfo[i][gTimer] != 0) return SendClientMessage(playerid, COLOR_GRAD1, !"Идет захват данной территории!");
	if (GZInfo[i][gID] == 47 || GZInfo[i][gID] == 35 || GZInfo[i][gID] == 18 || GZInfo[i][gID] == 59 || GZInfo[i][gID] == 1) return SendClientMessage(playerid, COLOR_GREY, !"Данная территория прилегает к респавну, продажа запрещена!");
	if (sscanf(params, "ud",params[0],params[1])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /sellzone [id] [цена]");
	if (!IsAGang(params[0]))return SendClientMessage(playerid, COLOR_GREY, !"Территорию возможно продать только бандиту.");
	if (params[1] < 50000 || params[1] > 500000) return SendClientMessage(playerid, COLOR_GREY, !"Цена должна быть: от 50000 до 500000!");
	if (!PlayerInConnected(params[0]) || playerid == params[0] || pInfo[playerid][pMember] == pInfo[params[0]][pMember]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Игрок далеко от вас");
	if (crimeDiplomation[capture_band(pInfo[playerid][pMember])][capture_band(GZInfo[i][gFrakVlad])] != sDIP_ALLIANCE) return SendClientMessage(playerid, COLOR_LI_RED, !"[Дипломатия] "colwhi"С данной бандой не заключен союз");
	if (PlayerOffer[ params[0] ][YN_TYPE_ZONE][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid,CGRAY2,!"У этого игрока уже есть активное предложение, подождите пока он даст согласие/отклонит");
	
	PlayerOffer[ params[0] ][YN_TYPE_ZONE][TargetOfferID] = playerid;
	PlayerOffer[ params[0] ][YN_TYPE_ZONE][TargetPrice] = params[1];
	PlayerOffer[ params[0] ][YN_TYPE_ZONE][TargetParams][0] = i;

	PlayerOffer[params[0]][YN_TYPE_ZONE][TargetTimer] = SetTimerEx("reset_yn",time_clear_offer,false,"ii",params[0],YN_TYPE_ZONE);

	pTemp[ params[0] ][status_offer_type]++;

	SendMes(playerid, C_OFFER, "Вы предложили %s купить территорию за "collime"$%d", pInfo[params[0]][pName], params[1]);
	SendMes(params[0], C_OFFER, "%s предлагает Вам купить территорию за "collime"$%d", pInfo[playerid][pName], params[1]);
	SendClientMessage(params[0], C_OFFER, !"(( Нажмите: {33AA33}Y"c_offer" - чтобы купить территорию или "colred"N"c_offer" - отказаться ))");
	return 1;
}


CMD:propose(playerid, params[])
{
    if (kLibGetPlayerMoney(playerid) < 100000) return SendClientMessage(playerid, COLOR_GREY, !"Вам нужно 100.000 на свадьбу!");
    if (!IsPlayerInRangeOfPoint(playerid, 20, -1968.6589,1119.4569,1333.0275)) return SendClientMessage(playerid, COLOR_GREY, !"Команду можно использовать только в церкви.");
	if (!GetString(pInfo[playerid][pMarriedTo],"-")) return SendClientMessage(playerid, COLOR_GREY, !"Вы уже женаты!");
	if (sscanf(params, "u", params[0])) return scm(playerid, COLOR_WHITE, !"Введите: /propose [id]");
    if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (!GetString(pInfo[params[0]][pMarriedTo],"-")) return SendClientMessage(playerid, COLOR_GREY, !"Человек уже состоит в браке!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Человек не рядом с вами!");

	if (PlayerOffer[ params[0] ][YN_TYPE_WEDDING][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid,CGRAY2,!"У этого игрока уже есть активное предложение, подождите пока он даст согласие/отклонит");
	
	PlayerOffer[params[0]][YN_TYPE_WEDDING][TargetOfferID] = playerid;
	PlayerOffer[params[0]][YN_TYPE_WEDDING][TargetTimer] = SetTimerEx("reset_yn",time_clear_offer,false,"ii",params[0], YN_TYPE_WEDDING);

	SendMes(playerid, C_OFFER, "Вы предложили руку и сердце %s.",pInfo[params[0]][pName]);
	SendMes(params[0], C_OFFER,"%s предлагает вам руку и сердце. (( Нажмите: {33AA33}Y"c_offer" - согласиться или "colred"N"c_offer" - отказаться ))",pInfo[playerid][pName]);

	pTemp[params[0]][status_offer_type]++;

	return 1;
}

CMD:myskill(playerid, params[])
{ 
	if (isnull(params)) {
	    show_skill(playerid,playerid);
 		SendClientMessage(playerid,COLOR_WHITE,!"Введите: /myskill [ид игрока] - Показать выписку другому человеку");
 		return 1;
 	}
	new id = strval(params);
	if (!PlayerInConnected(id)) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, id)) return SendClientMessage(playerid, COLOR_GREY, !"Игрок должен находиться рядом с вами");

	if (PlayerOffer[ id ][YN_TYPE_SKILL][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid,CGRAY2, !"У этого игрока уже есть активное предложение, подождите пока он даст согласие/отклонит");
	
	PlayerOffer[id][YN_TYPE_SKILL][TargetOfferID] = playerid;
	PlayerOffer[id][YN_TYPE_SKILL][TargetTimer] = SetTimerEx("reset_yn",time_clear_offer,false,"ii",id,YN_TYPE_SKILL);

	SendMes(playerid,C_OFFER, "Вы предложили %s посмотреть ваши навыки владением оружия",pInfo[id][pName]);
	SendMes(id,C_OFFER, "%s предлагает Вам посмотреть его навыки владения оружием.", pInfo[playerid][pName]);
	SendClientMessage(id,C_OFFER,!"(( Нажмите: {33AA33}Y"c_offer" - согласиться или "colred"N"c_offer" - отказаться ))");
	
	pTemp[ id ][status_offer_type]++;

	return 1;
}
CMD:hrating(playerid, params[])
{ 
	if (isnull(params)) {
	    ShowRating(playerid, playerid);
 		SendClientMessage(playerid, COLOR_WHITE,!"Введите: /hrating [ид игрока] - Показать рейтинг другому человеку");
 		return 1;
 	}
	new id = strval(params);
	if (!PlayerInConnected(id)) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, id)) return SendClientMessage(playerid, COLOR_GREY, !"Игрок должен находиться рядом с вами");
	if (id == playerid) {
	    ShowRating(playerid, playerid);
 		SendClientMessage(playerid, COLOR_WHITE,!"Введите: /hrating [ид игрока] - Показать рейтинг другому человеку");
 		return 1;
 	}
	if (PlayerOffer[ id ][YN_TYPE_RATING][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid,CGRAY2, !"У этого игрока уже есть активное предложение, подождите пока он даст согласие/отклонит");
	
	PlayerOffer[id][YN_TYPE_RATING][TargetOfferID] = playerid;
	PlayerOffer[id][YN_TYPE_RATING][TargetTimer] = SetTimerEx("reset_yn",time_clear_offer,false,"ii",id,YN_TYPE_RATING); 
	SendMes(playerid, C_OFFER, "Вы предложили %s ознакомиться с Вашим рейтингом", pInfo[id][pName]);
	SendMes(id, C_OFFER, "%s предлагает Вам ознакомиться с его рейтинг", pInfo[playerid][pName]);
	SendClientMessage(id, C_OFFER, !"(( Нажмите: {33AA33}Y"c_offer" - согласиться или "colred"N"c_offer" - отказаться ))");
	
	pTemp[ id ][status_offer_type]++;

	return 1;
}

CMD:ticket(playerid, params[])
{
	if (!IsACop(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не полицейский!");
	if (strlen(params[2]) >= 32) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали слишком много символов!");
	if (sscanf(params, "uds[32]",params[0],params[1],params[2])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /ticket [id] [цена] [причина]");
	if (params[1] < 1 || params[1] > 10000) return SendClientMessage(playerid, COLOR_GREY, !"Штраф не должен привышать 10000 и не должен быть меньше 0 $!");
	if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return 1;
	if (kLibGetPlayerMoney(params[0]) < params[1]) return SendClientMessage(playerid, COLOR_GRAD1, !"У этого человека нет столько денег!");

	if (PlayerOffer[ params[0] ][YN_TYPE_TICKET][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid,CGRAY2,!"У этого игрока уже есть неоплаченный штраф");

	PlayerOffer[params[0]][YN_TYPE_TICKET][TargetOfferID] = playerid;
	PlayerOffer[params[0]][YN_TYPE_TICKET][TargetPrice] = params[1];
	PlayerOffer[params[0]][YN_TYPE_TICKET][TargetTimer] = SetTimerEx("reset_yn",time_clear_offer,false,"ii",params[0],YN_TYPE_TICKET);

	SendMes(playerid, C_OFFER, "Вы выписали штраф в размере $%d %s. Причина: %s",params[1],pInfo[params[0]][pName],params[2]);
	SendMes(params[0], C_OFFER, "Офицер %s выписал вам штраф в размере $%d. Причина: %s",pInfo[playerid][pName],params[1],params[2]);
	SendClientMessage(params[0], C_OFFER, !"(( Нажмите: {33AA33}Y"c_offer" - чтобы оплатить штраф или "colred"N"c_offer" - отказаться ))");

	pTemp[ params[0] ][status_offer_type]++;

	return 1;
}

CMD:medcard(playerid, params[]) {
	new targetid;
	if (sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /medcard [id]");
	if (!PlayerInConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
    if (!IsPlayerInRangeOfPlayer(8.0, playerid, targetid) || GetPlayerState(targetid) == PLAYER_STATE_SPECTATING) return true;
	if (!MedcardInfo[playerid][pMedcardID]) return SendClientMessage(playerid, COLOR_GREY, !"У вас нет медицинской карты!");
	if (targetid == playerid) {
		MeAction(playerid, "просматривает свою мед. карту", SELECT_ACTION_IN_BUBBLE);
		ShowMedcard(playerid, playerid);
	}
	else {
		if (PlayerOffer[ targetid ][YN_TYPE_MEDICAL_CARD][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, CGRAY2, !"У этого игрока уже есть предложение");

		PlayerOffer[targetid][YN_TYPE_MEDICAL_CARD][TargetOfferID] = playerid;
		PlayerOffer[targetid][YN_TYPE_MEDICAL_CARD][TargetTimer] = SetTimerEx("reset_yn",time_clear_offer,false,"ii",targetid,YN_TYPE_MEDICAL_CARD);

		new temp_str[44+MAX_PLAYER_NAME];

		format(temp_str,sizeof(temp_str),"Вы предложили %s посмотреть мед. карту.",pInfo[targetid][pName]);
		SendClientMessage(playerid,C_OFFER,temp_str);

		format(temp_str,sizeof(temp_str),"%s предлагает Вам посмотреть его мед. карту.", pInfo[playerid][pName]);
		SendClientMessage(targetid,C_OFFER,temp_str);
		SendClientMessage(targetid,C_OFFER, !"(( Нажмите: {33AA33}Y"c_offer" - чтобы посмотреть или "colred"N"c_offer" - отказаться ))");
		pTemp[targetid][status_offer_type]++;
	} 
	return true;
}
CMD:kiss(playerid, params[]) { 
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
	new 
		targetid;
	if (sscanf(params,"u", targetid) || targetid == playerid) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /kiss [playerid]");
	if (!PlayerInConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!"); 
	if (!IsPlayerInRangeOfPlayer(4.0, playerid, targetid) || GetPlayerVirtualWorld(targetid) != GetPlayerVirtualWorld(playerid)) 
		return SendClientMessage(playerid, COLOR_GREY, !"Игрок должен находиться рядом с вами"); 
	if (GetPlayerState(targetid) != PLAYER_STATE_ONFOOT) return 1;

	if (PlayerOffer[targetid][YN_TYPE_KISS][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, CGRAY2,  !"У этого игрока уже есть предложение!"); 
	if (PlayerOffer[playerid][YN_TYPE_KISS][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, CGRAY2,  !"У Вас уже есть предложение!");

	PlayerOffer[targetid][YN_TYPE_KISS][TargetOfferID] = playerid;
	PlayerOffer[targetid][YN_TYPE_KISS][TargetTimer] = SetTimerEx("reset_yn",time_clear_offer,false,"ii", targetid, YN_TYPE_KISS); 

	SendMes(playerid, C_OFFER, "Вы предложили %s поцелуй", pInfo[targetid][pName]);
	SendMes(targetid, C_OFFER, "%s предлагает Вам поцелуй", pInfo[playerid][pName]);
	SendClientMessage(targetid, C_OFFER, !"(( Нажмите: {33AA33}Y"c_offer" - согласиться или "colred"N"c_offer" - отказаться))");

	pTemp[targetid][status_offer_type]++;  
	return 1;
} //YN_TYPE_POOL

CMD:pool(playerid, params[])  {
	if (!IsPlayerNearPoolTable(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом с игровым столом!");
	new targetid, bet;
	if (sscanf(params, "ud", targetid, bet) || !(CASINO_DICE_MIN_BET <= bet <= CASINO_DICE_MAX_BET) || targetid == playerid)
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /pool [id игрока] [ставка] ("#CASINO_DICE_MIN_BET" - "#CASINO_DICE_MAX_BET")");
	if (!PlayerInConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, targetid) || GetPlayerState(targetid) == PLAYER_STATE_SPECTATING) return true;
	if (PlayerOffer[targetid][YN_TYPE_POOL][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, CGRAY2,  !"У этого игрока уже есть активная игра!");

	if (PlayerOffer[playerid][YN_TYPE_POOL][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, CGRAY2,  !"У вас уже есть активная игра!");
	
	if (kLibGetPlayerMoney(playerid) < bet || kLibGetPlayerMoney(targetid) < bet) 
		return SendClientMessage(playerid, COLOR_GREY, !"У вас или игрока недостаточно средств!");

	if (gettime() < PlayerOffer[ playerid ][YN_TYPE_POOL][TargetParams][0])
		return SendClientMessage(playerid, COLOR_GREY, !"Нельзя так часто предлагать.");

	PlayerOffer[ targetid ][YN_TYPE_POOL][TargetOfferID] = playerid;
	PlayerOffer[ targetid ][YN_TYPE_POOL][TargetPrice] = bet;
	PlayerOffer[ playerid ][YN_TYPE_POOL][TargetParams][0] = gettime() + 3;

	PlayerOffer[ playerid ][YN_TYPE_POOL][TargetOfferID] = targetid; // игра активна


	SendMes(playerid, C_OFFER, "Вы предложили %s сыграть в бильярд на "collime"$%i", pInfo[targetid][pName], bet);
	SendMes(targetid, C_OFFER, "%s предлагает Вам сыграть в бильярд на "collime"$%i", pInfo[playerid][pName], bet);
	SendClientMessage(targetid, C_OFFER,"(( Нажмите: {33AA33}Y"c_offer" - согласиться или "colred"N"c_offer" - отказаться))");

	pTemp[targetid][status_offer_type]++;
	return 1;
}
CMD:dice(playerid, params[])  {
	if (!IsPlayerNearDiceTable(playerid))
		return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом с игровым столом!");
	new targetid, bet;
	if (sscanf(params, "ud", targetid, bet) || !(CASINO_DICE_MIN_BET <= bet <= CASINO_DICE_MAX_BET) || targetid == playerid)
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /dice [id игрока] [ставка] ("#CASINO_DICE_MIN_BET" - "#CASINO_DICE_MAX_BET")");
	if (!PlayerInConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, targetid) || GetPlayerState(targetid) == PLAYER_STATE_SPECTATING) return true;
	if (PlayerOffer[targetid][YN_TYPE_DICE][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, CGRAY2,  !"У этого игрока уже есть активная игра!");

	if (PlayerOffer[playerid][YN_TYPE_DICE][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, CGRAY2,  !"У вас уже есть активная игра!");
	
	if (kLibGetPlayerMoney(playerid) < bet || kLibGetPlayerMoney(targetid) < bet) 
		return SendClientMessage(playerid, COLOR_GREY, !"У вас или игрока недостаточно средств!");

	if (gettime() < PlayerOffer[ playerid ][YN_TYPE_DICE][TargetParams][0])
		return SendClientMessage(playerid, COLOR_GREY, !"Нельзя так часто предлагать.");

	PlayerOffer[ targetid ][YN_TYPE_DICE][TargetOfferID] = playerid;
	PlayerOffer[ targetid ][YN_TYPE_DICE][TargetPrice] = bet;
	PlayerOffer[ playerid ][YN_TYPE_DICE][TargetParams][0] = gettime() + 3;

	PlayerOffer[ playerid ][YN_TYPE_DICE][TargetOfferID] = targetid; // игра активна


	SendMes(playerid, C_OFFER, "Вы предложили %s сыграть в кости на $%i.", pInfo[targetid][pName], bet);
	SendMes(targetid, C_OFFER, "%s предлагает Вам сыграть в кости на $%i.", pInfo[playerid][pName], bet);
	SendClientMessage(targetid, C_OFFER,"(( Нажмите: {33AA33}Y"c_offer" - согласиться или "colred"N"c_offer" - отказаться))");

	pTemp[targetid][status_offer_type]++;
	return 1;
}
CMD:setmap(playerid)
{
	new distance,
		str_[128];
	t_string[0] = EOS;
	strcat(t_string, "[№] Название\tДистанция\n");
	for(new i = 0; i < sizeof(RaceMapName); i++)
	{
		distance = floatround(floatsqroot(floatpower(RaceCheckpoint[i][0] - pTemp[playerid][tPos][0], 2) + floatpower(RaceCheckpoint[i][1] - pTemp[playerid][tPos][1], 2) + floatpower(RaceCheckpoint[i][2] - pTemp[playerid][tPos][2], 2)));
		format(str_, sizeof str_, "[%d] %s\t%d м.\n", i, RaceMapName[i], distance);
		strcat(t_string, str_);
	}
	ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Список: "colwhi"Точек финиша", t_string, "Закрыть", "");
	return 1;
}
CMD:setrace(playerid,params[]) { 
	new 
		targetid, money, map_;
	if (sscanf(params,"udd", targetid, map_, money) || !(0 <= map_ <= sizeof(RaceCheckpoint)) || !(RACE_RATE_MIN_MONEY <= money <= RACE_RATE_MAX_MONEY) || targetid == playerid) 
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /setrace [id игрока] [id карты (/setmap)] [ставка]");
	if (!PlayerInConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, targetid) || GetPlayerVirtualWorld(targetid) != GetPlayerVirtualWorld(playerid)) 
		return SendClientMessage(playerid, COLOR_GREY, !"Игрок должен находиться рядом с вами");
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, !"Вы не за рулем машины");
	if (GetPlayerState(targetid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, !"Игрок не за рулем машины");
	if (PlayerOffer[targetid][YN_TYPE_RACE][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, CGRAY2,  !"У этого игрока уже есть активная гонка!");

	if (PlayerOffer[playerid][YN_TYPE_RACE][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid, CGRAY2,  !"У Вас уже есть активная гонка!");

	if (kLibGetPlayerMoney(playerid) < money || kLibGetPlayerMoney(targetid) < money) 
		return SendClientMessage(playerid, COLOR_GREY, !"У Вас или игрока недостаточно средств!");

	if (gettime() < PlayerOffer[ playerid ][YN_TYPE_RACE][TargetParams][0])
		return SendClientMessage(playerid, COLOR_GREY, !"Нельзя так часто предлагать.");

 
	PlayerOffer[ targetid ][YN_TYPE_RACE][TargetOfferID] = playerid;
	PlayerOffer[ targetid ][YN_TYPE_RACE][TargetPrice] = money;
	pTemp[playerid][tRaceMoney] = pTemp[targetid][tRaceMoney] = money;
	PlayerOffer[ playerid ][YN_TYPE_RACE][TargetParams][0] = gettime() + 3;
	PlayerOffer[ playerid ][YN_TYPE_RACE][TargetParams][1] = map_;


	PlayerOffer[ playerid ][YN_TYPE_RACE][TargetOfferID] = targetid; // игра активна


	SendMes(playerid, C_OFFER, "Вы предложили %s гонку на "collime"$%i"c_offer", точка финиша: "colred"%s", pInfo[targetid][pName], money, RaceMapName[map_]);
	SendMes(targetid, C_OFFER, "%s предлагает Вам гонку на "collime"$%i"c_offer", точка финиша: "colred"%s", pInfo[playerid][pName], money, RaceMapName[map_]);
	SendClientMessage(targetid, C_OFFER, !"(( Нажмите: {33AA33}Y"c_offer" - согласиться или "colred"N"c_offer" - отказаться))");

	pTemp[targetid][status_offer_type]++; 
	return 1;
}

CMD:healaddict(playerid, params[])
{
	if (!IsAMedic(playerid) && pTemp[playerid][tDutyWork])
		return SendClientMessage(playerid, COLOR_GREY, !"Вам недоступна данная команда или Вы не начали рабочий день!");
	if (sscanf(params, "ud", params[0], params[1]))  return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /healaddict [id/name] [цена]");
    if (params[1] < 2500 || params[1] > 12000) return SendClientMessage(playerid, COLOR_GREY, !"Цена должна быть от 2500$ до 12000$");
    if(!IsPlayerInMedical(playerid) ) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться в больнице!");
    if (!PlayerInConnected(params[0]) || playerid == params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден/Вы указали свой ID!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом друг с другом"); 
    if (seans[params[0]] == true) return SendClientMessage(playerid,COLOR_GREEN, !"Следующий сеанс можно провести через час");
    if (pInfo[params[0]][pAddiction] < 1000) return SendClientMessage(playerid,COLOR_GREEN, !"У пациента меньше чем 1000 зависимости");

    if (PlayerOffer[ params[0] ][YN_TYPE_HEALADDICT][TargetOfferID] != INVALID_PLAYER_ID) return SendClientMessage(playerid,CGRAY2,!"У этого игрока уже есть активное предложение, подождите пока он даст согласие/отклонит");

	PlayerOffer[params[0]][YN_TYPE_HEALADDICT][TargetOfferID] = playerid;
	PlayerOffer[params[0]][YN_TYPE_HEALADDICT][TargetTimer] = SetTimerEx("reset_yn",time_clear_offer,false,"ii",params[0],YN_TYPE_HEALADDICT);

	SendMes(playerid, C_OFFER,"Вы предложили %s провести сеанс от наркозависимости по цене $%d", pInfo[params[0]][pName],params[1], params[2]);
	SendMes(params[0], C_OFFER,"%s предлагает Вам провести сеанс от наркозависимости по цене $%d", pInfo[playerid][pName],params[1], params[2]);
	SendClientMessage(params[0], C_OFFER,"(( Нажмите: {33AA33}Y"c_offer"- согласиться или "colred"N"c_offer"- отказаться ))");

	pTemp[params[0]][status_offer_type]++;
	new
        Float: c_Seans = (pInfo[params[0]][pAddiction] / 500) > 0 ? pInfo[params[0]][pAddiction] / 500 + 1: pInfo[params[0]][pAddiction] / 500;	
	//SendMes(params[0], COLOR_GREEN, "Доктор %s провёл с вами сеанс от наркозависимости",pInfo[playerid][pName]);
    SendMes(playerid, COLOR_GREEN, "Вы провели сеанс от наркозависимости с %s по цене $%d.",pInfo[params[0]][pName],params[1]);
	SendMes(playerid, COLOR_GREEN, "Необходимо провести %d сеансов с этим человеком, до полного выздоровления!", floatround(c_Seans, floatround_floor));
    SendMes(params[0], COLOR_GREEN, "Вам провели сеанс от наркозависимости человек: %s по цене $%d.",pInfo[playerid][pName],params[1]);
	SendMes(params[0], COLOR_GREEN, "Необходимо провести %d сеансов с вами, до полного выздоровления!", floatround(c_Seans, floatround_floor));
	//pInfo[playerid][pCash] -= 2500;pInfo[playerid][pCash] += 2500;
	return 1;
}