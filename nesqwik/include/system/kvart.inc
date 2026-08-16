#if defined _apartment_included
    #endinput
#endif
#define _apartment_included

#include <a_samp>

#if !defined INVALID_DYNAMIC_PICKUP_ID
    #define INVALID_DYNAMIC_PICKUP_ID (0)
#endif
#if !defined INVALID_DYNAMIC_MAP_ICON_ID
    #define INVALID_DYNAMIC_MAP_ICON_ID (-1)
#endif

// ==========================================
//  
// ==========================================
new apt_cfg_apt_int = 1;
new apt_cfg_pod_int = 1;
// ==========================================
// ПРОВЕРКА ТАБЛИЦ ПРИ ЗАГРУЗКЕ
// ==========================================
forward CheckAptTables();
public CheckAptTables()
{
    new Cache:res = mysql_query(mysql, "SHOW TABLES LIKE 'podezdy'", true);
    if(cache_num_rows() == 0)
    {
        Apt_CreateTables();
        print("[APT-SYSTEM] Таблицы созданы.");
    }
    cache_delete(res);
    return 1;
}
new Float:apt_cfg_pod_sp_x, Float:apt_cfg_pod_sp_y, Float:apt_cfg_pod_sp_z, Float:apt_cfg_pod_sp_a;
new Float:apt_cfg_pod_el_x, Float:apt_cfg_pod_el_y, Float:apt_cfg_pod_el_z;
new Float:apt_cfg_apt_sp_x, Float:apt_cfg_apt_sp_y, Float:apt_cfg_apt_sp_z, Float:apt_cfg_apt_sp_a;
new Float:apt_cfg_apt_ex_x, Float:apt_cfg_apt_ex_y, Float:apt_cfg_apt_ex_z, Float:apt_cfg_apt_ex_a;
new Float:apt_cfg_armor_x, Float:apt_cfg_armor_y, Float:apt_cfg_armor_z;
new Float:apt_cfg_fridge_x, Float:apt_cfg_fridge_y, Float:apt_cfg_fridge_z;
new Float:apt_cfg_safe_x, Float:apt_cfg_safe_y, Float:apt_cfg_safe_z;
new Float:apt_cfg_medkit_x, Float:apt_cfg_medkit_y, Float:apt_cfg_medkit_z;

#define MAX_APT_POD             200
#define MAX_APT_KVART           1000

// ==========================================
// ID 
// ==========================================
#define D_KVART_MAIN            8800
#define D_KVART_UPGS            8801
#define D_KVART_SAFE            8802
#define D_KVART_SAFE_PUT        8803
#define D_KVART_SAFE_TAKE       8804
#define D_KVART_SELL_GOS        8805
#define D_KVART_BUY             8806
#define D_KVART_OUTSIDE         8812
#define D_POD_ELEVATOR          8814
#define D_KVART_INFO            8817
#define D_KVART_HELP            8820

// ==========================================
//  
// ==========================================
enum E_APT_POD_STRUCT {
    APT_P_SQL_ID,
    APT_P_FLOORS,
    Float:APT_P_POS_X, Float:APT_P_POS_Y, Float:APT_P_POS_Z,
    APT_P_PICKUP,       
    APT_P_ICON,
    Text3D:APT_P_LABEL
};
new apt_Podezd[MAX_APT_POD][E_APT_POD_STRUCT];
new apt_pod_loaded = 0;

enum E_APT_KVART_STRUCT {
    APT_K_SQL_ID,
    APT_K_POD_ID,
    APT_K_FLOOR,       
    APT_K_OWNER_ID,
    APT_K_OWNER_NAME[24],
    APT_K_PRICE,
    APT_K_VW,           
    Float:APT_K_POS_X, Float:APT_K_POS_Y, Float:APT_K_POS_Z,
    Float:APT_K_ENTER_X, Float:APT_K_ENTER_Y, Float:APT_K_ENTER_Z, Float:APT_K_ENTER_A,
    APT_K_LOCKED,
    APT_K_UPG_MEDKIT,
    APT_K_UPG_DOOR,     
    APT_K_UPG_SAFE,
    APT_K_SAFE_MONEY,
    APT_K_UPG_ARMOR,
    APT_K_UPG_FRIDGE,
    APT_K_DOOR_PICKUP,  
    APT_K_EXIT_PICKUP,  
    APT_K_ICON,
    Text3D:APT_K_LABEL,
    APT_K_MEDKIT_PICKUP,
    Text3D:APT_K_MEDKIT_LABEL,
    Text3D:APT_K_ARMOR_LABEL,
    Text3D:APT_K_FRIDGE_LABEL,
    Text3D:APT_K_SAFE_LABEL
};
new apt_Kvartira[MAX_APT_KVART][E_APT_KVART_STRUCT];
new apt_kvart_loaded = 0;

new global_PodExitPickup;
new global_PodElevatorPickup;

// ==========================================
//  
// ==========================================

stock Apt_UnfreezePlayer(playerid) {
    TogglePlayerControllable(playerid, 1);
    return 1;
}

stock Apt_StripNewLine(string[]) {
    new len = strlen(string);
    while (len > 0 && (string[len - 1] == '\r' || string[len - 1] == '\n' || string[len - 1] == ' ')) {
        string[len - 1] = EOS;
        len--;
    }
}

stock Apt_GetPodFloorVW(podid, floor) {
    return 10000 + (podid * 100) + floor;
}

stock Apt_LoadSettings()
{
    new File:cfg = fopen("apt_settings.ini", io_read);
    if(!cfg)
    {
        cfg = fopen("apt_settings.ini", io_write);
        fwrite(cfg, "APT_INT_ID=1\r\n");
        fwrite(cfg, "POD_INT_ID=1\r\n");
        fwrite(cfg, "POD_SPAWN_X=558.452941\r\n");
        fwrite(cfg, "POD_SPAWN_Y=23.897575\r\n");
        fwrite(cfg, "POD_SPAWN_Z=1049.305664\r\n");
        fwrite(cfg, "POD_SPAWN_A=356.682495\r\n");
        fwrite(cfg, "POD_ELEVATOR_X=560.827270\r\n"); 
        fwrite(cfg, "POD_ELEVATOR_Y=22.927341\r\n");
        fwrite(cfg, "POD_ELEVATOR_Z=1049.360351\r\n");
        fwrite(cfg, "APT_SPAWN_X=665.957336\r\n");
        fwrite(cfg, "APT_SPAWN_Y=29.611766\r\n");
        fwrite(cfg, "APT_SPAWN_Z=1024.230957\r\n");
        fwrite(cfg, "APT_SPAWN_A=89.013771\r\n");
        fwrite(cfg, "APT_EXIT_X=667.423400\r\n");
        fwrite(cfg, "APT_EXIT_Y=29.523674\r\n");
        fwrite(cfg, "APT_EXIT_Z=1024.232055\r\n");
        fwrite(cfg, "APT_EXIT_A=89.013771\r\n");
        fwrite(cfg, "APT_ARMOR_X=659.573059\r\n");
        fwrite(cfg, "APT_ARMOR_Y=28.623514\r\n");
        fwrite(cfg, "APT_ARMOR_Z=1024.227539\r\n");
        fwrite(cfg, "APT_SAFE_X=665.781982\r\n");
        fwrite(cfg, "APT_SAFE_Y=28.639144\r\n");
        fwrite(cfg, "APT_SAFE_Z=1024.231811\r\n");
        fwrite(cfg, "APT_MEDKIT_X=662.616271\r\n");
        fwrite(cfg, "APT_MEDKIT_Y=32.097236\r\n");
        fwrite(cfg, "APT_MEDKIT_Z=1024.227539\r\n");
        fwrite(cfg, "APT_FRIDGE_X=659.071411\r\n");
        fwrite(cfg, "APT_FRIDGE_Y=32.500427\r\n");
        fwrite(cfg, "APT_FRIDGE_Z=1024.227539\r\n");
        fclose(cfg);
        
        apt_cfg_apt_int = 1;
        apt_cfg_pod_int = 1;
        apt_cfg_pod_sp_x = 558.452941; apt_cfg_pod_sp_y = 23.897575;
        apt_cfg_pod_sp_z = 1049.305664; apt_cfg_pod_sp_a = 356.682495;
        apt_cfg_pod_el_x = 560.827270; apt_cfg_pod_el_y = 22.927341; apt_cfg_pod_el_z = 1049.360351;
        apt_cfg_apt_sp_x = 665.957336; apt_cfg_apt_sp_y = 29.611766; apt_cfg_apt_sp_z = 1024.230957; apt_cfg_apt_sp_a = 89.013771;
        apt_cfg_apt_ex_x = 667.423400; apt_cfg_apt_ex_y = 29.523674; apt_cfg_apt_ex_z = 1024.232055; apt_cfg_apt_ex_a = 89.013771;
        apt_cfg_armor_x = 659.573059; apt_cfg_armor_y = 28.623514; apt_cfg_armor_z = 1024.227539;
        apt_cfg_safe_x = 665.781982; apt_cfg_safe_y = 28.639144; apt_cfg_safe_z = 1024.231811;
        apt_cfg_medkit_x = 662.616271; apt_cfg_medkit_y = 32.097236; apt_cfg_medkit_z = 1024.227539;
        apt_cfg_fridge_x = 659.071411; apt_cfg_fridge_y = 32.500427; apt_cfg_fridge_z = 1024.227539;
    }
    else
    {
        new str[128], key[32], val[64];
        while(fread(cfg, str))
        {
            new d = strfind(str, "=");
            if(d != -1)
            {
                strmid(key, str, 0, d);
                strmid(val, str, d+1, strlen(str));
                Apt_StripNewLine(key);
                Apt_StripNewLine(val);
                
                if(!strcmp(key, "APT_INT_ID")) apt_cfg_apt_int = strval(val);
                else if(!strcmp(key, "POD_INT_ID")) apt_cfg_pod_int = strval(val);
                else if(!strcmp(key, "POD_SPAWN_X")) apt_cfg_pod_sp_x = floatstr(val);
                else if(!strcmp(key, "POD_SPAWN_Y")) apt_cfg_pod_sp_y = floatstr(val);
                else if(!strcmp(key, "POD_SPAWN_Z")) apt_cfg_pod_sp_z = floatstr(val);
                else if(!strcmp(key, "POD_SPAWN_A")) apt_cfg_pod_sp_a = floatstr(val);
                else if(!strcmp(key, "POD_ELEVATOR_X")) apt_cfg_pod_el_x = floatstr(val);
                else if(!strcmp(key, "POD_ELEVATOR_Y")) apt_cfg_pod_el_y = floatstr(val);
                else if(!strcmp(key, "POD_ELEVATOR_Z")) apt_cfg_pod_el_z = floatstr(val);
                else if(!strcmp(key, "APT_SPAWN_X")) apt_cfg_apt_sp_x = floatstr(val);
                else if(!strcmp(key, "APT_SPAWN_Y")) apt_cfg_apt_sp_y = floatstr(val);
                else if(!strcmp(key, "APT_SPAWN_Z")) apt_cfg_apt_sp_z = floatstr(val);
                else if(!strcmp(key, "APT_SPAWN_A")) apt_cfg_apt_sp_a = floatstr(val);
                else if(!strcmp(key, "APT_EXIT_X")) apt_cfg_apt_ex_x = floatstr(val);
                else if(!strcmp(key, "APT_EXIT_Y")) apt_cfg_apt_ex_y = floatstr(val);
                else if(!strcmp(key, "APT_EXIT_Z")) apt_cfg_apt_ex_z = floatstr(val);
                else if(!strcmp(key, "APT_EXIT_A")) apt_cfg_apt_ex_a = floatstr(val);
                else if(!strcmp(key, "APT_ARMOR_X")) apt_cfg_armor_x = floatstr(val);
                else if(!strcmp(key, "APT_ARMOR_Y")) apt_cfg_armor_y = floatstr(val);
                else if(!strcmp(key, "APT_ARMOR_Z")) apt_cfg_armor_z = floatstr(val);
                else if(!strcmp(key, "APT_SAFE_X")) apt_cfg_safe_x = floatstr(val);
                else if(!strcmp(key, "APT_SAFE_Y")) apt_cfg_safe_y = floatstr(val);
                else if(!strcmp(key, "APT_SAFE_Z")) apt_cfg_safe_z = floatstr(val);
                else if(!strcmp(key, "APT_MEDKIT_X")) apt_cfg_medkit_x = floatstr(val);
                else if(!strcmp(key, "APT_MEDKIT_Y")) apt_cfg_medkit_y = floatstr(val);
                else if(!strcmp(key, "APT_MEDKIT_Z")) apt_cfg_medkit_z = floatstr(val);
                else if(!strcmp(key, "APT_FRIDGE_X")) apt_cfg_fridge_x = floatstr(val);
                else if(!strcmp(key, "APT_FRIDGE_Y")) apt_cfg_fridge_y = floatstr(val);
                else if(!strcmp(key, "APT_FRIDGE_Z")) apt_cfg_fridge_z = floatstr(val);
            }
        }
        fclose(cfg);
        print("[APT-SYSTEM] Файл настроек scriptfiles/apt_settings.ini загружен.");
    }
}

