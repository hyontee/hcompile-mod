// ==================== СИСТЕМА АВТОПИЛОТА ====================
// Автопилот для транспорта: игрок выбирает точку назначения через
// меню (переиспользует категории из /gps), машина сама едет к цели.
// Подключается через #include "../include/system/autopilot_system.pwn"
// ================================================================

#define DIALOG_AUTOPILOT_MAIN          20100
#define DIALOG_AUTOPILOT_PUBLIC        20101
#define DIALOG_AUTOPILOT_TRANSPORT     20102
#define DIALOG_AUTOPILOT_JOBS          20103
#define DIALOG_AUTOPILOT_ORG           20104
#define DIALOG_AUTOPILOT_GANGS         20105
#define DIALOG_AUTOPILOT_BERTHS        20106
#define DIALOG_AUTOPILOT_ENTERTAIN     20107
#define DIALOG_AUTOPILOT_BANKS         20108
#define DIALOG_AUTOPILOT_TAXIPARK      20109
#define DIALOG_AUTOPILOT_AUTOSALONS    20110
#define DIALOG_AUTOPILOT_CITIES        20111
#define DIALOG_AUTOPILOT_VOKZALS       20112
#define DIALOG_AUTOPILOT_MISTS         20113

#define AUTOPILOT_MAX_SPEED             80.0
#define AUTOPILOT_ARRIVE_DIST           8.0
#define AUTOPILOT_SLOWDOWN_DIST         50.0
#define AUTOPILOT_MIN_SPEED             18.0
#define AUTOPILOT_TURN_MIN_SPEED        12.0
#define AUTOPILOT_MAX_TURN_PER_TICK     4.0
#define AUTOPILOT_TICK_MS               50
#define AUTOPILOT_STUCK_LIMIT           20

new bool: g_AutoPilotActive[MAX_PLAYERS];
new Float: g_AutoPilotTarget[MAX_PLAYERS][3];
new g_AutoPilotTimer[MAX_PLAYERS];
new Float: g_AutoPilotCurSpeed[MAX_PLAYERS];
new Float: g_AutoPilotLastPos[MAX_PLAYERS][3];
new g_AutoPilotStuckTicks[MAX_PLAYERS];

new const Float: ap_public_places[4][3] =
{
    {-2569.206787,2248.303710,58.188438},
    {-2561.733398,37.204780,27.866283},
    {1916.5503,2302.2786,15.1412},
    {-286.9034,576.8859,12.8447}
};

new const Float: ap_transport[3][3] =
{
    {2382.080810,1723.076171,-1.847625},
    {615.201660,1669.412475,12.070997},
    {-1044.015136,2207.833740,38.119235}
};

new const Float: ap_jobs[7][3] =
{
    {1836.6302,-116.0337,15.5716},
    {2760.593505,-2396.189697,21.890625},
    {2773.839355,-2452.672607,21.882169},
    {889.022521,787.449279,14.198203},
    {1795.219238,2530.799804,15.672040},
    {652.959899,173.051406,2.081145},
    {1970.049194,-2603.647460,11.526079}
};

new const Float: ap_state_organizations[7][3] =
{
    {-2569.206787,2248.303710,58.188438},
    {1907.813720,-2232.832275,11.227499},
    {2578.9482,-2416.1196,21.9922},
    {-2399.9565,-383.9907,29.4402},
    {-286.9034,576.8859,12.8447},
    {2412.250488,-1841.700439,22.949813},
    {1731.4894,1768.2654,16.7501}
};

new const Float: ap_gangs[3][3] =
{
    {409.9953,1049.5887,12.0788},
    {1943.9056,2164.6016,15.2714},
    {-2405.8662,58.9733,26.5702}
};

new const Float: ap_berths[4][3] =
{
    {2310.545654,300.313903,2.039983},
    {2506.951171,-1253.455688,1.436212},
    {654.545776,168.784423,2.081145},
    {-2530.635986,355.645568,2.100287}
};

new const Float: ap_entertainment[3][3] =
{
    {1334.033569,2370.760742,17.664188},
    {611.408325,1693.072387,11.243210},
    {-2378.568847,32.216888,26.566650}
};

new const Float: ap_banks[3][3] =
{
    {393.282592,758.764648,12.034260},
    {1852.014404,2041.454711,15.922142},
    {2376.754882,-2143.508544,22.000938}
};

