//==================================================================
// СИСТЕМА РАБОЧИХ СКИНОВ (ФОРМ) С ПРАВИЛЬНОЙ КОДИРОВКОЙ
// АВТОР: https://t.me/welsistudio
//==================================================================

#pragma dynamic 6550
#pragma warning disable 239
#pragma warning disable 214
#pragma warning disable 202
#pragma warning disable 203
#pragma warning disable 213
#pragma warning disable 217
#pragma warning disable 219
#pragma warning disable 209
#pragma warning disable 234
#pragma warning disable 204
#pragma disablerecursion

#include <a_samp>
#include <a_http>
#include <streamer>

// ==================== НАСТРОЙКИ ====================
#define WORK_SKIN_MANAGER 170     
#define WORK_SKIN_DEALER 171      
#define WORK_SKIN_GUARD 172       
#define WORK_SKIN_ADMIN 217       

#define WORK_SALARY_MANAGER 2000  
#define WORK_SALARY_DEALER 1500   
#define WORK_SALARY_GUARD 1200    
#define WORK_SALARY_ADMIN 5000    

#define DIALOG_WORK_MENU 5000
#define DIALOG_WORK_SKIN 5001
#define DIALOG_WORK_STATS 5002

// ==================== ПЕРЕМЕННЫЕ ====================
new PlayerOldSkin[MAX_PLAYERS];
new PlayerWorkTime[MAX_PLAYERS];
new PlayerWorkSalary[MAX_PLAYERS];
new bool:PlayerOnDuty[MAX_PLAYERS];
new PlayerWorkSkin[MAX_PLAYERS];
new bool:PlayerInCasino[MAX_PLAYERS];

new work_sphere;
new work_pickup;
new work_textlabel;

// ==================== OnGameModeInit ====================
public OnGameModeInit()
{
    work_sphere = CreateDynamicSphere(2517.021484, 2489.340087, 2501.078125, 3.0);
    work_pickup = CreateDynamicPickup(19135, 23, 2517.021484, 2489.340087, 2501.078125);
    work_textlabel = CreateDynamic3DTextLabel("{FFFF00}Раздевалка\n{FFFFFF}Подойдите для взаимодействия", -1, 2517.021484, 2489.340087, 2501.578125, 10.0);
    return 1;
}

// ==================== OnPlayerCommandText ====================
public OnPlayerCommandText(playerid, cmdtext[])
{
    if(strcmp(cmdtext, "/work", true) == 0)
    {
        if(!IsPlayerInDynamicArea(playerid, work_sphere))
        {
            SendClientMessage(playerid, -1, "{FF0000}Вы должны подойти к раздевалке!");
            return 1;
        }
        
        ShowDialogWorkMenu(playerid);
        return 1;
    }
    
    if(strcmp(cmdtext, "/workon", true) == 0)
    {
        if(!PlayerOnDuty[playerid])
        {
            SendClientMessage(playerid, -1, "{FF0000}Вы не надели форму! Используйте /work");
            return 1;
        }
        
        if(GetPlayerVehicleSeat(playerid) != -1)
        {
            SendClientMessage(playerid, -1, "{FF0000}Вы не можете работать в транспорте!");
            return 1;
        }
        
        if(PlayerWorkTime[playerid] > 0)
        {
            SendClientMessage(playerid, -1, "{FFFF00}Вы уже на работе!");
            return 1;
        }
        
        PlayerWorkTime[playerid] = gettime();
        SendClientMessage(playerid, -1, "{00FF00}Вы вышли на работу! Используйте /workoff чтобы закончить.");
        return 1;
    }
    
    if(strcmp(cmdtext, "/workoff", true) == 0)
    {
        if(!PlayerOnDuty[playerid])
        {
            SendClientMessage(playerid, -1, "{FF0000}Вы не на работе!");
            return 1;
        }
        
        if(PlayerWorkTime[playerid] == 0)
        {
            SendClientMessage(playerid, -1, "{FF0000}Вы не начинали работу!");
            return 1;
        }
        
        new time = gettime() - PlayerWorkTime[playerid];
        new minutes = time / 60;
        
        if(minutes < 1)
        {
            SendClientMessage(playerid, -1, "{FF0000}Вы проработали меньше минуты, зарплата не начислена!");
            PlayerWorkTime[playerid] = 0;
            return 1;
        }
        
        new salary = minutes * PlayerWorkSalary[playerid];
        GivePlayerMoney(playerid, salary);
        
        new string[128];
        format(string, sizeof string, "{00FF00}Вы отработали %d минут и получили $%d", minutes, salary);
        SendClientMessage(playerid, -1, string);
        
        PlayerOnDuty[playerid] = false;
        PlayerWorkTime[playerid] = 0;
        
        if(PlayerOldSkin[playerid] != 0)
        {
            SetPlayerSkin(playerid, PlayerOldSkin[playerid]);
            PlayerOldSkin[playerid] = 0;
        }
        
        return 1;
    }
    
    if(strcmp(cmdtext, "/workstats", true) == 0)
    {
        if(!PlayerOnDuty[playerid])
        {
            SendClientMessage(playerid, -1, "{FF0000}Вы не на работе!");
            return 1;
        }
        
        if(PlayerWorkTime[playerid] == 0)
        {
            SendClientMessage(playerid, -1, "{FFFF00}Вы ещё не начинали работать! Используйте /workon");
            return 1;
        }
        
        new time = gettime() - PlayerWorkTime[playerid];
        new minutes = time / 60;
        new seconds = time % 60;
        
        new string[256];
        format(string, sizeof string,
            "{00FF00}Статус: {FFFFFF}На работе\n\
            {00FF00}Время работы: {FFFFFF}%d мин %d сек\n\
            {00FF00}Зарплата: {FFFFFF}$%d/мин\n\
            {00FF00}Заработано: {FFFFFF}$%d",
            minutes, seconds,
            PlayerWorkSalary[playerid],
            minutes * PlayerWorkSalary[playerid]
        );
        
        ShowPlayerDialog(playerid, DIALOG_WORK_STATS, DIALOG_STYLE_MSGBOX, "{00FF00}Статистика работы", string, "OK", "");
        return 1;
    }
    
    if(strcmp(cmdtext, "/workskin", true) == 0)
    {
        if(!IsPlayerInDynamicArea(playerid, work_sphere))
        {
            SendClientMessage(playerid, -1, "{FF0000}Вы должны подойти к раздевалке!");
            return 1;
        }
        
        if(PlayerOnDuty[playerid])
        {
            SendClientMessage(playerid, -1, "{FF0000}Вы на работе! Сначала завершите работу (/workoff)");
            return 1;
        }
        
        ShowDialogWorkSkin(playerid);
        return 1;
    }
    
    return 0;
}

