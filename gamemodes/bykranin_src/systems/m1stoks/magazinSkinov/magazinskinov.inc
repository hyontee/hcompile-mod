//>> Файл: bykranin_src/systems/m1stoks/magazinSkinov/magazinskinov.inc  (645 строк)
//>> Тема: самостоятельные модули (были отдельными файлами в исходном проекте)
//>> Внутри: MagazinSkinov_GetCatalogCount, MagazinSkinov_GetCatalogSkinId, MagazinSkinov_GetCatalogPrice, MagazinSkinov_CreateTextDraws, MagazinSkinov_Init, MagazinSkinov_ResetPlayer, MagazinSkinov_DestroyPricePTD
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
// BEGIN INLINED: modules/m1stoks/magazinSkinov/magazinskinov.inc
#if defined _magazinskinov_included
	#endinput
#endif
#define _magazinskinov_included

#define MSKIN_TD_COUNT          15

#define MSKIN_TD_BTN_LEFT       3
#define MSKIN_TD_BTN_RIGHT      8
#define MSKIN_TD_BTN_BUY_BOX    11
#define MSKIN_TD_BTN_EXIT_BOX   12
#define MSKIN_TD_BTN_BUY        13
#define MSKIN_TD_BTN_EXIT       14

#define MSKIN_PRICE_BOX_X1      249.6667
#define MSKIN_PRICE_BOX_X2      392.0000
#define MSKIN_PRICE_BOX_Y       379.5701
#define MSKIN_PRICE_BOX_H       1.4665
#define MSKIN_PRICE_PTD_X       320.8333
#define MSKIN_PRICE_PTD_Y       381.0000

#define MSKIN_REG_POS_X         1200.4557
#define MSKIN_REG_POS_Y         607.9025
#define MSKIN_REG_POS_Z         1349.3094
#define MSKIN_REG_ANGLE         180.0
#define MSKIN_REG_INTERIOR      1
#define MSKIN_REG_CAM_X         1200.0
#define MSKIN_REG_CAM_Y         605.0
#define MSKIN_REG_CAM_Z         1350.0

/*
	Ассортимент магазина одежды — редактируйте здесь.
	Формат строки: { skin_id, price_rub, "название (только для кодера, не показывается игроку)" }
	Мужские и женские скины — в отдельных таблицах, отсортированы по цене.
	Количество позиций меняется через MSKIN_CATALOG_MALE_ITEMS / MSKIN_CATALOG_FEMALE_ITEMS.
*/
#define MSKIN_CATALOG_MALE_ITEMS    87
#define MSKIN_CATALOG_FEMALE_ITEMS  12
#define MSKIN_CAT_NAME_LEN      32

enum E_MSKIN_CATALOG
{
	MSKIN_CAT_ID,
	MSKIN_CAT_PRICE,
	MSKIN_CAT_NAME[MSKIN_CAT_NAME_LEN]
};

