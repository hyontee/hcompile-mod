enum e_Furniture_Init
{
    f_ObjectID,
    f_Places
}

new Furniture_Init[][Furniture_Init] =
{
    {2636, 1},
    {2350, 1},
    {2121, 1},
    {1811, 1},
    {1805, 1},
    {1724, 1},
    {2293, 1},
    {2292, 1},
    {2079, 1},
    {2310, 1},
    {1716, 1},
    {1671, 1},
    {2776, 1},
    {1721, 1},
    {2356, 1},
    {1255, 1},
    {1720, 1},
    {1727, 1},

    {1713, 2},
    {2302, 2},
    {1728, 2},
    {1723, 2},
    {1702, 2},
    {1757, 2},
    {2748, 2},
    {11862, 2},
    {11720, 2},
    {14866, 2},
    {2571, 2}, // посмотри как оно выглядит

    {1764, 3},
    {14493, 5}, // посмотри как оно выглядит
}

#define MAX_FURNITURE 100

enum e_Furniture_Data
{
    f_ObjectID,
    f_ObjectZone, // зона конкретного объекта мебели
	f_Type, // тип мебели
	f_Places, // количество мест конкретного объекта мебели

	Float:f_X,
	Float:f_Y,
	Float:f_Z,

	Float:f_RX,
	Float:f_RY,
	Float:f_RZ
}
new Furniture_Data[MAX_FURNITURE][e_Furniture_Data],
    totalfurniture;

stock furniture_CreateDynamicObject(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_OBJECT_SD, Float:drawdistance = STREAMER_OBJECT_DD, STREAMER_TAG_AREA areaid = STREAMER_TAG_AREA -1)
{
    new
        ok_return = CreateDynamicObject(modelid, x, y, z, rx, ry, rz, worldid, interiorid, playerid, streamdistance, drawdistance, areaid);
    for(new i, j = sizeof(IW_Furniture)-1; i != -1; i--)
    {
        if(modelid == IW_Furniture[i][f_ObjectID])
        {
            Furniture_Add(ok_return, modelid);
            break;
        }
    }
    return ok_return;
}

#if defined _ALS_CreateDynamicObject
        #undef CreateDynamicObject
#else
        #define _ALS_CreateDynamicObject
#endif
#define CreateDynamicObject furniture_CreateDynamicObject

stock furniture_DestroyDynamicObject(objectid)
{
    new modelid = GetDynamicObjectModelID(objectid),
        ok_return = DestroyDynamicObject(modelid);
    for(new i, j = sizeof(IW_Furniture)-1; i != -1; i--)
    {
        if(modelid == IW_Furniture[i][f_ObjectID])
        {
            //
            break;
        }
    }
    return ok_return;
}

#if defined _ALS_DestroyDynamicObject
        #undef DestroyDynamicObject
#else
        #define _ALS_DestroyDynamicObject
#endif
#define DestroyDynamicObject furniture_DestroyDynamicObject