// ==================== ДИАЛОГИ ====================
stock ShowDialogWorkMenu(playerid)
{
    new string[512];
    format(string, sizeof string,
        "{FFFFFF}1. {00FF00}Выбрать форму\n\
        {FFFFFF}2. {FFFF00}Статистика\n\
        {FFFFFF}3. {00FF00}Начать работу\n\
        {FFFFFF}4. {FF0000}Закончить работу"
    );
    
    ShowPlayerDialog(playerid, DIALOG_WORK_MENU, DIALOG_STYLE_LIST, "{00FF00}Система работы", string, "Выбрать", "Закрыть");
    return 1;
}

stock ShowDialogWorkSkin(playerid)
{
    new string[512];
    format(string, sizeof string,
        "{FFFFFF}1. {00FF00}Менеджер ($%d/мин)\n\
        {FFFFFF}2. {00FF00}Крупье ($%d/мин)\n\
        {FFFFFF}3. {00FF00}Охранник ($%d/мин)\n\
        {FFFFFF}4. {FF0000}Снять форму\n\
        {FFFFFF}5. {FFFF00}Администратор ($%d/мин)",
        WORK_SALARY_MANAGER,
        WORK_SALARY_DEALER,
        WORK_SALARY_GUARD,
        WORK_SALARY_ADMIN
    );
    
    ShowPlayerDialog(playerid, DIALOG_WORK_SKIN, DIALOG_STYLE_LIST, "{00FF00}Выбор формы", string, "Выбрать", "Назад");
    return 1;
}