stock Apt_FindPodBySQL(sql_id)
{
    for(new i = 0; i < apt_pod_loaded; i++)
        if(apt_Podezd[i][APT_P_SQL_ID] == sql_id) return i;
    return -1;
}

stock IsKvartiraFree(kvart_id)
{
    if(apt_Kvartira[kvart_id][APT_K_OWNER_ID] != 0) return 0;
    if(strcmp(apt_Kvartira[kvart_id][APT_K_OWNER_NAME], "None", true) != 0) return 0;
    return 1;
}

stock IsKvartiraOwner(playerid, kvart_id)
{
    new pAccID = GetPlayerAccountID(playerid);
    if(pAccID != 0 && apt_Kvartira[kvart_id][APT_K_OWNER_ID] == pAccID) return 1;
    
    new pName[24];
    GetPlayerName(playerid, pName, sizeof(pName));
    if(strcmp(apt_Kvartira[kvart_id][APT_K_OWNER_NAME], "None", true) != 0 && !strcmp(apt_Kvartira[kvart_id][APT_K_OWNER_NAME], pName, true)) return 1;
    
    return 0;
}

stock Apt_GetPlayerOwnedKvartira(playerid)
{
    new pAccID = GetPlayerAccountID(playerid);
    if(pAccID <= 0) return -1;
    for(new i = 0; i < apt_kvart_loaded; i++) {
        if(apt_Kvartira[i][APT_K_OWNER_ID] == pAccID) return i;
    }
    return -1;
}

stock Apt_UpdatePodezdVisuals(id);
stock Apt_UpdateKvartiraVisuals(id);
stock Apt_SaveKvartira(id);

stock Apt_OpenKvartMenu(playerid)
{
    new in_id = GetPVarInt(playerid, "apt_InsideId");
    if(in_id < 0 || in_id >= apt_kvart_loaded)
    {
        new cur_vw = GetPlayerVirtualWorld(playerid);
        if(cur_vw >= 100000) {
            for(new _i = 0; _i < apt_kvart_loaded; _i++) {
                if(apt_Kvartira[_i][APT_K_VW] == cur_vw) {
                    in_id = _i;
                    SetPVarInt(playerid, "apt_InsideId", _i);
                    break;
                }
            }
        }
    }
    if(in_id < 0 || in_id >= apt_kvart_loaded)
        return SendClientMessage(playerid, 0x95A5A6FF, "     .");
        
    if(!IsKvartiraOwner(playerid, in_id))
        return SendClientMessage(playerid, 0xE74C3CFF, "     .");
        
    new str[512];
    format(str, sizeof(str), "{FFFFFF}  \n   \t[%s]\n \n  \n  ",
        (apt_Kvartira[in_id][APT_K_LOCKED] ? "{E74C3C}{FFFFFF}" : "{2ECC71}{FFFFFF}"));
        
    SetPVarInt(playerid, "apt_dialog_active", 1);
    ShowPlayerDialog(playerid, D_KVART_MAIN, DIALOG_STYLE_LIST, "{FF5252} ", str, "", "");
    return 1;
}

stock Apt_CreateTables()
{
    mysql_query(mysql, "CREATE TABLE IF NOT EXISTS `podezdy` (`id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `floors` INT NOT NULL DEFAULT 1, `pos_x` FLOAT NOT NULL DEFAULT 0, `pos_y` FLOAT NOT NULL DEFAULT 0, `pos_z` FLOAT NOT NULL DEFAULT 0, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;", false);
    mysql_query(mysql, "CREATE TABLE IF NOT EXISTS `kvartiry` (`id` INT UNSIGNED NOT NULL AUTO_INCREMENT, `podezd_id` INT UNSIGNED NOT NULL DEFAULT 0, `floor` INT NOT NULL DEFAULT 1, `owner_id` INT UNSIGNED NOT NULL DEFAULT 0, `owner_name` VARCHAR(24) NOT NULL DEFAULT 'None', `price` INT UNSIGNED NOT NULL DEFAULT 10000, `vw` INT UNSIGNED NOT NULL DEFAULT 0, `pos_x` FLOAT NOT NULL DEFAULT 0, `pos_y` FLOAT NOT NULL DEFAULT 0, `pos_z` FLOAT NOT NULL DEFAULT 0, `enter_x` FLOAT NOT NULL DEFAULT 0, `enter_y` FLOAT NOT NULL DEFAULT 0, `enter_z` FLOAT NOT NULL DEFAULT 0, `enter_angle` FLOAT NOT NULL DEFAULT 0, `locked` TINYINT(1) NOT NULL DEFAULT 0, `upg_medkit` TINYINT(1) NOT NULL DEFAULT 0, `upg_door` TINYINT(1) NOT NULL DEFAULT 0, `upg_safe` TINYINT(1) NOT NULL DEFAULT 0, `safe_money` INT UNSIGNED NOT NULL DEFAULT 0, `upg_armor` TINYINT(1) NOT NULL DEFAULT 0, `upg_fridge` TINYINT(1) NOT NULL DEFAULT 0, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;", false);
}

