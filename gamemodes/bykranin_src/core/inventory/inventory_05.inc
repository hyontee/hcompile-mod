//>> Файл: bykranin_src/core/inventory/inventory_05.inc  (227 строк)
//>> Тема: инвентарь, предметы, кейсы/награды, аксессуары, багажник
//>> Внутри: ApplyAdminSkin, /askin, ShowFamilyy, /ndrive, /pdd, /setvinil
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock ApplyAdminSkin(playerid, skinType)
{
    switch (skinType)
    {
        case 1:
        {
            SetPlayerSkin(playerid, 122); // Мужской скин
            //SendClientMessage(playerid, 0x00FF00FF, ""SC"Вы успешно {FFFF00}надели {FFFFFF}скин {FFFF00}администратора.");
        }
        case 2:
        {
            SetPlayerSkin(playerid, 11943); // Женский скин
            SendClientMessage(playerid, 0x00FF00FF, ""SC"Вы успешно {FFFF00}надели {FFFFFF}скин {FFFF00}администратора.");
        }
        case 3:
        {
            SetPlayerSkin(playerid, GetPlayerSkinEx(playerid)); // Прежний скин
            SendClientMessage(playerid, 0x00FF00FF, ""SC"Вы успешно {FFFF00}сняли {FFFFFF}скин {FFFF00}администратора.");
        }
        default:
        {
            SendClientMessage(playerid, COLOR_RED, ""SC"Используйте: /askin [1 - Мужской, 2 - Женский, 3 - Прежний]");
        }
    }
}




CMD:askin(playerid, params[])
{
    if(!(GetPlayerAdminEx(playerid) >= 1 || GetPlayerYouTubeEx(playerid) >= 1))
        return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

    if (!strlen(params))
    {
        SendClientMessage(playerid, COLOR_RED, ""SC"Используйте: /askin [1 - Мужской, 2 - Женский, 3 - Прежний]");
        return 1;
    }

    ApplyAdminSkin(playerid, strval(params));
    return 1;
}

stock ShowFamilyy(playerid, num, num2)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x51); // generated

    BS_WriteValue(bitstream, PR_INT32, num);
    BS_WriteValue(bitstream, PR_INT32, num2);

    BS_Send(bitstream, playerid);

    BS_Delete(bitstream);

    return true;
}

CMD:ndrive(playerid, params[])

{

 if(GetPlayerAdminEx(playerid) < 1) return 1;





 if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /ndrive [id игрока]");



 extract params -> new to_player;



 if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))

 return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");



 new jail_time = 30;

    if(GetPlayerData(to_player, P_JAIL) > 0) return SendClientMessage(playerid, 0xCECECEFF, "Этот игрок уже сидит в тюрьме");

 //else if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "Нельзя посадить  самого себя");



 if(AntiSliv(playerid, "/ndrive")) return true;



 new fmt_msg[128];

 format(fmt_msg, sizeof fmt_msg, "Администратор %s посадил в тюрьму игрока %s на %d мин", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), jail_time);



 format(fmt_msg, sizeof fmt_msg, "%s. Причина: NonRP вождение", fmt_msg);



 SendClientMessageToAll(0xFF5533FF, fmt_msg);



 SendClientMessage(to_player, 0xCECECEFF, "Время до окончания заключения: {CCCC00}/time");



 JailPlayer(to_player, jail_time);



 format(fmt_msg, sizeof fmt_msg, "Посадил в тюрьму %s[acc:%d] на %d мин. Причина: ndrive (NonRp Вождения)",

 GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), jail_time);



 SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);



 return 1;

}

CMD:pdd(playerid, params[])

{

  if(GetPlayerAdminEx(playerid) < 13) return 1;





  if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}| {FFFFFF}Используйте: /pdd {ffff00}[id игрока]");



  extract params -> new to_player;



  if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))

  return SendClientMessage(playerid, 0xCECECEFF, "{ff0000}| {FFFFFF}Такого игрока нет");



  new jail_time = 60;

    if(GetPlayerData(to_player, P_JAIL) > 0) return SendClientMessage(playerid, 0xCECECEFF, "{ff0000}| {FFFFFF}Этот игрок уже сидит в тюрьме");

  //else if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "Нельзя постадить в тюрьму самого себя");



  if(AntiSliv(playerid, "/pdd")) return true;



  new fmt_msg[128];

  format(fmt_msg, sizeof fmt_msg, "Администратор %s посадил в тюрьму игрока %s на %d мин", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), jail_time);



  format(fmt_msg, sizeof fmt_msg, "%s. Причина: ПДД", fmt_msg);



  SendClientMessageToAll(0xFF5533FF, fmt_msg);



  SendClientMessage(to_player, 0xCECECEFF, "{ffff00}| {FFFFFF}Время до окончания заключения: {CCCC00}/time");



  JailPlayer(to_player, jail_time);



  format(fmt_msg, sizeof fmt_msg, "Посадил в тюрьму %s[acc:%d] на %d мин. Причина: ПДД",

  GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), jail_time);



  SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);



  return 1;

}

CMD:setvinil(playerid, params[]) 
{

    extract params -> new idvinila; else return SendClientMessage(playerid, 0x999999FF, "Используйте: /setvinil [id Винила]");

    new vehicleid = GetPlayerVehicleID(playerid);
    if (vehicleid == 0)
        return SendClientMessage(playerid, -1, "Ошибка: Вы не внутри транспортного средства.");
        
     // Получим доступное количество раскрасок для текущего ТС, используя собственную функцию (см. ниже).
    new num_paintjobs = GetNumberOfPaintjobsForVehicle(GetVehicleModel(vehicleid));
    if (num_paintjobs == 0)
        return SendClientMessage(playerid, -1, "Ошибка: Для текущего транспортного средства нет доступных раскрасок.");
    
    ChangeVehiclePaintjob(vehicleid, idvinila);
    
    new string[128];
    format(string, sizeof(string), "Вы сменили раскраску транспорта на %d.", idvinila);
    return ShowNotificationNew(playerid, 2, 10, 0, 0, string, ">>");
}


