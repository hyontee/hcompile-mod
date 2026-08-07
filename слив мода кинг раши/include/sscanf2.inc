/*
*  sscanf 2.8.2
*  Created by Y_Less, updated by Emmet_.
*
*  Version: MPL 1.1
*
*  The contents of this file are subject to the Mozilla Public License Version
*  1.1 (the "License"); you may not use this file except in compliance with
*  the License. You may obtain a copy of the License at
*  [url]http://www.mozilla.org/MPL/[/url]
*
*  Software distributed under the License is distributed on an "AS IS" basis,
*  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
*  for the specific language governing rights and limitations under the
*  License.
*
*  The Original Code is the sscanf 2.0 SA:MP plugin.
*
*  The Initial Developer of the Original Code is Alex "Y_Less" Cole.
*  Portions created by the Initial Developer are Copyright (C) 2010
*  the Initial Developer. All Rights Reserved.
*
*  Contributor(s):
*
*  Special Thanks to:
*
*      SA:MP Team past, present and future
*/

#if defined _inc_a_npc
#pragma library sscanf
#elseif !defined _samp_included
#error Please include <a_npc> or <a_samp> first.
#endif

#define SSCANF:%0(%1) sscanf_%0(%1);public sscanf_%0(%1)

#if defined sscanf
#error sscanf (possibly the PAWN version) already defined.
#endif

native sscanf(const data[], const format[], {Float,_}:...);
native unformat(const data[], const format[], {Float,_}:...) = sscanf;
native SSCANF_Init(players, invalid, len);
native SSCANF_Join(playerid, const name[], npc);
native SSCANF_Leave(playerid);
native SSCANF_IsConnected(playerid);

native SSCANF_Option(const name[], value);

stock const
SSCANF_QUIET[] = "SSCANF_QUIET",
OLD_DEFAULT_NAME[] = "OLD_DEFAULT_NAME",
MATCH_NAME_PARTIAL[] = "MATCH_NAME_PARTIAL",
CELLMIN_ON_MATCHES[] = "CELLMIN_ON_MATCHES",
OLD_DEFAULT_KUSTOM[] = "OLD_DEFAULT_KUSTOM",
OLD_DEFAULT_CUSTOM[] = "OLD_DEFAULT_CUSTOM";

static stock
bool:SSCANF_gInit = false,
SSCANF_g_sPlayers[MAX_PLAYERS char];

#if defined _inc_a_npc
forward SSCANF_PlayerCheck();

/*
	OnNPCModeInit

	Called when the script starts if it is a NPC mode, sets up the system,
	then calls the "real" OnNPCModeInit (using the new ALS 2 hook method).
	*/

public OnNPCModeInit()
{
	SSCANF_Init(MAX_PLAYERS, INVALID_PLAYER_ID, MAX_PLAYER_NAME);
	#if !defined SSCANF_NO_PLAYERS
	// Initialise the system.
	SSCANF_PlayerCheck();
	SetTimer("SSCANF_PlayerCheck", 1, 1);
	#endif
	#if defined SSCANF_OnNPCModeInit
	SSCANF_OnNPCModeInit();
	#endif
	return 1;
}

#if defined _ALS_OnNPCModeInit
#undef OnNPCModeInit
#else
#define _ALS_OnNPCModeInit
#endif
#define OnNPCModeInit SSCANF_OnNPCModeInit
#if defined SSCANF_OnNPCModeInit
forward SSCANF_OnNPCModeInit();
#endif

/*
	SSCANF_PlayerCheck

	NPC modes have no "OnPlayerConnect callback, so we need to simulate one.
	*/

