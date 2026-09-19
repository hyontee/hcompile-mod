
#define PACKET_CUSTOMRPC    			        251
			
#define RPC_SHOW_SPAWN_SELECTOR_WINDOW  0x24
#define RPC_SHOW_FUEL_STATION 0x88
#define RPC_SHOW_CAR 0x50
#define RPC_ADMIN_SPEC 0x43
#define RPC_SPEC_NAME 0x44
#define RPC_SHOW_PERSON 0x61
#define RPC_HIDE_PERSON 0x91
#define RPC_SHOW_RECON 0x92
#define RPC_HIDE_RECON 0x93
#define RPC_SHOW_TAXI 0x50

#define RPC_AUTO_SHOP 0x59
#define RPC_UPD_SHOP 0x60
#define RPC_HIDE_AUTO 0x200
#define RPC_SHOW_PASS 0x77
#define RPC_SHOW_SHOP 0x78
#define RPC_HIDE_SHOP 0x79
#define RPC_CASINO_LUCKY_WHEEL_MENU 89
#define RPC_SHOW_CASINO_BUY_CHIP 90
#define RPC_SHOW_DICE_TABLE 91
#define RPC_UPDATE_BACCARAT 92
#define RPC_INVENTAR_SHOWHIDE 		97
#define RPC_MATRIX_CLICK 98
#define RPC_INVENTAR_BUTTONS 99
#define RPC_INVENTAR_CARRYNG 100
#define RPC_ITEM_ACTIVETOGGLE   101
#define RPC_ITEM_MATRIX				102
#define RPC_SPAWN_AT				75
#define RPC_SHOW_FAMILY				0x33

#define MAX_STREAM_SOURCES				1000

new selectcarfamid, famaccess;


stock SpawnPlayerAT(playerid, posX, posY, posZ, rot)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SPAWN_AT);

    BS_WriteValue(bitstream, PR_FLOAT, posX);
	BS_WriteValue(bitstream, PR_FLOAT, posY);
    BS_WriteValue(bitstream, PR_FLOAT, posZ);
	BS_WriteValue(bitstream, PR_FLOAT, rot);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    SetPlayerVirtualWorld(playerid, 0);

    BS_Delete(bitstream);

    return true;
}

stock ShowFamily(playerid, toggle, const name[], money, coin, ifLeader)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_FAMILY);

    BS_WriteValue(bitstream, PR_UINT8, toggle);
	BS_WriteValue(bitstream, PR_UINT16, strlen(name));
	BS_WriteValue(bitstream, PR_STRING, name);
    BS_WriteValue(bitstream, PR_UINT32, money);
	BS_WriteValue(bitstream, PR_UINT32, coin);
    BS_WriteValue(bitstream, PR_UINT8, ifLeader);


    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock ShowFuelStation(playerid, type, price1, price2, price3, price4, price5, maxCount)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_FUEL_STATION);

    BS_WriteValue(bitstream, PR_INT32, type);
    BS_WriteValue(bitstream, PR_INT32, price1);
    BS_WriteValue(bitstream, PR_INT32, price2);
    BS_WriteValue(bitstream, PR_INT32, price3);
    BS_WriteValue(bitstream, PR_INT32, price4);
    BS_WriteValue(bitstream, PR_INT32, price5);
    BS_WriteValue(bitstream, PR_INT32, maxCount);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock ShowSpawnSelectorForPlayer(playerid, org, garage, house)
{
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_SPAWN_SELECTOR_WINDOW);

    BS_WriteValue(bitstream, PR_INT32, org);
    BS_WriteValue(bitstream, PR_INT32, garage);
    BS_WriteValue(bitstream, PR_INT32, house);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);
}

stock ShowCar(playerid, id, const name[])
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_CAR);
    
    BS_WriteValue(bitstream, PR_INT32, id);
	BS_WriteValue(bitstream, PR_UINT16, strlen(name));
	BS_WriteValue(bitstream, PR_STRING, name);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock ShowSpec(playerid, toplayer)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_ADMIN_SPEC);

	BS_WriteValue(bitstream, PR_INT32, toplayer);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock ShowName(playerid, const player_name[])
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SPEC_NAME);

	BS_WriteValue(bitstream, PR_UINT16, strlen(player_name));
	BS_WriteValue(bitstream, PR_STRING, player_name);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock ShowPerson(playerid, toggle)
{
    new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_PERSON);

    BS_WriteValue(bitstream, PR_BOOL, toggle);

	PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

	BS_Delete(bitstream);

	return 1;
}

stock HidePerson(playerid)
{ 
    ShowPerson(playerid, 0);
}

stock ShowRecon(playerid, const name[], toplayer)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_RECON);

	BS_WriteValue(bitstream, PR_UINT16, strlen(name));
	BS_WriteValue(bitstream, PR_STRING, name);

    BS_WriteValue(bitstream, PR_INT32, toplayer);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock HideRecon(playerid)
{
    SendCustomRPC(playerid, RPC_HIDE_RECON);
}

