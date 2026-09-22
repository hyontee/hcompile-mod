//>> Файл: bykranin_src/core/property/property_10.inc  (302 строк)
//>> Тема: недвижимость: дома, квартиры, бизнесы, аренда, отели
//>> Внутри: CreateRentBike, ShowPlayerBuyCommandDialog, GetPlayerAdminCMDAllow, /anak, /licsog, IsBusinessNoEnter, IsBusinessNoBuy
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock CreateRentBike()
{
    return CreateAllRentZones();
}
stock ShowPlayerBuyCommandDialog(playerid)
{
	if(GetPlayerAdminEx(playerid) < 9)
		return SendClientMessage(playerid, -1, "Покупка платных команд доступна с 9-ого уровня администратора");

	new big_fmt[568], description[64];
	for(new i; i < sizeof(g_admin_cmd_buy); i ++)
	{
		if(g_player[playerid][CMD_ACCESS][i] != '1') description = "{dd2e13}Не куплено";
            else description = "{23dc1b}Куплено";

		format(big_fmt, sizeof(big_fmt), "%s[%d] %s\t\t%s\t%d Руб\n",big_fmt, i+1, g_admin_cmd_buy[i][CMD_NAME], description, g_admin_cmd_buy[i][CMD_PRICE]);
	}
	Dialog
	(
		playerid, DIALOG_BUY_CMD, DIALOG_STYLE_LIST,
		"Покупка платных комманд",
		big_fmt,
		"Далее", "Отмена"
	);
	return 1;
}
stock GetPlayerAdminCMDAllow(playerid, CMD_id)
{
	if(GetPlayerAdminEx(playerid) < 1) return false;
	
    return (g_player[playerid][CMD_ACCESS][CMD_id]  == '1');
}