new const g_magazinskinov_catalog_m[MSKIN_CATALOG_MALE_ITEMS][E_MSKIN_CATALOG] =
{
		{29,    5850,  "Борзый>"},
		{33, 	9750,  "Базовый 1"},
		{30,    14625, "Мерзляк"},
		{36,    15600, "Сосед 1"},
		{37,    19500, "Сосед 2"},
		{278,    20000,  "Спайк"},
		{43,   23400,   "Друг 1"},
		{18594, 25000, ""},
		{44,   29250,  "Друг 2"},
		{45,   31200,  ""},
		{297,  35000,  ""},
		{47, 	35100,  ""},
		{60, 39000,  ""},
		{96, 40000, ""},
		{97, 40000, ""},
		{66, 42900, ""},
		{67, 42900, ""},
		// {18680, 45000, "Кудряш"},
		{142, 48750, ""},
		{7, 50000, ""},
		{143, 52650, "Тинэйджер"},
		{18615, 55000, "Рокер"},
		{144, 58500, "Плохиш"},
		{6, 60000, ""},
		{154, 62400, ""}, //old: {45, 62400, ""},
		{128, 100000, "Мажор 1"},
		{268, 100000, ""},
		{101, 107250, ""},
		{3, 117000, "Гопник в красном"},
		{18861, 120000, ""},
		{177, 130000, ""},
		{180, 156000, "Социофоб 2"},
		{181, 175500, ""},
		{182, 195000, ""},
		{123, 200000, ""},
		{183, 214500, ""},
		{185, 234000, ""},
		{189, 263000, ""},
		{18608, 270000, ""},
		{247, 292000, "Mr. Mallboro"},
		{18603, 330000, ""},
		{19199, 500000, ""},
		{242, 682500, ""},
		{121, 780000, ""},
		{18611, 800000, ""},
		{248, 975000, ""},
		{107, 980000, ""},
		{50, 1100000, ""},
		{250, 1267500, ""},
		{217, 1365000, "Lil Peep"},
		{110, 1500000, ""},
		{121, 1500000, ""},
		{221, 1755000, ""},
		{18860, 1900000, ""},
		{68, 2000000, ""},
		{18616, 2300000, ""},
		{95, 2500000, "Мексу"},
		{223, 2535000, "Американец"},
		{290, 2730000, "Ядовито-зелёный"},
		{291, 2925000, "Модник 2"},
		{108, 3000000, "Full White"},
		{124, 3000000, "Хмурый"},
		{292, 3000000, "Социофоб"},
		{109, 3250000, "Батори"},
		{272, 3500000, "Mr. Бежевый"},
		{18, 3700000, ""},
		{51, 4500000, ""},
		{52, 4550000, ""},
		{125, 5000000, ""},
		{18617, 5500000, ""},
		{293, 5850000, ""},
		{294, 6000000, ""},
		{80, 6100000, ""},
		{146, 6200000, ""},
		{153, 6300000, ""},
		{120, 6400000, ""},
		{81, 6500000, ""},
		{83, 6600000, ""},
		{82, 6800000, ""},
		{213, 6800000, ""},
		{98, 6900000, ""},
		{127, 7000000, ""},
		{203, 7000000, ""},
		{42, 7500000, ""},
		{271, 8000000, ""},
		{273, 8500000, ""},
		{73, 9000000, "Пижон"},
		{106, 22800000, "Mr. Alen"}
};

new const g_magazinskinov_catalog_f[MSKIN_CATALOG_FEMALE_ITEMS][E_MSKIN_CATALOG] =
{
		{75,    1000,  "Casual A"},
		{169,   1400,  "Casual B"},
		{172,   1600,  "Office A"},
		{197,   1800,  "Office B"},
		{214,   2000,  "Sport A"},
		{201,   2100,  "Street A"},
		{215,   2200,  "Sport B"},
		{216,   2300,  "Street B"},
		{246,   2500,  "Classic A"},
		{5321,  4800,  "Premium A"},
		{5363,  5500,  "Premium B"},
		{5364,  5900,  "Premium C"}
};

stock MagazinSkinov_GetCatalogCount(sex)
{
	if(sex) return MSKIN_CATALOG_FEMALE_ITEMS;
	return MSKIN_CATALOG_MALE_ITEMS;
}

stock MagazinSkinov_GetCatalogSkinId(sex, index)
{
	if(sex) return g_magazinskinov_catalog_f[index][MSKIN_CAT_ID];
	return g_magazinskinov_catalog_m[index][MSKIN_CAT_ID];
}

stock MagazinSkinov_GetCatalogPrice(sex, index)
{
	if(sex) return g_magazinskinov_catalog_f[index][MSKIN_CAT_PRICE];
	return g_magazinskinov_catalog_m[index][MSKIN_CAT_PRICE];
}

new Text:g_skin_business[MSKIN_TD_COUNT];
new bool:p_skinshop_open[MAX_PLAYERS];
new bool:p_skinshop_active[MAX_PLAYERS];
new Float:p_skinshop_save_pos[MAX_PLAYERS][4];
new p_skinshop_save_int[MAX_PLAYERS];
new p_skinshop_save_vw[MAX_PLAYERS];
new p_skinshop_save_skin[MAX_PLAYERS];
new p_skinshop_count[MAX_PLAYERS];
new p_skinshop_index[MAX_PLAYERS];
new PlayerText:p_skinshop_price_ptd[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};

