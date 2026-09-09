#define POGONY_MVD 0
#define POGONY_ARMY 1

enum e_pogony
{
    e_modelid,
    e_rankpog
};
new const mvd_pogony[][e_pogony] = 
{
    {4119, 10},
    {4120, 9},
    {4121, 8},
    {4122, 7},
    {4123, 6},
    {4124, 5}
};
new const arm_pogony[][e_pogony] = 
{
    {18353, 1},
    {18354, 2},
    {18355, 3},
    {18356, 4},
    {18357, 5},
    {18358, 6},
    {18359, 7},
    {18360, 8},
    {18361, 9}
};

enum e_temp_skin
{
    e_model,
    e_sex,
    e_type
};

new const mvd_skin[][e_temp_skin] =
{
    {15384, 1, 0},
    {15381, 1, 0},
    {15387, 1, 0},
    {276, 1, 0},
    {15386, 1, 0},
    {15385, 1, 0},
    {15383, 1, 0},
    {15388, 1, 0},
    {15382, 1, 0}
};

new const arm_skin[][e_temp_skin] =
{
    {253, 1, 0},
    {30, 1, 0},
    {179, 1, 0},
    {287, 1, 0},
    {61, 1, 0}
};

SysPogony_GetModelID(rank, type, &modelid)
{
    if(type == POGONY_MVD)
    {
        for(new i = 0; i < sizeof mvd_pogony; i++)
        {
            if(mvd_pogony[i][e_rankpog] == rank)
            {
                modelid = mvd_pogony[i][e_modelid];
                return 1;
            }
        }
    }
    else if(type == POGONY_ARMY)
    {
        for(new i = 0; i < sizeof arm_pogony; i++)
        {
            if(arm_pogony[i][e_rankpog] == rank)  
            {
                modelid = arm_pogony[i][e_modelid];
                return 1;
            }
        }
    }
    return 0;
}

SysPogony_RemovePogony(playerid)
{
    if(IsPlayerAttachedObjectSlotUsed(playerid, 9)) RemovePlayerAttachedObject(playerid, 9);
    if(IsPlayerAttachedObjectSlotUsed(playerid, 8)) RemovePlayerAttachedObject(playerid, 8);
}
SysPogony_AddPogony(playerid)
{
    new skinid = GetPlayerData(playerid, P_OSKIN);
    new index;

    if(GetPlayerTeamEx(playerid) == TEAM_ARMY)
    {
        if(SysPogony_IsARMskin(skinid, index))
        {
            new modelid;
            if(SysPogony_GetModelID(GetPlayerJob(playerid), POGONY_ARMY, modelid))
            {
                SysPogony_RemovePogony(playerid);

                if(arm_skin[index][e_sex] == 0) 
                {
                    SetPlayerAttachedObject(playerid, 9, modelid, 15, 0.090, 0.026, 0.049, -2.500, -23.600, 83.999, 1.000, 1.000, 1.000);
                    SetPlayerAttachedObject(playerid, 8, modelid, 16, 0.087, 0.021, -0.050, 0.000, -154.999, -92.300, 1.000, 1.000, 1.000);
                }
                else 
                {
                    SetPlayerAttachedObject(playerid, 9, modelid, 15, 0.152, -0.004, 0.074, -2.500, -8.800, 83.999, 1.000, 1.000, 1.000);
                    SetPlayerAttachedObject(playerid, 8, modelid, 16, 0.140, -0.007, -0.074, 0.000, -170.800, -83.900, 1.000, 1.000, 1.000);
                }
            }
        }
    }
    else if(GetPlayerTeamEx(playerid) == TEAM_MVD)
    {
        if(SysPogony_IsMVDskin(skinid, index))
        {
            new modelid;
            if(SysPogony_GetModelID(GetPlayerJob(playerid), POGONY_MVD, modelid))
            {
                SysPogony_RemovePogony(playerid);

                if(mvd_skin[index][e_sex] == 0)
                {
                    SetPlayerAttachedObject(playerid, 9, modelid, 15, 0.096, 0.013, 0.047, 4.399, -24.799, 179.999, 1.000, 1.000, 1.000);
                    SetPlayerAttachedObject(playerid, 8, modelid, 16, 0.101, 0.017, -0.050, 0.000, -158.600, 0.000, 1.000, 1.000, 1.000);
                }
                else
                {
                    SetPlayerAttachedObject(playerid, 9, modelid, 15, 0.157, 0.014, 0.072, 0.000, -12.100, 174.800, 1.000, 1.000, 1.000);
                    SetPlayerAttachedObject(playerid, 8, modelid, 16, 0.152, 0.014, -0.071, 0.000, -169.900, -0.000, 1.000, 1.000, 1.000);

				}
            }
        }
    }
}
SysPogony_IsARMskin(skinid, &index)
{
    for(new i = 0; i < sizeof arm_skin; i++)
    {
        if(skinid == arm_skin[i][e_model])
        {
            index = i;
            return 1;
        }
    }
    return 0;
}
SysPogony_IsMVDskin(skinid, &index)
{
    for(new i = 0; i < sizeof mvd_skin;   i++)
    {
        if(skinid == mvd_skin[i][e_model])
        {
            index = i;
            return 1;
        }
    }
    return 0;
}

SysPogony_UpdatePogonyForAll(playerid)
{
    SysPogony_CheckAndUpdatePogony(playerid);
}


forward SysPogony_LoadPogonyDelayed(playerid);
public SysPogony_LoadPogonyDelayed(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    
    SysPogony_CheckAndUpdatePogony(playerid);
    return 1;
}

SysPogony_CheckAndUpdatePogony(playerid)
{
    new skinid = GetPlayerData(playerid, P_OSKIN);
    new index;
    
    if(GetPlayerTeamEx(playerid) == TEAM_ARMY)
    {
        if(SysPogony_IsARMskin(skinid, index))
        {
            SysPogony_AddPogony(playerid);
        }
        else
        {
            SysPogony_RemovePogony(playerid);
        }
    }
    else if(GetPlayerTeamEx(playerid) == TEAM_MVD)
    {
        if(SysPogony_IsMVDskin(skinid, index))
        {
            SysPogony_AddPogony(playerid);
        }
        else
        {
            SysPogony_RemovePogony(playerid);
        }
    }
    else
    {
        SysPogony_RemovePogony(playerid);
    }
}