stock ShowTaxi(playerid, id, num, cash, price, rast)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_TAXI);

    BS_WriteValue(bitstream, PR_INT32, id);
    BS_WriteValue(bitstream, PR_INT32, num);
    BS_WriteValue(bitstream, PR_INT32, cash);
    BS_WriteValue(bitstream, PR_INT32, price);
    BS_WriteValue(bitstream, PR_INT32, rast);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock ShowInfoFam(playerid, const name[], const statys[], repa, colivo, lvl1, lvl2, lvl3, cash, mater, masks, fuels, ammos, armors)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_INFOFAM);

	BS_WriteValue(bitstream, PR_UINT16, strlen(name));
	BS_WriteValue(bitstream, PR_STRING, name);

    BS_WriteValue(bitstream, PR_UINT16, strlen(statys));
	BS_WriteValue(bitstream, PR_STRING, statys);

    BS_WriteValue(bitstream, PR_INT32, repa);
    BS_WriteValue(bitstream, PR_INT32, colivo);
    BS_WriteValue(bitstream, PR_INT32, lvl1);
    BS_WriteValue(bitstream, PR_INT32, lvl2);
    BS_WriteValue(bitstream, PR_INT32, lvl3);
    BS_WriteValue(bitstream, PR_INT32, cash);
    BS_WriteValue(bitstream, PR_INT32, mater);
    BS_WriteValue(bitstream, PR_INT32, masks);
    BS_WriteValue(bitstream, PR_INT32, fuels);
    BS_WriteValue(bitstream, PR_INT32, ammos);
    BS_WriteValue(bitstream, PR_INT32, armors);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock ShowUluc(playerid, lvl1, lvl2, lvl3, cash, maxcash, mats, mask, fuels, ammos, puples)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_ULUCFAM);

    BS_WriteValue(bitstream, PR_INT32, lvl1);
    BS_WriteValue(bitstream, PR_INT32, lvl2);
    BS_WriteValue(bitstream, PR_INT32, lvl3);
    BS_WriteValue(bitstream, PR_INT32, cash);
    BS_WriteValue(bitstream, PR_INT32, maxcash);
    BS_WriteValue(bitstream, PR_INT32, mats);
    BS_WriteValue(bitstream, PR_INT32, mask);
    BS_WriteValue(bitstream, PR_INT32, fuels);
    BS_WriteValue(bitstream, PR_INT32, ammos);
    BS_WriteValue(bitstream, PR_INT32, puples);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock HideAuto(playerid)
{
	ShowAuto(playerid, 0);

    return true;
}

stock ShowAuto(playerid, toggle)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_AUTO_SHOP);

    BS_WriteValue(bitstream, PR_BOOL, toggle);

	PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

	BS_Delete(bitstream);

	return 1;
}

stock UpdateAuto(playerid, const name[], price, count, maxspeed, acceleration, gear)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
	BS_WriteValue(bitstream, PR_UINT32, RPC_UPD_SHOP);

	BS_WriteValue(bitstream, PR_UINT8, strlen(name));
    BS_WriteValue(bitstream, PR_STRING, name);

	BS_WriteValue(bitstream, PR_UINT32, price);
	BS_WriteValue(bitstream, PR_UINT32, count);

	BS_WriteValue(bitstream, PR_FLOAT, maxspeed);
	BS_WriteValue(bitstream, PR_FLOAT, acceleration);

	BS_WriteValue(bitstream, PR_UINT32, gear);

	PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

	BS_Delete(bitstream);
}

stock ShowPass(playerid, lvvl, prem, lvlstand)
{
   new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_PASS);

    BS_WriteValue(bitstream, PR_UINT32, lvvl);
    BS_WriteValue(bitstream, PR_BOOL, prem);
    BS_WriteValue(bitstream, PR_UINT32, lvlstand);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock ShowShop(playerid, price)
{
   new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, RPC_SHOW_SHOP);

    BS_WriteValue(bitstream, PR_UINT32, price);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}
stock HideShop(playerid)
{
    SendCustomRPC(playerid, RPC_HIDE_SHOP);
}



