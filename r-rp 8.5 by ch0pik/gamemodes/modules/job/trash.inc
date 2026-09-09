enum E_TRASH_STRUCT
{
    TRASH_CAR_model_id,
	Float: TRASH_CAR_POS_X,
	Float: TRASH_CAR_POS_Y,
	Float: TRASH_CAR_POS_Z,
	Float: TRASH_CAR_POS_A
};
#define MAX_TRASH_CAR		(6)
new const
	g_trash_car[MAX_TRASH_CAR][E_TRASH_STRUCT] =
{
	{15670,-2109.4185,-299.4727,25.8673,80.2167},
	{15670,-2110.2864,-304.0607,25.8241,80.1169},
	{408,-2112.0042,-307.8977,26.0735,78.8185},
	{408,-2112.7190,-312.1628,26.0327,78.6320},
	{408,-2113.6372,-316.5615,25.9900,79.9098},
	{408,-2067.3118,-143.5456,26.3592,79.1297}
};
enum E_PLAYER_TRASH
{
    TRASH_ID_CAR,
	TRASH_ID,
};
new const
	g_player_trash[MAX_PLAYERS][E_PLAYER_TRASH];
enum E_WORK_TRASH_STRUCT
{
	T_ID_TRASH,
    T_OWNER_TRASH,
	T_STATUS,
	Float: TRASH_POS_X,
	Float: TRASH_POS_Y,
	Float: TRASH_POS_Z,
	Float: TRASH_POS_A
};
new total_trash;
#define MAX_TRASH		(14)
new g_trash_bag[MAX_TRASH];
new const
	g_trash_work[MAX_TRASH][E_WORK_TRASH_STRUCT] =
{
	{1,-1,1,216.97,854.82,11.85,0.0},
	{2,-1,1,182.40,844.03,11.85,0.0},
	{3,-1,1,-268.85,557.04,12.50,0.0},
	{4,-1,1,-313.18,547.09,12.40,0.0},
	{5,-1,1,-398.32,658.32,11.95,0.0},
	{6,-1,1,-325.01,990.23,11.71,0.0},
	{7,-1,1,-365.77,1019.36,11.73,0.0},
	{8,-1,1,-1081.21,2208.38,37.77,0.0},
	{9,-1,1,-2416.06,2752.61,37.58,0.0},
	{10,-1,1,-2444.77,2799.61,37.58,0.0},
	{11,-1,1,-2392.11,2837.07,37.37,0.0},
	{12,-1,1,-2462.89,2830.77,37.58,0.0},
	{13,-1,1,-2377.93,2942.21,37.39,0.0},
	{14,-1,1,-2463.49,2939.42,37.41,0.0}
};
CMD:trash(playerid)
{
	if(total_trash == 0) return SendClientMessage(playerid,-1,"Свободных мусорок нет.");
	if(g_player_trash[playerid][TRASH_ID_CAR] != 0)
	{
		string_dialog[0] = EOS;
		STRING_GLOBAL[0] = EOS;
		for(new idx, count; idx < sizeof g_trash_work; idx ++)
		{
			if(g_trash_work[idx][T_STATUS] != 1) continue;
			format(STRING_GLOBAL, sizeof STRING_GLOBAL, "%d. Дистанция [%.1f м.]      Загруженность [\"50%\"]     [Свободно]\n",g_trash_work[idx][T_ID_TRASH], GetPlayerDistanceFromPoint(playerid,  g_trash_work[idx][TRASH_POS_X], g_trash_work[idx][TRASH_POS_Y], g_trash_work[idx][TRASH_POS_Z]));
			strcat(string_dialog, STRING_GLOBAL);
			SetPlayerListitemValue(playerid, count ++, idx);
		}
		Dialog(playerid, TRASH_PLAYER_WORK, DIALOG_STYLE_LIST, "Места", string_dialog, "Выбрать", "Выйти");
	}
	else SendClientMessage(playerid,-1,"Вы не работаете мусоровозом");
	return 1;
}