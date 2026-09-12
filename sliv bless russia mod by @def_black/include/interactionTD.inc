// Encoding: Cyrillic (Windows 1251) 
// Ъюфш№ютър: Ъш№шыышір (Windows 1251) 

#if defined _SYSTEM_INTERACTION
	#endinput
#endif
#define _SYSTEM_INTERACTION

#define USC             "{ff2400}| {ffffff}"
#define COR_SERVER          0xFF0000FF

// ------------------------------------
forward OnPlayerInteractionEx(playerid, interactionid);

new PlayerText:interaction_PTD[MAX_PLAYERS][1];

// ------------------------------------
public OnGameModeInit()
{
    print("\n");
    print("=========================================\n");
    print(" System Interaction 2025 loaded.\n");
    print("             Version:  0.0.1\n");
    print("        (Created) 2025 By Wхrtюn\n");
    print("=========================================\n");
    #if defined werint_OnGameModeInit
        return werint_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit werint_OnGameModeInit
#if defined werint_OnGameModeInit
    forward werint_OnGameModeInit();
#endif

public OnPlayerConnect(playerid)
{
    SetPVarInt(playerid, "interaction_td_use", 0);
    CreateInteractionTextDraw(playerid);
    SetTimerEx("OnPlayerInteraction", 1000, true, "w", playerid);
    #if defined werint_OnPlayerConnect
        return werint_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect werint_OnPlayerConnect
#if defined werint_OnPlayerConnect
    forward werint_OnPlayerConnect(playerid);
#endif

stock CreateInteractionTextDraw(playerid) 
{
    interaction_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 434.0000, 295.0000, "txd:interaction_werton");
	PlayerTextDrawTextSize(playerid, interaction_PTD[playerid][0], 48.2000, 73.0000);
	PlayerTextDrawAlignment(playerid, interaction_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, interaction_PTD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, interaction_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, interaction_PTD[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, interaction_PTD[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, interaction_PTD[playerid][0], 0);
	PlayerTextDrawSetSelectable(playerid, interaction_PTD[playerid][0], true);
}

public OnPlayerInteraction(playerid) 
{
    for(new idx; idx < sizeof InteractionDat; idx ++)
	{
	    new Float:x = InteractionDat[idx][0];
        new Float:y = InteractionDat[idx][1];
        new Float:z = InteractionDat[idx][2];
        new Float:range = InteractionDat[idx][3];
        
       if(IsPlayerInRangeOfPoint(playerid, range, x, y, z))
       {
	      if(GetPVarInt(playerid, "interaction_td_use") == 0)
		  {
          SelectTextDraw(playerid, COR_SERVER);
	      PlayerTextDrawShow(playerid, interaction_PTD[playerid][0]);
	      TogglePlayerControllable(playerid, true);
	      ShowHud(playerid);
      	SetPVarInt(playerid, "interaction_td_use", 1);
      	return 1;
	      }
	      return 1;
	   }
	}
	if(GetPVarInt(playerid, "interaction_td_use") == 1)
	{
    PlayerTextDrawHide(playerid, interaction_PTD[playerid][0]);
    if(GetPlayerInterior(playerid))
    {
       printf("[Interaction]Шу№юъ шёяюыќчютры ''тчршьюфхщёђтшх'', эю эрѕюфшђёџ т шэђх№ќх№х");
       SetPVarInt(playerid, "interaction_td_use", 0);
    }
   else
      {
           CancelSelectTextDraw(playerid);
           TogglePlayerControllable(playerid, true);
           SetPVarInt(playerid, "interaction_td_use", 0);
      }
    }
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(playertextid == interaction_PTD[playerid][0])
    {
         for(new idx; idx < sizeof InteractionDat; idx ++)
     	{
            if(IsPlayerInRangeOfPoint(playerid, InteractionDat[idx][3], InteractionDat[idx][0], InteractionDat[idx][1], InteractionDat[idx][2]))
        	{
              OnPlayerInteractionEx(playerid, InteractionDat[idx][4]);
            }
         }
    }
#if defined werint_OnPlayerClickPlayer
		return werint_OnPlayerClickPlayer(playerid, playertextid);
	#else
	    return 0;
	#endif
}
#if defined _ALS_OnPlayerClickPlayerTextD
    #undef OnPlayerClickPlayerTextDraw
#else
    #define _ALS_OnPlayerClickPlayerTextD
#endif
#if defined werint_OnPlayerClickPlayer
	forward werint_OnPlayerClickPlayer(playerid, PlayerText:playertextid);
#endif
#define	OnPlayerClickPlayerTextDraw werint_OnPlayerClickPlayer

CMD:vz(playerid)
{
    for(new idx; idx < sizeof InteractionDat; idx ++)
    {
        if(IsPlayerInRangeOfPoint(playerid, InteractionDat[idx][3], InteractionDat[idx][0], InteractionDat[idx][1], InteractionDat[idx][2]))
        {
            OnPlayerInteractionEx(playerid, InteractionDat[idx][4]);
        }
        }
}