new const Float: ap_autosalons[6][3] =
{
    {2477.189941,-720.067810,12.331512},
    {1409.747558,458.474578,13.163024},
    {657.475830,2661.963134,13.516562},
    {-2243.496826,264.510131,24.539062},
    {-908.8949,1182.4471,10.7247},
    {1980.827392,-550.358337,11.974724}
};

new const Float: ap_cities[9][3] =
{
    {2741.322753,-1434.873046,23.814182},
    {214.106903,819.745117,12.132319},
    {-630.529113,964.976379,12.004625},
    {-1062.917114,424.410278,20.436664},
    {1888.277709,2253.680419,15.952725},
    {-2117.363281,-269.016113,25.883516},
    {-1489.310546,2370.496826,57.790000},
    {-514.984130,-1594.674072,40.964874},
    {385.337463,-1252.215576,40.561260}
};

new const Float: ap_vokzals[3][3] =
{
    {829.268920,799.759826,13.029401},
    {2768.988281,-2418.091552,20.974534},
    {1806.439086,2518.951660,14.819187}
};

forward UpdateAutoPilot(playerid);

stock ShowAutopilotMenu(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return SendClientMessage(playerid, 0xFF5252FF, "{FF5252}Ошибка:{FFFFFF} Вы должны быть за рулём машины!");

    new title[128];
    format(title, sizeof title, "{FF5252}Автопилот{ffffff} | Куда едем?");

    Dialog
    (
        playerid, DIALOG_AUTOPILOT_MAIN, DIALOG_STYLE_LIST,
        title,
        ""c_server"1. "c_b"Важные места\n"\
        ""c_server"2. "c_b"Работы для новичков\n"\
        ""c_server"3. "c_b"Основные работы\n"\
        ""c_server"4. "c_b"Государственные организации\n"\
        ""c_server"5. "c_b"Базы преступных группировок\n"\
        ""c_server"6. "c_b"Транспортные компании\n"\
        ""c_server"7. "c_b"Развлечения\n"\
        ""c_server"8. "c_b"Банки\n"\
        ""c_server"9. "c_b"Автосалоны\n"\
        ""c_server"10. "c_b"Города и населенные пункты\n"\
        ""c_server"11. "c_b"Вокзалы\n"\
        ""c_server"12. "c_b"Поиск ближайших мест",
        "Выбрать", "Закрыть"
    );
    return 1;
}

stock StartAutoPilot(playerid, Float:x, Float:y, Float:z)
{
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return SendClientMessage(playerid, 0xFF5252FF, "{FF5252}Ошибка:{FFFFFF} Вы должны быть за рулём машины!");

    if(g_AutoPilotActive[playerid])
    {
        KillTimer(g_AutoPilotTimer[playerid]);
    }

    g_AutoPilotTarget[playerid][0] = x;
    g_AutoPilotTarget[playerid][1] = y;
    g_AutoPilotTarget[playerid][2] = z;
    g_AutoPilotCurSpeed[playerid] = 0.0;
    g_AutoPilotStuckTicks[playerid] = 0;

    new vehicleid = GetPlayerVehicleID(playerid);
    GetVehiclePos(vehicleid, g_AutoPilotLastPos[playerid][0], g_AutoPilotLastPos[playerid][1], g_AutoPilotLastPos[playerid][2]);

    g_AutoPilotActive[playerid] = true;
    g_AutoPilotTimer[playerid] = SetTimerEx("UpdateAutoPilot", AUTOPILOT_TICK_MS, true, "i", playerid);

    SendClientMessage(playerid, 0x00FF00FF, "{00FF00}Автопилот:{FFFFFF} Маршрут проложен. Чтобы отключить, введите {FF5252}/stopautopilot{FFFFFF}.");
    return 1;
}

stock StopAutoPilot(playerid, bool:silent = false)
{
    if(!g_AutoPilotActive[playerid]) return 0;

    KillTimer(g_AutoPilotTimer[playerid]);
    g_AutoPilotActive[playerid] = false;
    g_AutoPilotCurSpeed[playerid] = 0.0;

    if(!silent && IsPlayerConnected(playerid))
        SendClientMessage(playerid, 0x00FF00FF, "{00FF00}Автопилот:{FFFFFF} Автопилот отключён.");
    return 1;
}

CMD:autopilot(playerid, params[])
{
    if(!IsPlayerLogged(playerid)) return 0;
    return ShowAutopilotMenu(playerid);
}

CMD:stopautopilot(playerid, params[])
{
    if(!IsPlayerLogged(playerid)) return 0;

    if(!g_AutoPilotActive[playerid])
        return SendClientMessage(playerid, 0xFF5252FF, "{FF5252}Ошибка:{FFFFFF} Автопилот не активирован!");

    StopAutoPilot(playerid);
    return 1;
}

