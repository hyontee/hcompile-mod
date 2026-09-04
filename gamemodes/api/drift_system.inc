// =========================================================
// Drift points system (original by @rayden_studio)
// Adapted to berkut.pwn: GivePlayerMoney -> GivePlayerMoneyEx,
// arrays declared here since the source snippet assumed they
// already existed in the mod.
// =========================================================
new DriftPoints[MAX_PLAYERS];
new bool:IsDrifting[MAX_PLAYERS];

stock CheckPlayerDrift(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
    {
        if(DriftPoints[playerid] > 0) EndDrift(playerid);
        return 0;
    }

    new Float:vx, Float:vy, Float:vz, Float:speed;
    GetVehicleVelocity(GetPlayerVehicleID(playerid), vx, vy, vz);
    speed = floatsqroot((vx*vx)+(vy*vy)+(vz*vz)) * 180.0; // Скорость в км/ч

    if(speed < 30.0)
    {
        if(DriftPoints[playerid] > 0) EndDrift(playerid);
        return 0;
    }

    new Float:vAngle, Float:mAngle;
    GetVehicleZAngle(GetPlayerVehicleID(playerid), vAngle);
    mAngle = atan2(vy, vx) - 90.0;
    if(mAngle < 0.0) mAngle += 360.0;

    new Float:driftAngle = floatabs(vAngle - mAngle);
    if(driftAngle > 180.0) driftAngle = 360.0 - driftAngle;

    if(driftAngle > 15.0 && driftAngle < 75.0)
    {
        IsDrifting[playerid] = true;
        new points = floatround(driftAngle * (speed / 20.0));
        DriftPoints[playerid] += points;

        new driftStr[64];
        format(driftStr, sizeof(driftStr), "~r~DRIFT: ~w~%d XP", DriftPoints[playerid]);
        GameTextForPlayer(playerid, driftStr, 1000, 3);
    }
    else
    {
        if(DriftPoints[playerid] > 0) EndDrift(playerid);
    }
    return 1;
}

stock EndDrift(playerid)
{
    if(DriftPoints[playerid] > 100)
    {
        new reward = DriftPoints[playerid] * 10;

        GivePlayerMoneyEx(playerid, reward, "Дрифт", true, false);

        new rewardStr[128];
        format(rewardStr, sizeof(rewardStr), "{00ff00}[Дрифт]{ffffff} Занос завершен! Вы получили {00ff00}%d рублей {ffffff}(Очки: %d)", reward, DriftPoints[playerid]);
        SendClientMessage(playerid, -1, rewardStr);
    }
    DriftPoints[playerid] = 0;
    IsDrifting[playerid] = false;
    return 1;
}
