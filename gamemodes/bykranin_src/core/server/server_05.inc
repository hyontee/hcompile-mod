//>> Файл: bykranin_src/core/server/server_05.inc  (328 строк)
//>> Тема: инфраструктура: таймеры, сохранение, MySQL, утилиты
//>> Внутри: FERMAGAREL, ZAVODBUSAEVO, ARZVISHKA, KARAKVISHKA, GARELVISHKA, DrugEffectGone
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public FERMAGAREL()
{
for(new i=0;i<MAX_PLAYERS;i++)
{
new playerid=i;
if(GetPVarInt(playerid, "FermaGarelpva")==1)
{
    new query[128];
    new fmt_text[128];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
    
    // Обновление очков игрока и базы данных
    SetPlayerData(playerid, P_OHFAM, GetPlayerData(playerid, P_OHFAM) + 1);
    UpdatePlayerDatabaseInt(playerid, "ocfam", GetPlayerData(playerid, P_OHFAM));
    AddFamilyData(fam_id, F_OCKIFARMA, +, 1);
  
  format(fmt_text, sizeof(fmt_text), "UPDATE family SET ochki=%d WHERE id=%d LIMIT 1", GetFamilyData(fam_id, F_OCKIFARMA), fam_id);
    mysql_query(mysql, fmt_text, false);
    
    // Получение очков семьи игрока
    new Cache: result;
    mysql_format(mysql, query, sizeof query, "SELECT ochki FROM family WHERE id=%d LIMIT 1", fam_id);
    result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new ochki = cache_get_field_content_int(0, "ochki");
        cache_delete(result);

        // Обновление текст-драва для очков семьи
        PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
        format(fmt_text, sizeof(fmt_text), "%d", ochki);
        PlayerTextDrawSetString(playerid, zakaz3_PTD[playerid][0], fmt_text);
        PlayerTextDrawShow(playerid, zakaz3_PTD[playerid][0]);
    }
					else
    {
        cache_delete(result);
    }
    
    // Получение очков лидера
    mysql_format(mysql, query, sizeof query, "SELECT ochki FROM family ORDER BY ochki DESC LIMIT 1");
    result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new lider_ochki = cache_get_field_content_int(0, "ochki");
        cache_delete(result);

        // Обновление текст-драва для очков лидера
        TextDrawHideForPlayer(playerid, zakaz3_TD[1]);
        format(fmt_text, sizeof(fmt_text), "%d", lider_ochki);
        TextDrawSetString(zakaz3_TD[1], fmt_text);
        TextDrawShowForPlayer(playerid, zakaz3_TD[1]);
    }
					else
    {
        cache_delete(result);
    }
    }
    }
    }
    forward ZAVODBUSAEVO();
public ZAVODBUSAEVO()
{
for(new i=0;i<MAX_PLAYERS;i++)
{
new playerid=i;
if(GetPVarInt(playerid, "Zavodpva")==1)
{
    new query[128];
    new fmt_text[128];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
    
    // Обновление очков игрока и базы данных
    SetPlayerData(playerid, P_OHZAVOD, GetPlayerData(playerid, P_OHZAVOD) + 1);
    UpdatePlayerDatabaseInt(playerid, "oczav", GetPlayerData(playerid, P_OHZAVOD));
    AddFamilyData(fam_id, F_OCZAVOD, +, 1);
  
  format(fmt_text, sizeof(fmt_text), "UPDATE family SET ochki1=%d WHERE id=%d LIMIT 1", GetFamilyData(fam_id, F_OCZAVOD), fam_id);
    mysql_query(mysql, fmt_text, false);
    
    // Получение очков семьи игрока
    new Cache: result;
    mysql_format(mysql, query, sizeof query, "SELECT ochki1 FROM family WHERE id=%d LIMIT 1", fam_id);
    result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new ochki = cache_get_field_content_int(0, "ochki1");
        cache_delete(result);

        // Обновление текст-драва для очков семьи
        PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
        format(fmt_text, sizeof(fmt_text), "%d", ochki);
        PlayerTextDrawSetString(playerid, zakaz3_PTD[playerid][0], fmt_text);
        PlayerTextDrawShow(playerid, zakaz3_PTD[playerid][0]);
    }
					else
    {
        cache_delete(result);
    }
    
    // Получение очков лидера
    mysql_format(mysql, query, sizeof query, "SELECT ochki1 FROM family ORDER BY ochki1 DESC LIMIT 1");
    result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new lider_ochki = cache_get_field_content_int(0, "ochki1");
        cache_delete(result);

        // Обновление текст-драва для очков лидера
        TextDrawHideForPlayer(playerid, zakaz3_TD[1]);
        format(fmt_text, sizeof(fmt_text), "%d", lider_ochki);
        TextDrawSetString(zakaz3_TD[1], fmt_text);
        TextDrawShowForPlayer(playerid, zakaz3_TD[1]);
    }
					else
    {
        cache_delete(result);
    }
    }
    }
    }
    forward ARZVISHKA();