public UpdateAutoPilot(playerid)
{
    if(!g_AutoPilotActive[playerid]) return 0;

    if(!IsPlayerConnected(playerid))
    {
        StopAutoPilot(playerid, true);
        return 0;
    }

    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        SendClientMessage(playerid, 0xFF5252FF, "{FF5252}Автопилот:{FFFFFF} Вы вышли из машины. Автопилот отключён.");
        StopAutoPilot(playerid, true);
        return 0;
    }

    new vehicleid = GetPlayerVehicleID(playerid);
    new Float:vX, Float:vY, Float:vZ, Float:vAngle;
    new Float:tX = g_AutoPilotTarget[playerid][0];
    new Float:tY = g_AutoPilotTarget[playerid][1];
    new Float:tZ = g_AutoPilotTarget[playerid][2];

    GetVehiclePos(vehicleid, vX, vY, vZ);
    GetVehicleZAngle(vehicleid, vAngle);

    new Float:distToTarget = GetVehicleDistanceFromPoint(vehicleid, tX, tY, tZ);

    if(distToTarget < AUTOPILOT_ARRIVE_DIST)
    {
        SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
        SetVehicleAngularVelocity(vehicleid, 0.0, 0.0, 0.0);
        SendClientMessage(playerid, 0x00FF00FF, "{00FF00}Автопилот:{FFFFFF} Вы прибыли в пункт назначения!");
        StopAutoPilot(playerid, true);
        return 0;
    }

    // ---- Детект "застряли в препятствии" (упёрлись в стену/объект и не двигаемся) ----
    new Float:dLX = vX - g_AutoPilotLastPos[playerid][0];
    new Float:dLY = vY - g_AutoPilotLastPos[playerid][1];
    new Float:dLZ = vZ - g_AutoPilotLastPos[playerid][2];
    new Float:movedDist = floatsqroot(dLX*dLX + dLY*dLY + dLZ*dLZ);

    if(g_AutoPilotCurSpeed[playerid] > (AUTOPILOT_MIN_SPEED * 0.5) && movedDist < 0.05)
    {
        g_AutoPilotStuckTicks[playerid]++;
    }
    else
    {
        g_AutoPilotStuckTicks[playerid] = 0;
    }

    g_AutoPilotLastPos[playerid][0] = vX;
    g_AutoPilotLastPos[playerid][1] = vY;
    g_AutoPilotLastPos[playerid][2] = vZ;

    if(g_AutoPilotStuckTicks[playerid] > AUTOPILOT_STUCK_LIMIT)
    {
        SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
        SendClientMessage(playerid, 0xFF5252FF, "{FF5252}Автопилот:{FFFFFF} машина упёрлась в препятствие, автопилот отключён.");
        StopAutoPilot(playerid, true);
        return 0;
    }

    // ---- Поворот к цели: плавно, с жёстким ограничением угла за один тик ----
    // (раньше угол задавался почти мгновенно - SetVehicleZAngle резко "довора-
    // чивал" кузов при высокой скорости, из-за чего физика машины конфликтовала
    // сама с собой и машину подбрасывало/уносило в полёт)
    new Float:targetAngle = GetAngleToPoint(tX, tY, vX, vY);
    new Float:angleDiff = targetAngle - vAngle;

    if(angleDiff < -180.0) angleDiff += 360.0;
    if(angleDiff > 180.0) angleDiff -= 360.0;

    new Float:turnStep = angleDiff * 0.25;
    if(turnStep > AUTOPILOT_MAX_TURN_PER_TICK) turnStep = AUTOPILOT_MAX_TURN_PER_TICK;
    if(turnStep < -AUTOPILOT_MAX_TURN_PER_TICK) turnStep = -AUTOPILOT_MAX_TURN_PER_TICK;

    new Float:newAngle = vAngle + turnStep;
    if(newAngle < 0.0) newAngle += 360.0;
    if(newAngle >= 360.0) newAngle -= 360.0;

    SetVehicleZAngle(vehicleid, newAngle);
    // гасим паразитное вращение (кувырки/переворот) от предыдущих столкновений
    SetVehicleAngularVelocity(vehicleid, 0.0, 0.0, 0.0);

    // ---- Скорость: тормозим у цели и заметно сильнее - на резких поворотах ----
    new Float:desiredSpeed = AUTOPILOT_MAX_SPEED;
    if(distToTarget < AUTOPILOT_SLOWDOWN_DIST)
    {
        desiredSpeed = AUTOPILOT_MIN_SPEED + ((AUTOPILOT_MAX_SPEED - AUTOPILOT_MIN_SPEED) * (distToTarget / AUTOPILOT_SLOWDOWN_DIST));
    }

    new Float:absAngleDiff = floatabs(angleDiff);
    if(absAngleDiff > 60.0)
    {
        desiredSpeed = AUTOPILOT_TURN_MIN_SPEED;
    }
    else if(absAngleDiff > 25.0 && desiredSpeed > AUTOPILOT_MIN_SPEED)
    {
        desiredSpeed = AUTOPILOT_MIN_SPEED;
    }

    if(g_AutoPilotCurSpeed[playerid] < desiredSpeed)
    {
        g_AutoPilotCurSpeed[playerid] += 3.0;
        if(g_AutoPilotCurSpeed[playerid] > desiredSpeed) g_AutoPilotCurSpeed[playerid] = desiredSpeed;
    }
    else if(g_AutoPilotCurSpeed[playerid] > desiredSpeed)
    {
        g_AutoPilotCurSpeed[playerid] -= 5.0;
        if(g_AutoPilotCurSpeed[playerid] < desiredSpeed) g_AutoPilotCurSpeed[playerid] = desiredSpeed;
    }

    new Float:rawSpeed = g_AutoPilotCurSpeed[playerid] / 100.0;

    new Float:oldVelX, Float:oldVelY, Float:oldVelZ;
    GetVehicleVelocity(vehicleid, oldVelX, oldVelY, oldVelZ);

    // ключевая правка: гасим вертикальную скорость машины, чтобы её не "уносило
    // в полёт" после наезда на бордюр/объект (раньше старая Z-скорость просто
    // копировалась дальше без ограничений и могла бесконтрольно расти)
    if(oldVelZ > 0.03) oldVelZ = 0.03;
    if(oldVelZ < -0.08) oldVelZ = -0.08;

    new Float:newVelX = -floatsin(newAngle, degrees) * rawSpeed;
    new Float:newVelY = floatcos(newAngle, degrees) * rawSpeed;

    SetVehicleVelocity(vehicleid, newVelX, newVelY, oldVelZ);
    return 1;
}

