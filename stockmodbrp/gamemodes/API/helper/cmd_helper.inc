CMD:makehelper(playerid, params[])
{
    if(pData[playerid][pAdmin] < 4)
    	return NoCMD(playerid);

	if(sscanf(params, "dd", params[0], params[1]))
		return SendInf(playerid, "/makehelper [ID игрока] [LVL]");

	static
		temp_string[500];

    new str[100];
    new para1;
	new level;
	para1 = params[0];
	level = params[1];

	if(pData[para1][pWarnc]) return SendClientMessage(playerid,CGRAY,"У игрока есть варн");
	if(pData[playerid][pAdmin] >= 4)
	{
	    if(IsPlayerConnected(para1))
	    {
	        if(para1 != INVALID_PLAYER_ID)
	        {
	            if(level < 0 || level > 4)
	            	return SendClientMessage(playerid, COLOR_GREY, "Админка от 0 до 4!");

				pData[para1][pAdmin] = level;

		   		if( pData[para1][pScoreGame][12] < level && level > 1)
		   		{
					format(String256, sizeof( String256 ), "На ваш счет зачислено %d доната",(level -1 )*100 );
					pData[para1][pDonate] += (level-1)*100;
				    UpdatePlayerData(para1,"donate",pData[para1][pDonate]);
			   		pData[ para1 ][ pScoreGame ][12] = level;
					UpdatePlayerData( para1 , "game13", pData[ para1 ][ pScoreGame ][12] );
					if( level == 3 )
					{
			    	    give_money(para1 ,200000, "Администраторский бонус");
			        }
					else if( level == 4 )
					{
			    	    give_money(para1 ,250000, "Администраторский бонус");
			        }
					else if( level == 5 )
					{
			    	    give_money(para1 ,250000, "Администраторский бонус");
			        }
				}
				if(level > 0)
				{
					format(str, sizeof(str), "%s назначил Вас администратором", pData[playerid][pNickname]);
					SendClientMessage(para1, COLOR_YELLOW, str);
					format(str, sizeof(str), "Вы назначили %s администратором %i уровня.", pData[para1][pNickname], level);
					SendClientMessage(playerid, COLOR_YELLOW, str);

					format(temp_string, sizeof(temp_string), "SELECT * FROM admins WHERE username = '%s' LIMIT 1", pData[para1][pNickname]);
					new Result:adminfind = sql_queryEx(zConn, temp_string, QUERY_CACHED);

					if(sql_num_rows(adminfind))
					{

						format(temp_string, 200, "UPDATE admins SET level_admin = '%d', promote_name = '%s', admin_status = '1' WHERE username = '%s'", level, pData[playerid][pNickname], pData[para1][pNickname]);
					 	sql_queryEx(zConn, temp_string, QUERY_THREADED);
					}
					else
					{
					    format(temp_string, 256,"\
					    	INSERT INTO admins(username, userid, level_admin, promote_name, admin_status) \
					    	VALUES('%s', '%d', '%d', '%s', '1')", pData[para1][pNickname], pData[para1][pMysqlID], level, pData[playerid][pNickname]);
					   	sql_queryEx(zConn, temp_string, QUERY_THREADED);
					}

				}
				else if(level == 0)
				{
					SFCM(playerid, COLOR_YELLOW, "Вы сняли %s с должности администратора.", pData[para1][pNickname]);
				    SFCM(para1, COLOR_YELLOW, "%s снял вас с должности администратора.", pData[playerid][pNickname]);
					format(String256,sizeof(String256),"UPDATE `accounts` SET atime = 0 WHERE `nickname`='%s'", pData[para1][pNickname]);
				    pData[para1][pTextType] = 0;
					pData[para1][pPhone] = 0;
					sql_queryEx(zConn, String256, QUERY_THREADED);
					new query2[250];
					format(query2,sizeof(query2),"UPDATE `accounts` SET `phone` = '0', WHERE id = '%d'" ,pData[para1][pMysqlID]);
					sql_queryEx(zConn, query2, QUERY_THREADED);

					format(temp_string, 128, "DELETE FROM admins WHERE username = '%s'", pData[para1][pNickname]);
					sql_queryEx(zConn, temp_string, QUERY_THREADED);

					format(temp_string, 128, "DELETE FROM white_list_pc_version WHERE white_list_nickname = '%s'", params[0]);
					sql_queryEx(zConn, temp_string, QUERY_THREADED);

				}
				new query[150];
				format(query,sizeof(query),"UPDATE `accounts` SET `admin` = '%d' WHERE id = '%d'",pData[para1][pAdmin],pData[para1][pMysqlID]);
				sql_queryEx(zConn, query, QUERY_THREADED);

			}
		}
	}



	return true;
}
CMD:hahelp(playerid)
{
	if(!pData[playerid][pAdmin])
	return true;




	SPD(playerid, dhelpHelp, DIALOG_STYLE_LIST,
		!"Список доступных команд администратора",
		""cBLUE"- "cWH"Хелпер новечок\n\
		"cBLUE"- "cWH"Хелпер освоившийся\n\
		"cBLUE"- "cWH"Заместитель бывалый\n\
		"cBLUE"- "cWH"Гл. Хелпер\
		", !"Выбрать", !"Отмена");

	return true;
}