public ARZVISHKA()
{
for(new i=0;i<MAX_PLAYERS;i++)
{
new playerid=i;
if(GetPVarInt(playerid, "Arzpva")==1)
{
    new query[128];
    new fmt_text[128];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
    
    // Обновление очков игрока и базы данных
    SetPlayerData(playerid, P_OHARZ, GetPlayerData(playerid, P_OHARZ) + 1);
    UpdatePlayerDatabaseInt(playerid, "ocarz", GetPlayerData(playerid, P_OHARZ));
    AddFamilyData(fam_id, F_VISHARZ, +, 1);
  
  format(fmt_text, sizeof(fmt_text), "UPDATE family SET ochki2=%d WHERE id=%d LIMIT 1", GetFamilyData(fam_id, F_VISHARZ), fam_id);
    mysql_query(mysql, fmt_text, false);
    
    // Получение очков семьи игрока
    new Cache: result;
    mysql_format(mysql, query, sizeof query, "SELECT ochki2 FROM family WHERE id=%d LIMIT 1", fam_id);
    result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new ochki = cache_get_field_content_int(0, "ochki2");
        cache_delete(result);

        // Обновление текст-драва для очков семьи
        PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
        format(fmt_text, sizeof(fmt_text), "%d", ochki);
        PlayerTextDrawSetString(playerid, zakaz3_PTD[playerid][0], fmt_text);
        PlayerTextDrawShow(playerid, zakaz3_PTD[playerid][0]);
    }
					else
    {
        cache_delete(result);
    }
    
    // Получение очков лидера
    mysql_format(mysql, query, sizeof query, "SELECT ochki2 FROM family ORDER BY ochki2 DESC LIMIT 1");
    result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new lider_ochki = cache_get_field_content_int(0, "ochki1");
        cache_delete(result);

        // Обновление текст-драва для очков лидера
        TextDrawHideForPlayer(playerid, zakaz3_TD[1]);
        format(fmt_text, sizeof(fmt_text), "%d", lider_ochki);
        TextDrawSetString(zakaz3_TD[1], fmt_text);
        TextDrawShowForPlayer(playerid, zakaz3_TD[1]);
    }
					else
    {
        cache_delete(result);
    }
    }
    }
    }
    forward KARAKVISHKA();