stock MagazinSkinov_CreateTextDraws()
{
	g_skin_business[0] = TextDrawCreate(30.0002, 361.7333, "Box");
	TextDrawLetterSize(g_skin_business[0], 0.0000, 3.4999);
	TextDrawTextSize(g_skin_business[0], 66.0000, 0.0000);
	TextDrawAlignment(g_skin_business[0], 1);
	TextDrawColor(g_skin_business[0], -1);
	TextDrawUseBox(g_skin_business[0], 1);
	TextDrawBoxColor(g_skin_business[0], -1523963137);
	TextDrawBackgroundColor(g_skin_business[0], 255);
	TextDrawFont(g_skin_business[0], 1);
	TextDrawSetProportional(g_skin_business[0], 1);
	TextDrawSetShadow(g_skin_business[0], 0);

	g_skin_business[1] = TextDrawCreate(31.3332, 363.3927, "Box");
	TextDrawLetterSize(g_skin_business[1], 0.0000, 0.2666);
	TextDrawTextSize(g_skin_business[1], 65.0000, 0.0000);
	TextDrawAlignment(g_skin_business[1], 1);
	TextDrawColor(g_skin_business[1], -1);
	TextDrawUseBox(g_skin_business[1], 1);
	TextDrawBoxColor(g_skin_business[1], 255);
	TextDrawBackgroundColor(g_skin_business[1], 255);
	TextDrawFont(g_skin_business[1], 1);
	TextDrawSetProportional(g_skin_business[1], 1);
	TextDrawSetShadow(g_skin_business[1], 0);
	TextDrawSetSelectable(g_skin_business[1], 1);

	g_skin_business[2] = TextDrawCreate(31.6667, 388.6965, "Box");
	TextDrawLetterSize(g_skin_business[2], 0.0000, 0.2666);
	TextDrawTextSize(g_skin_business[2], 65.0000, 0.0000);
	TextDrawAlignment(g_skin_business[2], 1);
	TextDrawColor(g_skin_business[2], -1);
	TextDrawUseBox(g_skin_business[2], 1);
	TextDrawBoxColor(g_skin_business[2], 255);
	TextDrawBackgroundColor(g_skin_business[2], 255);
	TextDrawFont(g_skin_business[2], 1);
	TextDrawSetProportional(g_skin_business[2], 1);
	TextDrawSetShadow(g_skin_business[2], 0);
	TextDrawSetSelectable(g_skin_business[2], 1);

	g_skin_business[3] = TextDrawCreate(43.6665, 370.4443, "<<");
	TextDrawLetterSize(g_skin_business[3], 0.4000, 1.6000);
	TextDrawAlignment(g_skin_business[3], 1);
	TextDrawColor(g_skin_business[3], -1);
	TextDrawBackgroundColor(g_skin_business[3], 255);
	TextDrawFont(g_skin_business[3], 1);
	TextDrawSetProportional(g_skin_business[3], 1);
	TextDrawSetShadow(g_skin_business[3], 0);
	TextDrawSetSelectable(g_skin_business[3], 1);

	g_skin_business[4] = TextDrawCreate(247.3332, 340.1625, "Box");
	TextDrawLetterSize(g_skin_business[4], 0.0000, 6.1665);
	TextDrawTextSize(g_skin_business[4], 394.0000, 0.0000);
	TextDrawAlignment(g_skin_business[4], 1);
	TextDrawColor(g_skin_business[4], -1);
	TextDrawUseBox(g_skin_business[4], 1);
	TextDrawBoxColor(g_skin_business[4], -1523963137);
	TextDrawBackgroundColor(g_skin_business[4], 255);
	TextDrawFont(g_skin_business[4], 1);
	TextDrawSetProportional(g_skin_business[4], 1);
	TextDrawSetShadow(g_skin_business[4], 0);

	g_skin_business[5] = TextDrawCreate(582.3336, 362.1480, "Box");
	TextDrawLetterSize(g_skin_business[5], 0.0000, 3.4999);
	TextDrawTextSize(g_skin_business[5], 619.0000, 0.0000);
	TextDrawAlignment(g_skin_business[5], 1);
	TextDrawColor(g_skin_business[5], -1);
	TextDrawUseBox(g_skin_business[5], 1);
	TextDrawBoxColor(g_skin_business[5], -1523963137);
	TextDrawBackgroundColor(g_skin_business[5], 255);
	TextDrawFont(g_skin_business[5], 1);
	TextDrawSetProportional(g_skin_business[5], 1);
	TextDrawSetShadow(g_skin_business[5], 0);

	g_skin_business[6] = TextDrawCreate(583.6666, 363.8074, "Box");
	TextDrawLetterSize(g_skin_business[6], 0.0000, 0.2666);
	TextDrawTextSize(g_skin_business[6], 618.0000, 0.0000);
	TextDrawAlignment(g_skin_business[6], 1);
	TextDrawColor(g_skin_business[6], -1);
	TextDrawUseBox(g_skin_business[6], 1);
	TextDrawBoxColor(g_skin_business[6], 255);
	TextDrawBackgroundColor(g_skin_business[6], 255);
	TextDrawFont(g_skin_business[6], 1);
	TextDrawSetProportional(g_skin_business[6], 1);
	TextDrawSetShadow(g_skin_business[6], 0);
	TextDrawSetSelectable(g_skin_business[6], 1);

	g_skin_business[7] = TextDrawCreate(584.0000, 389.1111, "Box");
	TextDrawLetterSize(g_skin_business[7], 0.0000, 0.2666);
	TextDrawTextSize(g_skin_business[7], 618.0000, 0.0000);
	TextDrawAlignment(g_skin_business[7], 1);
	TextDrawColor(g_skin_business[7], -1);
	TextDrawUseBox(g_skin_business[7], 1);
	TextDrawBoxColor(g_skin_business[7], 255);
	TextDrawBackgroundColor(g_skin_business[7], 255);
	TextDrawFont(g_skin_business[7], 1);
	TextDrawSetProportional(g_skin_business[7], 1);
	TextDrawSetShadow(g_skin_business[7], 0);
	TextDrawSetSelectable(g_skin_business[7], 1);

	g_skin_business[8] = TextDrawCreate(595.9995, 371.2738, ">>");
	TextDrawLetterSize(g_skin_business[8], 0.4000, 1.6000);
	TextDrawAlignment(g_skin_business[8], 1);
	TextDrawColor(g_skin_business[8], -1);
	TextDrawBackgroundColor(g_skin_business[8], 255);
	TextDrawFont(g_skin_business[8], 1);
	TextDrawSetProportional(g_skin_business[8], 1);
	TextDrawSetShadow(g_skin_business[8], 0);
	TextDrawSetSelectable(g_skin_business[8], 1);

	g_skin_business[9] = TextDrawCreate(249.3332, 341.8219, "Box");
	TextDrawLetterSize(g_skin_business[9], 0.0000, 0.4332);
	TextDrawTextSize(g_skin_business[9], 392.0000, 0.0000);
	TextDrawAlignment(g_skin_business[9], 1);
	TextDrawColor(g_skin_business[9], -1);
	TextDrawUseBox(g_skin_business[9], 1);
	TextDrawBoxColor(g_skin_business[9], 255);
	TextDrawBackgroundColor(g_skin_business[9], 255);
	TextDrawFont(g_skin_business[9], 1);
	TextDrawSetProportional(g_skin_business[9], 1);
	TextDrawSetShadow(g_skin_business[9], 0);

	g_skin_business[10] = TextDrawCreate(249.6667, 379.5701, "Box");
	TextDrawLetterSize(g_skin_business[10], 0.0000, 1.4665);
	TextDrawTextSize(g_skin_business[10], 392.0000, 0.0000);
	TextDrawAlignment(g_skin_business[10], 1);
	TextDrawColor(g_skin_business[10], -1);
	TextDrawUseBox(g_skin_business[10], 1);
	TextDrawBoxColor(g_skin_business[10], 255);
	TextDrawBackgroundColor(g_skin_business[10], 255);
	TextDrawFont(g_skin_business[10], 1);
	TextDrawSetProportional(g_skin_business[10], 1);
	TextDrawSetShadow(g_skin_business[10], 0);

	g_skin_business[11] = TextDrawCreate(250.0000, 350.9479, "Box");
	TextDrawLetterSize(g_skin_business[11], 0.0000, 2.5999);
	TextDrawTextSize(g_skin_business[11], 316.0000, 0.0000);
	TextDrawAlignment(g_skin_business[11], 1);
	TextDrawColor(g_skin_business[11], -1);
	TextDrawUseBox(g_skin_business[11], 1);
	TextDrawBoxColor(g_skin_business[11], 255);
	TextDrawBackgroundColor(g_skin_business[11], 255);
	TextDrawFont(g_skin_business[11], 1);
	TextDrawSetProportional(g_skin_business[11], 1);
	TextDrawSetShadow(g_skin_business[11], 0);
	TextDrawSetSelectable(g_skin_business[11], 1);

	g_skin_business[12] = TextDrawCreate(320.6664, 351.3627, "Box");
	TextDrawLetterSize(g_skin_business[12], 0.0000, 2.5999);
	TextDrawTextSize(g_skin_business[12], 392.0000, 0.0000);
	TextDrawAlignment(g_skin_business[12], 1);
	TextDrawColor(g_skin_business[12], -1);
	TextDrawUseBox(g_skin_business[12], 1);
	TextDrawBoxColor(g_skin_business[12], 255);
	TextDrawBackgroundColor(g_skin_business[12], 255);
	TextDrawFont(g_skin_business[12], 1);
	TextDrawSetProportional(g_skin_business[12], 1);
	TextDrawSetShadow(g_skin_business[12], 0);
	TextDrawSetSelectable(g_skin_business[12], 1);

	g_skin_business[13] = TextDrawCreate(283.0000, 355.9500, "КУПИТЬ");
	TextDrawLetterSize(g_skin_business[13], 0.4000, 1.6000);
	TextDrawAlignment(g_skin_business[13], 2);
	TextDrawColor(g_skin_business[13], -1);
	TextDrawBackgroundColor(g_skin_business[13], 0);
	TextDrawFont(g_skin_business[13], 1);
	TextDrawSetProportional(g_skin_business[13], 1);
	TextDrawSetShadow(g_skin_business[13], 0);
	TextDrawSetSelectable(g_skin_business[13], 1);

	g_skin_business[14] = TextDrawCreate(356.3332, 356.3600, "ВЫХОД");
	TextDrawLetterSize(g_skin_business[14], 0.4000, 1.6000);
	TextDrawAlignment(g_skin_business[14], 2);
	TextDrawColor(g_skin_business[14], -1);
	TextDrawBackgroundColor(g_skin_business[14], 0);
	TextDrawFont(g_skin_business[14], 1);
	TextDrawSetProportional(g_skin_business[14], 1);
	TextDrawSetShadow(g_skin_business[14], 0);
	TextDrawSetSelectable(g_skin_business[14], 1);
}