stock LoadFamilyCar(playerid, const name[], vehid, access, isspawn)
{
    print("LoadCar");
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x34);

	BS_WriteValue(bitstream, PR_UINT16, strlen(name));

	BS_WriteValue(bitstream, PR_STRING, name);

    BS_WriteValue(bitstream, PR_UINT16, vehid);

    BS_WriteValue(bitstream, PR_UINT16, access);

    BS_WriteValue(bitstream, PR_BOOL, isspawn);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock GetVehidAccess(playerid, vehid, access, isspawn){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x41);

    BS_WriteValue(bitstream, PR_UINT16, vehid);
    BS_WriteValue(bitstream, PR_UINT16, access);
	BS_WriteValue(bitstream, PR_BOOL, isspawn);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock LoadFamilyNotif(playerid, const text[], const name[]){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x44);

    BS_WriteValue(bitstream, PR_UINT16, strlen(text));
	BS_WriteValue(bitstream, PR_STRING, text);
    BS_WriteValue(bitstream, PR_UINT16, strlen(name));
	BS_WriteValue(bitstream, PR_STRING, name);
	
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}
stock LoadFamilyRaiting(playerid, const name[], rep, capture){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x45);

    BS_WriteValue(bitstream, PR_UINT16, strlen(name));
	BS_WriteValue(bitstream, PR_STRING, name);
    BS_WriteValue(bitstream, PR_UINT32, rep);
    BS_WriteValue(bitstream, PR_UINT16, capture);
    
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock SetInfoFamily(playerid, status, rep, people, upd_sklad, upd_weapon, upd_people, money, mats, mask, oils, ammo, armor, skin_id, const name[]){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x46);

    BS_WriteValue(bitstream, PR_UINT8, status);
    BS_WriteValue(bitstream, PR_UINT32, rep);
    BS_WriteValue(bitstream, PR_UINT16, people);
    BS_WriteValue(bitstream, PR_UINT8, upd_sklad);
    BS_WriteValue(bitstream, PR_UINT8, upd_weapon);
    BS_WriteValue(bitstream, PR_UINT8, upd_people);
    BS_WriteValue(bitstream, PR_UINT32, money);
    BS_WriteValue(bitstream, PR_UINT32, mats);
    BS_WriteValue(bitstream, PR_UINT16, mask);
    BS_WriteValue(bitstream, PR_UINT16, oils);
    BS_WriteValue(bitstream, PR_UINT32, ammo);
    BS_WriteValue(bitstream, PR_UINT32, armor);
    BS_WriteValue(bitstream, PR_UINT16, skin_id);

    BS_WriteValue(bitstream, PR_UINT16, strlen(name));
	BS_WriteValue(bitstream, PR_STRING, name);
    
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock LoadPlayers(playerid, id, const name[], lvl, const nameRang[], rang, warn, phone, mute, isOnline){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x47);

    BS_WriteValue(bitstream, PR_UINT32, id);

    BS_WriteValue(bitstream, PR_UINT16, strlen(name));
	BS_WriteValue(bitstream, PR_STRING, name);

    BS_WriteValue(bitstream, PR_UINT16, lvl);

    BS_WriteValue(bitstream, PR_UINT16, strlen(nameRang));
	BS_WriteValue(bitstream, PR_STRING, nameRang);

    BS_WriteValue(bitstream, PR_UINT8, rang);
    BS_WriteValue(bitstream, PR_UINT8, warn);
    BS_WriteValue(bitstream, PR_UINT32, phone);
    BS_WriteValue(bitstream, PR_UINT32, mute);

    BS_WriteValue(bitstream, PR_BOOL, isOnline);


    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock LoadDataFamPlayer(playerid, id, rang, warn, mute){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x42);

    BS_WriteValue(bitstream, PR_UINT16, id);



    BS_WriteValue(bitstream, PR_UINT16, rang);
    BS_WriteValue(bitstream, PR_UINT16, warn);
    BS_WriteValue(bitstream, PR_UINT32, mute);


    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}


stock PlayAudioRPC(playerid, index, statemusic, vehid = 0, const url[], Float:posX = 0.0, Float:posY = 0.0, Float:posZ = 0.0, Float:distance = 50.0, usepos = 0){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x48);

    BS_WriteValue(bitstream, PR_UINT16, index);
    BS_WriteValue(bitstream, PR_UINT8, statemusic);
    BS_WriteValue(bitstream, PR_UINT16, vehid);

    BS_WriteValue(bitstream, PR_UINT8, strlen(url));
	BS_WriteValue(bitstream, PR_STRING, url);

    BS_WriteValue(bitstream, PR_FLOAT, posX);
    BS_WriteValue(bitstream, PR_FLOAT, posY);
    BS_WriteValue(bitstream, PR_FLOAT, posZ);
    BS_WriteValue(bitstream, PR_FLOAT, distance);
    BS_WriteValue(bitstream, PR_UINT8, usepos);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock StopAudioRPC(playerid, index){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x49);

    BS_WriteValue(bitstream, PR_UINT16, index);


    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock PauseAudioRPC(playerid, index){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x51);

    BS_WriteValue(bitstream, PR_UINT16, index);


    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);


    return true;
}

stock ResumeAudioRPC(playerid, index){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x52);

    BS_WriteValue(bitstream, PR_UINT16, index);


    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock ShowMusic(playerid, bool:toggle){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x50);

    BS_WriteValue(bitstream, PR_BOOL, toggle);


    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);


    return true;
}

stock SetStateMusic(playerid, index, statemusic){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x53);

    BS_WriteValue(bitstream, PR_UINT16, index);
    BS_WriteValue(bitstream, PR_UINT8, statemusic);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);


    return true;
}

stock SetPut(playerid, toggle){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x54);

    BS_WriteValue(bitstream, PR_BOOL, toggle);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);


    return true;
}

