#if defined _BR_DEATH_CMD_FWD_INC_
    #endinput
#endif
#define _BR_DEATH_CMD_FWD_INC_

// callcmd:: до объявления CMD: в death.pwn
forward pc_cmd_donate(playerid);
forward pc_cmd_car(playerid);
forward pc_cmd_inv(playerid, params[]);
forward pc_cmd_promo(playerid, params[]);
forward pc_cmd_i(playerid, params[]);
forward pc_cmd_buy(playerid, params[]);
forward pc_cmd_business(playerid, params[]);
forward pc_cmd_tungui(playerid, params[]);
forward pc_cmd_kick(playerid, params[]);
forward pc_cmd_mute(playerid, params[]);
forward pc_cmd_jail(playerid, params[]);
forward pc_cmd_warn(playerid, params[]);
forward pc_cmd_ban(playerid, params[]);
forward pc_cmd_e(playerid, params[]);
forward pc_cmd_park(playerid, params[]);
forward pc_cmd_lk(playerid);
forward pc_cmd_l(playerid);
forward pc_cmd_reward(playerid, params[]);
forward pc_cmd_cases(playerid, params[]);

forward Pass_ShowPassportDialog(viewerid, ownerid);
forward Lic_ShowLicensesDialog(viewerid, ownerid);
forward CarPass_ShowDialog(viewerid, ownerid, slot);
forward MM_GetPlayerGender(playerid, dest[], size);
forward MM_GetPlayerHouseLabel(playerid, dest[], size);