stock MagazinSkinov_Init()
{
	MagazinSkinov_CreateTextDraws();
	printf("[MagazinSkinov]: Загружено %d текстдравов.", MSKIN_TD_COUNT);
}

stock MagazinSkinov_ResetPlayer(playerid)
{
	p_skinshop_open[playerid] = false;
	p_skinshop_active[playerid] = false;
	p_skinshop_count[playerid] = 0;
	p_skinshop_index[playerid] = 0;
}

stock MagazinSkinov_DestroyPricePTD(playerid)
{
	if(p_skinshop_price_ptd[playerid] != PlayerText:INVALID_TEXT_DRAW)
	{
		PlayerTextDrawDestroy(playerid, p_skinshop_price_ptd[playerid]);
		p_skinshop_price_ptd[playerid] = PlayerText:INVALID_TEXT_DRAW;
	}
}

stock MagazinSkinov_CreatePricePTD(playerid)
{
	MagazinSkinov_DestroyPricePTD(playerid);

	p_skinshop_price_ptd[playerid] = CreatePlayerTextDraw(playerid, MSKIN_PRICE_PTD_X, MSKIN_PRICE_PTD_Y, "_");
	PlayerTextDrawLetterSize(playerid, p_skinshop_price_ptd[playerid], 0.3500, 1.2000);
	PlayerTextDrawAlignment(playerid, p_skinshop_price_ptd[playerid], 2);
	PlayerTextDrawColor(playerid, p_skinshop_price_ptd[playerid], 0x808080FF);
	PlayerTextDrawBackgroundColor(playerid, p_skinshop_price_ptd[playerid], 0);
	PlayerTextDrawFont(playerid, p_skinshop_price_ptd[playerid], 1);
	PlayerTextDrawSetProportional(playerid, p_skinshop_price_ptd[playerid], 1);
	PlayerTextDrawSetShadow(playerid, p_skinshop_price_ptd[playerid], 0);
}