stock SetPause(playerid, toggle){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x55);

    BS_WriteValue(bitstream, PR_BOOL, toggle);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);


    return true;
}
stock ShowInventory(playerid, toggle){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x62);

    BS_WriteValue(bitstream, PR_BOOL, toggle);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);


    return true;
}
stock AddItemInv(playerid, gameid, value, weight, title[], title2[]){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x63);

    BS_WriteValue(bitstream, PR_UINT16, gameid);
    BS_WriteValue(bitstream, PR_UINT16, value);
    BS_WriteValue(bitstream, PR_FLOAT, weight);
    BS_WriteValue(bitstream, PR_UINT16, strlen(title));
	BS_WriteValue(bitstream, PR_STRING, title);
    BS_WriteValue(bitstream, PR_UINT16, strlen(title2));
	BS_WriteValue(bitstream, PR_STRING, title2);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);


    return true;
}
stock AddActionItemInv(playerid, gameid, weight, title[], title2[]){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x64);

    BS_WriteValue(bitstream, PR_UINT16, gameid);
    BS_WriteValue(bitstream, PR_FLOAT, weight);
    BS_WriteValue(bitstream, PR_UINT16, strlen(title));
	BS_WriteValue(bitstream, PR_STRING, title);
    BS_WriteValue(bitstream, PR_UINT16, strlen(title2));
	BS_WriteValue(bitstream, PR_STRING, title2);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);


    return true;
}

stock SetInfoInv(playerid, skin_id, eat, weight, max_weight, lvl){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x65);

    BS_WriteValue(bitstream, PR_UINT16, skin_id);
    BS_WriteValue(bitstream, PR_UINT16, eat);
    BS_WriteValue(bitstream, PR_FLOAT, weight);
    BS_WriteValue(bitstream, PR_UINT16, max_weight);
    BS_WriteValue(bitstream, PR_UINT16, lvl);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);


    return true;
}
stock LoadNameRang(playerid, rangname[]){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x56);

    BS_WriteValue(bitstream, PR_UINT16, strlen(rangname));
	BS_WriteValue(bitstream, PR_STRING, rangname);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);


    return true;
}

stock GetAccessRang(playerid, sclad, invite, uninvite, mute, giverang){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x57);

    BS_WriteValue(bitstream, PR_UINT16, sclad);
    BS_WriteValue(bitstream, PR_UINT16, invite);
    BS_WriteValue(bitstream, PR_UINT16, uninvite);
    BS_WriteValue(bitstream, PR_UINT16, mute);
    BS_WriteValue(bitstream, PR_UINT16, giverang);


    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);


    return true;
}
stock AddInfoStock(playerid, allmoney, mats, mask, oil, armor){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x58);

    BS_WriteValue(bitstream, PR_UINT32, allmoney);
    BS_WriteValue(bitstream, PR_UINT32, mats);
    BS_WriteValue(bitstream, PR_UINT32, mask);
    BS_WriteValue(bitstream, PR_UINT32, oil);
    BS_WriteValue(bitstream, PR_UINT32, armor);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}

stock UpdateInventoryItem(playerid, gameid, count, pos, weight){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x66);

    BS_WriteValue(bitstream, PR_UINT16, gameid);
    BS_WriteValue(bitstream, PR_UINT16, count);
    BS_WriteValue(bitstream, PR_UINT16, pos);
    BS_WriteValue(bitstream, PR_FLOAT, weight);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}