// ==========================================
// HOOK: ON GAMEMODE INIT
// ==========================================
public OnGameModeInit()
{
    print("[APT-SYSTEM]   ...");
    Apt_LoadSettings();
    Apt_CreateTables();
    
    new Cache:res_pod = mysql_query(mysql, "SELECT * FROM `podezdy` ORDER BY `id` ASC", true);
    new rows_pod = cache_num_rows();
    if(rows_pod > MAX_APT_POD) rows_pod = MAX_APT_POD;
    
    for(new i = 0; i < rows_pod; i++)
    {
        apt_Podezd[i][APT_P_SQL_ID] = cache_get_field_content_int(i, "id");
        apt_Podezd[i][APT_P_FLOORS] = cache_get_field_content_int(i, "floors");
        apt_Podezd[i][APT_P_POS_X]  = cache_get_field_content_float(i, "pos_x");
        apt_Podezd[i][APT_P_POS_Y]  = cache_get_field_content_float(i, "pos_y");
        apt_Podezd[i][APT_P_POS_Z]  = cache_get_field_content_float(i, "pos_z");
        
        apt_Podezd[i][APT_P_PICKUP] = 0;
        apt_Podezd[i][APT_P_ICON]   = -1;
        apt_Podezd[i][APT_P_LABEL]  = Text3D:-1;
        
        Apt_UpdatePodezdVisuals(i);
    }
    apt_pod_loaded = rows_pod;
    cache_delete(res_pod);

    global_PodExitPickup = CreateDynamicPickup(1318, 23, apt_cfg_pod_sp_x, apt_cfg_pod_sp_y, apt_cfg_pod_sp_z, -1, apt_cfg_pod_int, -1);
    global_PodElevatorPickup = CreateDynamicPickup(1318, 23, apt_cfg_pod_el_x, apt_cfg_pod_el_y, apt_cfg_pod_el_z, -1, apt_cfg_pod_int, -1);
    
    new Cache:res_kv = mysql_query(mysql, "SELECT * FROM `kvartiry` ORDER BY `id` ASC", true);
    new rows_kv = cache_num_rows();
    if(rows_kv > MAX_APT_KVART) rows_kv = MAX_APT_KVART;
    
    for(new i = 0; i < rows_kv; i++)
    {
        apt_Kvartira[i][APT_K_SQL_ID]    = cache_get_field_content_int(i, "id");
        apt_Kvartira[i][APT_K_POD_ID]    = cache_get_field_content_int(i, "podezd_id");
        apt_Kvartira[i][APT_K_FLOOR]     = cache_get_field_content_int(i, "floor");
        
        if(apt_Kvartira[i][APT_K_FLOOR] < 1) apt_Kvartira[i][APT_K_FLOOR] = 1;

        apt_Kvartira[i][APT_K_OWNER_ID]  = cache_get_field_content_int(i, "owner_id");
        cache_get_field_content(i, "owner_name", apt_Kvartira[i][APT_K_OWNER_NAME], mysql, 24);
        apt_Kvartira[i][APT_K_PRICE]     = cache_get_field_content_int(i, "price");
        
        apt_Kvartira[i][APT_K_VW]        = 100000 + apt_Kvartira[i][APT_K_SQL_ID];
        
        new fix_query[128];
        format(fix_query, sizeof(fix_query), "UPDATE `kvartiry` SET `vw` = %d WHERE `id` = %d", apt_Kvartira[i][APT_K_VW], apt_Kvartira[i][APT_K_SQL_ID]);
        mysql_query(mysql, fix_query, false);
        
        apt_Kvartira[i][APT_K_POS_X]     = cache_get_field_content_float(i, "pos_x");
        apt_Kvartira[i][APT_K_POS_Y]     = cache_get_field_content_float(i, "pos_y");
        apt_Kvartira[i][APT_K_POS_Z]     = cache_get_field_content_float(i, "pos_z");
        apt_Kvartira[i][APT_K_ENTER_X]   = cache_get_field_content_float(i, "enter_x");
        apt_Kvartira[i][APT_K_ENTER_Y]   = cache_get_field_content_float(i, "enter_y");
        apt_Kvartira[i][APT_K_ENTER_Z]   = cache_get_field_content_float(i, "enter_z");
        apt_Kvartira[i][APT_K_ENTER_A]   = cache_get_field_content_float(i, "enter_angle");
        apt_Kvartira[i][APT_K_LOCKED]    = cache_get_field_content_int(i, "locked");
        apt_Kvartira[i][APT_K_UPG_MEDKIT]= cache_get_field_content_int(i, "upg_medkit");
        apt_Kvartira[i][APT_K_UPG_DOOR]  = cache_get_field_content_int(i, "upg_door");
        apt_Kvartira[i][APT_K_UPG_SAFE]  = cache_get_field_content_int(i, "upg_safe");
        apt_Kvartira[i][APT_K_SAFE_MONEY]= cache_get_field_content_int(i, "safe_money");
        apt_Kvartira[i][APT_K_UPG_ARMOR] = cache_get_field_content_int(i, "upg_armor");
        apt_Kvartira[i][APT_K_UPG_FRIDGE]= cache_get_field_content_int(i, "upg_fridge");
        
        apt_Kvartira[i][APT_K_DOOR_PICKUP]   = 0;
        apt_Kvartira[i][APT_K_EXIT_PICKUP]   = 0;
        apt_Kvartira[i][APT_K_ICON]          = -1;
        apt_Kvartira[i][APT_K_LABEL]         = Text3D:-1;
        apt_Kvartira[i][APT_K_MEDKIT_PICKUP] = 0;
        apt_Kvartira[i][APT_K_MEDKIT_LABEL]  = Text3D:-1;
        apt_Kvartira[i][APT_K_ARMOR_LABEL]   = Text3D:-1;
        apt_Kvartira[i][APT_K_FRIDGE_LABEL]  = Text3D:-1;
        apt_Kvartira[i][APT_K_SAFE_LABEL]    = Text3D:-1;

        Apt_UpdateKvartiraVisuals(i);
    }
    apt_kvart_loaded = rows_kv;
    cache_delete(res_kv);
    print("[APT-SYSTEM]    .");
    
    #if defined apt_OnGameModeInit
        return apt_OnGameModeInit();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit apt_OnGameModeInit
#if defined apt_OnGameModeInit
    forward apt_OnGameModeInit();
#endif

// ==========================================
//  
// ==========================================

stock Apt_UpdatePodezdVisuals(id)
{
    if(apt_Podezd[id][APT_P_PICKUP] != 0) { DestroyDynamicPickup(apt_Podezd[id][APT_P_PICKUP]); apt_Podezd[id][APT_P_PICKUP] = 0; }
    if(apt_Podezd[id][APT_P_ICON] != -1) { DestroyDynamicMapIcon(apt_Podezd[id][APT_P_ICON]); apt_Podezd[id][APT_P_ICON] = -1; }
    if(apt_Podezd[id][APT_P_LABEL] != Text3D:-1) { DestroyDynamic3DTextLabel(apt_Podezd[id][APT_P_LABEL]); apt_Podezd[id][APT_P_LABEL] = Text3D:-1; }
    
    new text[128];
    format(text, sizeof(text), "{FF5252} %d\n{FFFFFF} : %d", apt_Podezd[id][APT_P_SQL_ID], apt_Podezd[id][APT_P_FLOORS]);
    
    apt_Podezd[id][APT_P_PICKUP] = CreateDynamicPickup(1318, 23, apt_Podezd[id][APT_P_POS_X], apt_Podezd[id][APT_P_POS_Y], apt_Podezd[id][APT_P_POS_Z], 0, 0, -1);
    apt_Podezd[id][APT_P_ICON] = CreateDynamicMapIcon(apt_Podezd[id][APT_P_POS_X], apt_Podezd[id][APT_P_POS_Y], apt_Podezd[id][APT_P_POS_Z], 31, 0, 0, 0, -1, 100.0);
    apt_Podezd[id][APT_P_LABEL] = CreateDynamic3DTextLabel(text, 0xFFFFFFFF, apt_Podezd[id][APT_P_POS_X], apt_Podezd[id][APT_P_POS_Y], apt_Podezd[id][APT_P_POS_Z] + 1.0, 15.0, 0xFFFF, 0xFFFF, 0, 0, 0);
}

stock Apt_UpdateKvartiraVisuals(id)
{
    if(apt_Kvartira[id][APT_K_DOOR_PICKUP] != 0) { DestroyDynamicPickup(apt_Kvartira[id][APT_K_DOOR_PICKUP]); apt_Kvartira[id][APT_K_DOOR_PICKUP] = 0; }
    if(apt_Kvartira[id][APT_K_EXIT_PICKUP] != 0) { DestroyDynamicPickup(apt_Kvartira[id][APT_K_EXIT_PICKUP]); apt_Kvartira[id][APT_K_EXIT_PICKUP] = 0; }
    if(apt_Kvartira[id][APT_K_ICON] != -1) { DestroyDynamicMapIcon(apt_Kvartira[id][APT_K_ICON]); apt_Kvartira[id][APT_K_ICON] = -1; }
    if(apt_Kvartira[id][APT_K_LABEL] != Text3D:-1) { DestroyDynamic3DTextLabel(apt_Kvartira[id][APT_K_LABEL]); apt_Kvartira[id][APT_K_LABEL] = Text3D:-1; }

    if(apt_Kvartira[id][APT_K_MEDKIT_PICKUP] != 0) { DestroyDynamicPickup(apt_Kvartira[id][APT_K_MEDKIT_PICKUP]); apt_Kvartira[id][APT_K_MEDKIT_PICKUP] = 0; }
    if(apt_Kvartira[id][APT_K_MEDKIT_LABEL] != Text3D:-1) { DestroyDynamic3DTextLabel(apt_Kvartira[id][APT_K_MEDKIT_LABEL]); apt_Kvartira[id][APT_K_MEDKIT_LABEL] = Text3D:-1; }
    if(apt_Kvartira[id][APT_K_ARMOR_LABEL] != Text3D:-1) { DestroyDynamic3DTextLabel(apt_Kvartira[id][APT_K_ARMOR_LABEL]); apt_Kvartira[id][APT_K_ARMOR_LABEL] = Text3D:-1; }
    if(apt_Kvartira[id][APT_K_FRIDGE_LABEL] != Text3D:-1) { DestroyDynamic3DTextLabel(apt_Kvartira[id][APT_K_FRIDGE_LABEL]); apt_Kvartira[id][APT_K_FRIDGE_LABEL] = Text3D:-1; }
    if(apt_Kvartira[id][APT_K_SAFE_LABEL] != Text3D:-1) { DestroyDynamic3DTextLabel(apt_Kvartira[id][APT_K_SAFE_LABEL]); apt_Kvartira[id][APT_K_SAFE_LABEL] = Text3D:-1; }

    new pod_floor_vw = Apt_GetPodFloorVW(apt_Kvartira[id][APT_K_POD_ID], apt_Kvartira[id][APT_K_FLOOR]);
    new vw = apt_Kvartira[id][APT_K_VW];
    new pickup_model, text[256];
    
    if(!IsKvartiraFree(id))
    {
        pickup_model = 1272;
        format(text, sizeof(text), "{FF5252} %d\n{FFFFFF}: {FF5252}%s", 
            apt_Kvartira[id][APT_K_SQL_ID], 
            apt_Kvartira[id][APT_K_OWNER_NAME]);
            
        if(apt_Kvartira[id][APT_K_UPG_MEDKIT]) {
            apt_Kvartira[id][APT_K_MEDKIT_PICKUP] = CreateDynamicPickup(1240, 23, apt_cfg_medkit_x, apt_cfg_medkit_y, apt_cfg_medkit_z, vw, apt_cfg_apt_int, -1);
            apt_Kvartira[id][APT_K_MEDKIT_LABEL] = CreateDynamic3DTextLabel("{2ECC71} {FFFFFF}\n  ", 0xFFFFFFFF, apt_cfg_medkit_x, apt_cfg_medkit_y, apt_cfg_medkit_z + 0.5, 5.0, 0xFFFF, 0xFFFF, 0, vw, apt_cfg_apt_int);
        }
        if(apt_Kvartira[id][APT_K_UPG_ARMOR]) {
            apt_Kvartira[id][APT_K_ARMOR_LABEL] = CreateDynamic3DTextLabel("{FF5252}  {FFFFFF}\n: {FF5252}/claimbron", 0xFFFFFFFF, apt_cfg_armor_x, apt_cfg_armor_y, apt_cfg_armor_z + 0.5, 5.0, 0xFFFF, 0xFFFF, 0, vw, apt_cfg_apt_int);
        }
        if(apt_Kvartira[id][APT_K_UPG_FRIDGE]) {
            apt_Kvartira[id][APT_K_FRIDGE_LABEL] = CreateDynamic3DTextLabel("{FF5252}{FFFFFF}\n: {FF5252}/eathol", 0xFFFFFFFF, apt_cfg_fridge_x, apt_cfg_fridge_y, apt_cfg_fridge_z + 0.5, 5.0, 0xFFFF, 0xFFFF, 0, vw, apt_cfg_apt_int);
        }
        if(apt_Kvartira[id][APT_K_UPG_SAFE]) {
            new safe_str[128];
            format(safe_str, sizeof(safe_str), "{FF5252} {FFFFFF}\n: {2ECC71}%d .{FFFFFF}\n: {FF5252}/seifkv", apt_Kvartira[id][APT_K_SAFE_MONEY]);
            apt_Kvartira[id][APT_K_SAFE_LABEL] = CreateDynamic3DTextLabel(safe_str, 0xFFFFFFFF, apt_cfg_safe_x, apt_cfg_safe_y, apt_cfg_safe_z + 0.5, 5.0, 0xFFFF, 0xFFFF, 0, vw, apt_cfg_apt_int);
        }
    }
    else
    {
        pickup_model = 1273;
        format(text, sizeof(text), "{2ECC71} %d\n{FFFFFF}: {2ECC71}\n{FFFFFF}: {2ECC71}%d .", apt_Kvartira[id][APT_K_SQL_ID], apt_Kvartira[id][APT_K_PRICE]);
    }

    apt_Kvartira[id][APT_K_DOOR_PICKUP] = CreateDynamicPickup(pickup_model, 23, apt_Kvartira[id][APT_K_POS_X], apt_Kvartira[id][APT_K_POS_Y], apt_Kvartira[id][APT_K_POS_Z], pod_floor_vw, apt_cfg_pod_int, -1);
    apt_Kvartira[id][APT_K_ICON] = CreateDynamicMapIcon(apt_Kvartira[id][APT_K_POS_X], apt_Kvartira[id][APT_K_POS_Y], apt_Kvartira[id][APT_K_POS_Z], (pickup_model == 1272 ? 32 : 31), 0, pod_floor_vw, apt_cfg_pod_int, -1, 100.0);
    apt_Kvartira[id][APT_K_LABEL] = CreateDynamic3DTextLabel(text, 0xFFFFFFFF, apt_Kvartira[id][APT_K_POS_X], apt_Kvartira[id][APT_K_POS_Y], apt_Kvartira[id][APT_K_POS_Z] + 0.8, 10.0, 0xFFFF, 0xFFFF, 0, pod_floor_vw, apt_cfg_pod_int);
    apt_Kvartira[id][APT_K_EXIT_PICKUP] = CreateDynamicPickup(1318, 23, apt_cfg_apt_ex_x, apt_cfg_apt_ex_y, apt_cfg_apt_ex_z, vw, apt_cfg_apt_int, -1);
}

stock Apt_SaveKvartira(id)
{
    new query[600], esc_name[49];
    mysql_real_escape_string(apt_Kvartira[id][APT_K_OWNER_NAME], esc_name, mysql);
    format(query, sizeof(query), "UPDATE `kvartiry` SET `owner_id`=%d, `owner_name`='%s', `locked`=%d, `upg_medkit`=%d, `upg_door`=%d, `upg_safe`=%d, `safe_money`=%d, `upg_armor`=%d, `upg_fridge`=%d WHERE `id`=%d",
        apt_Kvartira[id][APT_K_OWNER_ID],  esc_name,
        apt_Kvartira[id][APT_K_LOCKED],
        apt_Kvartira[id][APT_K_UPG_MEDKIT], apt_Kvartira[id][APT_K_UPG_DOOR],
        apt_Kvartira[id][APT_K_UPG_SAFE],   apt_Kvartira[id][APT_K_SAFE_MONEY],
        apt_Kvartira[id][APT_K_UPG_ARMOR],  apt_Kvartira[id][APT_K_UPG_FRIDGE],
        apt_Kvartira[id][APT_K_SQL_ID]);
    mysql_query(mysql, query, false);
}

// ==========================================
// HOOK: ON PLAYER CONNECT/DISCONNECT
// ==========================================
public OnPlayerConnect(playerid)
{
    SetPVarInt(playerid, "apt_InsideId",  -1);
    SetPVarInt(playerid, "apt_OutsideId", -1);
    SetPVarInt(playerid, "apt_dialog_active", 0);
    SetPVarInt(playerid, "apt_armor_cd", 0);
    SetPVarInt(playerid, "apt_fridge_cd", 0);
    
    #if defined apt_OnPlayerConnect
        return apt_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect apt_OnPlayerConnect
#if defined apt_OnPlayerConnect
    forward apt_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    DeletePVar(playerid, "apt_InsideId");
    DeletePVar(playerid, "apt_OutsideId");
    DeletePVar(playerid, "apt_PodElevator");
    DeletePVar(playerid, "apt_pickup_tick");
    DeletePVar(playerid, "apt_armor_cd");
    DeletePVar(playerid, "apt_fridge_cd");
    DeletePVar(playerid, "apt_dialog_active");
    
    #if defined apt_OnPlayerDisconnect
        return apt_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect apt_OnPlayerDisconnect
#if defined apt_OnPlayerDisconnect
    forward apt_OnPlayerDisconnect(playerid, reason);
#endif

// ==========================================
// HOOK: ON PLAYER PICKUP PICKUP
// ==========================================
public OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id)
{
    if(GetPVarInt(playerid, "apt_dialog_active") == 1) return 0;
    if(GetTickCount() - GetPVarInt(playerid, "apt_pickup_tick") < 2000) return 0;
    
    new inside_id = GetPVarInt(playerid, "apt_InsideId");
    if(inside_id >= 0 && inside_id < apt_kvart_loaded)
    {
        if(apt_Kvartira[inside_id][APT_K_MEDKIT_PICKUP] != 0 && pickupid == apt_Kvartira[inside_id][APT_K_MEDKIT_PICKUP])
        {
            SetPVarInt(playerid, "apt_pickup_tick", GetTickCount());
            SetPlayerHealth(playerid, 100.0);
            SendClientMessage(playerid, 0x2ECC71FF, "  .   .");
            return 1;
        }
    }

    for(new i = 0; i < apt_pod_loaded; i++)
    {
        if(apt_Podezd[i][APT_P_PICKUP] != 0 && pickupid == apt_Podezd[i][APT_P_PICKUP])
        {
            if(GetPlayerVirtualWorld(playerid) != 0) continue;
            
            SetPVarInt(playerid, "apt_pickup_tick", GetTickCount() + 3000);
            new floor_vw = Apt_GetPodFloorVW(apt_Podezd[i][APT_P_SQL_ID], 1);
            SetPlayerVirtualWorld(playerid, floor_vw);
            SetPlayerInterior(playerid, apt_cfg_pod_int);
            TogglePlayerControllable(playerid, 0);
            SetPlayerPos(playerid, apt_cfg_pod_sp_x, apt_cfg_pod_sp_y, apt_cfg_pod_sp_z);
            SetPlayerFacingAngle(playerid, apt_cfg_pod_sp_a);
            SetTimerEx("Apt_UnfreezePlayer", 1500, false, "i", playerid);
            SetCameraBehindPlayer(playerid);
            return 1;
        }
    }

    if(pickupid != 0 && pickupid == global_PodExitPickup)
    {
        new vw = GetPlayerVirtualWorld(playerid);
        if(vw >= 10000 && vw < 100000)
        {
            new pod_sql_id = (vw - 10000) / 100;
            new pod_idx = Apt_FindPodBySQL(pod_sql_id);
            if(pod_idx != -1)
            {
                SetPVarInt(playerid, "apt_pickup_tick", GetTickCount());
                SetPlayerVirtualWorld(playerid, 0);
                SetPlayerInterior(playerid, 0);
                SetPlayerPos(playerid, apt_Podezd[pod_idx][APT_P_POS_X], apt_Podezd[pod_idx][APT_P_POS_Y], apt_Podezd[pod_idx][APT_P_POS_Z]);
                return 1;
            }
        }
    }

    if(pickupid != 0 && pickupid == global_PodElevatorPickup)
    {
        new vw = GetPlayerVirtualWorld(playerid);
        if(vw >= 10000 && vw < 100000)
        {
            new pod_sql_id = (vw - 10000) / 100;
            new pod_idx = Apt_FindPodBySQL(pod_sql_id);
            if(pod_idx != -1)
            {
                SetPVarInt(playerid, "apt_pickup_tick", GetTickCount());
                if(apt_Podezd[pod_idx][APT_P_FLOORS] <= 1)
                {
                    SendClientMessage(playerid, 0x95A5A6FF, "    1 .");
                    return 1;
                }
                SetPVarInt(playerid, "apt_PodElevator", pod_idx);
                new str[512], tmp[32];
                str[0] = EOS;
                for(new f = 1; f <= apt_Podezd[pod_idx][APT_P_FLOORS]; f++) {
                    format(tmp, sizeof(tmp), " %d\n", f);
                    strcat(str, tmp);
                }
                SetPVarInt(playerid, "apt_dialog_active", 1);
                ShowPlayerDialog(playerid, D_POD_ELEVATOR, DIALOG_STYLE_LIST, "{FF5252} ", str, "", "");
                return 1;
            }
        }
    }

    for(new i = 0; i < apt_kvart_loaded; i++)
    {
        if(apt_Kvartira[i][APT_K_DOOR_PICKUP] != 0 && pickupid == apt_Kvartira[i][APT_K_DOOR_PICKUP])
        {
            new req_vw = Apt_GetPodFloorVW(apt_Kvartira[i][APT_K_POD_ID], apt_Kvartira[i][APT_K_FLOOR]);
            if(GetPlayerVirtualWorld(playerid) != req_vw) continue;
            
            SetPVarInt(playerid, "apt_pickup_tick", GetTickCount());
            SetPVarInt(playerid, "apt_OutsideId", i);
            SetPVarInt(playerid, "apt_dialog_active", 1);
            
            if(IsKvartiraFree(i))
            {
                new str[256];
                format(str, sizeof(str), "{FFFFFF} %d  .\n\n : {2ECC71}%d .{FFFFFF}\n   ?", apt_Kvartira[i][APT_K_SQL_ID], apt_Kvartira[i][APT_K_PRICE]);
                ShowPlayerDialog(playerid, D_KVART_BUY, DIALOG_STYLE_MSGBOX, "{FF5252} ", str, "", "");
            }
            else
            {
                new is_owner = IsKvartiraOwner(playerid, i);
                new str[256], title[96];
                format(title, sizeof(title), "{FF5252}  %d", apt_Kvartira[i][APT_K_SQL_ID]);
                format(str, sizeof(str), " ");
                if(is_owner)
                    format(str, sizeof(str), "%s\n%s ", str, (apt_Kvartira[i][APT_K_LOCKED] ? "" : ""));
                ShowPlayerDialog(playerid, D_KVART_OUTSIDE, DIALOG_STYLE_LIST, title, str, "", "");
            }
            return 1;
        }

        if(apt_Kvartira[i][APT_K_EXIT_PICKUP] != 0 && pickupid == apt_Kvartira[i][APT_K_EXIT_PICKUP])
        {
            if(GetPlayerVirtualWorld(playerid) != apt_Kvartira[i][APT_K_VW]) continue;
            
            SetPVarInt(playerid, "apt_pickup_tick", GetTickCount());
            new pod_floor_vw = Apt_GetPodFloorVW(apt_Kvartira[i][APT_K_POD_ID], apt_Kvartira[i][APT_K_FLOOR]);
            
            SetPlayerVirtualWorld(playerid, pod_floor_vw);
            SetPlayerInterior(playerid, apt_cfg_pod_int);
            TogglePlayerControllable(playerid, 0);
            SetPlayerPos(playerid, apt_Kvartira[i][APT_K_POS_X], apt_Kvartira[i][APT_K_POS_Y], apt_Kvartira[i][APT_K_POS_Z]);
            SetTimerEx("Apt_UnfreezePlayer", 1500, false, "i", playerid);
            SetCameraBehindPlayer(playerid);
            
            SetPVarInt(playerid, "apt_InsideId", -1);
            return 1;
        }
    }
    return 0;
}

// ==========================================
// HOOK: ON DIALOG RESPONSE
// ==========================================
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == D_POD_ELEVATOR || dialogid == D_KVART_BUY || dialogid == D_KVART_OUTSIDE || 
       dialogid == D_KVART_MAIN || dialogid == D_KVART_UPGS || dialogid == D_KVART_SAFE || 
       dialogid == D_KVART_SAFE_PUT || dialogid == D_KVART_SAFE_TAKE || dialogid == D_KVART_SELL_GOS || 
       dialogid == D_KVART_INFO || dialogid == D_KVART_HELP) 
    {
        DeletePVar(playerid, "apt_dialog_active");
    }
    else return 0;

    if(dialogid == D_POD_ELEVATOR)
    {
        if(!response) { DeletePVar(playerid, "apt_PodElevator"); return 1; }
        
        new pod_i = GetPVarInt(playerid, "apt_PodElevator");
        DeletePVar(playerid, "apt_PodElevator");
        
        if(pod_i < 0 || pod_i >= apt_pod_loaded) return 1;
        
        new floor = listitem + 1;
        if(floor < 1 || floor > apt_Podezd[pod_i][APT_P_FLOORS]) return 1; 

        new msg[64];
        format(msg, sizeof(msg), "*    %d .", floor);
        SendClientMessage(playerid, 0x2ECC71FF, msg);
        
        new floor_vw = Apt_GetPodFloorVW(apt_Podezd[pod_i][APT_P_SQL_ID], floor);
        SetPVarInt(playerid, "apt_pickup_tick", GetTickCount() + 3000);
        
        TogglePlayerControllable(playerid, 0);
        SetPlayerVirtualWorld(playerid, floor_vw);
        SetPlayerPos(playerid, apt_cfg_pod_el_x + 1.0, apt_cfg_pod_el_y, apt_cfg_pod_el_z);
        SetTimerEx("Apt_UnfreezePlayer", 1500, false, "i", playerid);
        SetCameraBehindPlayer(playerid);
        return 1;
    }

    if(dialogid == D_KVART_BUY)
    {
        if(!response) { DeletePVar(playerid, "apt_OutsideId"); return 1; }
        
        new i = GetPVarInt(playerid, "apt_OutsideId");
        if(i < 0 || i >= apt_kvart_loaded || !IsKvartiraFree(i)) 
            return SendClientMessage(playerid, 0xE74C3CFF, "    .");
            
        if(Apt_GetPlayerOwnedKvartira(playerid) != -1)
            return SendClientMessage(playerid, 0xE74C3CFF, "   .");
            
        if(GetPlayerMoneyEx(playerid) < apt_Kvartira[i][APT_K_PRICE])
            return SendClientMessage(playerid, 0xE74C3CFF, "   .");
            
        GivePlayerMoneyEx(playerid, -apt_Kvartira[i][APT_K_PRICE], " ", true, true);
        
        apt_Kvartira[i][APT_K_OWNER_ID] = GetPlayerAccountID(playerid);
        GetPlayerName(playerid, apt_Kvartira[i][APT_K_OWNER_NAME], 24);
        
        Apt_SaveKvartira(i);
        Apt_UpdateKvartiraVisuals(i);
        
        SetPVarInt(playerid, "apt_pickup_tick", GetTickCount());
        SendClientMessage(playerid, 0x2ECC71FF, "!    .");
        DeletePVar(playerid, "apt_OutsideId");
        return 1;
    }

    if(dialogid == D_KVART_OUTSIDE)
    {
        if(!response) { DeletePVar(playerid, "apt_OutsideId"); return 1; }
        
        new i = GetPVarInt(playerid, "apt_OutsideId");
        if(i < 0 || i >= apt_kvart_loaded) return 1;
        
        new is_owner = IsKvartiraOwner(playerid, i);
        if(listitem == 0) 
        {
            if(apt_Kvartira[i][APT_K_LOCKED] && !is_owner) return SendClientMessage(playerid, 0xE74C3CFF, " .");
            
            SetPVarInt(playerid, "apt_pickup_tick", GetTickCount());
            SetPlayerVirtualWorld(playerid, apt_Kvartira[i][APT_K_VW]);
            SetPlayerInterior(playerid, apt_cfg_apt_int);
            TogglePlayerControllable(playerid, 0);
            SetPlayerPosEx(playerid, apt_Kvartira[i][APT_K_ENTER_X], apt_Kvartira[i][APT_K_ENTER_Y], apt_Kvartira[i][APT_K_ENTER_Z], apt_Kvartira[i][APT_K_ENTER_A], apt_cfg_apt_int, apt_Kvartira[i][APT_K_VW]);
            SetTimerEx("Apt_UnfreezePlayer", 1500, false, "i", playerid);
            SetCameraBehindPlayer(playerid);
            
            SetPVarInt(playerid, "apt_InsideId", i);
            DeletePVar(playerid, "apt_OutsideId");
            return 1;
        }
        if(listitem == 1 && is_owner) 
        {
            apt_Kvartira[i][APT_K_LOCKED] ^= 1;
            Apt_SaveKvartira(i);
            Apt_UpdateKvartiraVisuals(i);
            SetPVarInt(playerid, "apt_pickup_tick", GetTickCount()); 
            SendClientMessage(playerid, 0x2ECC71FF, apt_Kvartira[i][APT_K_LOCKED] ? "   ." : "   .");
            DeletePVar(playerid, "apt_OutsideId");
            return 1;
        }
        return 1;
    }

    if(dialogid == D_KVART_MAIN)
    {
        if(!response) return 1;
        new in_id = GetPVarInt(playerid, "apt_InsideId");
        if(in_id < 0 || in_id >= apt_kvart_loaded) return 1;
        
        switch(listitem)
        {
            case 0: 
            {
                new str[700];
                format(str, sizeof(str), "{FFFFFF} :\t\t{FF5252}#%d\n{FFFFFF}:\t\t{FF5252}%s\n{FFFFFF} :\t\t%s\n\n{FFB732}»  :\n",
                    apt_Kvartira[in_id][APT_K_SQL_ID], apt_Kvartira[in_id][APT_K_OWNER_NAME],
                    (apt_Kvartira[in_id][APT_K_LOCKED] ? "{E74C3C}" : "{2ECC71}"));
                format(str, sizeof(str), "%s{FFFFFF}:\t\t\t%s\n{FFFFFF}-:\t\t%s\n{FFFFFF}:\t\t\t%s\n{FFFFFF} :\t%s\n{FFFFFF}:\t\t%s\n\n",
                    str,
                    (apt_Kvartira[in_id][APT_K_UPG_MEDKIT] ? "{2ECC71}" : "{95A5A6}"), 
                    (apt_Kvartira[in_id][APT_K_UPG_DOOR] ? "{2ECC71}" : "{95A5A6}"),
                    (apt_Kvartira[in_id][APT_K_UPG_SAFE] ? "{2ECC71}" : "{95A5A6}"), 
                    (apt_Kvartira[in_id][APT_K_UPG_ARMOR] ? "{2ECC71}" : "{95A5A6}"),
                    (apt_Kvartira[in_id][APT_K_UPG_FRIDGE] ? "{2ECC71}" : "{95A5A6}"));
                format(str, sizeof(str), "%s{FFB732}»  :\n{FFFFFF}. :\t\t{2ECC71}%d .\n{FFFFFF} :\t\t{2ECC71}%d .",
                    str, apt_Kvartira[in_id][APT_K_PRICE], apt_Kvartira[in_id][APT_K_SAFE_MONEY]);
                SetPVarInt(playerid, "apt_dialog_active", 1);
                ShowPlayerDialog(playerid, D_KVART_INFO, DIALOG_STYLE_MSGBOX, "{FF5252}  ", str, "", "");
            }
            case 1: 
            {
                apt_Kvartira[in_id][APT_K_LOCKED] ^= 1;
                Apt_SaveKvartira(in_id);
                Apt_UpdateKvartiraVisuals(in_id);
                SendClientMessage(playerid, 0x2ECC71FF, apt_Kvartira[in_id][APT_K_LOCKED] ? "  ." : "  .");
                Apt_OpenKvartMenu(playerid);
            }
            case 2: 
            {
                if(!apt_Kvartira[in_id][APT_K_UPG_SAFE]) return SendClientMessage(playerid, 0xE74C3CFF, "    ."), Apt_OpenKvartMenu(playerid);
                new str[128];
                format(str, sizeof(str), "{FFFFFF}  : {2ECC71}%d .{FFFFFF}\n\n \n ", apt_Kvartira[in_id][APT_K_SAFE_MONEY]);
                SetPVarInt(playerid, "apt_dialog_active", 1);
                ShowPlayerDialog(playerid, D_KVART_SAFE, DIALOG_STYLE_LIST, "{FF5252} ", str, "", "");
            }
            case 3:
            {
                new str[700];
                format(str, sizeof(str), "{FFFFFF} \t\t\t%s\n{FFFFFF} \t\t%s\n{FFFFFF} \t\t\t%s\n{FFFFFF}  \t\t%s\n{FFFFFF} \t\t%s",
                    (apt_Kvartira[in_id][APT_K_UPG_MEDKIT] ? "{2ECC71}" : "{FF5252}5.000 ."),
                    (apt_Kvartira[in_id][APT_K_UPG_DOOR] ? "{2ECC71}" : "{FF5252}15.000 ."),
                    (apt_Kvartira[in_id][APT_K_UPG_SAFE] ? "{2ECC71}" : "{FF5252}50.000 ."),
                    (apt_Kvartira[in_id][APT_K_UPG_ARMOR] ? "{2ECC71}" : "{FF5252}35.000 ."),
                    (apt_Kvartira[in_id][APT_K_UPG_FRIDGE] ? "{2ECC71}" : "{FF5252}25.000 ."));
                SetPVarInt(playerid, "apt_dialog_active", 1);
                ShowPlayerDialog(playerid, D_KVART_UPGS, DIALOG_STYLE_LIST, "{FF5252}  ", str, "", "");
            }
            case 4:
            {
                new sell_price = apt_Kvartira[in_id][APT_K_PRICE] / 2;
                new str[256];
                format(str, sizeof(str), "{FFFFFF}      ?\n\n  (50%%): {2ECC71}%d .{FFFFFF}\n\n   !", sell_price);
                SetPVarInt(playerid, "apt_dialog_active", 1);
                ShowPlayerDialog(playerid, D_KVART_SELL_GOS, DIALOG_STYLE_MSGBOX, "{E74C3C} ", str, "", "");
            }
        }
        return 1;
    }

    if(dialogid == D_KVART_SELL_GOS)
    {
        if(!response) return Apt_OpenKvartMenu(playerid);
        new in_id = GetPVarInt(playerid, "apt_InsideId");
        if(in_id < 0 || in_id >= apt_kvart_loaded) return 1;
        if(!IsKvartiraOwner(playerid, in_id)) return 1;
        
        new sell_price = apt_Kvartira[in_id][APT_K_PRICE] / 2;
        GivePlayerMoneyEx(playerid, sell_price, "  ", true, true);

        apt_Kvartira[in_id][APT_K_OWNER_ID] = 0;
        format(apt_Kvartira[in_id][APT_K_OWNER_NAME], 24, "None");
        apt_Kvartira[in_id][APT_K_LOCKED] = 0;
        apt_Kvartira[in_id][APT_K_UPG_MEDKIT] = 0;
        apt_Kvartira[in_id][APT_K_UPG_DOOR] = 0;
        apt_Kvartira[in_id][APT_K_UPG_SAFE] = 0;
        apt_Kvartira[in_id][APT_K_SAFE_MONEY] = 0;
        apt_Kvartira[in_id][APT_K_UPG_ARMOR] = 0;
        apt_Kvartira[in_id][APT_K_UPG_FRIDGE] = 0;

        Apt_SaveKvartira(in_id);
        Apt_UpdateKvartiraVisuals(in_id);
        
        SendClientMessage(playerid, 0x2ECC71FF, "     .");

        new pod_floor_vw = Apt_GetPodFloorVW(apt_Kvartira[in_id][APT_K_POD_ID], apt_Kvartira[in_id][APT_K_FLOOR]);
        SetPlayerVirtualWorld(playerid, pod_floor_vw);
        SetPlayerInterior(playerid, apt_cfg_pod_int);
        
        TogglePlayerControllable(playerid, 0);
        SetPlayerPos(playerid, apt_Kvartira[in_id][APT_K_POS_X], apt_Kvartira[in_id][APT_K_POS_Y], apt_Kvartira[in_id][APT_K_POS_Z]);
        SetTimerEx("Apt_UnfreezePlayer", 1500, false, "i", playerid);
        SetCameraBehindPlayer(playerid);

        SetPVarInt(playerid, "apt_pickup_tick", GetTickCount() + 2000);
        SetPVarInt(playerid, "apt_InsideId", -1);
        return 1;
    }

    if(dialogid == D_KVART_UPGS)
    {
        if(!response) return Apt_OpenKvartMenu(playerid);
        new in_id = GetPVarInt(playerid, "apt_InsideId");
        if(in_id < 0 || in_id >= apt_kvart_loaded) return 1;

        new price = 0;
        switch(listitem)
        {
            case 0: { if(apt_Kvartira[in_id][APT_K_UPG_MEDKIT]) return SendClientMessage(playerid, 0xE74C3CFF, "  ."), Apt_OpenKvartMenu(playerid);
                      price = 5000; }
            case 1: { if(apt_Kvartira[in_id][APT_K_UPG_DOOR]) return SendClientMessage(playerid, 0xE74C3CFF, "  ."), Apt_OpenKvartMenu(playerid);
                      price = 15000; }
            case 2: { if(apt_Kvartira[in_id][APT_K_UPG_SAFE]) return SendClientMessage(playerid, 0xE74C3CFF, "  ."), Apt_OpenKvartMenu(playerid);
                      price = 50000; }
            case 3: { if(apt_Kvartira[in_id][APT_K_UPG_ARMOR]) return SendClientMessage(playerid, 0xE74C3CFF, "  ."), Apt_OpenKvartMenu(playerid);
                      price = 35000; }
            case 4: { if(apt_Kvartira[in_id][APT_K_UPG_FRIDGE]) return SendClientMessage(playerid, 0xE74C3CFF, "  ."), Apt_OpenKvartMenu(playerid);
                      price = 25000; }
        }

        if(GetPlayerMoneyEx(playerid) < price) 
            return SendClientMessage(playerid, 0xE74C3CFF, "    ."), Apt_OpenKvartMenu(playerid);
            
        GivePlayerMoneyEx(playerid, -price, "   ", true, true);
        
        switch(listitem) {
            case 0: apt_Kvartira[in_id][APT_K_UPG_MEDKIT] = 1;
            case 1: apt_Kvartira[in_id][APT_K_UPG_DOOR] = 1;
            case 2: apt_Kvartira[in_id][APT_K_UPG_SAFE] = 1;   
            case 3: apt_Kvartira[in_id][APT_K_UPG_ARMOR] = 1;
            case 4: apt_Kvartira[in_id][APT_K_UPG_FRIDGE] = 1;
        }
        
        Apt_SaveKvartira(in_id);
        Apt_UpdateKvartiraVisuals(in_id);
        SendClientMessage(playerid, 0x2ECC71FF, "     !");
        Apt_OpenKvartMenu(playerid);
        return 1;
    }

    if(dialogid == D_KVART_SAFE)
    {
        if(!response) return Apt_OpenKvartMenu(playerid);
        new in_id = GetPVarInt(playerid, "apt_InsideId");
        if(in_id < 0 || in_id >= apt_kvart_loaded) return 1;
        
        if(listitem == 0)
        {
            SetPVarInt(playerid, "apt_dialog_active", 1);
            ShowPlayerDialog(playerid, D_KVART_SAFE_PUT, DIALOG_STYLE_INPUT, "{FF5252} ", "{FFFFFF} ,     :", "", "");
        }
        else if(listitem == 1)
        {
            SetPVarInt(playerid, "apt_dialog_active", 1);
            ShowPlayerDialog(playerid, D_KVART_SAFE_TAKE, DIALOG_STYLE_INPUT, "{FF5252}  ", "{FFFFFF} ,   :", "", "");
        }
        return 1;
    }

    if(dialogid == D_KVART_SAFE_PUT)
    {
        if(!response) return Apt_OpenKvartMenu(playerid);
        new in_id = GetPVarInt(playerid, "apt_InsideId");
        if(in_id < 0 || in_id >= apt_kvart_loaded) return 1;
        
        new amount = strval(inputtext);
        if(amount < 1) return SendClientMessage(playerid, 0xE74C3CFF, "    .");
        if(GetPlayerMoneyEx(playerid) < amount) return SendClientMessage(playerid, 0xE74C3CFF, "    .");
        
        GivePlayerMoneyEx(playerid, -amount, " ", true, true);
        apt_Kvartira[in_id][APT_K_SAFE_MONEY] += amount;
        
        Apt_SaveKvartira(in_id);
        Apt_UpdateKvartiraVisuals(in_id);
        
        new msg[128];
        format(msg, sizeof(msg), "  %d .  .  : %d .", amount, apt_Kvartira[in_id][APT_K_SAFE_MONEY]);
        SendClientMessage(playerid, 0x2ECC71FF, msg);
        return 1;
    }

    if(dialogid == D_KVART_SAFE_TAKE)
    {
        if(!response) return Apt_OpenKvartMenu(playerid);
        new in_id = GetPVarInt(playerid, "apt_InsideId");
        if(in_id < 0 || in_id >= apt_kvart_loaded) return 1;
        
        new amount = strval(inputtext);
        if(amount < 1) return SendClientMessage(playerid, 0xE74C3CFF, "    .");
        if(apt_Kvartira[in_id][APT_K_SAFE_MONEY] < amount) return SendClientMessage(playerid, 0xE74C3CFF, "    .");
        
        GivePlayerMoneyEx(playerid, amount, "  ", true, true);
        apt_Kvartira[in_id][APT_K_SAFE_MONEY] -= amount;
        
        Apt_SaveKvartira(in_id);
        Apt_UpdateKvartiraVisuals(in_id);
        
        new msg[128];
        format(msg, sizeof(msg), "  %d .  . : %d .", amount, apt_Kvartira[in_id][APT_K_SAFE_MONEY]);
        SendClientMessage(playerid, 0x2ECC71FF, msg);
        return 1;
    }

    #if defined apt_OnDialogResponse
        return apt_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse apt_OnDialogResponse