#if !defined SSCANF_NO_PLAYERS
public SSCANF_PlayerCheck()
{
	for (new i = 0; i != MAX_PLAYERS; ++i)
	{
		if (IsPlayerConnected(i))
		{
			if (!SSCANF_g_sPlayers{i})
			{
				new
				name[MAX_PLAYER_NAME];
				GetPlayerName(i, name, sizeof (name));
				// We have no way to know if they are an NPC or not!
				SSCANF_Join(i, name, 0);
				SSCANF_g_sPlayers{i} = 1;
			}
		}
		else
		{
			if (SSCANF_g_sPlayers{i})
			{
				SSCANF_Leave(i);
				SSCANF_g_sPlayers{i} = 0;
			}
		}
	}
}
#endif
#else
/*
	OnFilterScriptInit

	Called when the script starts if it is a filterscript, sets up the system,
	then calls the "real" OnFilterScriptInit (using the new ALS 2 hook
	method).
	*/

public OnFilterScriptInit()
{
	new
	name[MAX_PLAYER_NAME];
	
	SSCANF_Init(GetMaxPlayers(), INVALID_PLAYER_ID, MAX_PLAYER_NAME);
	SSCANF_gInit = true;
	
	// Check if there are any players that aren't initialized.
	for (new i = 0; i < MAX_PLAYERS; i ++)
	{
		if (IsPlayerConnected(i) && !SSCANF_IsConnected(i))
		{
			GetPlayerName(i, name, MAX_PLAYER_NAME);
			SSCANF_Join(i, name, IsPlayerNPC(i));
		}
	}
	
	#if defined SSCANF_OnFilterScriptInit
	SSCANF_OnFilterScriptInit();
	#endif
	return 1;
}

#if defined _ALS_OnFilterScriptInit
#undef OnFilterScriptInit
#else
#define _ALS_OnFilterScriptInit
#endif
#define OnFilterScriptInit SSCANF_OnFilterScriptInit
#if defined SSCANF_OnFilterScriptInit
forward SSCANF_OnFilterScriptInit();
#endif

/*
	OnGameModeInit

	Called when the script starts if it is a gamemode.  This callback is also
	called in filterscripts so we don't want to reinitialise the system in
	that case.
	*/

public OnGameModeInit()
{
	if (!SSCANF_gInit)
	{
		new
		name[MAX_PLAYER_NAME];
		
		SSCANF_Init(GetMaxPlayers(), INVALID_PLAYER_ID, MAX_PLAYER_NAME);
		SSCANF_gInit = true;
		
		// Check if there are any players that aren't initialized.
		for (new i = 0; i < MAX_PLAYERS; i ++)
		{
			if (IsPlayerConnected(i) && !SSCANF_IsConnected(i))
			{
				GetPlayerName(i, name, MAX_PLAYER_NAME);
				SSCANF_Join(i, name, IsPlayerNPC(i));
			}
		}
	}
	#if defined SSCANF_OnGameModeInit
	SSCANF_OnGameModeInit();
	#endif
	return 1;
}

#if defined _ALS_OnGameModeInit
#undef OnGameModeInit
#else
#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit SSCANF_OnGameModeInit
#if defined SSCANF_OnGameModeInit
forward SSCANF_OnGameModeInit();
#endif

/*
	OnPlayerConnect

	Called when a player connects.  Actually increments an internal count so
	that if a script ends and "OnPlayerDisconnect" is called then "sscanf"
	still knows that the player is really connected.  Also stores their name
	internally.
	*/

public OnPlayerConnect(playerid)
{
	new
	name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof (name));
	SSCANF_Join(playerid, name, IsPlayerNPC(playerid));
	#if defined SSCANF_OnPlayerConnect
	SSCANF_OnPlayerConnect(playerid);
	#endif
	return 1;
}

#if defined _ALS_OnPlayerConnect
#undef OnPlayerConnect
#else
#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect SSCANF_OnPlayerConnect
#if defined SSCANF_OnPlayerConnect
forward SSCANF_OnPlayerConnect(playerid);
#endif

/*
	OnPlayerDisconnect

	Called when a player disconnects, or when a script is ended.
	*/

