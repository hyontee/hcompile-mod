#include <a_samp>

#define DIALOG_BR_SPOILER 9100

#define COLOR_RED   0xE74C3CFF
#define COLOR_GREEN 0x33CC33FF

new gVehicleSpoilerObj[MAX_VEHICLES];

stock RemoveVehicleSpoilerObject(vehicleid)
{
    if(vehicleid < 1 || vehicleid > MAX_VEHICLES) return 0;

    if(gVehicleSpoilerObj[vehicleid] != 0)
    {
        DestroyObject(gVehicleSpoilerObj[vehicleid]);
        gVehicleSpoilerObj[vehicleid] = 0;
    }
    return 1;
}

stock CreateVehicleSpoilerObject(vehicleid, modelid)
{
    if(vehicleid < 1 || vehicleid > MAX_VEHICLES) return 0;

    RemoveVehicleSpoilerObject(vehicleid);

    new objid = CreateObject(modelid, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 300.0);
    gVehicleSpoilerObj[vehicleid] = objid;
    return objid;
}

stock AttachSpoilerByType(vehicleid, type)
{
    new objid;

    switch(type)
    {
        case 1:
        {
            objid = CreateVehicleSpoilerObject(vehicleid, 18646);
            AttachObjectToVehicle(objid, vehicleid, 0.0, -1.95, 0.45, 0.0, 0.0, 0.0);
        }
        case 2:
        {
            objid = CreateVehicleSpoilerObject(vehicleid, 18647);
            AttachObjectToVehicle(objid, vehicleid, 0.0, -2.00, 0.60, 0.0, 0.0, 0.0);
        }
        case 3:
        {
            objid = CreateVehicleSpoilerObject(vehicleid, 18648);
            AttachObjectToVehicle(objid, vehicleid, 0.0, -2.05, 0.68, 0.0, 0.0, 0.0);
        }
        case 4:
        {
            objid = CreateVehicleSpoilerObject(vehicleid, 18649);
            AttachObjectToVehicle(objid, vehicleid, 0.0, -2.08, 0.72, 0.0, 0.0, 0.0);
        }
        case 5:
        {
            objid = CreateVehicleSpoilerObject(vehicleid, 18650);
            AttachObjectToVehicle(objid, vehicleid, 0.0, -2.10, 0.70, 0.0, 0.0, 0.0);
        }
        case 6:
        {
            objid = CreateVehicleSpoilerObject(vehicleid, 18651);
            AttachObjectToVehicle(objid, vehicleid, 0.0, -1.92, 0.50, 0.0, 0.0, 0.0);
        }
        case 7:
        {
            objid = CreateVehicleSpoilerObject(vehicleid, 18652);
            AttachObjectToVehicle(objid, vehicleid, 0.0, -2.06, 0.66, 0.0, 0.0, 0.0);
        }
        case 8:
        {
            objid = CreateVehicleSpoilerObject(vehicleid, 18653);
            AttachObjectToVehicle(objid, vehicleid, 0.0, -2.12, 0.78, 0.0, 0.0, 0.0);
        }
        case 9:
        {
            objid = CreateVehicleSpoilerObject(vehicleid, 18654);
            AttachObjectToVehicle(objid, vehicleid, 0.0, -2.00, 0.55, 0.0, 0.0, 0.0);
        }
        case 10:
        {
            objid = CreateVehicleSpoilerObject(vehicleid, 18655);
            AttachObjectToVehicle(objid, vehicleid, 0.0, -2.15, 0.74, 0.0, 0.0, 0.0);
        }
        case 11:
        {
            objid = CreateVehicleSpoilerObject(vehicleid, 18656);
            AttachObjectToVehicle(objid, vehicleid, 0.0, -2.05, 0.58, 0.0, 0.0, 0.0);
        }
        case 12:
        {
            objid = CreateVehicleSpoilerObject(vehicleid, 18657);
            AttachObjectToVehicle(objid, vehicleid, 0.0, -2.18, 0.82, 0.0, 0.0, 0.0);
        }
        case 13:
        {
            objid = CreateVehicleSpoilerObject(vehicleid, 18658);
            AttachObjectToVehicle(objid, vehicleid, 0.0, -1.98, 0.52, 0.0, 0.0, 0.0);
        }
        case 14:
        {
            objid = CreateVehicleSpoilerObject(vehicleid, 18659);
            AttachObjectToVehicle(objid, vehicleid, 0.0, -2.07, 0.64, 0.0, 0.0, 0.0);
        }
        case 15:
        {
            objid = CreateVehicleSpoilerObject(vehicleid, 18660);
            AttachObjectToVehicle(objid, vehicleid, 0.0, -2.20, 0.86, 0.0, 0.0, 0.0);
        }
        default: return 0;
    }
    return 1;
}