#if defined apt_OnDialogResponse
    forward apt_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
#endif

// ==========================================
// 
// ==========================================

CMD:kvhelp(playerid, params[])
{
    new str[512];
    strcat(str, "{FF5252}/kvart{FFFFFF} -     ()\n");
    strcat(str, "{FF5252}/exitkv{FFFFFF} -   \n");
    strcat(str, "{FF5252}/claimbron{FFFFFF} -   \n");
    strcat(str, "{FF5252}/eathol{FFFFFF} -   \n");
    strcat(str, "{FF5252}/seifkv{FFFFFF} -   ( )\n");
    ShowPlayerDialog(playerid, D_KVART_HELP, DIALOG_STYLE_MSGBOX, "{FF5252}: ", str, "", "");
    return 1;
}

CMD:claimbron(playerid, params[])
{
    new in_id = GetPVarInt(playerid, "apt_InsideId");
    if(in_id < 0 || in_id >= apt_kvart_loaded) return SendClientMessage(playerid, 0xE74C3CFF, "     .");
    if(!apt_Kvartira[in_id][APT_K_UPG_ARMOR]) return SendClientMessage(playerid, 0xE74C3CFF, "       .");
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, apt_cfg_armor_x, apt_cfg_armor_y, apt_cfg_armor_z)) 
        return SendClientMessage(playerid, 0xE74C3CFF, "      .");
    if(gettime() < GetPVarInt(playerid, "apt_armor_cd")) 
        return SendClientMessage(playerid, 0xE74C3CFF, "      5 .");
    
    SetPVarInt(playerid, "apt_armor_cd", gettime() + 300);
    SetPlayerArmour(playerid, 100.0);
    SendClientMessage(playerid, 0x2ECC71FF, "     .");
    return 1;
}