stock bool:Autopilot_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_AUTOPILOT_MAIN:
        {
            if(!response) return true;

            new title[128];

            switch(listitem)
            {
                case 0:
                {
                    format(title, sizeof title, "{FF5252}Автопилот{ffffff} | Важные места");
                    Dialog(playerid, DIALOG_AUTOPILOT_PUBLIC, DIALOG_STYLE_LIST, title,
                        "1. Правительство\n2. Автошкола\n3. Военкомат\n4. Городская больница г.Арзамас",
                        "Выбрать", "Назад");
                }
                case 1:
                {
                    format(title, sizeof title, "{FF5252}Автопилот{ffffff} | Работы для новичков");
                    Dialog(playerid, DIALOG_AUTOPILOT_TRANSPORT, DIALOG_STYLE_LIST, title,
                        "1. Шахта\n2. Грузчик\n3. Завод",
                        "Выбрать", "Назад");
                }
                case 2:
                {
                    format(title, sizeof title, "{FF5252}Автопилот{ffffff} | По работе");
                    Dialog(playerid, DIALOG_AUTOPILOT_JOBS, DIALOG_STYLE_LIST, title,
                        "1. База механиков\n2. Курьерская служба доставки\n3. Аренда автобуса (Южный)\n4. Аренда автобуса (Арзамас)\n5. Аренда автобуса (Батырево)\n6. Водолаз\n7. ТЦК",
                        "Выбрать", "Назад");
                }
                case 3:
                {
                    format(title, sizeof title, "{FF5252}Автопилот{ffffff} | Государственные организации");
                    Dialog(playerid, DIALOG_AUTOPILOT_ORG, DIALOG_STYLE_LIST, title,
                        "1. Правительство области\n2. Отдел полиции №1 (ГИБДД)\n3. Отдел полиции №2 (УМВД)\n4. Отдел ФСБ\n5. Городская больница г. Арзамас\n6. СМИ\n7. Воинская часть",
                        "Выбрать", "Назад");
                }
                case 4:
                {
                    format(title, sizeof title, "{FF5252}Автопилот{ffffff} | Базы преступных группировок");
                    Dialog(playerid, DIALOG_AUTOPILOT_GANGS, DIALOG_STYLE_LIST, title,
                        "1. Арзамасская ОПГ\n2. Батыревская ОПГ\n3. Лыткаринская ОПГ",
                        "Выбрать", "Назад");
                }
                case 5:
                {
                    format(title, sizeof title, "{FF5252}Автопилот{ffffff} | Транспортные компании");
                    Dialog(playerid, DIALOG_AUTOPILOT_BERTHS, DIALOG_STYLE_LIST, title,
                        "1. Причал возле Гарели\n2. Причал г.Южный\n3. Причал г.Арзамас\n4. Причал г.Лыткарино",
                        "Выбрать", "Назад");
                }
                case 6:
                {
                    format(title, sizeof title, "{FF5252}Автопилот{ffffff} | Развлечения");
                    Dialog(playerid, DIALOG_AUTOPILOT_ENTERTAIN, DIALOG_STYLE_LIST, title,
                        "1. Казино\n2. Битва за контейнеры\n3. Компьютерный клуб",
                        "Выбрать", "Назад");
                }
                case 7:
                {
                    format(title, sizeof title, "{FF5252}Автопилот{ffffff} | Банки");
                    Dialog(playerid, DIALOG_AUTOPILOT_BANKS, DIALOG_STYLE_LIST, title,
                        "1. Центральный банк Арзамас\n2. Центральный банк Батырево\n3. Центральный банк Южный",
                        "Выбрать", "Назад");
                }
                case 8:
                {
                    format(title, sizeof title, "{FF5252}Автопилот{ffffff} | Автосалоны");
                    Dialog(playerid, DIALOG_AUTOPILOT_AUTOSALONS, DIALOG_STYLE_LIST, title,
                        "1. Автосалон низкого класса\n2. Автосалон среднего класса\n3. Автосалон высокого класса\n4. Салон грузовых автомобилей\n5. Мотосалон 'Harley Davidson'\n6. Авторынок поддержанных автомобилей",
                        "Выбрать", "Назад");
                }
                case 9:
                {
                    format(title, sizeof title, "{FF5252}Автопилот{ffffff} | Города и населенные пункты");
                    Dialog(playerid, DIALOG_AUTOPILOT_CITIES, DIALOG_STYLE_LIST, title,
                        "1. г. Южный\n2. г. Арзамас\n3. д. Рублевка\n4. п. Егоровка\n5. пгт. Батырево\n6. г. Лыткарино\n7. г. Эдово\n8. п. Бусаево\n9. д. Корякино",
                        "Выбрать", "Назад");
                }
                case 10:
                {
                    format(title, sizeof title, "{FF5252}Автопилот{ffffff} | Вокзалы");
                    Dialog(playerid, DIALOG_AUTOPILOT_VOKZALS, DIALOG_STYLE_LIST, title,
                        "1. Вокзал г. Арзамас\n2. Вокзал г. Южный\n3. Вокзал пгт. Батырево",
                        "Выбрать", "Назад");
                }
                case 11:
                {
                    format(title, sizeof title, "{FF5252}Автопилот{ffffff} | Поиск ближайших мест");
                    Dialog(playerid, DIALOG_AUTOPILOT_MISTS, DIALOG_STYLE_LIST, title,
                        "1. Найти ближайшую АЗС\n2. Найти ближайший магазин 24/7\n3. Найти ближайший магазин одежды\n4. Найти ближайший магазин оружия",
                        "Выбрать", "Назад");
                }
            }
            return true;
        }

        case DIALOG_AUTOPILOT_PUBLIC:
        {
            if(response && 0 <= listitem <= sizeof ap_public_places - 1)
                StartAutoPilot(playerid, ap_public_places[listitem][0], ap_public_places[listitem][1], ap_public_places[listitem][2]);
            else if(!response) ShowAutopilotMenu(playerid);
            return true;
        }
        case DIALOG_AUTOPILOT_TRANSPORT:
        {
            if(response && 0 <= listitem <= sizeof ap_transport - 1)
                StartAutoPilot(playerid, ap_transport[listitem][0], ap_transport[listitem][1], ap_transport[listitem][2]);
            else if(!response) ShowAutopilotMenu(playerid);
            return true;
        }
        case DIALOG_AUTOPILOT_JOBS:
        {
            if(response && 0 <= listitem <= sizeof ap_jobs - 1)
                StartAutoPilot(playerid, ap_jobs[listitem][0], ap_jobs[listitem][1], ap_jobs[listitem][2]);
            else if(!response) ShowAutopilotMenu(playerid);
            return true;
        }
        case DIALOG_AUTOPILOT_ORG:
        {
            if(response && 0 <= listitem <= sizeof ap_state_organizations - 1)
                StartAutoPilot(playerid, ap_state_organizations[listitem][0], ap_state_organizations[listitem][1], ap_state_organizations[listitem][2]);
            else if(!response) ShowAutopilotMenu(playerid);
            return true;
        }
        case DIALOG_AUTOPILOT_GANGS:
        {
            if(response && 0 <= listitem <= sizeof ap_gangs - 1)
                StartAutoPilot(playerid, ap_gangs[listitem][0], ap_gangs[listitem][1], ap_gangs[listitem][2]);
            else if(!response) ShowAutopilotMenu(playerid);
            return true;
        }
        case DIALOG_AUTOPILOT_BERTHS:
        {
            if(response && 0 <= listitem <= sizeof ap_berths - 1)
                StartAutoPilot(playerid, ap_berths[listitem][0], ap_berths[listitem][1], ap_berths[listitem][2]);
            else if(!response) ShowAutopilotMenu(playerid);
            return true;
        }
        case DIALOG_AUTOPILOT_ENTERTAIN:
        {
            if(response && 0 <= listitem <= sizeof ap_entertainment - 1)
                StartAutoPilot(playerid, ap_entertainment[listitem][0], ap_entertainment[listitem][1], ap_entertainment[listitem][2]);
            else if(!response) ShowAutopilotMenu(playerid);
            return true;
        }
        case DIALOG_AUTOPILOT_BANKS:
        {
            if(response && 0 <= listitem <= sizeof ap_banks - 1)
                StartAutoPilot(playerid, ap_banks[listitem][0], ap_banks[listitem][1], ap_banks[listitem][2]);
            else if(!response) ShowAutopilotMenu(playerid);
            return true;
        }
        case DIALOG_AUTOPILOT_AUTOSALONS:
        {
            if(response && 0 <= listitem <= sizeof ap_autosalons - 1)
                StartAutoPilot(playerid, ap_autosalons[listitem][0], ap_autosalons[listitem][1], ap_autosalons[listitem][2]);
            else if(!response) ShowAutopilotMenu(playerid);
            return true;
        }
        case DIALOG_AUTOPILOT_CITIES:
        {
            if(response && 0 <= listitem <= sizeof ap_cities - 1)
                StartAutoPilot(playerid, ap_cities[listitem][0], ap_cities[listitem][1], ap_cities[listitem][2]);
            else if(!response) ShowAutopilotMenu(playerid);
            return true;
        }
        case DIALOG_AUTOPILOT_VOKZALS:
        {
            if(response && 0 <= listitem <= sizeof ap_vokzals - 1)
                StartAutoPilot(playerid, ap_vokzals[listitem][0], ap_vokzals[listitem][1], ap_vokzals[listitem][2]);
            else if(!response) ShowAutopilotMenu(playerid);
            return true;
        }
        case DIALOG_AUTOPILOT_MISTS:
        {
            if(response)
            {
                new Float:x, Float:y, Float:z, id;

                switch(listitem)
                {
                    case 0:
                    {
                        id = GetNearestFuelStation(playerid, 0.0);
                        x = GetFuelStationData(id, FS_POS_X);
                        y = GetFuelStationData(id, FS_POS_Y);
                        z = GetFuelStationData(id, FS_POS_Z);
                    }
                    case 1:
                    {
                        id = GetNearestBiz(playerid, BUSINESS_TYPE_SHOP_24_7, 0.0);
                        x = GetBusinessData(id, B_POS_X);
                        y = GetBusinessData(id, B_POS_Y);
                        z = GetBusinessData(id, B_POS_Z);
                    }
                    case 2:
                    {
                        id = GetNearestBiz(playerid, BUSINESS_TYPE_CLOTHING_SHOP, 0.0);
                        x = GetBusinessData(id, B_POS_X);
                        y = GetBusinessData(id, B_POS_Y);
                        z = GetBusinessData(id, B_POS_Z);
                    }
                    case 3:
                    {
                        id = GetNearestBiz(playerid, BUSINESS_TYPE_SHOP_GUN, 0.0);
                        x = GetBusinessData(id, B_POS_X);
                        y = GetBusinessData(id, B_POS_Y);
                        z = GetBusinessData(id, B_POS_Z);
                    }
                }

                StartAutoPilot(playerid, x, y, z);
            }
            else ShowAutopilotMenu(playerid);
            return true;
        }
    }
    return false;
}