forward FS_OpenBRSpoilerMenu(playerid);
public FS_OpenBRSpoilerMenu(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, COLOR_RED, "[ОШИБКА] Вы не в транспортном средстве!");

    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return SendClientMessage(playerid, COLOR_RED, "[ОШИБКА] Вы должны сидеть за рулем!");

    SetPVarInt(playerid, "br_spoiler_vehicle", GetPlayerVehicleID(playerid));

    new dialog_text[700];
    format(dialog_text, sizeof(dialog_text),
        "Снять спойлер\n\
1. Sport Lip\n\
2. Street Wing\n\
3. GT Wing\n\
4. Race Wing\n\
5. Wide Wing\n\
6. Ducktail\n\
7. Carbon Wing\n\
8. Motorsport Wing\n\
9. Aero Type 1\n\
10. Aero Type 2\n\
11. Aero Type 3\n\
12. Drag Wing\n\
13. Street Ducktail\n\
14. Mid Wing\n\
15. Super Wing");

    ShowPlayerDialog(playerid, DIALOG_BR_SPOILER, DIALOG_STYLE_LIST,
        "BR Спойлеры",
        dialog_text,
        "Выбрать",
        "Отмена"
    );
    return 1;
}

public OnFilterScriptInit()
{
    print("[br_spoiler] loaded");
    for(new i = 0; i < MAX_VEHICLES; i++)
    {
        gVehicleSpoilerObj[i] = 0;
    }
    return 1;
}

public OnFilterScriptExit()
{
    for(new i = 0; i < MAX_VEHICLES; i++)
    {
        if(gVehicleSpoilerObj[i] != 0)
        {
            DestroyObject(gVehicleSpoilerObj[i]);
            gVehicleSpoilerObj[i] = 0;
        }
    }
    return 1;
}

public OnVehicleSpawn(vehicleid)
{
    RemoveVehicleSpoilerObject(vehicleid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    DeletePVar(playerid, "br_spoiler_vehicle");
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_BR_SPOILER)
    {
        if(!response) return 1;

        new vehicleid = GetPVarInt(playerid, "br_spoiler_vehicle");

        if(vehicleid <= 0 || vehicleid > MAX_VEHICLES)
            return SendClientMessage(playerid, COLOR_RED, "[ОШИБКА] Автомобиль не найден.");

        if(!IsPlayerInAnyVehicle(playerid))
            return SendClientMessage(playerid, COLOR_RED, "[ОШИБКА] Вы не в транспортном средстве!");

        if(GetPlayerVehicleID(playerid) != vehicleid)
            return SendClientMessage(playerid, COLOR_RED, "[ОШИБКА] Вы должны находиться в этом автомобиле!");

        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
            return SendClientMessage(playerid, COLOR_RED, "[ОШИБКА] Вы должны сидеть за рулем!");

        if(listitem == 0)
        {
            RemoveVehicleSpoilerObject(vehicleid);
            SendClientMessage(playerid, COLOR_GREEN, "[ТЮНИНГ] Спойлер снят с вашего автомобиля!");
            return 1;
        }

        if(AttachSpoilerByType(vehicleid, listitem))
        {
            SendClientMessage(playerid, COLOR_GREEN, "[ТЮНИНГ] Спойлер установлен на ваш автомобиль!");
        }
        else
        {
            SendClientMessage(playerid, COLOR_RED, "[ОШИБКА] Не удалось установить спойлер.");
        }
        return 1;
    }
    return 0;
}