CMD:eathol(playerid, params[])
{
    new in_id = GetPVarInt(playerid, "apt_InsideId");
    if(in_id < 0 || in_id >= apt_kvart_loaded) return SendClientMessage(playerid, 0xE74C3CFF, "     .");
    if(!apt_Kvartira[in_id][APT_K_UPG_FRIDGE]) return SendClientMessage(playerid, 0xE74C3CFF, "    .");
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, apt_cfg_fridge_x, apt_cfg_fridge_y, apt_cfg_fridge_z)) 
        return SendClientMessage(playerid, 0xE74C3CFF, "    .");
    if(gettime() < GetPVarInt(playerid, "apt_fridge_cd")) 
        return SendClientMessage(playerid, 0xE74C3CFF, "     30 .");
    
    SetPVarInt(playerid, "apt_fridge_cd", gettime() + 1800);
    new Float:health;
    GetPlayerHealth(playerid, health);
    if(health < 100.0) SetPlayerHealth(playerid, 100.0);
    SendClientMessage(playerid, 0x2ECC71FF, "     .");
    return 1;
}

CMD:seifkv(playerid, params[])
{
    new in_id = GetPVarInt(playerid, "apt_InsideId");
    if(in_id < 0 || in_id >= apt_kvart_loaded) return SendClientMessage(playerid, 0xE74C3CFF, "     .");
    if(!apt_Kvartira[in_id][APT_K_UPG_SAFE]) return SendClientMessage(playerid, 0xE74C3CFF, "    .");
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, apt_cfg_safe_x, apt_cfg_safe_y, apt_cfg_safe_z)) 
        return SendClientMessage(playerid, 0xE74C3CFF, "    .");
    if(!IsKvartiraOwner(playerid, in_id)) return SendClientMessage(playerid, 0xE74C3CFF, "      .");
    
    new str[256];
    format(str, sizeof(str), "{FFFFFF}   : {2ECC71}%d .{FFFFFF}\n\n \n ", apt_Kvartira[in_id][APT_K_SAFE_MONEY]);
    SetPVarInt(playerid, "apt_dialog_active", 1);
    ShowPlayerDialog(playerid, D_KVART_SAFE, DIALOG_STYLE_LIST, "{FF5252} ", str, "", "");
    return 1;
}