stock MagazinSkinov_UpdatePricePTD(playerid)
{
	new idx = p_skinshop_index[playerid];
	new sex = GetPlayerSex(playerid);
	new fmt_str[48];

	format(fmt_str, sizeof fmt_str, "ЦЕНА: %d", MagazinSkinov_GetCatalogPrice(sex, idx));
	PlayerTextDrawSetString(playerid, p_skinshop_price_ptd[playerid], fmt_str);
	PlayerTextDrawShow(playerid, p_skinshop_price_ptd[playerid]);
}

stock MagazinSkinov_LoadAssortment(playerid)
{
	p_skinshop_count[playerid] = MagazinSkinov_GetCatalogCount(GetPlayerSex(playerid));
	p_skinshop_index[playerid] = 0;
}

stock MagazinSkinov_SelectIndex(playerid, index)
{
	if(p_skinshop_count[playerid] <= 0)
		return 0;

	if(index < 0)
		index = p_skinshop_count[playerid] - 1;
	else if(index >= p_skinshop_count[playerid])
		index = 0;

	p_skinshop_index[playerid] = index;
	SetPlayerSkin(playerid, MagazinSkinov_GetCatalogSkinId(GetPlayerSex(playerid), index));
	MagazinSkinov_UpdatePricePTD(playerid);
	return 1;
}