public OnPlayerDisconnect(playerid, reason)
{
	#if defined SSCANF_OnPlayerDisconnect
	SSCANF_OnPlayerDisconnect(playerid, reason);
	#endif
	SSCANF_Leave(playerid);
	return 1;
}

#if defined _ALS_OnPlayerDisconnect
#undef OnPlayerDisconnect
#else
#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect SSCANF_OnPlayerDisconnect
#if defined SSCANF_OnPlayerDisconnect
forward SSCANF_OnPlayerDisconnect(playerid, reason);
#endif
#endif

#define SSCANF_Init
#define SSCANF_Join
#define SSCANF_Leave

#define extract%0->%1; EXTRN%1;unformat(_:EXTRZ:EXTRV:EXTRX:%0,##,%1,,);
#define unformat(_:EXTRZ:EXTRV:EXTRX:%0,##,%1);%2else if (unformat(_:EXTRV:EXTRX:%0,##,%1))

#define EXTRV:EXTRX:%0<%3>##,%9new%1,%2) EXTRY:%0##P<%3>,|||%1|||%2)
#define EXTRX:%0##,%9new%1,%2) EXTRY:%0##,|||%1|||%2)
#define EXTRY: EXTR8:EXTR9:EXTR0:EXTR1:EXTR2:EXTR3:EXTR4:

#define EXTR8:EXTR9:EXTR0:EXTR1:EXTR2:EXTR3:EXTR4:%0##%1,%2|||%6:%3=%9|||%4) %6_EXTRO:%0##%1,%2|||%3=%9|||%4)
#define EXTR9:EXTR0:EXTR1:EXTR2:EXTR3:EXTR4:%0##%1,%2|||%3=%9|||%4) __EXTRO:%0##%1,%2|||%3=%9|||%4)
#define EXTR0:EXTR1:EXTR2:EXTR3:EXTR4:%0##%1,%2|||%6:%3[%7]|||%4) %6_EXTRW:%0##%1,%2|||%3[%7]|||%4)
#define EXTR1:EXTR2:EXTR3:EXTR4:%0##%1,%2|||%3[%7]|||%4) __EXTRW:%0##%1,%2|||%3|||%4)
#define EXTR2:EXTR3:EXTR4:%0##%1,%2|||%6:%3|||%4) %6_EXTRN:%0##%1,%2|||%3|||%4)
#define EXTR3:EXTR4:%0##%1,,%2||||||%4) %0##%1,%2)
#define EXTR4:%0##%1,%2|||%3|||%4) __EXTRN:%0##%1,%2|||%3|||%4)

// Optional specifiers.
#define __EXTRO:%0##%1,%2|||%3=%9|||%4,%5) EXTRY:%0##%1I"("#%9")"#,%2,%3|||%4|||%5)
#define Float_EXTRO:%0##%1,%2|||%3=%9|||%4,%5) EXTRY:%0##%1F"("#%9")"#,%2,%3|||%4|||%5)
#define player_EXTRO:%0##%1,%2|||%3=%9|||%4,%5) EXTRY:%0##%1U"("#%9")"#,%2,%3|||%4|||%5)
#define string_EXTRO:%0##%1,%2|||%3[%7]=%9|||%4,%5) EXTRY:%0##%1S"("#%9")"#[%7],%2,%3|||%4|||%5)

// Normal specifiers (the double underscore is to work for "_:".
#define __EXTRN:%0##%1,%2|||%3|||%4,%5) EXTRY:%0##%1i,%2,%3|||%4|||%5)
#define Float_EXTRN:%0##%1,%2|||%3|||%4,%5) EXTRY:%0##%1f,%2,%3|||%4|||%5)
#define player_EXTRN:%0##%1,%2|||%3|||%4,%5) EXTRY:%0##%1u,%2,%3|||%4|||%5)
//#define string_EXTRW:%0##%1,%2|||%3[%7]|||%4,%5) EXTRY:%0##%1s[%7],%2,%3|||%4|||%5)

