#include <a_samp>
#include <streamer>

#define COLOR_ORANGE       0xFF9900AA
#define COLOR_GRAD6        0xF0F0F0FF
#define COLOR_BLACK        0x000000AA
#define COLOR_GREY         0xAFAFAFAA
#define COLOR_GREEN        0x33AA33AA
#define COLOR_ORANGE       0xFF9900AA
#define COLOR_RED          0xAA3333AA

new vxod;
new vixod;

new Text3D:text;
new Text3D:vxxod;
new Text3D:viixod;


enum time
{
	pTime
}
new pNegr[MAX_PLAYERS][time];

forward hiniga(playerid);
forward dhsa(playerid);

main()
{
	print("\n----------------------------------");
	print("Больница загружена                  ");
	print("----------------------------------\n");
}
public OnGameModeInit()
{
	text = Create3DTextLabel("Выйти из больницы можно только через 120 секунд после\n появления в ней", COLOR_RED, -1051.699829, -1465.512207, 23.404191, 25.0 , 0, 1);
	
	viixod = Create3DTextLabel("Выход из больницы", COLOR_ORANGE, -1053.597045,-1468.846557,23.412004, 25.0 , 0, 1);
	
	vxxod = Create3DTextLabel("Вход в больницу", COLOR_ORANGE, 420.247375,1756.805419,14.405934, 25.0 , 0, 1);
	
	vixod = CreatePickup(1318,23,-1053.597045,-1468.846557,23.412004);
	
	vxod = CreatePickup(1318,23,420.247375,1756.805419,14.405934);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	SetTimer("dhsa", 15000, false);
	return 1;
}
public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(pickupid == vixod)
	{
		if(pNegr[playerid][pTime] > 1) return true;
		{
		    SetPlayerPos(playerid,416.453582,1758.006225,14.401344);
			SendClientMessage(playerid, COLOR_RED, "Вы успешно покинули больницу!");
		}
	}
	if(pickupid == vxod)
	{
	    SetPlayerPos(playerid,-1053.639770,-1464.328857,23.404191);
		SendClientMessage(playerid, COLOR_RED, "Вы зашли в больницу!");
	}
	return 1;
}
public hiniga(playerid)
{
	SendClientMessage(playerid, COLOR_GREY, "Вы можете выйти с больницы");
	pNegr[playerid][pTime] = 0;
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}
public dhsa(playerid)
{
	pNegr[playerid][pTime] = 2;
 	SetPlayerHealth(playerid, 20);
	SetTimer("hiniga", 120000, false);
	SendClientMessage(playerid, COLOR_GREY, "Вы умерли и попали в больницу!");
	new randompiz=random(4);
	switch (randompiz)
	{
    	case 0:SetPlayerPos(playerid,-1069.027465,-1441.230957,23.404191);
    	case 1:SetPlayerPos(playerid,-1058.425170,-1432.671142,23.404191);
    	case 2:SetPlayerPos(playerid,-1051.036621,-1430.111083,23.404191);
    	case 3:SetPlayerPos(playerid,-1050.887207,-1436.130981,23.404191);
	}
	SetPlayerHealth(playerid, 100);
	return 1;
}