/*CMD:aprav(playerid, params[])
{
    if(!GetPlayerAdminEx(playerid)) return 1;

    new fmt_str[2000];

    format
	(
		fmt_str,sizeof fmt_str,
	    "{ffffff}Администраторам сервера запрещается:\n\
	    1. Ненормативная лексика в чат, а особенно в сторону игрока(ов) {FF6600}(Наказание: ВЫГОВОР!){ffffff} \n\
	    2. Угрозы игрокам {FF6600}(Наказание: ВЫГОВОР!){ffffff} \n\
	    3. Банить/Кикать/Сажать игрока(ов) из личной неприязни {FF6600}(Наказание: ВЫГОВОР!){ffffff} \n\
	    4. Банить/Кикать/Сажать игрока(ов) не проследив за ним и не сделав скриншота {FF6600}(Наказание: Предупреждение){ffffff} \n\
	    5. Выдавать игроку(ам) запрещённое оружие {FF6600}(Наказание: ВЫГОВОР!){ffffff} \n\
	    6. Игнорить репорт {FF6600}(Наказание: ВЫГОВОР!){ffffff} \n\
	    7. Оскорбление других модераторов/администраторов {FF6600}(Наказание: ВЫГОВОР!){ffffff} \n\
	    8. Допускать мат/оффтоп/metagaming в /ad,/vipad,/s {FF6600}(Наказание: ВЫГОВОР!){ffffff} \n\
	    9. Позволять игрокам оскорбление других игроков {FF6600}(Наказание: ВЫГОВОР!){ffffff} \n\
	    10. Просить повышение {FF6600}(Наказание: ВЫГОВОР!){ffffff} \n\
	    11. Находиться АФК больше 30 минут {FF6600}(Наказание: ВЫГОВОР!){ffffff} \n\
	    12. Флуди или оффтоп в /a {FF6600}(Наказание: ВЫГОВОР!){ffffff} \n\
	    13. Флуд или оффтоп в КФ ВК {FF6600}(Наказание: ВЫГОВОР!){ffffff} \n\
	    14. Помеха другим администраторам. {FF6600}(Наказание: ВЫГОВОР!){ffffff} \n\
	    15. Реклама {FF6600}(Наказание: Лишение админских прав){ffffff} \n\
	    16. ТП или помеха основателям {FF6600}(Наказание: ВЫГОВОР!){ffffff} \n\
	    17. Блат кого-то из игроков {FF6600}(Наказание: ВЫГОВОР!){ffffff} \n\
	    18. Использавание адм.в личных целях {FF6600}(Наказание: ВЫГОВОР!){ffffff} \n\
	    19. Помеха РП процессу {FF6600}(Наказание: ВЫГОВОР!){ffffff} \n\
	    20. Влезать в РП процесс {FF6600}(Наказание: ВЫГОВОР!){ffffff} \n\
	    21. Читерить, если ваш админ-лвл ниже 5{FF6600}(Наказание: ВЫГОВОР!){ffffff}"
	);

    Dialog(playerid,INVALID_DIALOG_ID,DIALOG_STYLE_MSGBOX,"{65c8ff}Правила Администраторов:",fmt_str,"Принять","");
    return true;
}
CMD:anak(playerid, params[])
{
    if(!GetPlayerAdminEx(playerid)) return 1;

	new fmt_str[2000];

    format
	(
		fmt_str,sizeof fmt_str,
		"{ffffff}Наказания для правонарушителей:\n\
	    1. Читы - {FF6600}(Наказание: Деморган до 30 мин.){ffffff} \n\
	    2. Оффтоп в любой чат - {FF6600}(Наказание: Мут до 10 мин.){ffffff} \n\
	    3. Metagaming - {FF6600}(Наказание: Мут до 10 мин.){ffffff} \n\
	    4. Powergaming - {FF6600}(Наказание: КПЗ до 15 мин.){ffffff} \n\
	    5. DM - {FF6600}(Наказание: КПЗ до 10 мин.){ffffff} \n\
	    6. DB - {FF6600}(Наказание: КПЗ до 10 мин.){ffffff} \n\
	    7. Реклама сторонних ресурсов - {FF6600}(Наказание: МУТ/БАН!){ffffff} \n\
	    8. Багоюз - {FF6600}(Наказание: КПЗ до 10 мин.){ffffff} \n\
	    9. Попрошайничество - {FF6600}(Наказание: Мут до 10 мин.){ffffff} \n\
	    10. Оскорбления игроков - {FF6600}(Наказание: Мут до 20 мин.){ffffff} \n\
	    11. Оскорбления администраторов - {FF6600}(Наказание: Мут на 60 минут, после бан если не успокоится..){ffffff} \n\
	    12. Оскорбления родителей игрока - {FF6600}(Наказание: Мут > Бан){ffffff} \n\
	    13. Мат в /ad, /vipad, /r, /d, /s, /me, обычный чат - {FF6600}(Наказание: Мут до 10 мин.){ffffff} \n\
	    14. DM в ЗЗ - {FF6600}(Наказание: /warn или КПЗ до 15 мин.){ffffff}\n\
	    15. Срыв Мероприятия - {FF6600}(Наказание: КПЗ до 10 мин.){ffffff}"
	);

    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{65c8ff}Нормы наказаний | Команды:",fmt_str,"Принять","");
    return true;
}
CMD:licsog(playerid, params[])
{
    if(!GetPlayerAdminEx(playerid)) return 1;

    new fmt_str[2000];

    format
	(
		fmt_str,sizeof fmt_str,
	    "{ffffff}Лицензионное соглашение:\n\
	    1. Пользуясь административными правами вы полностью потдверждаете то, что вы прочитали лиц.соглашение.. \n\
	    правила проекта,и нормы наказаний и соглашаетесь соблюдать правила/ \n\
	    2. Не соблюдая правила, либо давая наказания не по нормам, вы будете получать выговоры, и будете сняты.. \n\
	    без единого возврата средств. \n\
	    3. Повышения происходит как повторной оплатой, так и отличной работой на админке. (Онлайн +5 стабильно) \n\
	    4. Повышение, или пополнение донат-счета возможно через сайт, либо через основателя проекта [vk.com/id568918059].. \n\
	    если вас кто-то обманул, выдавая себя за основателей проекта. Средства возвращены не будут, а то что вы покупали.. \n\
	    вам предоставлено не будет ! \n\
	    5. Официальный сайт проекта > RUSSIA-MOBILE.RU | Владелец проекта - Alekseevich \n\
	    6. Официальное сообщество проекта > VK.COM/blackrussia.online | Директор проекта - Gromov \n\
	    7. Техническое сообщество проекта > VK.COM/TRUEE.HELP | Разработчик проекта - Oscar\n\
	    8. Если вы не работаете, не отвечаете на репорты, или не отыгрываете норму будьте готовы к снятию.. \n\
	    9. После оплаты всегда сохраняйте чеки, чтобы избежать проблем с получением донат-рублей и прочих услуг \n\
	    10. Если пополнить аккаунт не получается, пишите владельцу проекта. Либо в тех.раздел \n\
	    11. Также, вам запрещено превышать свои полномочия, точнее > Продавать донат-рубли, админ-права..\n\
	    и.т.д | За это вы будете сняты, и добавлены в ЧС проекта, все проданное вами будет удалено."
	);

    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,"{65c8ff}Лицензионное соглашение:",fmt_str,"Принять","");
    return true;
}*/
stock IsBusinessNoEnter(action_id) //автосалоны
{
if(GetBusinessData(action_id, B_TYPE) == 20) return 1;
	switch(GetBusinessData(action_id, B_TYPE))
	{
		case BUSINESS_TYPE_STYLING_CENTER,
		     BUSINESS_TYPE_TECH_CENTER,
		     BUSINESS_TYPE_TIRE_CENTER:
			return 1;
	}
	switch(GetBusinessData(action_id, B_SQL_ID))
	{
		case 31, 32, 33:/*, 34, 35: //34, 35, 36, 37:*/
		{
			return 1;
		}
	}
	return 0;
}