// Array versions of normal specifiers.
#define __EXTRW:%0##%1,%2|||%3[%7]|||%4,%5) EXTRY:%0##%1a<i>[%7],%2,%3|||%4|||%5)
#define Float_EXTRW:%0##%1,%2|||%3[%7]|||%4,%5) EXTRY:%0##%1a<f>[%7],%2,%3|||%4|||%5)
#define player_EXTRW:%0##%1,%2|||%3[%7]|||%4,%5) EXTRY:%0##%1a<u>[%7],%2,%3|||%4|||%5)
#define string_EXTRW:%0##%1,%2|||%3[%7]|||%4,%5) EXTRY:%0##%1s[%7],%2,%3|||%4|||%5)

// Get rid of excess leading space which causes warnings.
#define EXTRN%0new%1; new%1;

#if !defined string
#define string:
#endif

#define player:

#define hex:
#define hex_EXTRO:%0##%1,%2|||%3=%9|||%4,%5) EXTRY:%0##%1H"("#%9")"#,%2,%3|||%4|||%5)
#define hex_EXTRN:%0##%1,%2|||%3|||%4,%5) EXTRY:%0##%1h,%2,%3|||%4|||%5)
#define hex_EXTRW:%0##%1,%2|||%3[%7]|||%4,%5) EXTRY:%0##%1a<h>[%7],%2,%3|||%4|||%5)

#define bin:
#define bin_EXTRO:%0##%1,%2|||%3=%9|||%4,%5) EXTRY:%0##%1B"("#%9")"#,%2,%3|||%4|||%5)
#define bin_EXTRN:%0##%1,%2|||%3|||%4,%5) EXTRY:%0##%1b,%2,%3|||%4|||%5)
#define bin_EXTRW:%0##%1,%2|||%3[%7]|||%4,%5) EXTRY:%0##%1a<b>[%7],%2,%3|||%4|||%5)

#define kustom:%0<%1> %0
#define kustom_EXTRO:%0##%1,%2|||%3<%8>=%9|||%4,%5) EXTRY:%0##%1K<%8>"("#%9")"#,%2,%3|||%4|||%5)
#define kustom_EXTRN:%0##%1,%2|||%3<%8>|||%4,%5) EXTRY:%0##%1k<%8>,%2,%3|||%4|||%5)
//#define bin_EXTRW:%0##%1,%2|||%3[%7]|||%4,%5) EXTRY:%0##%1a<b>[%7],%2,%3|||%4|||%5)

