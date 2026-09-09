#if defined _prop_captcha_included
    #endinput
#endif
#define _prop_captcha_included

static PlayerCaptcha[MAX_PLAYERS][7];
static PlayerCaptchaTimer[MAX_PLAYERS];
static PlayerCaptchaTimeOpen[MAX_PLAYERS];

stock ShowPropertyCaptcha(playerid, type, id, bool:owner = false, price = -1)
{
    if(gettime() < PlayerCaptchaTimer[playerid])
    {
        new fmt_text[128];
        format(fmt_text, sizeof fmt_text, "Повторите попытку через %d сек.", PlayerCaptchaTimer[playerid] - gettime());
        return SendClientMessage(playerid, 0xCECECEFF, fmt_text);
    }

    SetPVarInt(playerid, "BuyType", type);
    SetPVarInt(playerid, "BuyID", id);
    SetPVarInt(playerid, "BuyFromOwner", _:owner);
    SetPVarInt(playerid, "BuyPrice", price);

    PlayerCaptchaTimeOpen[playerid] = GetTickCount();

    static const charset[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    for(new i = 0; i < 6; i++) PlayerCaptcha[playerid][i] = charset[random(sizeof(charset) - 1)];
    PlayerCaptcha[playerid][6] = EOS;

    new fmt_dialog[256];
    format(fmt_dialog, sizeof fmt_dialog, 
        "{FFFFFF}Для подтверждения покупки введите код:\n\n\
        {FFCC00}КОД: %s\n\n\
        {FFFFFF}Введите код ниже:", PlayerCaptcha[playerid]);

    Dialog(playerid, D_PROP_CAPTCHA, DIALOG_STYLE_INPUT, "{3399FF}Проверка", fmt_dialog, "Ввод", "Отмена");
    return 1;
}

stock CheckPropertyCaptcha(playerid, dialogid, response, inputtext[])
{
    if(dialogid == D_PROP_CAPTCHA)
    {
        if(!response) 
        {
            DeletePVar(playerid, "BuyType");
            DeletePVar(playerid, "BuyID");
            DeletePVar(playerid, "BuyPrice");
            DeletePVar(playerid, "BuyFromOwner");
            return 1;
        }

        if(strcmp(inputtext, PlayerCaptcha[playerid], false) == 0)
        {
            new delta_time = GetTickCount() - PlayerCaptchaTimeOpen[playerid];
            
            new type = GetPVarInt(playerid, "BuyType");
            new target_id = GetPVarInt(playerid, "BuyID");

            if(delta_time < 600) 
            {
                new adm_msg[144], type_name[20];
                switch(type) {
                    case 1: type_name = "дом";
                    case 2: type_name = "бизнес";
                    case 3: type_name = "огород";
                    case 4: type_name = "гараж";
                }
                format(adm_msg, sizeof(adm_msg), "[A] %s[%d] подозрительно быстро ввел капчу (%d мс) при покупке [%s №%d]", 
                    GetPlayerNameEx(playerid), playerid, delta_time, type_name, target_id);
                SendMessageToAdmins(adm_msg, 0xFF6600FF);
            }

            SetPVarInt(playerid, "CaptchaPassed", 1);
            
            if(type == 1)
            {
                SendClientMessage(playerid, 0xFFFFFFFF, "Поздравляем! Вы приобрели дом");
                BuyPlayerHouse(playerid, target_id);

                EnterPlayerToHouse(playerid, target_id);
                PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);

                GameText(playerid, "~b~Добро пожаловать ~g~в~n~~y~в новый ~w~ дом!", 4000, 2);
                Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{3399FF}Новый дом", "{FFFFFF}Вам нужно заплатить за дом в ближайшем отделением банка {FFCD00}(/gps)", "Ок", "");
            }
            else if(type == 2)
            {
                SendClientMessage(playerid, 0xFFFFFFFF, "Поздравляем! Вы купили бизнес");
                BuyPlayerBusiness(playerid, target_id);

                AddPlayerAchiv(playerid, 8);

                PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
                Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{3399FF}Новый бизнес", "{FFFFFF}Вам нужно заплатить за аренду бизнеса в ближайшем отделением банка {FFCD00}(/gps)", "Ок", "");
            }
            else if(type == 3)
            {
                BuyPlayerGarden(playerid, target_id);

                PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
                new fmt_str[144];
                format(fmt_str, sizeof fmt_str,"{FFFFFF}Вы успешно приобрели огород {FFA500}№%d {FFFFFF}за {FFA500}%s {FFFFFF}руб.", target_id, formatInt(GetGardenData(target_id, G_PRICE)));
                SendClientMessage(playerid, 0xCECECEFF, fmt_str);
                static fmt_text[144];
                static garden;
				format(fmt_text, sizeof fmt_text, "Игрок %s[%d] приобрел огород №%d за %d$", GetPlayerNameEx(playerid), playerid, garden, GetGardenData(garden, G_PRICE));
				SendMessageToAdmins(fmt_text, 0x999999FF);
            }
            else if(type == 4) 
            {
                SendClientMessage(playerid, COLOR_WHITE, "Поздравляем! Вы купили гараж");
                BuyPlayerGarage(playerid, target_id);
                if(GetGarageData(target_id, G_TYPE) == 1)
                {
                    AddPlayerData(playerid, P_CAR_SLOTS,+,5);
                    UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
                }
                else if(GetGarageData(target_id, G_TYPE) == 2)
                {
                    AddPlayerData(playerid, P_CAR_SLOTS,+,9);
                    UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
                }
                else if(GetGarageData(target_id, G_TYPE) == 3)
                {
                    AddPlayerData(playerid, P_CAR_SLOTS,+,15);
                    UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
                }
                PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
                Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{"#cGold"}Новый гараж", "{"#cW"}Вам нужно заплатить за аренду гаража в ближайшем отделением банка {"#cGold"}(H - GPS)", "Ок", "");
            }
            
            DeletePVar(playerid, "CaptchaPassed");
            DeletePVar(playerid, "BuyType");
            DeletePVar(playerid, "BuyID");
            DeletePVar(playerid, "BuyPrice");
            DeletePVar(playerid, "BuyFromOwner");
        }
        else
        {
            PlayerCaptchaTimer[playerid] = gettime() + 60;
            SendClientMessage(playerid, 0xFF6600FF, "Неверный код!");
        }
        return 1;
    }
    return 0;
}