Furniture_Add(objectid, modelid)
{
    Furniture_Data[TOTALFURNITURE][f_ObjectID] = objectid;
    GetDynamicObjectPos(objectid, Furniture_Data[TOTALFURNITURE][f_X],Furniture_Data[TOTALFURNITURE][f_Y],Furniture_Data[TOTALFURNITURE][f_Z]);
    GetDynamicObjectRot(objectid, Furniture_Data[TOTALFURNITURE][f_RX],Furniture_Data[TOTALFURNITURE][f_RY],Furniture_Data[TOTALFURNITURE][f_RZ]);

    Furniture_Data[TOTALFURNITURE][f_ObjectZone] = CreateDynamicSphere(Furniture_Data[TOTALFURNITURE][f_X],Furniture_Data[TOTALFURNITURE][f_Y],Furniture_Data[TOTALFURNITURE][f_Z], 5.0, -1, -1, -1);

    /*if(Furniute_Data[TOTALFURNITURE][fRZ] >= 360.0)
    {
        CreateDynamic3DTextLabel("one place", -1, Furniute_Data[TOTALFURNITURE][fX]+0.3,Furniute_Data[TOTALFURNITURE][fY]-0.5,Furniute_Data[TOTALFURNITURE][fZ], 10.0, INVALID_PLAYER_ID,INVALID_PLAYER_ID, 0, -1, -1, -1, 100.0);
        CreateDynamic3DTextLabel("two place", -1, Furniute_Data[TOTALFURNITURE][fX]+1.3,Furniute_Data[TOTALFURNITURE][fY]-0.5,Furniute_Data[TOTALFURNITURE][fZ], 10.0, INVALID_PLAYER_ID,INVALID_PLAYER_ID, 0, -1, -1, -1, 100.0);

        Furniture_Places[TOTALFURNITURE][0][fPlayerX] = Furniute_Data[TOTALFURNITURE][fX]+0.3;
        Furniture_Places[TOTALFURNITURE][0][fPlayerY] = Furniute_Data[TOTALFURNITURE][fY]-0.5;
        Furniture_Places[TOTALFURNITURE][0][fPlayerZ] = Furniute_Data[TOTALFURNITURE][fZ]+1.5;
        Furniture_Places[TOTALFURNITURE][0][fPlayerFA] = 0.0;

        Furniture_Places[TOTALFURNITURE][1][fPlayerX] = Furniute_Data[TOTALFURNITURE][fX]+1.3;
        Furniture_Places[TOTALFURNITURE][1][fPlayerY] = Furniute_Data[TOTALFURNITURE][fY]-0.5;
        Furniture_Places[TOTALFURNITURE][1][fPlayerZ] = Furniute_Data[TOTALFURNITURE][fZ]+1.5;
        Furniture_Places[TOTALFURNITURE][1][fPlayerFA] = 0.0;

    }
    else if(Furniute_Data[TOTALFURNITURE][fRZ] <= 180.0)
    {
        CreateDynamic3DTextLabel("one place", -1, Furniute_Data[TOTALFURNITURE][fX]-0.3,Furniute_Data[TOTALFURNITURE][fY]+0.5,Furniute_Data[TOTALFURNITURE][fZ], 10.0, INVALID_PLAYER_ID,INVALID_PLAYER_ID, 0, -1, -1, -1, 100.0);
        CreateDynamic3DTextLabel("two place", -1, Furniute_Data[TOTALFURNITURE][fX]-1.3,Furniute_Data[TOTALFURNITURE][fY]+0.5,Furniute_Data[TOTALFURNITURE][fZ], 10.0, INVALID_PLAYER_ID,INVALID_PLAYER_ID, 0, -1, -1, -1, 100.0);

        Furniture_Places[TOTALFURNITURE][0][fPlayerX] = Furniute_Data[TOTALFURNITURE][fX]-0.3;
        Furniture_Places[TOTALFURNITURE][0][fPlayerY] = Furniute_Data[TOTALFURNITURE][fY]+0.5;
        Furniture_Places[TOTALFURNITURE][0][fPlayerZ] = Furniute_Data[TOTALFURNITURE][fZ]+1.5;
        Furniture_Places[TOTALFURNITURE][0][fPlayerFA] = 0.0;

        Furniture_Places[TOTALFURNITURE][1][fPlayerX] = Furniute_Data[TOTALFURNITURE][fX]-1.3;
        Furniture_Places[TOTALFURNITURE][1][fPlayerY] = Furniute_Data[TOTALFURNITURE][fY]+0.5;
        Furniture_Places[TOTALFURNITURE][1][fPlayerZ] = Furniute_Data[TOTALFURNITURE][fZ]+1.5;
        Furniture_Places[TOTALFURNITURE][1][fPlayerFA] = 0.0;
    }*/

    Furniute_Data[TOTALFURNITURE][fType] = 0; // 0 - тип мебели, в нашем случае это сидячая мебель
    Furniute_Data[TOTALFURNITURE][fPlaces] = 2; // 2 - количество мест для игроков на данном объекте

    TOTALFURNITURE++;
}