stock MagazinSkinov_IsClothingBiz(playerid)
{
	new businessid = GetPlayerInBiz(playerid);

	if(businessid == -1)
		return 0;

	return GetBusinessData(businessid, B_TYPE) == BUSINESS_TYPE_CLOTHING_SHOP;
}

stock MagazinSkinov_TeleportToBizExit(playerid)
{
	new businessid = GetPlayerInBiz(playerid);

	if(businessid == -1)
		return 0;

	SetPlayerPosEx
	(
		playerid,
		GetBusinessData(businessid, B_EXIT_POS_X),
		GetBusinessData(businessid, B_EXIT_POS_Y),
		GetBusinessData(businessid, B_EXIT_POS_Z),
		GetBusinessData(businessid, B_EXIT_ANGLE),
		0,
		0,
		false
	);
	SetPlayerInBiz(playerid, -1);
	return 1;
}

stock MagazinSkinov_Show(playerid)
{
	for(new i = 0; i < MSKIN_TD_COUNT; i++)
		TextDrawShowForPlayer(playerid, g_skin_business[i]);

	p_skinshop_open[playerid] = true;
	SelectTextDraw(playerid, 0xFFFFFFFF);
}

stock MagazinSkinov_Hide(playerid)
{
	if(!p_skinshop_open[playerid])
		return 0;

	for(new i = 0; i < MSKIN_TD_COUNT; i++)
		TextDrawHideForPlayer(playerid, g_skin_business[i]);

	if(p_skinshop_price_ptd[playerid] != PlayerText:INVALID_TEXT_DRAW)
		PlayerTextDrawHide(playerid, p_skinshop_price_ptd[playerid]);

	CancelSelectTextDraw(playerid);
	p_skinshop_open[playerid] = false;
	return 1;
}

stock MagazinSkinov_EnterShop(playerid)
{
	if(p_skinshop_active[playerid])
		return 0;

	if(GetPlayerTeamEx(playerid) > 0)
	{
		SendClientMessage(playerid, 0xCECECEFF, "Вы состоите в организации, купить новую внешность нельзя");
		return 0;
	}

	if(!MagazinSkinov_IsClothingBiz(playerid))
		return 0;

	GetPlayerPos(playerid, p_skinshop_save_pos[playerid][0], p_skinshop_save_pos[playerid][1], p_skinshop_save_pos[playerid][2]);
	GetPlayerFacingAngle(playerid, p_skinshop_save_pos[playerid][3]);
	p_skinshop_save_int[playerid] = GetPlayerInterior(playerid);
	p_skinshop_save_vw[playerid] = GetPlayerVirtualWorld(playerid);
	p_skinshop_save_skin[playerid] = GetPlayerSkinEx(playerid);

	MagazinSkinov_LoadAssortment(playerid);

	TogglePlayerControllable(playerid, false);
	SetPlayerPosEx(playerid, MSKIN_REG_POS_X, MSKIN_REG_POS_Y, MSKIN_REG_POS_Z, MSKIN_REG_ANGLE, MSKIN_REG_INTERIOR, p_skinshop_save_vw[playerid], false);
	SetPlayerCameraPos(playerid, MSKIN_REG_CAM_X, MSKIN_REG_CAM_Y, MSKIN_REG_CAM_Z, 5.0050);
	SetPlayerCameraLookAt(playerid, MSKIN_REG_POS_X, MSKIN_REG_POS_Y, MSKIN_REG_POS_Z);

	SetPlayerSkin(playerid, MagazinSkinov_GetCatalogSkinId(GetPlayerSex(playerid), 0));
	p_skinshop_active[playerid] = true;

	MagazinSkinov_CreatePricePTD(playerid);
	MagazinSkinov_UpdatePricePTD(playerid);
	MagazinSkinov_Show(playerid);
	return 1;
}