SSCANF:weapon(text[])
{
	// This function is VERY basic, needs VASTLY improving to detect variations.
	if ('0' <= text[0] <= '9')
	{
		new
		ret = strval(text);
		if (0 <= ret <= 18 || 22 <= ret <= 46)
		{
			return ret;
		}
	}
	else if (!strcmp(text, "Unarmed")) return 0;
	else if (!strcmp(text, "Brass Knuckles")) return 1;
	else if (!strcmp(text, "Golf Club")) return 2;
	else if (!strcmp(text, "Night Stick")) return 3;
	else if (!strcmp(text, "Knife")) return 4;
	else if (!strcmp(text, "Baseball Bat")) return 5;
	else if (!strcmp(text, "Shovel")) return 6;
	else if (!strcmp(text, "Pool cue")) return 7;
	else if (!strcmp(text, "Katana")) return 8;
	else if (!strcmp(text, "Chainsaw")) return 9;
	else if (!strcmp(text, "Purple Dildo")) return 10;
	else if (!strcmp(text, "White Dildo")) return 11;
	else if (!strcmp(text, "Long White Dildo")) return 12;
	else if (!strcmp(text, "White Dildo 2")) return 13;
	else if (!strcmp(text, "Flowers")) return 14;
	else if (!strcmp(text, "Cane")) return 15;
	else if (!strcmp(text, "Grenades")) return 16;
	else if (!strcmp(text, "Tear Gas")) return 17;
	else if (!strcmp(text, "Molotovs")) return 18;
	else if (!strcmp(text, "Pistol")) return 22;
	else if (!strcmp(text, "Silenced Pistol")) return 23;
	else if (!strcmp(text, "Desert Eagle")) return 24;
	else if (!strcmp(text, "Shotgun")) return 25;
	else if (!strcmp(text, "Sawn Off Shotgun")) return 26;
	else if (!strcmp(text, "Combat Shotgun")) return 27;
	else if (!strcmp(text, "Micro Uzi")) return 28;
	else if (!strcmp(text, "Mac 10")) return 28;
	else if (!strcmp(text, "MP5")) return 29;
	else if (!strcmp(text, "AK47")) return 30;
	else if (!strcmp(text, "M4")) return 31;
	else if (!strcmp(text, "Tec9")) return 32;
	else if (!strcmp(text, "Rifle")) return 33;
	else if (!strcmp(text, "Sniper Rifle")) return 34;
	else if (!strcmp(text, "RPG")) return 35;
	else if (!strcmp(text, "Missile Launcher")) return 36;
	else if (!strcmp(text, "Flame Thrower")) return 37;
	else if (!strcmp(text, "Minigun")) return 38;
	else if (!strcmp(text, "Sachel Charges")) return 39;
	else if (!strcmp(text, "Detonator")) return 40;
	else if (!strcmp(text, "Spray Paint")) return 41;
	else if (!strcmp(text, "Fire Extinguisher")) return 42;
	else if (!strcmp(text, "Camera")) return 43;
	else if (!strcmp(text, "Nightvision Goggles")) return 44;
	else if (!strcmp(text, "Thermal Goggles")) return 45;
	else if (!strcmp(text, "Parachute")) return 46;
	return -1;
}

