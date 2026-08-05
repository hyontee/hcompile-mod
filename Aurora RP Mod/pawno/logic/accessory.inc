
stock AccessorySelect(playerid, id)
{
	if (GetPVarInt(playerid, "buy_accses"))
	{
		new price;
		switch (type_acces[playerid])
		{
		case 1:
		{
			new max_accs = sizeof(acces_id_glass) - 1;
			if (id == 0)
			{
				PlayerSelectAcsFix[playerid] += 1;
				if (PlayerSelectAcsFix[playerid] >= max_accs)
					PlayerSelectAcsFix[playerid] = 0;
			}
			else if (id == 1)
			{
				PlayerSelectAcsFix[playerid] -= 1;
				if (PlayerSelectAcsFix[playerid] <= 0)
					PlayerSelectAcsFix[playerid] = max_accs;
			}
			AtachPlayerAccessory(playerid, acces_id_glass[PlayerSelectAcsFix[playerid]][0], GetPlayerSkin(playerid));
			price = acces_id_glass[PlayerSelectAcsFix[playerid]][1];
			PlayerIDAcsFix[playerid] = acces_id_glass[PlayerSelectAcsFix[playerid]][0];
		}
		case 2:
		{
			new max_accs = sizeof(acces_id_hat) - 1;
			if (id == 0)
			{
				PlayerSelectAcsFix[playerid] += 1;
				if (PlayerSelectAcsFix[playerid] >= max_accs)
					PlayerSelectAcsFix[playerid] = 0;
			}
			else if (id == 1)
			{
				PlayerSelectAcsFix[playerid] -= 1;
				if (PlayerSelectAcsFix[playerid] <= 0)
					PlayerSelectAcsFix[playerid] = max_accs;
			}
			AtachPlayerAccessory(playerid, acces_id_hat[PlayerSelectAcsFix[playerid]][0], GetPlayerSkin(playerid));
			price = acces_id_hat[PlayerSelectAcsFix[playerid]][1];
			PlayerIDAcsFix[playerid] = acces_id_hat[PlayerSelectAcsFix[playerid]][0];
		}
		case 3:
		{
			new max_accs = sizeof(acces_id_bonnet) - 1;
			if (id == 0)
			{
				PlayerSelectAcsFix[playerid] += 1;
				if (PlayerSelectAcsFix[playerid] >= max_accs)
					PlayerSelectAcsFix[playerid] = 0;
			}
			else if (id == 1)
			{
				PlayerSelectAcsFix[playerid] -= 1;
				if (PlayerSelectAcsFix[playerid] <= 0)
					PlayerSelectAcsFix[playerid] = max_accs;
			}
			AtachPlayerAccessory(playerid, acces_id_bonnet[PlayerSelectAcsFix[playerid]][0], GetPlayerSkin(playerid));
			price = acces_id_bonnet[PlayerSelectAcsFix[playerid]][1];
			PlayerIDAcsFix[playerid] = acces_id_bonnet[PlayerSelectAcsFix[playerid]][0];
		}
		case 4:
		{
			new max_accs = sizeof(acces_id_cap) - 1;
			if (id == 0)
			{
				PlayerSelectAcsFix[playerid] += 1;
				if (PlayerSelectAcsFix[playerid] >= max_accs)
					PlayerSelectAcsFix[playerid] = 0;
			}
			else if (id == 1)
			{
				PlayerSelectAcsFix[playerid] -= 1;
				if (PlayerSelectAcsFix[playerid] <= 0)
					PlayerSelectAcsFix[playerid] = max_accs;
			}
			AtachPlayerAccessory(playerid, acces_id_cap[PlayerSelectAcsFix[playerid]][0], GetPlayerSkin(playerid));
			price = acces_id_cap[PlayerSelectAcsFix[playerid]][1];
			PlayerIDAcsFix[playerid] = acces_id_cap[PlayerSelectAcsFix[playerid]][0];
		}
		case 5:
		{
			new max_accs = sizeof(acces_id_beret) - 1;
			if (id == 0)
			{
				PlayerSelectAcsFix[playerid] += 1;
				if (PlayerSelectAcsFix[playerid] >= max_accs)
					PlayerSelectAcsFix[playerid] = 0;
			}
			else if (id == 1)
			{
				PlayerSelectAcsFix[playerid] -= 1;
				if (PlayerSelectAcsFix[playerid] <= 0)
					PlayerSelectAcsFix[playerid] = max_accs;
			}
			AtachPlayerAccessory(playerid, acces_id_beret[PlayerSelectAcsFix[playerid]][0], GetPlayerSkin(playerid));
			price = acces_id_beret[PlayerSelectAcsFix[playerid]][1];
			PlayerIDAcsFix[playerid] = acces_id_beret[PlayerSelectAcsFix[playerid]][0];
		}
		case 6:
		{
			new max_accs = sizeof(acces_id_bandanas) - 1;
			if (id == 0)
			{
				PlayerSelectAcsFix[playerid] += 1;
				if (PlayerSelectAcsFix[playerid] >= max_accs)
					PlayerSelectAcsFix[playerid] = 0;
			}
			else if (id == 1)
			{
				PlayerSelectAcsFix[playerid] -= 1;
				if (PlayerSelectAcsFix[playerid] <= 0)
					PlayerSelectAcsFix[playerid] = max_accs;
			}
			AtachPlayerAccessory(playerid, acces_id_bandanas[PlayerSelectAcsFix[playerid]][0], GetPlayerSkin(playerid));
			price = acces_id_bandanas[PlayerSelectAcsFix[playerid]][1];
			PlayerIDAcsFix[playerid] = acces_id_bandanas[PlayerSelectAcsFix[playerid]][0];
		}
		case 7:
		{
			new max_accs = sizeof(acces_id_panam) - 1;
			if (id == 0)
			{
				PlayerSelectAcsFix[playerid] += 1;
				if (PlayerSelectAcsFix[playerid] >= max_accs)
					PlayerSelectAcsFix[playerid] = 0;
			}
			else if (id == 1)
			{
				PlayerSelectAcsFix[playerid] -= 1;
				if (PlayerSelectAcsFix[playerid] <= 0)
					PlayerSelectAcsFix[playerid] = max_accs;
			}
			AtachPlayerAccessory(playerid, acces_id_panam[PlayerSelectAcsFix[playerid]][0], GetPlayerSkin(playerid));
			price = acces_id_panam[PlayerSelectAcsFix[playerid]][1];
			PlayerIDAcsFix[playerid] = acces_id_panam[PlayerSelectAcsFix[playerid]][0];
		}
		case 8:
		{
			new max_accs = sizeof(acces_id_sporthat) - 1;
			if (id == 0)
			{
				PlayerSelectAcsFix[playerid] += 1;
				if (PlayerSelectAcsFix[playerid] >= max_accs)
					PlayerSelectAcsFix[playerid] = 0;
			}
			else if (id == 1)
			{
				PlayerSelectAcsFix[playerid] -= 1;
				if (PlayerSelectAcsFix[playerid] <= 0)
					PlayerSelectAcsFix[playerid] = max_accs;
			}
			AtachPlayerAccessory(playerid, acces_id_sporthat[PlayerSelectAcsFix[playerid]][0], GetPlayerSkin(playerid));
			price = acces_id_sporthat[PlayerSelectAcsFix[playerid]][1];
			PlayerIDAcsFix[playerid] = acces_id_sporthat[PlayerSelectAcsFix[playerid]][0];
		}
		case 9:
		{
			new max_accs = sizeof(acces_id_kask) - 1;
			if (id == 0)
			{
				PlayerSelectAcsFix[playerid] += 1;
				if (PlayerSelectAcsFix[playerid] >= max_accs)
					PlayerSelectAcsFix[playerid] = 0;
			}
			else if (id == 1)
			{
				PlayerSelectAcsFix[playerid] -= 1;
				if (PlayerSelectAcsFix[playerid] <= 0)
					PlayerSelectAcsFix[playerid] = max_accs;
			}
			AtachPlayerAccessory(playerid, acces_id_kask[PlayerSelectAcsFix[playerid]][0], GetPlayerSkin(playerid));
			price = acces_id_kask[PlayerSelectAcsFix[playerid]][1];
			PlayerIDAcsFix[playerid] = acces_id_kask[PlayerSelectAcsFix[playerid]][0];
		}
		case 10:
		{
			new max_accs = sizeof(acces_id_mask) - 1;
			if (id == 0)
			{
				PlayerSelectAcsFix[playerid] += 1;
				if (PlayerSelectAcsFix[playerid] >= max_accs)
					PlayerSelectAcsFix[playerid] = 0;
			}
			else if (id == 1)
			{
				PlayerSelectAcsFix[playerid] -= 1;
				if (PlayerSelectAcsFix[playerid] <= 0)
					PlayerSelectAcsFix[playerid] = max_accs;
			}
			AtachPlayerAccessory(playerid, acces_id_mask[PlayerSelectAcsFix[playerid]][0], GetPlayerSkin(playerid));
			price = acces_id_mask[PlayerSelectAcsFix[playerid]][1];
			PlayerIDAcsFix[playerid] = acces_id_mask[PlayerSelectAcsFix[playerid]][0];
		}
		case 11:
		{
			new max_accs = sizeof(acces_id_headphones) - 1;
			if (id == 0)
			{
				PlayerSelectAcsFix[playerid] += 1;
				if (PlayerSelectAcsFix[playerid] >= max_accs)
					PlayerSelectAcsFix[playerid] = 0;
			}
			else if (id == 1)
			{
				PlayerSelectAcsFix[playerid] -= 1;
				if (PlayerSelectAcsFix[playerid] <= 0)
					PlayerSelectAcsFix[playerid] = max_accs;
			}
			AtachPlayerAccessory(playerid, acces_id_headphones[PlayerSelectAcsFix[playerid]][0], GetPlayerSkin(playerid));
			price = acces_id_headphones[PlayerSelectAcsFix[playerid]][1];
			PlayerIDAcsFix[playerid] = acces_id_headphones[PlayerSelectAcsFix[playerid]][0];
		}
		case 12:
		{
			new max_accs = sizeof(acces_id_watch) - 1;
			if (id == 0)
			{
				PlayerSelectAcsFix[playerid] += 1;
				if (PlayerSelectAcsFix[playerid] >= max_accs)
					PlayerSelectAcsFix[playerid] = 0;
			}
			else if (id == 1)
			{
				PlayerSelectAcsFix[playerid] -= 1;
				if (PlayerSelectAcsFix[playerid] <= 0)
					PlayerSelectAcsFix[playerid] = max_accs;
			}
			AtachPlayerAccessory(playerid, acces_id_watch[PlayerSelectAcsFix[playerid]][0], GetPlayerSkin(playerid));
			price = acces_id_watch[PlayerSelectAcsFix[playerid]][1];
			PlayerIDAcsFix[playerid] = acces_id_watch[PlayerSelectAcsFix[playerid]][0];
		}
		case 13:
		{
			new max_accs = sizeof(acces_id_backpack) - 1;
			if (id == 0)
			{
				PlayerSelectAcsFix[playerid] += 1;
				if (PlayerSelectAcsFix[playerid] >= max_accs)
					PlayerSelectAcsFix[playerid] = 0;
			}
			else if (id == 1)
			{
				PlayerSelectAcsFix[playerid] -= 1;
				if (PlayerSelectAcsFix[playerid] <= 0)
					PlayerSelectAcsFix[playerid] = max_accs;
			}
			AtachPlayerAccessory(playerid, acces_id_backpack[PlayerSelectAcsFix[playerid]][0], GetPlayerSkin(playerid));
			price = acces_id_backpack[PlayerSelectAcsFix[playerid]][1];
			PlayerIDAcsFix[playerid] = acces_id_backpack[PlayerSelectAcsFix[playerid]][0];
		}
		}
		PlayerPriceAcsFix[playerid] = price;
		new string[12];
		format(string, sizeof(string), "$%d", price);
		PlayerTextDrawSetString(playerid, buy_player_skins[playerid], string);
	}
	return 1;
}
stock AccessoryClose(playerid)
{
	new Float:x, Float:y, Float:z, Float:x2, Float:y2, Float:z2;
	GetPlayerCameraPos(playerid, x, y, z);
	InterpolateCameraPos(playerid, x, y, z, 212.5107 + (2.5 * floatsin(-89.8527, degrees)), -41.5253 + (2.5 * floatcos(-89.8527, degrees)), 1002.0234, 1200);
	GetPlayerCameraFrontVector(playerid, x2, y2, z2);
	InterpolateCameraLookAt(playerid, x + x2, y + y2, z + z2, 212.5107, -41.5253, 1002.0234, 1200);
	AccessoryBuy(playerid);
	return 1;
}
stock AccessoryBuy(playerid)
{
	new string[512];
	format(string, sizeof(string), "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s", acces_name_all[0], acces_name_all[1], acces_name_all[2], acces_name_all[3], acces_name_all[4], acces_name_all[5], acces_name_all[6], acces_name_all[7], acces_name_all[8], acces_name_all[9], acces_name_all[10], acces_name_all[11], acces_name_all[12]);
	ShowPlayerDialog(playerid, D_BUYACS, DSL, "" P "Покупка аксесуаров", string, "Выбрать", "Отмена");
	return true;
}

