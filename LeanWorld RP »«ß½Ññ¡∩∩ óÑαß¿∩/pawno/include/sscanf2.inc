/*
 *  sscanf 2.8.3
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

#if !defined _INC_SSCANF
	#define _INC_SSCANF
#else
	#endinput
#endif

#if defined _inc_a_npc
	#pragma library sscanf
#elseif !defined _samp_included
	#error Please include <a_npc> or <a_samp> first.
#endif

#define SSCANF:%0(%1) forward sscanf_%0(%1);public sscanf_%0(%1)

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
							name[MAX_PLAYER_NAME + 1];
						GetPlayerName(i, name, sizeof(name));
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
     		name[MAX_PLAYER_NAME + 1];

		SSCANF_Init(GetMaxPlayers(), INVALID_PLAYER_ID, MAX_PLAYER_NAME);
		SSCANF_gInit = true;

		// Check if there are any players that aren't initialized.
		for (new i = 0; i < MAX_PLAYERS; i ++)
		{
		    if (IsPlayerConnected(i) && !SSCANF_IsConnected(i))
		    {
		        GetPlayerName(i, name, sizeof(name));
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
		        name[MAX_PLAYER_NAME + 1];

			SSCANF_Init(GetMaxPlayers(), INVALID_PLAYER_ID, MAX_PLAYER_NAME);
			SSCANF_gInit = true;

			// Check if there are any players that aren't initialized.
			for (new i = 0; i < MAX_PLAYERS; i ++)
			{
			    if (IsPlayerConnected(i) && !SSCANF_IsConnected(i))
			    {
			        GetPlayerName(i, name, sizeof(name));
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
			name[MAX_PLAYER_NAME + 1];
		GetPlayerName(playerid, name, sizeof(name));
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

#define extract%0->%1; EXTRN%1;unformat(_:EXTRZ:EXTRV:EXTRX:%0,#,%1,,);
#define unformat(_:EXTRZ:EXTRV:EXTRX:%0,#,%1);%2else if (unformat(_:EXTRV:EXTRX:%0,#,%1))

#define EXTRV:EXTRX:%0<%3>%4#,%9new%1,%2) EXTRY:%0%4#P<%3>,|||%1|||%2)
#define EXTRX:%0#,%9new%1,%2) EXTRY:%0#,|||%1|||%2)
#define EXTRY: EXTR8:EXTR9:EXTR0:EXTR1:EXTR2:EXTR3:EXTR4:

#define EXTR8:EXTR9:EXTR0:EXTR1:EXTR2:EXTR3:EXTR4:%0#%1,%2|||%6:%3=%9|||%4) %6_EXTRO:%0#%1,%2|||%3=%9|||%4)
#define EXTR9:EXTR0:EXTR1:EXTR2:EXTR3:EXTR4:%0#%1,%2|||%3=%9|||%4) __EXTRO:%0#%1,%2|||%3=%9|||%4)
#define EXTR0:EXTR1:EXTR2:EXTR3:EXTR4:%0#%1,%2|||%6:%3[%7]|||%4) %6_EXTRW:%0#%1,%2|||%3[%7]|||%4)
#define EXTR1:EXTR2:EXTR3:EXTR4:%0#%1,%2|||%3[%7]|||%4) __EXTRW:%0#%1,%2|||%3|||%4)
#define EXTR2:EXTR3:EXTR4:%0#%1,%2|||%6:%3|||%4) %6_EXTRN:%0#%1,%2|||%3|||%4)
#define EXTR3:EXTR4:%0#%1,,%2||||||%4) %0#%1,%2)
#define EXTR4:%0#%1,%2|||%3|||%4) __EXTRN:%0#%1,%2|||%3|||%4)

// Optional specifiers.
#define __EXTRO:%0#%1,%2|||%3=%9|||%4,%5) EXTRY:%0#%1I"("#%9")"#,%2,%3|||%4|||%5)
#define Float_EXTRO:%0#%1,%2|||%3=%9|||%4,%5) EXTRY:%0#%1F"("#%9")"#,%2,%3|||%4|||%5)
#define player_EXTRO:%0#%1,%2|||%3=%9|||%4,%5) EXTRY:%0#%1U"("#%9")"#,%2,%3|||%4|||%5)
#define string_EXTRO:%0#%1,%2|||%3[%7]=%9|||%4,%5) EXTRY:%0#%1S"("#%9")"#[%7],%2,%3|||%4|||%5)

// Normal specifiers (the double underscore is to work for "_:".
#define __EXTRN:%0#%1,%2|||%3|||%4,%5) EXTRY:%0#%1i,%2,%3|||%4|||%5)
#define Float_EXTRN:%0#%1,%2|||%3|||%4,%5) EXTRY:%0#%1f,%2,%3|||%4|||%5)
#define player_EXTRN:%0#%1,%2|||%3|||%4,%5) EXTRY:%0#%1u,%2,%3|||%4|||%5)
//#define string_EXTRW:%0#%1,%2|||%3[%7]|||%4,%5) EXTRY:%0#%1s[%7],%2,%3|||%4|||%5)

// Array versions of normal specifiers.
#define __EXTRW:%0#%1,%2|||%3[%7]|||%4,%5) EXTRY:%0#%1a<i>[%7],%2,%3|||%4|||%5)
#define Float_EXTRW:%0#%1,%2|||%3[%7]|||%4,%5) EXTRY:%0#%1a<f>[%7],%2,%3|||%4|||%5)
#define player_EXTRW:%0#%1,%2|||%3[%7]|||%4,%5) EXTRY:%0#%1a<u>[%7],%2,%3|||%4|||%5)
#define string_EXTRW:%0#%1,%2|||%3[%7]|||%4,%5) EXTRY:%0#%1s[%7],%2,%3|||%4|||%5)

// Get rid of excess leading space which causes warnings.
#define EXTRN%0new%1; new%1;

#if !defined string
    #define string:
#endif

#define player:%0;unformat(%1) %0;unformat(%1)

#define hex:%0;unformat(%1) %0;unformat(%1)
#define hex_EXTRO:%0#%1,%2|||%3=%9|||%4,%5) EXTRY:%0#%1H"("#%9")"#,%2,%3|||%4|||%5)
#define hex_EXTRN:%0#%1,%2|||%3|||%4,%5) EXTRY:%0#%1h,%2,%3|||%4|||%5)
#define hex_EXTRW:%0#%1,%2|||%3[%7]|||%4,%5) EXTRY:%0#%1a<h>[%7],%2,%3|||%4|||%5)

#define bin:%0;unformat(%1) %0;unformat(%1)
#define bin_EXTRO:%0#%1,%2|||%3=%9|||%4,%5) EXTRY:%0#%1B"("#%9")"#,%2,%3|||%4|||%5)
#define bin_EXTRN:%0#%1,%2|||%3|||%4,%5) EXTRY:%0#%1b,%2,%3|||%4|||%5)
#define bin_EXTRW:%0#%1,%2|||%3[%7]|||%4,%5) EXTRY:%0#%1a<b>[%7],%2,%3|||%4|||%5)

#define kustom:%0<%1> %0
#define kustom_EXTRO:%0#%1,%2|||%3<%8>=%9|||%4,%5) EXTRY:%0#%1K<%8>"("#%9")"#,%2,%3|||%4|||%5)
#define kustom_EXTRN:%0#%1,%2|||%3<%8>|||%4,%5) EXTRY:%0#%1k<%8>,%2,%3|||%4|||%5)
//#define bin_EXTRW:%0#%1,%2|||%3[%7]|||%4,%5) EXTRY:%0#%1a<b>[%7],%2,%3|||%4|||%5)

SSCANF:weapon(stringfix[])
{
	// This function is VERY basic, needs VASTLY improving to detect variations.
	if ('0' <= stringfix[0] <= '9')
	{
		new
			ret = strval(stringfix);
		if (0 <= ret <= 18 || 22 <= ret <= 46)
		{
			return ret;
		}
	}
	else if (!strcmp(stringfix, "Unarmed", true)) return 0;
	else if (!strcmp(stringfix, "Brass Knuckles", true)) return 1;
	else if (!strcmp(stringfix, "Golf Club", true)) return 2;
	else if (!strcmp(stringfix, "Night Stick", true)) return 3;
	else if (!strcmp(stringfix, "Knife", true)) return 4;
	else if (!strcmp(stringfix, "Baseball Bat", true)) return 5;
	else if (!strcmp(stringfix, "Shovel", true)) return 6;
	else if (!strcmp(stringfix, "Pool cue", true)) return 7;
	else if (!strcmp(stringfix, "Katana", true)) return 8;
	else if (!strcmp(stringfix, "Chainsaw", true)) return 9;
	else if (!strcmp(stringfix, "Purple Dildo", true)) return 10;
	else if (!strcmp(stringfix, "White Dildo", true)) return 11;
	else if (!strcmp(stringfix, "Long White Dildo", true)) return 12;
	else if (!strcmp(stringfix, "White Dildo 2", true)) return 13;
	else if (!strcmp(stringfix, "Flowers", true)) return 14;
	else if (!strcmp(stringfix, "Cane", true)) return 15;
	else if (!strcmp(stringfix, "Grenades", true)) return 16;
	else if (!strcmp(stringfix, "Tear Gas", true)) return 17;
	else if (!strcmp(stringfix, "Molotovs", true)) return 18;
	else if (!strcmp(stringfix, "Pistol", true)) return 22;
	else if (!strcmp(stringfix, "Silenced Pistol", true)) return 23;
	else if (!strcmp(stringfix, "Desert Eagle", true)) return 24;
	else if (!strcmp(stringfix, "Shotgun", true)) return 25;
	else if (!strcmp(stringfix, "Sawn Off Shotgun", true)) return 26;
	else if (!strcmp(stringfix, "Combat Shotgun", true)) return 27;
	else if (!strcmp(stringfix, "Micro Uzi", true)) return 28;
	else if (!strcmp(stringfix, "Mac 10", true)) return 28;
	else if (!strcmp(stringfix, "MP5", true)) return 29;
	else if (!strcmp(stringfix, "AK47", true)) return 30;
	else if (!strcmp(stringfix, "M4", true)) return 31;
	else if (!strcmp(stringfix, "Tec9", true)) return 32;
	else if (!strcmp(stringfix, "Rifle", true)) return 33;
	else if (!strcmp(stringfix, "Sniper Rifle", true)) return 34;
	else if (!strcmp(stringfix, "RPG", true)) return 35;
	else if (!strcmp(stringfix, "Missile Launcher", true)) return 36;
	else if (!strcmp(stringfix, "Flame Thrower", true)) return 37;
	else if (!strcmp(stringfix, "Minigun", true)) return 38;
	else if (!strcmp(stringfix, "Sachel Charges", true)) return 39;
	else if (!strcmp(stringfix, "Detonator", true)) return 40;
	else if (!strcmp(stringfix, "Spray Paint", true)) return 41;
	else if (!strcmp(stringfix, "Fire Extinguisher", true)) return 42;
	else if (!strcmp(stringfix, "Camera", true)) return 43;
	else if (!strcmp(stringfix, "Nightvision Goggles", true)) return 44;
	else if (!strcmp(stringfix, "Thermal Goggles", true)) return 45;
	else if (!strcmp(stringfix, "Parachute", true)) return 46;
	return -1;
}

SSCANF:vehicle(stringfix[])
{
	// This function is VERY basic, needs VASTLY improving to detect variations.
	if ('0' <= stringfix[0] <= '9')
	{
		new
			ret = strval(stringfix);
		if (400 <= ret <= 611)
		{
			return ret;
		}
	}
	else if (!strcmp(stringfix, "Landstalker", true)) return 400;
	else if (!strcmp(stringfix, "Bravura", true)) return 401;
	else if (!strcmp(stringfix, "Buffalo", true)) return 402;
	else if (!strcmp(stringfix, "Linerunner", true)) return 403;
	else if (!strcmp(stringfix, "Perenniel", true)) return 404;
	else if (!strcmp(stringfix, "Sentinel", true)) return 405;
	else if (!strcmp(stringfix, "Dumper", true)) return 406;
	else if (!strcmp(stringfix, "Firetruck", true)) return 407;
	else if (!strcmp(stringfix, "Trashmaster", true)) return 408;
	else if (!strcmp(stringfix, "Stretch", true)) return 409;
	else if (!strcmp(stringfix, "Manana", true)) return 410;
	else if (!strcmp(stringfix, "Infernus", true)) return 411;
	else if (!strcmp(stringfix, "Voodoo", true)) return 412;
	else if (!strcmp(stringfix, "Pony", true)) return 413;
	else if (!strcmp(stringfix, "Mule", true)) return 414;
	else if (!strcmp(stringfix, "Cheetah", true)) return 415;
	else if (!strcmp(stringfix, "Ambulance", true)) return 416;
	else if (!strcmp(stringfix, "Leviathan", true)) return 417;
	else if (!strcmp(stringfix, "Moonbeam", true)) return 418;
	else if (!strcmp(stringfix, "Esperanto", true)) return 419;
	else if (!strcmp(stringfix, "Taxi", true)) return 420;
	else if (!strcmp(stringfix, "Washington", true)) return 421;
	else if (!strcmp(stringfix, "Bobcat", true)) return 422;
	else if (!strcmp(stringfix, "Mr Whoopee", true)) return 423;
	else if (!strcmp(stringfix, "BF Injection", true)) return 424;
	else if (!strcmp(stringfix, "Hunter", true)) return 425;
	else if (!strcmp(stringfix, "Premier", true)) return 426;
	else if (!strcmp(stringfix, "Enforcer", true)) return 427;
	else if (!strcmp(stringfix, "Securicar", true)) return 428;
	else if (!strcmp(stringfix, "Banshee", true)) return 429;
	else if (!strcmp(stringfix, "Predator", true)) return 430;
	else if (!strcmp(stringfix, "Bus", true)) return 431;
	else if (!strcmp(stringfix, "Rhino", true)) return 432;
	else if (!strcmp(stringfix, "Barracks", true)) return 433;
	else if (!strcmp(stringfix, "Hotknife", true)) return 434;
	else if (!strcmp(stringfix, "Article Trailer", true)) return 435;
	else if (!strcmp(stringfix, "Previon", true)) return 436;
	else if (!strcmp(stringfix, "Coach", true)) return 437;
	else if (!strcmp(stringfix, "Cabbie", true)) return 438;
	else if (!strcmp(stringfix, "Stallion", true)) return 439;
	else if (!strcmp(stringfix, "Rumpo", true)) return 440;
	else if (!strcmp(stringfix, "RC Bandit", true)) return 441;
	else if (!strcmp(stringfix, "Romero", true)) return 442;
	else if (!strcmp(stringfix, "Packer", true)) return 443;
	else if (!strcmp(stringfix, "Monster", true)) return 444;
	else if (!strcmp(stringfix, "Admiral", true)) return 445;
	else if (!strcmp(stringfix, "Squallo", true)) return 446;
	else if (!strcmp(stringfix, "Seasparrow", true)) return 447;
	else if (!strcmp(stringfix, "Pizzaboy", true)) return 448;
	else if (!strcmp(stringfix, "Tram", true)) return 449;
	else if (!strcmp(stringfix, "Article Trailer 2", true)) return 450;
	else if (!strcmp(stringfix, "Turismo", true)) return 451;
	else if (!strcmp(stringfix, "Speeder", true)) return 452;
	else if (!strcmp(stringfix, "Reefer", true)) return 453;
	else if (!strcmp(stringfix, "Tropic", true)) return 454;
	else if (!strcmp(stringfix, "Flatbed", true)) return 455;
	else if (!strcmp(stringfix, "Yankee", true)) return 456;
	else if (!strcmp(stringfix, "Caddy", true)) return 457;
	else if (!strcmp(stringfix, "Solair", true)) return 458;
	else if (!strcmp(stringfix, "Berkley's RC Van", true)) return 459;
	else if (!strcmp(stringfix, "Skimmer", true)) return 460;
	else if (!strcmp(stringfix, "PCJ-600", true)) return 461;
	else if (!strcmp(stringfix, "Faggio", true)) return 462;
	else if (!strcmp(stringfix, "Freeway", true)) return 463;
	else if (!strcmp(stringfix, "RC Baron", true)) return 464;
	else if (!strcmp(stringfix, "RC Raider", true)) return 465;
	else if (!strcmp(stringfix, "Glendale", true)) return 466;
	else if (!strcmp(stringfix, "Oceanic", true)) return 467;
	else if (!strcmp(stringfix, "Sanchez", true)) return 468;
	else if (!strcmp(stringfix, "Sparrow", true)) return 469;
	else if (!strcmp(stringfix, "Patriot", true)) return 470;
	else if (!strcmp(stringfix, "Quad", true)) return 471;
	else if (!strcmp(stringfix, "Coastguard", true)) return 472;
	else if (!strcmp(stringfix, "Dinghy", true)) return 473;
	else if (!strcmp(stringfix, "Hermes", true)) return 474;
	else if (!strcmp(stringfix, "Sabre", true)) return 475;
	else if (!strcmp(stringfix, "Rustler", true)) return 476;
	else if (!strcmp(stringfix, "ZR-350", true)) return 477;
	else if (!strcmp(stringfix, "Walton", true)) return 478;
	else if (!strcmp(stringfix, "Regina", true)) return 479;
	else if (!strcmp(stringfix, "Comet", true)) return 480;
	else if (!strcmp(stringfix, "BMX", true)) return 481;
	else if (!strcmp(stringfix, "Burrito", true)) return 482;
	else if (!strcmp(stringfix, "Camper", true)) return 483;
	else if (!strcmp(stringfix, "Marquis", true)) return 484;
	else if (!strcmp(stringfix, "Baggage", true)) return 485;
	else if (!strcmp(stringfix, "Dozer", true)) return 486;
	else if (!strcmp(stringfix, "Maverick", true)) return 487;
	else if (!strcmp(stringfix, "SAN News Maverick", true)) return 488;
	else if (!strcmp(stringfix, "Rancher", true)) return 489;
	else if (!strcmp(stringfix, "FBI Rancher", true)) return 490;
	else if (!strcmp(stringfix, "Virgo", true)) return 491;
	else if (!strcmp(stringfix, "Greenwood", true)) return 492;
	else if (!strcmp(stringfix, "Jetmax", true)) return 493;
	else if (!strcmp(stringfix, "Hotring Racer", true)) return 494;
	else if (!strcmp(stringfix, "Sandking", true)) return 495;
	else if (!strcmp(stringfix, "Blista Compact", true)) return 496;
	else if (!strcmp(stringfix, "Police Maverick", true)) return 497;
	else if (!strcmp(stringfix, "Boxville", true)) return 498;
	else if (!strcmp(stringfix, "Benson", true)) return 499;
	else if (!strcmp(stringfix, "Mesa", true)) return 500;
	else if (!strcmp(stringfix, "RC Goblin", true)) return 501;
	else if (!strcmp(stringfix, "Hotring Racer", true)) return 502;
	else if (!strcmp(stringfix, "Hotring Racer", true)) return 503;
	else if (!strcmp(stringfix, "Bloodring Banger", true)) return 504;
	else if (!strcmp(stringfix, "Rancher", true)) return 505;
	else if (!strcmp(stringfix, "Super GT", true)) return 506;
	else if (!strcmp(stringfix, "Elegant", true)) return 507;
	else if (!strcmp(stringfix, "Journey", true)) return 508;
	else if (!strcmp(stringfix, "Bike", true)) return 509;
	else if (!strcmp(stringfix, "Mountain Bike", true)) return 510;
	else if (!strcmp(stringfix, "Beagle", true)) return 511;
	else if (!strcmp(stringfix, "Cropduster", true)) return 512;
	else if (!strcmp(stringfix, "Stuntplane", true)) return 513;
	else if (!strcmp(stringfix, "Tanker", true)) return 514;
	else if (!strcmp(stringfix, "Roadtrain", true)) return 515;
	else if (!strcmp(stringfix, "Nebula", true)) return 516;
	else if (!strcmp(stringfix, "Majestic", true)) return 517;
	else if (!strcmp(stringfix, "Buccaneer", true)) return 518;
	else if (!strcmp(stringfix, "Shamal", true)) return 519;
	else if (!strcmp(stringfix, "Hydra", true)) return 520;
	else if (!strcmp(stringfix, "FCR-900", true)) return 521;
	else if (!strcmp(stringfix, "NRG-500", true)) return 522;
	else if (!strcmp(stringfix, "HPV1000", true)) return 523;
	else if (!strcmp(stringfix, "Cement Truck", true)) return 524;
	else if (!strcmp(stringfix, "Towtruck", true)) return 525;
	else if (!strcmp(stringfix, "Fortune", true)) return 526;
	else if (!strcmp(stringfix, "Cadrona", true)) return 527;
	else if (!strcmp(stringfix, "FBI Truck", true)) return 528;
	else if (!strcmp(stringfix, "Willard", true)) return 529;
	else if (!strcmp(stringfix, "Forklift", true)) return 530;
	else if (!strcmp(stringfix, "Tractor", true)) return 531;
	else if (!strcmp(stringfix, "Combine Harvester", true)) return 532;
	else if (!strcmp(stringfix, "Feltzer", true)) return 533;
	else if (!strcmp(stringfix, "Remington", true)) return 534;
	else if (!strcmp(stringfix, "Slamvan", true)) return 535;
	else if (!strcmp(stringfix, "Blade", true)) return 536;
	else if (!strcmp(stringfix, "Freight (Train)", true)) return 537;
	else if (!strcmp(stringfix, "Brownstreak (Train)", true)) return 538;
	else if (!strcmp(stringfix, "Vortex", true)) return 539;
	else if (!strcmp(stringfix, "Vincent", true)) return 540;
	else if (!strcmp(stringfix, "Bullet", true)) return 541;
	else if (!strcmp(stringfix, "Clover", true)) return 542;
	else if (!strcmp(stringfix, "Sadler", true)) return 543;
	else if (!strcmp(stringfix, "Firetruck LA", true)) return 544;
	else if (!strcmp(stringfix, "Hustler", true)) return 545;
	else if (!strcmp(stringfix, "Intruder", true)) return 546;
	else if (!strcmp(stringfix, "Primo", true)) return 547;
	else if (!strcmp(stringfix, "Cargobob", true)) return 548;
	else if (!strcmp(stringfix, "Tampa", true)) return 549;
	else if (!strcmp(stringfix, "Sunrise", true)) return 550;
	else if (!strcmp(stringfix, "Merit", true)) return 551;
	else if (!strcmp(stringfix, "Utility Van", true)) return 552;
	else if (!strcmp(stringfix, "Nevada", true)) return 553;
	else if (!strcmp(stringfix, "Yosemite", true)) return 554;
	else if (!strcmp(stringfix, "Windsor", true)) return 555;
	else if (!strcmp(stringfix, "Monster \"A\"", true)) return 556;
	else if (!strcmp(stringfix, "Monster \"B\"", true)) return 557;
	else if (!strcmp(stringfix, "Uranus", true)) return 558;
	else if (!strcmp(stringfix, "Jester", true)) return 559;
	else if (!strcmp(stringfix, "Sultan", true)) return 560;
	else if (!strcmp(stringfix, "Stratum", true)) return 561;
	else if (!strcmp(stringfix, "Elegy", true)) return 562;
	else if (!strcmp(stringfix, "Raindance", true)) return 563;
	else if (!strcmp(stringfix, "RC Tiger", true)) return 564;
	else if (!strcmp(stringfix, "Flash", true)) return 565;
	else if (!strcmp(stringfix, "Tahoma", true)) return 566;
	else if (!strcmp(stringfix, "Savanna", true)) return 567;
	else if (!strcmp(stringfix, "Bandito", true)) return 568;
	else if (!strcmp(stringfix, "Freight Flat Trailer (Train)", true)) return 569;
	else if (!strcmp(stringfix, "Streak Trailer (Train)", true)) return 570;
	else if (!strcmp(stringfix, "Kart", true)) return 571;
	else if (!strcmp(stringfix, "Mower", true)) return 572;
	else if (!strcmp(stringfix, "Dune", true)) return 573;
	else if (!strcmp(stringfix, "Sweeper", true)) return 574;
	else if (!strcmp(stringfix, "Broadway", true)) return 575;
	else if (!strcmp(stringfix, "Tornado", true)) return 576;
	else if (!strcmp(stringfix, "AT400", true)) return 577;
	else if (!strcmp(stringfix, "DFT-30", true)) return 578;
	else if (!strcmp(stringfix, "Huntley", true)) return 579;
	else if (!strcmp(stringfix, "Stafford", true)) return 580;
	else if (!strcmp(stringfix, "BF-400", true)) return 581;
	else if (!strcmp(stringfix, "Newsvan", true)) return 582;
	else if (!strcmp(stringfix, "Tug", true)) return 583;
	else if (!strcmp(stringfix, "Petrol Trailer", true)) return 584;
	else if (!strcmp(stringfix, "Emperor", true)) return 585;
	else if (!strcmp(stringfix, "Wayfarer", true)) return 586;
	else if (!strcmp(stringfix, "Euros", true)) return 587;
	else if (!strcmp(stringfix, "Hotdog", true)) return 588;
	else if (!strcmp(stringfix, "Club", true)) return 589;
	else if (!strcmp(stringfix, "Freight Box Trailer (Train)", true)) return 590;
	else if (!strcmp(stringfix, "Article Trailer 3", true)) return 591;
	else if (!strcmp(stringfix, "Andromada", true)) return 592;
	else if (!strcmp(stringfix, "Dodo", true)) return 593;
	else if (!strcmp(stringfix, "RC Cam", true)) return 594;
	else if (!strcmp(stringfix, "Launch", true)) return 595;
	else if (!strcmp(stringfix, "Police Car (LSPD)", true)) return 596;
	else if (!strcmp(stringfix, "Police Car (SFPD)", true)) return 597;
	else if (!strcmp(stringfix, "Police Car (LVPD)", true)) return 598;
	else if (!strcmp(stringfix, "Police Ranger", true)) return 599;
	else if (!strcmp(stringfix, "Picador", true)) return 600;
	else if (!strcmp(stringfix, "S.W.A.T.", true)) return 601;
	else if (!strcmp(stringfix, "Alpha", true)) return 602;
	else if (!strcmp(stringfix, "Phoenix", true)) return 603;
	else if (!strcmp(stringfix, "Glendale Shit", true)) return 604;
	else if (!strcmp(stringfix, "Sadler Shit", true)) return 605;
	else if (!strcmp(stringfix, "Baggage Trailer \"A\"", true)) return 606;
	else if (!strcmp(stringfix, "Baggage Trailer \"B\"", true)) return 607;
	else if (!strcmp(stringfix, "Tug Stairs Trailer", true)) return 608;
	else if (!strcmp(stringfix, "Boxville", true)) return 609;
	else if (!strcmp(stringfix, "Farm Trailer", true)) return 610;
	else if (!strcmp(stringfix, "Utility Trailer", true)) return 611;
	return -1;
}

// Fix the compiler crash when both the PAWN and Plugin versions of sscanf are
// found by renaming the old version at declaration.  (fixes.inc compatible
// naming scheme: "BAD_Function()").
#define sscanf(%0:...) BAD_sscanf(%0:...)