stock UpdateInventoryActionItem(playerid, gameid, pos, weight){
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x67);

    BS_WriteValue(bitstream, PR_UINT16, gameid);
    BS_WriteValue(bitstream, PR_UINT16, pos);
    BS_WriteValue(bitstream, PR_FLOAT, weight);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);

    BS_Delete(bitstream);

    return true;
}
IPacket:251(playerid, BitStream:bs){
    new header, rpcid;
    BS_ReadValue(bs, PR_UINT8, header, PR_UINT8, rpcid);

    if(rpcid == 0x35){
       // new button;
        //BS_ReadValue(bs, PR_UINT8, button);
       // switch(button)
      
    }
    if(rpcid == 0x36){
        new button, id;
        BS_ReadValue(bs, PR_UINT8, button);
        BS_ReadValue(bs, PR_UINT8, id);

        switch(button){
            case 0:{
                new fmt_text[640],
                Cache: result; 
                new fam_id = GetPlayerData(playerid, P_FAMILY);
//                GetFamilyData(fam_id, F_FAMILY_CARS);
                mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM family_cars WHERE id='%d'", id);
                result = mysql_query(mysql, fmt_text, true);

                new rows = cache_num_rows();
		
				new query[60];


				for(new i = 0; i < rows; i ++)
				{
                    famaccess = cache_get_field_content_int(id, "rang");
				}
                
				
            
		        cache_delete(result);
                
                return 1;
            }
            case 1:{
                UpChangeFamilyCarRang(playerid, id);
            }
            case 2:{
                DownChangeFamilyCarRang(playerid, id);
            }
            case 3: { //отметить на gps
                set_pos_fam_car(playerid, id);
            }
            case 4: { // загрузить
                spawn_fam_car(playerid, id);
            }
            case 5:{//загрузить на месте выгрузки

            }
            case 6:{//вернуть из семьи
            if(GetPlayerData(playerid, P_FAMILY_RANK) != 5) return ShowNotification(playerid, 2, "У вас нет доступа!", 3, "", "");
                new model, color1, color2, Float:pos[4], sqlid; new query[256], fmt_text[128];
				model = g_family_car[id][F_MODEL_ID];
				color1 = g_family_car[id][F_COLOR_1];
				color2 = g_family_car[id][F_COLOR_2];
			    pos[0] = g_family_car[id][F_POS_X];
				pos[1] = g_family_car[id][F_POS_Y];
				pos[2] = g_family_car[id][F_POS_Z];
				pos[3] = g_family_car[id][F_ANGLE];
				
				if(g_family_car[id][F_CAR_TEMP_ID] != -1)
                {
                    DestroyVehicle(g_family_car[id][F_CAR_TEMP_ID]);
                    Delete3DTextLabel(g_family_car[id][F_NAME_FAM]);
                }
								
				mysql_format(mysql, query, sizeof query, "INSERT INTO ownable_cars (owner_id, model_id, color_1, color_2, pos_x, pos_y, pos_z, angle, create_time) VALUES (%d, %d, %d, %d, %f, %f, %f, %f, %d)", GetPlayerSqlIDByName(GetPlayerNameEx(playerid)), model, color1, color2, pos[0], pos[1], pos[2], pos[3], gettime());
                mysql_query(mysql, query, false);

	
				mysql_format(mysql, fmt_text, sizeof fmt_text, "DELETE FROM family_cars WHERE id=%d", id);
				mysql_query(mysql, fmt_text, false);
                //LoadFamilyCarRPC(playerid);
                GetVehidAccess(playerid, 0, 0, false);

            }
            case 8:{//сбросить парковку
                restore_park_fam_car(id);
            }
            case 9:{//выгрузить
                destroy_fam_veh(playerid, id);
            }
        }
    }

    if(rpcid == 0x37){
        new button, id;
        new query[128];
        BS_ReadValue(bs, PR_UINT32, id);
        BS_ReadValue(bs, PR_UINT8, button);
        new famid = GetPlayerData(playerid, P_FAMILY) + 1;
        switch(button){
            case 0: { //повысить ранг 
            if(GetFamilyData(famid, F_RANG_GIVER) > GetPlayerData(playerid, P_FAMILY_RANK)) return ShowNotification(playerid, 2, "У вас нет доступа!", 3, "", "");
                UpRangFamily(playerid, id);
                return 1;
                //load_player_family(playerid);
            }
            case 1: { //дать выговор
            if(GetPlayerData(playerid, P_FAMILY_RANK) != 5) return ShowNotification(playerid, 2, "У вас нет доступа!", 3, "", "");
                UpWarnFamily(playerid, id);
            
                return 1;
                //load_player_family(playerid);
            }
            case 2: { //выдать мут +10
            if(GetFamilyData(famid, F_RANG_MUTE) > GetPlayerData(playerid, P_FAMILY_RANK)) return ShowNotification(playerid, 2, "У вас нет доступа!", 3, "", "");
                UpMuteFamily(playerid, id);
                return 1;
                //load_player_family(playerid);
            }
            case 3: { //понизить ранг 
            if(GetFamilyData(famid, F_RANG_GIVER) > GetPlayerData(playerid, P_FAMILY_RANK)) return ShowNotification(playerid, 2, "У вас нет доступа!", 3, "", "");
                DownRangFamily(playerid, id);
                return 1;
                //load_player_family(playerid);
            }
            case 4: { //убрать выговор
            if(GetPlayerData(playerid, P_FAMILY_RANK) != 5) return ShowNotification(playerid, 2, "У вас нет доступа!", 3, "", "");
                DownWarnFamily(playerid, id);
                return 1;
                //load_player_family(playerid);
            }
            case 5: { //снять мут -10
            if(GetFamilyData(famid, F_RANG_MUTE) > GetPlayerData(playerid, P_FAMILY_RANK)) return ShowNotification(playerid, 2, "У вас нет доступа!", 3, "", "");
                DownMuteFamily(playerid, id);
                return 1;
                //load_player_family(playerid);
            }
            case 6:{ //кик из фамы
            if(GetPlayerIDBySqlID(id) == playerid) return 1;
            if(GetFamilyData(famid, F_RANG_UNINV) > GetPlayerData(playerid, P_FAMILY_RANK)) return ShowNotification(playerid, 2, "У вас нет доступа!", 3, "", "");
                if(IsPlayerConnected(GetPlayerIDBySqlID(id))){
                    SetPlayerData(GetPlayerIDBySqlID(id), P_FAMILY, 0);
                    SetPlayerData(GetPlayerIDBySqlID(id), P_FAMILY_RANK, 0);
                    
                    new fmt[128];
                    format(fmt, sizeof fmt, "%s Выгнал %s из семьи", GetPlayerNameEx(playerid), GetPlayerNameEx(GetPlayerIDBySqlID(id)));
                    AddMessageFamily(playerid, fmt);
                }
                if(!IsPlayerConnected(GetPlayerIDBySqlID(id))){
                    new fmt[128];
                    format(fmt, sizeof fmt, "%s Выгнал %s из семьи", GetPlayerNameEx(playerid), GetPlayerNameBySqlID(id));
                    AddMessageFamily(playerid, fmt);
                }

                
                format(query, sizeof query, "UPDATE accounts SET family=%d,family_rank=%d WHERE id=%d",\
                0, 0, id);
                print(query);
                mysql_query(mysql, query, false);
                load_player_family(playerid);
                LoadDataFamPlayer(playerid, id, 0, 0, 0);
                return 1;
            }
        }
    }
    if(rpcid == 0x40){
        new button;
        new fam_id = GetPlayerData(playerid, P_FAMILY);
        BS_ReadValue(bs, PR_UINT8, button);
        switch(button){
            case 0: LoadFamilyCarRPC(playerid);
            case 1: LoadNotifFamily(playerid);
            case 2: LoadFamilyRaitingTop(playerid);
            case 3: {SetInfoFamily(playerid, 0, GetFamilyData(fam_id, F_EXP), GetFamilyPeople(playerid), 1, 1, 1, GetFamilyData(fam_id, F_MONEY), GetFamilyData(fam_id, F_METAL), 0, 0, GetFamilyData(fam_id, F_AMMO), 0, GetPlayerSkinEx(playerid), GetPlayerNameEx(playerid)); load_player_family(playerid);}
        }
    }
    if(rpcid == 0x38){
        new urlLen; new url[256];
        BS_ReadValue(bs, PR_UINT16, urlLen);
        BS_ReadValue(bs, PR_STRING, url, urlLen);

        play_music(playerid, url);
    
    }
    if(rpcid == 0x39){
        new buttonid;
        BS_ReadValue(bs, PR_UINT8, buttonid);
        new fm[30];
            format(fm, sizeof fm, "%d", buttonid);
            print(fm);
        switch(buttonid){
            case 0:{//пауза всем
                pause_all(playerid);
            }
            case 1:{//выйти из паузы всем
                resume_all(playerid);
            }
            case 4:{//пондянть
                if(IsPlayerInRangeOfPoint(playerid, 3.0, GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ")))
                {
                    SetPut(playerid, false);
                    DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "BBLabel"));
                    DeletePVar(playerid, "BPut"); DeletePVar(playerid, "BBLabel");
                    DeletePVar(playerid, "BBX");
                    DeletePVar(playerid, "BBY");
                    DeletePVar(playerid, "BBZ");
                    ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
                    ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
                    if(GetPVarInt(playerid, "BObject"))
                        DestroyDynamicObject(GetPVarInt(playerid, "BObject"));
                    foreach(Player, i){
                        SetStateMusic(i, playerid, PLAYER);
                    }
                    g_player_music[playerid][StateMusic] = PLAYER;
                }else{
                    return ShowNotification(playerid, 2, "Вы далеко от своего бумбокса", 3, "", "");
                }
            
            }
            case 3:{//положить
                    if(IsPlayerDriver(playerid)) return ShowNotification(playerid, 2, "Вы за рулем!", 3, "", "");

                    SetPut(playerid, true);

                    new Float:BBCoord[4];
                    GetPlayerPos(playerid, BBCoord[0], BBCoord[1], BBCoord[2]);
                    SetPVarFloat(playerid, "BBX", BBCoord[0]);
                    SetPVarFloat(playerid, "BBY", BBCoord[1]);
                    SetPVarFloat(playerid, "BBZ", BBCoord[2]);

                    SetPVarInt(playerid, "BPut", 1);
                    new pName[MAX_PLAYER_NAME], string[128];
                    
                    GetPlayerName(playerid, pName, sizeof(pName));
                	format(string, sizeof(string), "Бумбокс\nВладелец: %s", pName);
                    new objectid = CreateDynamicObject(1791, GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ")-0.9, 90.00, 90.00, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
                    SetPVarInt(playerid, "BObject", objectid);
	                SetPVarInt(playerid, "BBLabel", _:CreateDynamic3DTextLabel(string, -1,GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ")+0.5, 10.00, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = GetPlayerInterior(playerid)));

                    ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
                    ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);

                    foreach(Player, i){
                        SetStateMusic(i, playerid, COORDS);
                    }
                    
                    g_player_music[playerid][StateMusic] = COORDS;
            }
        }
    }
    if(rpcid == 0x41){
        new textLen; new text[256];
        BS_ReadValue(bs, PR_UINT16, textLen);
        BS_ReadValue(bs, PR_STRING, text, textLen);

        add_notif_fam(playerid, text);
    }
    if(rpcid == 0x42){
        new colorLen; new color[256];
        BS_ReadValue(bs, PR_UINT16, colorLen);
        BS_ReadValue(bs, PR_STRING, color, colorLen);

        set_color_chat_family(playerid, color);
    }
    if(rpcid == 0x43){
        new nameLen, rang; new name[256];
        BS_ReadValue(bs, PR_UINT16, nameLen);
        BS_ReadValue(bs, PR_STRING, name, nameLen);
        BS_ReadValue(bs, PR_UINT16, rang);

        edit_name_rang(playerid, rang, name);
    }
    if(rpcid == 0x44){
        new access, rang, bool:toggle; new quers[64];
        BS_ReadValue(bs, PR_UINT16, rang);
        BS_ReadValue(bs, PR_UINT16, access);
        BS_ReadValue(bs, PR_BOOL, toggle);

        if(toggle){
            printf("rang: %d, access: %d, toggle = true", rang, access);
        }else{
            printf("rang: %d, access: %d, toggle = false", rang, access);
        }
        new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
        switch(access){
            
            case 0: { //пригласить игрока
                if(toggle){
                    mysql_format(mysql, quers, sizeof quers, "UPDATE family SET r_Inv = '%d' WHERE id='%d'",rang, GetPlayerData(playerid, P_FAMILY) + 1);
                    mysql_query(mysql, quers, false);
                    SetFamilyData(fam_id, F_RANG_INV, rang);
                    
                }else{
                    mysql_format(mysql, quers, sizeof quers, "UPDATE family SET r_Inv = '%d' WHERE id='%d'",rang + 1, GetPlayerData(playerid, P_FAMILY) + 1);
                    mysql_query(mysql, quers, false);
                    SetFamilyData(fam_id, F_RANG_INV, rang + 1);
                    
                }
                get_access_fam(playerid);
                load_name_rang(playerid);
                return 1;
            }
            case 1: { //выгнать игрока
            if(toggle){
                    mysql_format(mysql, quers, sizeof quers, "UPDATE family SET r_UnInv = '%d' WHERE id='%d'",rang, GetPlayerData(playerid, P_FAMILY) + 1);
                    mysql_query(mysql, quers, false);
                    SetFamilyData(fam_id, F_RANG_UNINV, rang);
                }else{
                    mysql_format(mysql, quers, sizeof quers, "UPDATE family SET r_UnInv = '%d' WHERE id='%d'",rang + 1, GetPlayerData(playerid, P_FAMILY) + 1);
                    mysql_query(mysql, quers, false);
                    SetFamilyData(fam_id, F_RANG_UNINV, rang + 1);
                    
                }
                get_access_fam(playerid);
                load_name_rang(playerid);
                return 1;

            }
            case 2: { //изменять ранг
            if(toggle){
                    mysql_format(mysql, quers, sizeof quers, "UPDATE family SET r_GiveRang = '%d' WHERE id='%d'",rang, GetPlayerData(playerid, P_FAMILY) + 1);
                    mysql_query(mysql, quers, false);
                    SetFamilyData(fam_id, F_RANG_GIVER, rang);
                }else{
                    mysql_format(mysql, quers, sizeof quers, "UPDATE family SET r_GiveRang = '%d' WHERE id='%d'",rang + 1, GetPlayerData(playerid, P_FAMILY) + 1);
                    mysql_query(mysql, quers, false);
                    SetFamilyData(fam_id, F_RANG_GIVER, rang + 1);
                    
                }
                get_access_fam(playerid);
                load_name_rang(playerid);
                return 1;

            }
            case 3: { //выдавать мут
            if(toggle){
                    mysql_format(mysql, quers, sizeof quers, "UPDATE family SET r_Mute = '%d' WHERE id='%d'",rang, GetPlayerData(playerid, P_FAMILY) + 1);
                    mysql_query(mysql, quers, false);
                    SetFamilyData(fam_id, F_RANG_MUTE, rang);
                }else{
                    mysql_format(mysql, quers, sizeof quers, "UPDATE family SET r_Mute = '%d' WHERE id='%d'",rang + 1, GetPlayerData(playerid, P_FAMILY) + 1);
                    mysql_query(mysql, quers, false);
                    SetFamilyData(fam_id, F_RANG_MUTE, rang + 1);
                }
                get_access_fam(playerid);
                load_name_rang(playerid);
                return 1;

            }
            case 4: { //участие в войне семей
                return 1;

            }
            case 5: { //складу
            if(toggle){
                    mysql_format(mysql, quers, sizeof quers, "UPDATE family SET r_TakeMoney = '%d' WHERE id='%d'",rang, GetPlayerData(playerid, P_FAMILY) + 1);
                    mysql_query(mysql, quers, false);
                    SetFamilyData(fam_id, F_TAKE_MONEY, rang);
                }else{
                    mysql_format(mysql, quers, sizeof quers, "UPDATE family SET r_TakeMoney = '%d' WHERE id='%d'",rang + 1, GetPlayerData(playerid, P_FAMILY) + 1);
                    mysql_query(mysql, quers, false);
                    SetFamilyData(fam_id, F_TAKE_MONEY, rang + 1);
                }
                get_access_fam(playerid);
                load_name_rang(playerid);
                return 1;

            }
        }
    }
    if(rpcid == 0x45){
        new button;
        BS_ReadValue(bs, PR_UINT16, button);
        switch(button){
            case 0: { //семейные логи
                return 1; 
            }
            case 1:{ //черный список
                return 1;
            }
            case 2:{ //выйти из семьи
                new fmt_text[320];
                if(GetPlayerData(playerid, P_FAMILY_RANK) == 5){
                    format(
                    fmt_text, sizeof fmt_text,
                    "{FFFFFF}Вы состоите в семье \"%s{FFFFFF}\".\n"\
                    "Если Вы покинете семью, то потеряете все свои достижения в ней, такие как ранг.\n\n"\
                    "Вы лидер семьи, если вы покинете ее то она удалиться!\nВы уверены, что хотите покинуть семью?", GetFamName(playerid)
                );
                }else{
                format(
                    fmt_text, sizeof fmt_text,
                    "{FFFFFF}Вы состоите в семье \"%s{FFFFFF}\".\n"\
                    "Если Вы покинете семью, то потеряете все свои достижения в ней, такие как ранг.\n\n"\
                    "Вы уверены, что хотите покинуть семью?", GetFamName(playerid)
                );
                }
                Dialog
                (
                    playerid, 22848, DIALOG_STYLE_MSGBOX,
                    "{FFFF00}| {FFFFFF} Покинуть семью",
                    fmt_text,
                    "Покинуть",
                    "Отмена"
                );
            }
        }
    }
    if(rpcid == 0x46){
        new button;
        BS_ReadValue(bs, PR_UINT16, button);
        switch(button){
            case 0:{//колекциоер
                return 1;
            }
            case 1:{//сыщик
                return 1;
            }
            case 2:{// охотник
                return 1;
            }
            case 3:{// солдат
                return 1;
            }
            case 4:{// помощь поднебесной
                return 1;
            }
            case 5:{// легкие деньги
                return 1;
            }
        }
    }
    if(rpcid == 0x47){// покупка токенов
    
        new coin;
        BS_ReadValue(bs, PR_UINT16, coin);
        if(coin == 0) return 1;
        if(coin > GetPlayerDonateRub(playerid)) return ShowNotification(playerid, 2, "Не достаточно донат-рублей!", 3, "", "");
        new quers[64], fm[128];
        new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;


        mysql_format(mysql, quers, sizeof quers, "UPDATE family SET token = '%d' WHERE id='%d'",GetFamilyData(fam_id, F_TOKEN) + coin, fam_id);
        mysql_query(mysql, quers, false);

        SetFamilyData(fam_id, F_TOKEN, GetFamilyData(fam_id, F_TOKEN) + coin);

        GivePlayerDonateRub(playerid, -coin * 10, "Покупка жетонов семьи", true, true);
        

        if(GetPlayerData(playerid, P_FAMILY_RANK) != 5){
		    ShowFamily(playerid, 1, GetFamName(playerid), GetFamilyData(fam_id, F_TOKEN), GetFamilyData(fam_id, F_BLACKCOIN), 0);
        }else{
            ShowFamily(playerid, 1, GetFamName(playerid), GetFamilyData(fam_id, F_TOKEN), GetFamilyData(fam_id, F_BLACKCOIN), 1);
        }

        format(fm, sizeof fm, "Вы успешно преобрели %d жетонов!", coin);

        return ShowNotification(playerid, 3, fm, 3, "", "");
    }
    if(rpcid == 0x48){
        new button;
        BS_ReadValue(bs, PR_UINT16, button);

        switch(button){
            case 0:{//сейф
                callcmd::famsklad(playerid);
            }
            case 1:{//склад

            }
        }
    }
    if(rpcid == 0x49){
        new button;
        BS_ReadValue(bs, PR_UINT16, button);
        new quers[128];
        new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
        switch(button){
            case 0:{//улуч склад
            if(GetFamilyData(fam_id, F_LVL_SCLAD) == 7) return ShowNotification(playerid, 2, "У вас максимальный уровень улучшений!", 3, "", "");
                mysql_format(mysql, quers, sizeof quers, "UPDATE family SET upd_sklad = '%d' WHERE id='%d'",GetFamilyData(fam_id, F_LVL_SCLAD) + 1, GetPlayerData(playerid, P_FAMILY) + 1);
                mysql_query(mysql, quers, false);
                SetFamilyData(fam_id, F_LVL_SCLAD, GetFamilyData(fam_id, F_LVL_SCLAD) + 1);
                ShowNotification(playerid, 3, "Вы успешно улучшили Склад!", 3, "", "");
                return 1;
            }
            case 1:{//улуч оруж склад
                if(GetFamilyData(fam_id, F_LVL_WEAPON) == 7) return ShowNotification(playerid, 2, "У вас максимальный уровень улучшений!", 3, "", "");
                mysql_format(mysql, quers, sizeof quers, "UPDATE family SET upd_weapon = '%d' WHERE id='%d'",GetFamilyData(fam_id, F_LVL_WEAPON) + 1, GetPlayerData(playerid, P_FAMILY) + 1);
                mysql_query(mysql, quers, false);
                SetFamilyData(fam_id, F_LVL_WEAPON, GetFamilyData(fam_id, F_LVL_WEAPON) + 1);
                ShowNotification(playerid, 3, "Вы успешно улучшили Склад!", 3, "", "");
                return 1;
            }
            case 2:{//улуч колво людей
                if(GetFamilyData(fam_id, F_LVL_PEOPLE) == 7) return ShowNotification(playerid, 2, "У вас максимальный уровень улучшений!", 3, "", "");
                mysql_format(mysql, quers, sizeof quers, "UPDATE family SET upd_people = '%d' WHERE id='%d'",GetFamilyData(fam_id, F_LVL_PEOPLE) + 1, GetPlayerData(playerid, P_FAMILY) + 1);
                mysql_query(mysql, quers, false);
                SetFamilyData(fam_id, F_LVL_PEOPLE, GetFamilyData(fam_id, F_LVL_PEOPLE) + 1);
                ShowNotification(playerid, 3, "Вы успешно улучшили Склад!", 3, "", "");
                return 1;
            }
        }
    }
}