stock IsBusinessNoBuy(action_id) // гостиницы
{

	if(GetBusinessData(action_id, B_TYPE) == BUSINESS_TYPE_CAR_MARKET) return 1;
	switch(GetBusinessData(action_id, B_SQL_ID))
	{
		case 31,32,33:
		{
			return 1;
		}
	}
	return 0;
}


CMD:drugs(playerid, params[])
{
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /drugs [кол-во грамм]");
	
	extract params -> new drugs;
	
	if(!(1 <= drugs <= 3)) return SendClientMessage(playerid, 0xCECECEFF, "Количество грамм от 1 до 3");

	new fmt_msg[256];

	if(GetPlayerData(playerid, P_DRUGS) < drugs) return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет столько наркотиков");

	AddPlayerData(playerid, P_DRUGS, -, drugs);

	new Float:health;
    ApplyAnimation(playerid,"SMOKING","M_smk_drag",4.1,0,0,0,0,0);
	GetPlayerHealth(playerid, health);
	SetPlayerHealthEx(playerid, health + (drugs*20.0));

	SetPlayerWeather(playerid, -68);

	SetTimerEx("DrugEffectGone", 40000, false, "i", playerid);

	Action(playerid, "использовал наркотики", _, false);

	format(fmt_msg, sizeof fmt_msg, "Вы использовали %d грамм(а) наркотиков. Ваше здоровье (%d)", drugs, GetPlayerData(playerid, P_HEALTH));
	SendClientMessage(playerid, 0x32a44bFF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "UPDATE accounts SET drugs=%d WHERE id=%d", GetPlayerData(playerid, P_DRUGS), GetPlayerAccountID(playerid));
	mysql_query(mysql, fmt_msg, false);

	return 1;
}
forward FTIMERSEC(playerid);
public FTIMERSEC(playerid)
{
if(GetPVarInt(playerid, "FermaGarelpva")==1)
{
if(minferma>=0)
{
new fmt_text[120];
sicferma--;

TextDrawHideForPlayer(playerid, zakaz3_TD[2]);
format(fmt_text, sizeof(fmt_text), "%d",sicferma);
TextDrawSetString(zakaz3_TD[2], fmt_text); 
TextDrawShowForPlayer(playerid, zakaz3_TD[2]); 

if(sicferma==1)
{
minferma--;
sicferma=59;
if(GetPVarInt(playerid, "FermaGarelpva")==1)
{
TextDrawHideForPlayer(playerid, zakaz3_TD[3]);
format(fmt_text, sizeof(fmt_text), "%d:",minferma);
TextDrawSetString(zakaz3_TD[3], fmt_text); 
TextDrawShowForPlayer(playerid, zakaz3_TD[3]); 
}
}
if(minferma==0 && sicferma==0)
{
KillTimer(timersecfer);
}
}
}
}
forward FTIMERSECVI(playerid);
public FTIMERSECVI(playerid)
{
if(GetPVarInt(playerid, "Zavodpva")==1)
{
if(minzavod>=0)
{
new fmt_text[120];
siczavod--;

TextDrawHideForPlayer(playerid, zakaz3_TD[2]);
format(fmt_text, sizeof(fmt_text), "%d",siczavod);
TextDrawSetString(zakaz3_TD[2], fmt_text); 
TextDrawShowForPlayer(playerid, zakaz3_TD[2]); 

if(siczavod==1)
{
minzavod--;
siczavod=59;
TextDrawHideForPlayer(playerid, zakaz3_TD[3]);
format(fmt_text, sizeof(fmt_text), "%d:",minzavod);
TextDrawSetString(zakaz3_TD[3], fmt_text); 
TextDrawShowForPlayer(playerid, zakaz3_TD[3]); 

}
if(minzavod==0 && siczavod==0)
{
KillTimer(timerzavod);
}
}
}
}
forward ARZERSECVI(playerid);
public ARZERSECVI(playerid)
{
if(GetPVarInt(playerid, "Arzpva")==1)
{
if(minvish>=0)
{
new fmt_text[120];
sicvish--;

TextDrawHideForPlayer(playerid, zakaz3_TD[2]);
format(fmt_text, sizeof(fmt_text), "%d",sicvish);
TextDrawSetString(zakaz3_TD[2], fmt_text); 
TextDrawShowForPlayer(playerid, zakaz3_TD[2]); 

if(sicvish==1)
{
minvish--;
sicvish=59;
TextDrawHideForPlayer(playerid, zakaz3_TD[3]);
format(fmt_text, sizeof(fmt_text), "%d:",minvish);
TextDrawSetString(zakaz3_TD[3], fmt_text); 
TextDrawShowForPlayer(playerid, zakaz3_TD[3]); 
}
if(minvish==0 && sicvish==0)
{
KillTimer(timerarz);
}
}
}
}
//Обновление очков в базе данных
//forward FERMAGAREL();
//Хелпани последний раз


forward FERMAGAREL();