SSCANF:vehicle(text[])
{
	// This function is VERY basic, needs VASTLY improving to detect variations.
	if ('0' <= text[0] <= '9')
	{
		new
		ret = strval(text);
		if (400 <= ret <= 611)
		{
			return ret;
		}
	}
	else if (!strcmp(text, "Landstalker")) return 400;
	else if (!strcmp(text, "Bravura")) return 401;
	else if (!strcmp(text, "Buffalo")) return 402;
	else if (!strcmp(text, "Linerunner")) return 403;
	else if (!strcmp(text, "Perenniel")) return 404;
	else if (!strcmp(text, "Sentinel")) return 405;
	else if (!strcmp(text, "Dumper")) return 406;
	else if (!strcmp(text, "Firetruck")) return 407;
	else if (!strcmp(text, "Trashmaster")) return 408;
	else if (!strcmp(text, "Stretch")) return 409;
	else if (!strcmp(text, "Manana")) return 410;
	else if (!strcmp(text, "Infernus")) return 411;
	else if (!strcmp(text, "Voodoo")) return 412;
	else if (!strcmp(text, "Pony")) return 413;
	else if (!strcmp(text, "Mule")) return 414;
	else if (!strcmp(text, "Cheetah")) return 415;
	else if (!strcmp(text, "Ambulance")) return 416;
	else if (!strcmp(text, "Leviathan")) return 417;
	else if (!strcmp(text, "Moonbeam")) return 418;
	else if (!strcmp(text, "Esperanto")) return 419;
	else if (!strcmp(text, "Taxi")) return 420;
	else if (!strcmp(text, "Washington")) return 421;
	else if (!strcmp(text, "Bobcat")) return 422;
	else if (!strcmp(text, "Mr Whoopee")) return 423;
	else if (!strcmp(text, "BF Injection")) return 424;
	else if (!strcmp(text, "Hunter")) return 425;
	else if (!strcmp(text, "Premier")) return 426;
	else if (!strcmp(text, "Enforcer")) return 427;
	else if (!strcmp(text, "Securicar")) return 428;
	else if (!strcmp(text, "Banshee")) return 429;
	else if (!strcmp(text, "Predator")) return 430;
	else if (!strcmp(text, "Bus")) return 431;
	else if (!strcmp(text, "Rhino")) return 432;
	else if (!strcmp(text, "Barracks")) return 433;
	else if (!strcmp(text, "Hotknife")) return 434;
	else if (!strcmp(text, "Article Trailer")) return 435;
	else if (!strcmp(text, "Previon")) return 436;
	else if (!strcmp(text, "Coach")) return 437;
	else if (!strcmp(text, "Cabbie")) return 438;
	else if (!strcmp(text, "Stallion")) return 439;
	else if (!strcmp(text, "Rumpo")) return 440;
	else if (!strcmp(text, "RC Bandit")) return 441;
	else if (!strcmp(text, "Romero")) return 442;
	else if (!strcmp(text, "Packer")) return 443;
	else if (!strcmp(text, "Monster")) return 444;
	else if (!strcmp(text, "Admiral")) return 445;
	else if (!strcmp(text, "Squallo")) return 446;
	else if (!strcmp(text, "Seasparrow")) return 447;
	else if (!strcmp(text, "Pizzaboy")) return 448;
	else if (!strcmp(text, "Tram")) return 449;
	else if (!strcmp(text, "Article Trailer 2")) return 450;
	else if (!strcmp(text, "Turismo")) return 451;
	else if (!strcmp(text, "Speeder")) return 452;
	else if (!strcmp(text, "Reefer")) return 453;
	else if (!strcmp(text, "Tropic")) return 454;
	else if (!strcmp(text, "Flatbed")) return 455;
	else if (!strcmp(text, "Yankee")) return 456;
	else if (!strcmp(text, "Caddy")) return 457;
	else if (!strcmp(text, "Solair")) return 458;
	else if (!strcmp(text, "Berkley's RC Van")) return 459;
	else if (!strcmp(text, "Skimmer")) return 460;
	else if (!strcmp(text, "PCJ-600")) return 461;
	else if (!strcmp(text, "Faggio")) return 462;
	else if (!strcmp(text, "Freeway")) return 463;
	else if (!strcmp(text, "RC Baron")) return 464;
	else if (!strcmp(text, "RC Raider")) return 465;
	else if (!strcmp(text, "Glendale")) return 466;
	else if (!strcmp(text, "Oceanic")) return 467;
	else if (!strcmp(text, "Sanchez")) return 468;
	else if (!strcmp(text, "Sparrow")) return 469;
	else if (!strcmp(text, "Patriot")) return 470;
	else if (!strcmp(text, "Quad")) return 471;
	else if (!strcmp(text, "Coastguard")) return 472;
	else if (!strcmp(text, "Dinghy")) return 473;
	else if (!strcmp(text, "Hermes")) return 474;
	else if (!strcmp(text, "Sabre")) return 475;
	else if (!strcmp(text, "Rustler")) return 476;
	else if (!strcmp(text, "ZR-350")) return 477;
	else if (!strcmp(text, "Walton")) return 478;
	else if (!strcmp(text, "Regina")) return 479;
	else if (!strcmp(text, "Comet")) return 480;
	else if (!strcmp(text, "BMX")) return 481;
	else if (!strcmp(text, "Burrito")) return 482;
	else if (!strcmp(text, "Camper")) return 483;
	else if (!strcmp(text, "Marquis")) return 484;
	else if (!strcmp(text, "Baggage")) return 485;
	else if (!strcmp(text, "Dozer")) return 486;
	else if (!strcmp(text, "Maverick")) return 487;
	else if (!strcmp(text, "SAN News Maverick")) return 488;
	else if (!strcmp(text, "Rancher")) return 489;
	else if (!strcmp(text, "FBI Rancher")) return 490;
	else if (!strcmp(text, "Virgo")) return 491;
	else if (!strcmp(text, "Greenwood")) return 492;
	else if (!strcmp(text, "Jetmax")) return 493;
	else if (!strcmp(text, "Hotring Racer")) return 494;
	else if (!strcmp(text, "Sandking")) return 495;
	else if (!strcmp(text, "Blista Compact")) return 496;
	else if (!strcmp(text, "Police Maverick")) return 497;
	else if (!strcmp(text, "Boxville")) return 498;
	else if (!strcmp(text, "Benson")) return 499;
	else if (!strcmp(text, "Mesa")) return 500;
	else if (!strcmp(text, "RC Goblin")) return 501;
	else if (!strcmp(text, "Hotring Racer")) return 502;
	else if (!strcmp(text, "Hotring Racer")) return 503;
	else if (!strcmp(text, "Bloodring Banger")) return 504;
	else if (!strcmp(text, "Rancher")) return 505;
	else if (!strcmp(text, "Super GT")) return 506;
	else if (!strcmp(text, "Elegant")) return 507;
	else if (!strcmp(text, "Journey")) return 508;
	else if (!strcmp(text, "Bike")) return 509;
	else if (!strcmp(text, "Mountain Bike")) return 510;
	else if (!strcmp(text, "Beagle")) return 511;
	else if (!strcmp(text, "Cropduster")) return 512;
	else if (!strcmp(text, "Stuntplane")) return 513;
	else if (!strcmp(text, "Tanker")) return 514;
	else if (!strcmp(text, "Roadtrain")) return 515;
	else if (!strcmp(text, "Nebula")) return 516;
	else if (!strcmp(text, "Majestic")) return 517;
	else if (!strcmp(text, "Buccaneer")) return 518;
	else if (!strcmp(text, "Shamal")) return 519;
	else if (!strcmp(text, "Hydra")) return 520;
	else if (!strcmp(text, "FCR-900")) return 521;
	else if (!strcmp(text, "NRG-500")) return 522;
	else if (!strcmp(text, "HPV1000")) return 523;
	else if (!strcmp(text, "Cement Truck")) return 524;
	else if (!strcmp(text, "Towtruck")) return 525;
	else if (!strcmp(text, "Fortune")) return 526;
	else if (!strcmp(text, "Cadrona")) return 527;
	else if (!strcmp(text, "FBI Truck")) return 528;
	else if (!strcmp(text, "Willard")) return 529;
	else if (!strcmp(text, "Forklift")) return 530;
	else if (!strcmp(text, "Tractor")) return 531;
	else if (!strcmp(text, "Combine Harvester")) return 532;
	else if (!strcmp(text, "Feltzer")) return 533;
	else if (!strcmp(text, "Remington")) return 534;
	else if (!strcmp(text, "Slamvan")) return 535;
	else if (!strcmp(text, "Blade")) return 536;
	else if (!strcmp(text, "Freight (Train)")) return 537;
	else if (!strcmp(text, "Brownstreak (Train)")) return 538;
	else if (!strcmp(text, "Vortex")) return 539;
	else if (!strcmp(text, "Vincent")) return 540;
	else if (!strcmp(text, "Bullet")) return 541;
	else if (!strcmp(text, "Clover")) return 542;
	else if (!strcmp(text, "Sadler")) return 543;
	else if (!strcmp(text, "Firetruck LA")) return 544;
	else if (!strcmp(text, "Hustler")) return 545;
	else if (!strcmp(text, "Intruder")) return 546;
	else if (!strcmp(text, "Primo")) return 547;
	else if (!strcmp(text, "Cargobob")) return 548;
	else if (!strcmp(text, "Tampa")) return 549;
	else if (!strcmp(text, "Sunrise")) return 550;
	else if (!strcmp(text, "Merit")) return 551;
	else if (!strcmp(text, "Utility Van")) return 552;
	else if (!strcmp(text, "Nevada")) return 553;
	else if (!strcmp(text, "Yosemite")) return 554;
	else if (!strcmp(text, "Windsor")) return 555;
	else if (!strcmp(text, "Monster \"A\"")) return 556;
	else if (!strcmp(text, "Monster \"B\"")) return 557;
	else if (!strcmp(text, "Uranus")) return 558;
	else if (!strcmp(text, "Jester")) return 559;
	else if (!strcmp(text, "Sultan")) return 560;
	else if (!strcmp(text, "Stratum")) return 561;
	else if (!strcmp(text, "Elegy")) return 562;
	else if (!strcmp(text, "Raindance")) return 563;
	else if (!strcmp(text, "RC Tiger")) return 564;
	else if (!strcmp(text, "Flash")) return 565;
	else if (!strcmp(text, "Tahoma")) return 566;
	else if (!strcmp(text, "Savanna")) return 567;
	else if (!strcmp(text, "Bandito")) return 568;
	else if (!strcmp(text, "Freight Flat Trailer (Train)")) return 569;
	else if (!strcmp(text, "Streak Trailer (Train)")) return 570;
	else if (!strcmp(text, "Kart")) return 571;
	else if (!strcmp(text, "Mower")) return 572;
	else if (!strcmp(text, "Dune")) return 573;
	else if (!strcmp(text, "Sweeper")) return 574;
	else if (!strcmp(text, "Broadway")) return 575;
	else if (!strcmp(text, "Tornado")) return 576;
	else if (!strcmp(text, "AT400")) return 577;
	else if (!strcmp(text, "DFT-30")) return 578;
	else if (!strcmp(text, "Huntley")) return 579;
	else if (!strcmp(text, "Stafford")) return 580;
	else if (!strcmp(text, "BF-400")) return 581;
	else if (!strcmp(text, "Newsvan")) return 582;
	else if (!strcmp(text, "Tug")) return 583;
	else if (!strcmp(text, "Petrol Trailer")) return 584;
	else if (!strcmp(text, "Emperor")) return 585;
	else if (!strcmp(text, "Wayfarer")) return 586;
	else if (!strcmp(text, "Euros")) return 587;
	else if (!strcmp(text, "Hotdog")) return 588;
	else if (!strcmp(text, "Club")) return 589;
	else if (!strcmp(text, "Freight Box Trailer (Train)")) return 590;
	else if (!strcmp(text, "Article Trailer 3")) return 591;
	else if (!strcmp(text, "Andromada")) return 592;
	else if (!strcmp(text, "Dodo")) return 593;
	else if (!strcmp(text, "RC Cam")) return 594;
	else if (!strcmp(text, "Launch")) return 595;
	else if (!strcmp(text, "Police Car (LSPD)")) return 596;
	else if (!strcmp(text, "Police Car (SFPD)")) return 597;
	else if (!strcmp(text, "Police Car (LVPD)")) return 598;
	else if (!strcmp(text, "Police Ranger")) return 599;
	else if (!strcmp(text, "Picador")) return 600;
	else if (!strcmp(text, "S.W.A.T.")) return 601;
	else if (!strcmp(text, "Alpha")) return 602;
	else if (!strcmp(text, "Phoenix")) return 603;
	else if (!strcmp(text, "Glendale Shit")) return 604;
	else if (!strcmp(text, "Sadler Shit")) return 605;
	else if (!strcmp(text, "Baggage Trailer \"A\"")) return 606;
	else if (!strcmp(text, "Baggage Trailer \"B\"")) return 607;
	else if (!strcmp(text, "Tug Stairs Trailer")) return 608;
	else if (!strcmp(text, "Boxville")) return 609;
	else if (!strcmp(text, "Farm Trailer")) return 610;
	else if (!strcmp(text, "Utility Trailer")) return 611;
	return -1;
}

// Fix the compiler crash when both the PAWN and Plugin versions of sscanf are
// found by renaming the old version at declaration.  (fixes.inc compatible
// naming scheme: "BAD_Function()").
#define sscanf(%0:...) BAD_sscanf(%0:...)