// ==================== ОБРАБОТЧИК ДИАЛОГОВ ====================
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_WORK_MENU)
    {
        if(!response) return 1;
        
        switch(listitem)
        {
            case 0: ShowDialogWorkSkin(playerid);
            case 1: ShowDialogWorkStats(playerid);
            case 2:
            {
                if(!PlayerOnDuty[playerid])
                {
                    SendClientMessage(playerid, -1, "{FF0000}Вы не надели форму! Используйте /workskin");
                    return 1;
                }
                
                if(GetPlayerVehicleSeat(playerid) != -1)
                {
                    SendClientMessage(playerid, -1, "{FF0000}Вы не можете работать в транспорте!");
                    return 1;
                }
                
                PlayerWorkTime[playerid] = gettime();
                SendClientMessage(playerid, -1, "{00FF00}Вы вышли на работу! Используйте /workoff чтобы закончить.");
                return 1;
            }
            case 3:
            {
                if(!PlayerOnDuty[playerid])
                {
                    SendClientMessage(playerid, -1, "{FF0000}Вы не на работе!");
                    return 1;
                }
                
                if(PlayerWorkTime[playerid] == 0)
                {
                    SendClientMessage(playerid, -1, "{FF0000}Вы не начинали работу!");
                    return 1;
                }
                
                new time = gettime() - PlayerWorkTime[playerid];
                new minutes = time / 60;
                
                if(minutes < 1)
                {
                    SendClientMessage(playerid, -1, "{FF0000}Вы проработали меньше минуты, зарплата не начислена!");
                    PlayerWorkTime[playerid] = 0;
                    return 1;
                }
                
                new salary = minutes * PlayerWorkSalary[playerid];
                GivePlayerMoney(playerid, salary);
                
                new string[128];
                format(string, sizeof string, "{00FF00}Вы отработали %d минут и получили $%d", minutes, salary);
                SendClientMessage(playerid, -1, string);
                
                PlayerOnDuty[playerid] = false;
                PlayerWorkTime[playerid] = 0;
                
                if(PlayerOldSkin[playerid] != 0)
                {
                    SetPlayerSkin(playerid, PlayerOldSkin[playerid]);
                    PlayerOldSkin[playerid] = 0;
                }
                
                return 1;
            }
        }
        return 1;
    }
    
    if(dialogid == DIALOG_WORK_SKIN)
    {
        if(!response)
        {
            ShowDialogWorkMenu(playerid);
            return 1;
        }
        
        new skin;
        new salary;
        new skin_name[32];
        
        switch(listitem)
        {
            case 0:
            {
                skin = WORK_SKIN_MANAGER;
                salary = WORK_SALARY_MANAGER;
                format(skin_name, sizeof skin_name, "Менеджера");
            }
            case 1:
            {
                skin = WORK_SKIN_DEALER;
                salary = WORK_SALARY_DEALER;
                format(skin_name, sizeof skin_name, "Крупье");
            }
            case 2:
            {
                skin = WORK_SKIN_GUARD;
                salary = WORK_SALARY_GUARD;
                format(skin_name, sizeof skin_name, "Охранника");
            }
            case 3:
            {
                if(PlayerOnDuty[playerid])
                {
                    SendClientMessage(playerid, -1, "{FF0000}Вы на работе! Сначала завершите работу (/workoff)");
                    return 1;
                }
                
                if(PlayerOldSkin[playerid] != 0)
                {
                    SetPlayerSkin(playerid, PlayerOldSkin[playerid]);
                    SendClientMessage(playerid, -1, "{00FF00}Вы сняли форму");
                    PlayerOldSkin[playerid] = 0;
                    PlayerWorkSkin[playerid] = 0;
                    PlayerOnDuty[playerid] = false;
                }
                else
                {
                    SendClientMessage(playerid, -1, "{FF0000}Вы не надевали форму");
                }
                return 1;
            }
            case 4:
            {
                if(GetPlayerScore(playerid) < 1337)
                {
                    SendClientMessage(playerid, -1, "{FF0000}У вас нет прав для этой формы!");
                    return 1;
                }
                skin = WORK_SKIN_ADMIN;
                salary = WORK_SALARY_ADMIN;
                format(skin_name, sizeof skin_name, "Администратора");
            }
            default: return 1;
        }
        
        if(PlayerOldSkin[playerid] == 0)
            PlayerOldSkin[playerid] = GetPlayerSkin(playerid);
        
        SetPlayerSkin(playerid, skin);
        PlayerWorkSalary[playerid] = salary;
        PlayerWorkSkin[playerid] = skin;
        PlayerOnDuty[playerid] = false;
        PlayerWorkTime[playerid] = 0;
        
        new string[128];
        format(string, sizeof string, "{00FF00}Вы надели форму %s. Зарплата: $%d/мин", skin_name, salary);
        SendClientMessage(playerid, -1, string);
        SendClientMessage(playerid, -1, "{FFFF00}Используйте /workon чтобы начать работу");
        return 1;
    }
    
    return 0;
}

// ==================== ДОПОЛНИТЕЛЬНЫЕ ФУНКЦИИ ====================
stock ShowDialogWorkStats(playerid)
{
    if(!PlayerOnDuty[playerid])
    {
        SendClientMessage(playerid, -1, "{FF0000}Вы не на работе!");
        return 1;
    }
    
    if(PlayerWorkTime[playerid] == 0)
    {
        SendClientMessage(playerid, -1, "{FFFF00}Вы ещё не начинали работать! Используйте /workon");
        return 1;
    }
    
    new time = gettime() - PlayerWorkTime[playerid];
    new minutes = time / 60;
    new seconds = time % 60;
    
    new string[256];
    format(string, sizeof string,
        "{00FF00}Статус: {FFFFFF}На работе\n\
        {00FF00}Время работы: {FFFFFF}%d мин %d сек\n\
        {00FF00}Зарплата: {FFFFFF}$%d/мин\n\
        {00FF00}Заработано: {FFFFFF}$%d",
        minutes, seconds,
        PlayerWorkSalary[playerid],
        minutes * PlayerWorkSalary[playerid]
    );
    
    ShowPlayerDialog(playerid, DIALOG_WORK_STATS, DIALOG_STYLE_MSGBOX, "{00FF00}Статистика работы", string, "OK", "");
    return 1;
}

stock RemoveWorkSkin(playerid)
{
    if(PlayerOldSkin[playerid] != 0)
    {
        SetPlayerSkin(playerid, PlayerOldSkin[playerid]);
        PlayerOldSkin[playerid] = 0;
        PlayerOnDuty[playerid] = false;
        PlayerWorkTime[playerid] = 0;
        PlayerWorkSkin[playerid] = 0;
        PlayerInCasino[playerid] = false;
        return 1;
    }
    return 0;
}