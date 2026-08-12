stock getPlayerIdByNickname(const nickname[])
{
    if (strlen(nickname) > 0)
    {
        foreach (new i : Player)
        {
            new name[MAX_PLAYER_NAME + 1];
            GetPlayerName(i, name, sizeof(name));
            
            if (!strcmp(nickname, name)) {
                return i;
            }
        }
    }

    return -1;
}

/*stock getPlayerMaxCarsNumber(playerid)
{
    new playerHouseId = pInfo[playerid][pHouseID];
    if (playerHouseId != -1) {
        return 1 + HouseInfo[playerHouseId][hKlass];
    }

    return 0;
}*/

stock getPlayerMaxCarsNumber(playerid)
{
    new 
        house_id = pInfo[playerid][pHouseID],
        garage_id = HouseInfo[house_id][hGarageID];

    if house_id != - 1 *then
    {
        return garage_id != -1 ?  GarageInt[garage_id][gVehicleCount] : 2;
    }

    return -1;
}