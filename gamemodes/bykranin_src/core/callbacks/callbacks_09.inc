//>> Файл: bykranin_src/core/callbacks/callbacks_09.inc  (242 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: SendTurnSignalRPC, OnIncomingRPC
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock SendTurnSignalRPC(playerid, vehicleid, subtype)
{
    new BitStream:bs = BS_New();

    BS_WriteValue(
        bs,
        PR_UINT32, 3,
        PR_UINT16, vehicleid,
        PR_UINT8, subtype
    );

    PR_SendRPC(
        bs,
        playerid,
        97,
        PR_HIGH_PRIORITY,
        PR_RELIABLE_ORDERED
    );

    BS_Delete(bs);
	return 1;
}

public OnIncomingRPC(playerid, rpcid, BitStream:bs)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 1;

    if (rpcid == 97)
    {
        new firstValue;

        if (!BS_ReadUint32(bs, firstValue))
            return 1;

        if(firstValue == 2)
        {
            new weaponid = GetPlayerWeapon(playerid);
            if(weaponid < 22 || weaponid > 34)
                return 1;

            new tick = GetTickCount();
            if(GetPVarInt(playerid, "mobile_reload_tick") > tick)
                return 0;

            SetPVarInt(playerid, "mobile_reload_tick", tick + 500);

            new slot = GetWeaponSlot(weaponid);
            if(slot < 0 || slot >= MAX_WEAPON_SLOTS)
                return 1;

            new ammo = GetPlayerWeaponInfo(playerid, slot, TRACK_W_AMMO);
            if(ammo <= 0)
                return 1;

            SetPlayerAmmo(playerid, weaponid, ammo);
            SetPlayerArmedWeapon(playerid, weaponid);
            return 0;
        }

        // Поворотники: 1 — левый, 2 — правый, 3 — аварийная сигнализация.
        if(firstValue == 3)
        {
            new vehicleid;
            new turnStatus;

            if(!BS_ReadUint16(bs, vehicleid)) return 1;
            if(!BS_ReadUint8(bs, turnStatus)) return 1;

            if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 1;
            if(!IsValidVehicle(vehicleid)) return 1;
            if(GetPlayerVehicleID(playerid) != vehicleid) return 1;
            if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
            if(turnStatus < 1 || turnStatus > 3) return 1;

            if(TurnSignalState[vehicleid] == turnStatus && TurnSignalDriver[vehicleid] == playerid)
            {
                StopVehicleTurnSignal(vehicleid);
            }
            else
            {
                StopVehicleTurnSignal(vehicleid);
                StartVehicleTurnSignal(playerid, vehicleid, turnStatus);
            }
            return 1;
        }
        if (firstValue == 1)
        {
            new vehicleNetId;
            new Float:damage;
            new damagedPiece;

            if (!BS_ReadUint16(bs, vehicleNetId)) return 1;
            if (!BS_ReadFloat(bs, damage)) return 1;
            if (!BS_ReadUint16(bs, damagedPiece)) return 1;

            new vehicleid = vehicleNetId;
            if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || !IsValidVehicle(vehicleid)) return 1;
            if(damage != damage || damage <= 0.0 || damage > 1000.0) return 1;
            {
                new tick = GetTickCount();

                if (tick - gLastVehicleDamageTick[playerid] < 600)
                    return 0;

                gLastVehicleDamageTick[playerid] = tick;

                ApplyVehicleDamage(playerid, vehicleid, damage, damagedPiece);
            }
            return 1;
        }

        // Иначе firstValue = action
        new action = firstValue;
        new actionSubtype;

        if (action == 14)
        {
            if (!BS_ReadUint8(bs, actionSubtype))
                return 1;

            switch (actionSubtype)
            {
                case 0:
                {
                    BlackPass_OpenTasksScreen(playerid);
                }
                case 1:
                {
                    BlackPass_OpenTasksScreen(playerid);
                }
                case 2:
                {
                    callcmd::donate(playerid);
                }
                case 3:
                {
                    ShowPlayerDialog_Example(playerid);
                }
                case 4:
                {
                    ShowPlayerDialog_Example(playerid);
                }
                case 5:
                {
                    ShowPlayerDialog_Example(playerid);
                }
                case 6:
                {
                    ShowPlayerDialog_Example(playerid);
                }
            }
        }

        switch (action)
        {
            case 3:
            {
            }
            case 4:
            {
                callcmd::radial(playerid);
            }
            case 18:
            {

                if(IsPlayerAtATM(playerid))
                {
                    return callcmd::bankomat(playerid, "");
                }

                if (IsPlayerInRangeOfAnyCasinoTable(playerid))
                {
                    return ShowCasinoDiceUi(playerid);
                }

                if (IsPlayerInRangeOfAnyBlackJackTable(playerid))
                {
                    return callcmd::blackjack(playerid);
                }

                // FSIN HR uses the shared bottom interaction button.
                if(FsinFull_OnContextInteraction(playerid))
                {
                    return 1;
                }

                // The construction foreman uses the same interaction action as casino tables.
                if(Construction_TryInteract(playerid))
                {
                    return 1;
                }

                // HR desks use the exact same bottom interaction button as
                // the pier captain. No ALT/Y key and no clickable notification.
                if(HRDepartment_TryInteract(playerid))
                {
                    return 1;
                }

                // Hospital beds use the same mobile interaction action as the
                // pier captain. Nothing happens merely from entering the area.
                new hospital_bed = GetNearestMedBed(playerid, 2.8);
                if(hospital_bed != -1 && MedBed_IsPlayerInHospitalArea(playerid))
                {
                    ToggleInteractionWindow(playerid, false);
                    return MedBed_TryOccupy(playerid, hospital_bed);
                }

                // V11 diver fix: use the exact same mobile interaction action as containers.
                if(IsPlayerNearVodolazCaptain(playerid))
                {
                    return callcmd::vodoact(playerid);
                }

                if(IsPlayerNearVodolazLoot(playerid))
                {
                    ToggleInteractionWindow(playerid, false);
                    return callcmd::vodolootyashik(playerid);
                }

                if (IsPlayerNearContainer(playerid))
                {
                    return callcmd::cont(playerid);
                }

                if(IsPlayerNearMotoSalonRange(playerid))
                {
                    DebugMotoSalonLog(playerid, "Interaction:MOTO_RANGE:open_market");
                    ToggleInteractionWindow(playerid, false);
                    return EnterPlayerBuyCarMarket(playerid, STATIC_BIZ_ID_MOTO_SALON);
                }

                return 1;
            }
        }

        return 1;
    }

    return 1;
}