CMD:kvart(playerid, params[])
{
    return Apt_OpenKvartMenu(playerid);
}

CMD:exitkv(playerid, params[])
{
    new in_id = GetPVarInt(playerid, "apt_InsideId");
    if(in_id < 0 || in_id >= apt_kvart_loaded)
    {
        new cur_vw = GetPlayerVirtualWorld(playerid);
        if(cur_vw >= 100000) {
            for(new _i = 0; _i < apt_kvart_loaded; _i++) {
                if(apt_Kvartira[_i][APT_K_VW] == cur_vw) {
                    in_id = _i;
                    SetPVarInt(playerid, "apt_InsideId", _i);
                    break;
                }
            }
        }
    }
    
    if(in_id < 0 || in_id >= apt_kvart_loaded) return SendClientMessage(playerid, 0x95A5A6FF, "    .");
    
    new pod_floor_vw = Apt_GetPodFloorVW(apt_Kvartira[in_id][APT_K_POD_ID], apt_Kvartira[in_id][APT_K_FLOOR]);
    SetPlayerVirtualWorld(playerid, pod_floor_vw);
    SetPlayerInterior(playerid, apt_cfg_pod_int);
    
    TogglePlayerControllable(playerid, 0);
    SetPlayerPos(playerid, apt_Kvartira[in_id][APT_K_POS_X], apt_Kvartira[in_id][APT_K_POS_Y], apt_Kvartira[in_id][APT_K_POS_Z]);
    SetTimerEx("Apt_UnfreezePlayer", 1500, false, "i", playerid);
    SetCameraBehindPlayer(playerid);
    
    SetPVarInt(playerid, "apt_pickup_tick", GetTickCount() + 2000);
    SetPVarInt(playerid, "apt_InsideId", -1);
    SendClientMessage(playerid, 0x2ECC71FF, "   .");
    return 1;
}