public KARAKVISHKA()
{
for(new i=0;i<MAX_PLAYERS;i++)
{
new playerid=i;
if(GetPVarInt(playerid, "Karakpva")==1)
{
    new query[128];
    new fmt_text[128];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
    
    // Обновление очков игрока и базы данных
    SetPlayerData(playerid, P_OHKAR, GetPlayerData(playerid, P_OHKAR) + 1);
    UpdatePlayerDatabaseInt(playerid, "ockar", GetPlayerData(playerid, P_OHKAR));
    AddFamilyData(fam_id, F_OCKIFARMA, +, 1);
  
  format(fmt_text, sizeof(fmt_text), "UPDATE family SET ochki3=%d WHERE id=%d LIMIT 1", GetFamilyData(fam_id, F_VISHKAR), fam_id);
    mysql_query(mysql, fmt_text, false);
    
    // Получение очков семьи игрока
    new Cache: result;
    mysql_format(mysql, query, sizeof query, "SELECT ochki3 FROM family WHERE id=%d LIMIT 1", fam_id);
    result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new ochki = cache_get_field_content_int(0, "ochki3");
        cache_delete(result);

        // Обновление текст-драва для очков семьи
        PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
        format(fmt_text, sizeof(fmt_text), "%d", ochki);
        PlayerTextDrawSetString(playerid, zakaz3_PTD[playerid][0], fmt_text);
        PlayerTextDrawShow(playerid, zakaz3_PTD[playerid][0]);
    }
					else
    {
        cache_delete(result);
    }
    
    // Получение очков лидера
    mysql_format(mysql, query, sizeof query, "SELECT ochki3 FROM family ORDER BY ochki3 DESC LIMIT 1");
    result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new lider_ochki = cache_get_field_content_int(0, "ochki3");
        cache_delete(result);

        // Обновление текст-драва для очков лидера
        TextDrawHideForPlayer(playerid, zakaz3_TD[1]);
        format(fmt_text, sizeof(fmt_text), "%d", lider_ochki);
        TextDrawSetString(zakaz3_TD[1], fmt_text);
        TextDrawShowForPlayer(playerid, zakaz3_TD[1]);
    }
					else
    {
        cache_delete(result);
    }
    }
    }
    }
    forward GARELVISHKA();
public GARELVISHKA()
{
for(new i=0;i<MAX_PLAYERS;i++)
{
new playerid=i;
if(GetPVarInt(playerid, "Garelpva")==1)
{
    new query[128];
    new fmt_text[128];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
    
    // Обновление очков игрока и базы данных
    SetPlayerData(playerid, P_OHBUS, GetPlayerData(playerid, P_OHBUS) + 1);
    UpdatePlayerDatabaseInt(playerid, "ocbus", GetPlayerData(playerid, P_OHBUS));
    AddFamilyData(fam_id, F_VISBUS, +, 1);
  
  format(fmt_text, sizeof(fmt_text), "UPDATE family SET ochki4=%d WHERE id=%d LIMIT 1", GetFamilyData(fam_id, F_VISBUS), fam_id);
    mysql_query(mysql, fmt_text, false);
    
    // Получение очков семьи игрока
    new Cache: result;
    mysql_format(mysql, query, sizeof query, "SELECT ochki4 FROM family WHERE id=%d LIMIT 1", fam_id);
    result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new ochki = cache_get_field_content_int(0, "ochki4");
        cache_delete(result);

        // Обновление текст-драва для очков семьи
        PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
        format(fmt_text, sizeof(fmt_text), "%d", ochki);
        PlayerTextDrawSetString(playerid, zakaz3_PTD[playerid][0], fmt_text);
        PlayerTextDrawShow(playerid, zakaz3_PTD[playerid][0]);
    }
					else
    {
        cache_delete(result);
    }
    
    // Получение очков лидера
    mysql_format(mysql, query, sizeof query, "SELECT ochki4 FROM family ORDER BY ochki4 DESC LIMIT 1");
    result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new lider_ochki = cache_get_field_content_int(0, "ochki4");
        cache_delete(result);

        // Обновление текст-драва для очков лидера
        TextDrawHideForPlayer(playerid, zakaz3_TD[1]);
        format(fmt_text, sizeof(fmt_text), "%d", lider_ochki);
        TextDrawSetString(zakaz3_TD[1], fmt_text);
        TextDrawShowForPlayer(playerid, zakaz3_TD[1]);
    }
					else
    {
        cache_delete(result);
    }
    }
    }
    }
forward DrugEffectGone(playerid);
public DrugEffectGone(playerid)
{
    new time[3];
    new pogoda;

    gettime(time[0], time[1], time[2]);
    SetPlayerTime(playerid, time[0], time[1]);
    SetPlayerWeather(playerid, pogoda);
    SetPlayerDrunkLevel(playerid, 0);
    return 1;
}

