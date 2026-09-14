#include <a_samp>
#include <dini>

new GiftPickup;
new const giftFile[] = "GiftData.ini"; // Файл с данными

public OnFilterScriptInit()
{
    print("\n--------------------------------------");
    print(" Gift NPC Filterscript загружен!");
    print("--------------------------------------\n");

    // Создаем пикап перед NPC (координаты)
    GiftPickup = CreatePickup(1274, 1, 848.423583, 813.498779, 13.328223, -1);
    return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    if (pickupid == GiftPickup)
    {
        new name[MAX_PLAYER_NAME], path[64];
        GetPlayerName(playerid, name, sizeof(name));
        format(path, sizeof(path), "%s", giftFile);

        if (!fexist(path))
        {
            dini_Create(path);
        }

        if (dini_Isset(path, name))
        {
            SendClientMessage(playerid, -1, "Ты уже получил этот подарок!");
            return 1;
        }

        // Выдача подарка
        GivePlayerMoney(playerid, 25000000); // 25 000 000 ₽
        SetPlayerHealth(playerid, 100.0);    // Полное здоровье
        SetPlayerSkin(playerid, 87);         // Скин «коньки» (ID 87)
        SendClientMessage(playerid, -1, "Ты получил подарок: 25 000 000 ₽, полное здоровье и скин!");

        dini_Set(path, name, "1");
    }
    return 1;
}