// ==========================================
// -
// ==========================================

// ==========================================
// АДМИН-КОМАНДЫ (ИСПРАВЛЕННЫЕ)
// ==========================================

CMD:addpod(playerid, params[])
{
    // Проверка прав администратора (6 уровень)
    if(GetPlayerAdminEx(playerid) < 6) 
        return SendClientMessage(playerid, 0xE74C3CFF, "У вас нет прав на использование этой команды.");

    new floors;
    if(sscanf(params, "d", floors)) 
        return SendClientMessage(playerid, 0x95A5A6FF, "Используйте: /addpod [количество этажей]");
    
    if(floors < 1) 
        return SendClientMessage(playerid, 0xE74C3CFF, "Количество этажей должно быть не менее 1.");
    
    if(apt_pod_loaded >= MAX_APT_POD) 
        return SendClientMessage(playerid, 0xE74C3CFF, "Достигнут лимит подъездов в массиве инклуда.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new query[256];
    mysql_format(mysql, query, sizeof(query), 
        "INSERT INTO `podezdy` (`floors`, `pos_x`, `pos_y`, `pos_z`) VALUES (%d, '%f', '%f', '%f')", 
        floors, x, y, z);
    
    // Используем mysql_tquery с колбэком для получения ID
    mysql_tquery(mysql, query, "OnPodCreated", "iifff", playerid, floors, x, y, z);
    
    SendClientMessage(playerid, 0x2ECC71FF, "Подъезд создается...");
    return 1;
}

// Колбэк после создания подъезда
forward OnPodCreated(playerid, floors, Float:x, Float:y, Float:z);
public OnPodCreated(playerid, floors, Float:x, Float:y, Float:z)
{
    new Cache:res = mysql_query(mysql, "SELECT `id` FROM `podezdy` ORDER BY `id` DESC LIMIT 1", true);
    if(cache_num_rows() > 0)
    {
        new idx = apt_pod_loaded;
        apt_Podezd[idx][APT_P_SQL_ID] = cache_get_field_content_int(0, "id");
        apt_Podezd[idx][APT_P_FLOORS] = floors;
        apt_Podezd[idx][APT_P_POS_X] = x;
        apt_Podezd[idx][APT_P_POS_Y] = y;
        apt_Podezd[idx][APT_P_POS_Z] = z;
        
        Apt_UpdatePodezdVisuals(idx);
        apt_pod_loaded++;
        
        new msg[128];
        format(msg, sizeof(msg), "[Система] Подъезд №%d успешно создан на вашей позиции (Этажей: %d).", 
            apt_Podezd[idx][APT_P_SQL_ID], floors);
        SendClientMessage(playerid, 0x2ECC71FF, msg);
    }
    cache_delete(res);
    return 1;
}

CMD:addkvart(playerid, params[])
{
    // Проверка прав администратора (6 уровень)
    if(GetPlayerAdminEx(playerid) < 6) 
        return SendClientMessage(playerid, 0xE74C3CFF, "У вас нет прав на использование этой команды.");

    new pod_sql_id, floor, price;
    if(sscanf(params, "ddd", pod_sql_id, floor, price)) 
        return SendClientMessage(playerid, 0x95A5A6FF, "Используйте: /addkvart [ID подъезда] [этаж] [цена]");
    
    if(price < 1) 
        return SendClientMessage(playerid, 0xE74C3CFF, "Цена квартиры должна быть больше 0 руб.");
    
    if(floor < 1) 
        return SendClientMessage(playerid, 0xE74C3CFF, "Этаж не может быть меньше 1.");
    
    if(apt_kvart_loaded >= MAX_APT_KVART) 
        return SendClientMessage(playerid, 0xE74C3CFF, "Достигнут лимит квартир в массиве инклуда.");

    new pod_idx = Apt_FindPodBySQL(pod_sql_id);
    if(pod_idx == -1) 
        return SendClientMessage(playerid, 0xE74C3CFF, "Указанный ID подъезда не найден в базе данных.");
    
    if(floor > apt_Podezd[pod_idx][APT_P_FLOORS]) 
        return SendClientMessage(playerid, 0xE74C3CFF, "Ошибка: на указанном этаже нельзя создать квартиру (в подъезде меньше этажей).");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new query[512];
    mysql_format(mysql, query, sizeof(query), 
        "INSERT INTO `kvartiry` (`podezd_id`, `floor`, `price`, `pos_x`, `pos_y`, `pos_z`, `enter_x`, `enter_y`, `enter_z`, `enter_angle`) VALUES (%d, %d, %d, '%f', '%f', '%f', '%f', '%f', '%f', '%f')",
        pod_sql_id, floor, price, x, y, z, apt_cfg_apt_sp_x, apt_cfg_apt_sp_y, apt_cfg_apt_sp_z, apt_cfg_apt_sp_a);
    
    // Используем mysql_tquery с колбэком
    mysql_tquery(mysql, query, "OnKvartCreated", "iiiddd", playerid, pod_sql_id, floor, price, x, y, z);
    
    SendClientMessage(playerid, 0x2ECC71FF, "Квартира создается...");
    return 1;
}

// Колбэк после создания квартиры
forward OnKvartCreated(playerid, pod_sql_id, floor, price, Float:x, Float:y, Float:z);
public OnKvartCreated(playerid, pod_sql_id, floor, price, Float:x, Float:y, Float:z)
{
    new Cache:res = mysql_query(mysql, "SELECT `id` FROM `kvartiry` ORDER BY `id` DESC LIMIT 1", true);
    if(cache_num_rows() > 0)
    {
        new idx = apt_kvart_loaded;
        apt_Kvartira[idx][APT_K_SQL_ID] = cache_get_field_content_int(0, "id");
        apt_Kvartira[idx][APT_K_POD_ID] = pod_sql_id;
        apt_Kvartira[idx][APT_K_FLOOR] = floor;
        apt_Kvartira[idx][APT_K_OWNER_ID] = 0;
        format(apt_Kvartira[idx][APT_K_OWNER_NAME], 24, "None");
        apt_Kvartira[idx][APT_K_PRICE] = price;
        
        apt_Kvartira[idx][APT_K_VW] = 100000 + apt_Kvartira[idx][APT_K_SQL_ID];
        
        new fix_query[128];
        mysql_format(mysql, fix_query, sizeof(fix_query), 
            "UPDATE `kvartiry` SET `vw` = %d WHERE `id` = %d", 
            apt_Kvartira[idx][APT_K_VW], apt_Kvartira[idx][APT_K_SQL_ID]);
        mysql_tquery(mysql, fix_query);

        apt_Kvartira[idx][APT_K_POS_X] = x;
        apt_Kvartira[idx][APT_K_POS_Y] = y;
        apt_Kvartira[idx][APT_K_POS_Z] = z;
        apt_Kvartira[idx][APT_K_ENTER_X] = apt_cfg_apt_sp_x;
        apt_Kvartira[idx][APT_K_ENTER_Y] = apt_cfg_apt_sp_y;
        apt_Kvartira[idx][APT_K_ENTER_Z] = apt_cfg_apt_sp_z;
        apt_Kvartira[idx][APT_K_ENTER_A] = apt_cfg_apt_sp_a;
        
        apt_Kvartira[idx][APT_K_LOCKED] = 0;
        apt_Kvartira[idx][APT_K_UPG_MEDKIT] = 0;
        apt_Kvartira[idx][APT_K_UPG_DOOR] = 0;
        apt_Kvartira[idx][APT_K_UPG_SAFE] = 0;
        apt_Kvartira[idx][APT_K_SAFE_MONEY] = 0;
        apt_Kvartira[idx][APT_K_UPG_ARMOR] = 0;
        apt_Kvartira[idx][APT_K_UPG_FRIDGE] = 0;

        Apt_UpdateKvartiraVisuals(idx);
        apt_kvart_loaded++;

        new msg[128];
        format(msg, sizeof(msg), "[Система] Квартира №%d добавлена в подъезд №%d (Этаж: %d, Цена: %d руб.).", 
            apt_Kvartira[idx][APT_K_SQL_ID], pod_sql_id, floor, price);
        SendClientMessage(playerid, 0x2ECC71FF, msg);
    }
    cache_delete(res);
    return 1;
}