stock MagazinSkinov_ExitShop(playerid, bool:keep_skin = false)
{
	if(!p_skinshop_active[playerid])
	{
		MagazinSkinov_Hide(playerid);
		return 0;
	}

	new bool:clothing_biz = bool:MagazinSkinov_IsClothingBiz(playerid);

	MagazinSkinov_Hide(playerid);
	MagazinSkinov_DestroyPricePTD(playerid);

	if(!keep_skin)
		SetPlayerSkin(playerid, p_skinshop_save_skin[playerid]);

	if(clothing_biz)
		MagazinSkinov_TeleportToBizExit(playerid);
	else
	{
		SetPlayerPosEx
		(
			playerid,
			p_skinshop_save_pos[playerid][0],
			p_skinshop_save_pos[playerid][1],
			p_skinshop_save_pos[playerid][2],
			p_skinshop_save_pos[playerid][3],
			p_skinshop_save_int[playerid],
			p_skinshop_save_vw[playerid],
			false
		);
	}
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, true);

	p_skinshop_active[playerid] = false;
	return 1;
}

stock MagazinSkinov_BuySkin(playerid)
{
	if(!p_skinshop_active[playerid])
		return 0;

	new sex = GetPlayerSex(playerid);
	new idx = p_skinshop_index[playerid];
	new skinid = MagazinSkinov_GetCatalogSkinId(sex, idx);
	new price = MagazinSkinov_GetCatalogPrice(sex, idx);

	if(GetPlayerMoneyEx(playerid) < price)
	{
		SendClientMessage(playerid, 0xCECECEFF, "У Вас недостаточно денег для покупки скина");
		return 1;
	}

	GivePlayerMoneyEx(playerid, -price, "Покупка скина (магазин одежды)", false, true);
	SetPlayerData(playerid, P_SKIN, skinid);
	SendClientMessage(playerid, 0x66CC00FF, "Вы успешно купили новый скин!");
	MagazinSkinov_ExitShop(playerid, true);
	return 1;
}

stock MagazinSkinov_OnPlayerConnect(playerid)
{
	MagazinSkinov_ResetPlayer(playerid);
}

stock MagazinSkinov_OnPlayerDisconnect(playerid)
{
	MagazinSkinov_DestroyPricePTD(playerid);
	MagazinSkinov_ResetPlayer(playerid);
}

stock MagazinSkinov_OnClickTextDraw(playerid, Text:clickedid)
{
	if(!p_skinshop_open[playerid])
		return 0;

	if(clickedid == g_skin_business[MSKIN_TD_BTN_BUY] || clickedid == g_skin_business[MSKIN_TD_BTN_BUY_BOX])
	{
		MagazinSkinov_BuySkin(playerid);
		if(p_skinshop_open[playerid])
			SelectTextDraw(playerid, 0xFFFFFFFF);
		return 1;
	}

	if(clickedid == g_skin_business[MSKIN_TD_BTN_EXIT] || clickedid == g_skin_business[MSKIN_TD_BTN_EXIT_BOX])
	{
		MagazinSkinov_ExitShop(playerid, false);
		return 1;
	}

	if(clickedid == g_skin_business[MSKIN_TD_BTN_LEFT])
	{
		MagazinSkinov_SelectIndex(playerid, p_skinshop_index[playerid] - 1);
		SelectTextDraw(playerid, 0xFFFFFFFF);
		return 1;
	}

	if(clickedid == g_skin_business[MSKIN_TD_BTN_RIGHT])
	{
		MagazinSkinov_SelectIndex(playerid, p_skinshop_index[playerid] + 1);
		SelectTextDraw(playerid, 0xFFFFFFFF);
		return 1;
	}

	if(clickedid == Text:INVALID_TEXT_DRAW)
	{
		SelectTextDraw(playerid, 0xFFFFFFFF);
		return 1;
	}

	return 0;
}
// END INLINED: modules/m1stoks/magazinSkinov/magazinskinov.inc
