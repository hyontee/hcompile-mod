#if defined _number_board_included
    #endinput
#endif
#define _number_board_included

new const E_GARAGE_STRUCT:G_PLATE_NUMBER_SLOT[20] = {G_PLATE_NUMBER_SLOT_0, G_PLATE_NUMBER_SLOT_1, G_PLATE_NUMBER_SLOT_2,
    G_PLATE_NUMBER_SLOT_3, G_PLATE_NUMBER_SLOT_4, G_PLATE_NUMBER_SLOT_5, G_PLATE_NUMBER_SLOT_6, G_PLATE_NUMBER_SLOT_7,
    G_PLATE_NUMBER_SLOT_8, G_PLATE_NUMBER_SLOT_9, G_PLATE_NUMBER_SLOT_10, G_PLATE_NUMBER_SLOT_11, G_PLATE_NUMBER_SLOT_12,
    G_PLATE_NUMBER_SLOT_13, G_PLATE_NUMBER_SLOT_14, G_PLATE_NUMBER_SLOT_15, G_PLATE_NUMBER_SLOT_16, G_PLATE_NUMBER_SLOT_17,
	G_PLATE_NUMBER_SLOT_18, G_PLATE_NUMBER_SLOT_19
};

new const number_board_slot[5] = {12, 16, 20};
new const number_obj_type[5] = {16924, 16927, 16925, 16928, 16926};

new const Float:number_pos_board[3][20][6] =
{
    {
        {-1611.69, 1580.04, 2007.39, 0.00, 0.00, -90.00},
        {-1611.69, 1579.33, 2007.39, 0.00, 0.00, -90.00},
        {-1611.69, 1578.62, 2007.39, 0.00, 0.00, -90.00},
        {-1611.69, 1577.91, 2007.39, 0.00, 0.00, -90.00},
        {-1611.69, 1580.04, 2007.15, 0.00, 0.00, -90.00},
        {-1611.69, 1579.33, 2007.15, 0.00, 0.00, -90.00},
        {-1611.69, 1578.62, 2007.15, 0.00, 0.00, -90.00},
        {-1611.69, 1577.91, 2007.15, 0.00, 0.00, -90.00},
        {-1611.69, 1580.04, 2006.91, 0.00, 0.00, -90.00},
        {-1611.69, 1579.33, 2006.91, 0.00, 0.00, -90.00},
        {-1611.69, 1578.62, 2006.91, 0.00, 0.00, -90.00},
        {-1611.69, 1577.91, 2006.91, 0.00, 0.00, -90.00},
        {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}

    },
    {
        {2892.99, 2890.14, 1001.96, 0.00, 0.00, 90.00},
        {2892.99, 2890.85, 1001.96, 0.00, 0.00, 90.00},
        {2892.99, 2891.56, 1001.96, 0.00, 0.00, 90.00},
        {2892.99, 2892.27, 1001.96, 0.00, 0.00, 90.00},
        {2892.99, 2890.14, 1001.74, 0.00, 0.00, 90.00},
        {2892.99, 2890.85, 1001.74, 0.00, 0.00, 90.00},
        {2892.99, 2891.56, 1001.74, 0.00, 0.00, 90.00},
        {2892.99, 2892.27, 1001.74, 0.00, 0.00, 90.00},
        {2892.99, 2890.14, 1001.52, 0.00, 0.00, 90.00},
        {2892.99, 2890.85, 1001.52, 0.00, 0.00, 90.00},
        {2892.99, 2891.56, 1001.52, 0.00, 0.00, 90.00},
        {2892.99, 2892.27, 1001.52, 0.00, 0.00, 90.00},
        {2892.99, 2890.14, 1001.30, 0.00, 0.00, 90.00},
        {2892.99, 2890.85, 1001.30, 0.00, 0.00, 90.00},
        {2892.99, 2891.56, 1001.30, 0.00, 0.00, 90.00},
        {2892.99, 2892.27, 1001.30, 0.00, 0.00, 90.00},
        {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
    },
    {
        {-1667.14, -461.49, 1002.22, 0.00, 0.00, 90.00},
        {-1667.14, -460.78, 1002.22, 0.00, 0.00, 90.00},
        {-1667.14, -460.07, 1002.22, 0.00, 0.00, 90.00},
        {-1667.14, -459.36, 1002.22, 0.00, 0.00, 90.00},
        {-1667.14, -461.49, 1002.00, 0.00, 0.00, 90.00},
        {-1667.14, -460.78, 1002.00, 0.00, 0.00, 90.00},
        {-1667.14, -460.07, 1002.00, 0.00, 0.00, 90.00},
        {-1667.14, -459.36, 1002.00, 0.00, 0.00, 90.00},
        {-1667.14, -461.49, 1001.78, 0.00, 0.00, 90.00},
        {-1667.14, -460.78, 1001.78, 0.00, 0.00, 90.00},
        {-1667.14, -460.07, 1001.78, 0.00, 0.00, 90.00},
        {-1667.14, -459.36, 1001.78, 0.00, 0.00, 90.00},
        {-1667.14, -461.49, 1001.56, 0.00, 0.00, 90.00},
        {-1667.14, -460.78, 1001.56, 0.00, 0.00, 90.00},
        {-1667.14, -460.07, 1001.56, 0.00, 0.00, 90.00},
        {-1667.14, -459.36, 1001.56, 0.00, 0.00, 90.00},
        {-1667.14, -461.49, 1001.34, 0.00, 0.00, 90.00},
        {-1667.14, -460.78, 1001.34, 0.00, 0.00, 90.00},
        {-1667.14, -460.07, 1001.34, 0.00, 0.00, 90.00},
        {-1667.14, -459.36, 1001.34, 0.00, 0.00, 90.00}
    }
};

stock NumberBoardUpdate(typenumber, number[], region[], garage_id, slot)
{
    static textnz[256];

    new plate_obj = GetGarageData(garage_id, G_PLATE_NUMBER_SLOT[slot]);
    new garage_type = GetGarageData(garage_id, G_TYPE);
    new slot_max = number_board_slot[garage_type - 1];

    if(slot > slot_max) return 0;

    if(IsValidDynamicObject(plate_obj))
    {
        DestroyDynamicObject(plate_obj);
        SetGarageData(garage_id, G_PLATE_NUMBER_SLOT[slot], 0);
        plate_obj = 0;
    }

    if(!IsValidDynamicObject(plate_obj))
    {
        new object_num = number_obj_type[typenumber - 1];
        new Float:x = number_pos_board[garage_type - 1][slot][0];
        new Float:y = number_pos_board[garage_type - 1][slot][1];
        new Float:z = number_pos_board[garage_type - 1][slot][2];
        new Float:rx = number_pos_board[garage_type - 1][slot][3];
        new Float:ry = number_pos_board[garage_type - 1][slot][4];
        new Float:rz = number_pos_board[garage_type - 1][slot][5];

        new vm = garage_id + 2000;

        plate_obj = CreateDynamicObject(object_num, x, y, z, rx, ry, rz, vm);

        if(IsValidDynamicObject(plate_obj))
        {
            switch(typenumber)
            {
                case 1:{
                    SetDynamicObjectMaterialText(plate_obj, 1, number, 80, "Arial", 70, 1, 0xFF000000, 0x00000000, 1);
                    SetDynamicObjectMaterialText(plate_obj, 2, region, 50, "Arial", 80, 1, 0xFF000000, 0x00000000, 1);
                }
                case 2:{
                    SetDynamicObjectMaterialText(plate_obj, 1, number, 80, "Arial", 75, 1, 0xFF000000, 0x00000000, 1);
                    SetDynamicObjectMaterialText(plate_obj, 2, region, 90, "Arial", 160, 1, 0xFF000000, 0x00000000, 1);
                }
                case 3:{
                    format(textnz, sizeof textnz, "%s %s", number, region);
                    SetDynamicObjectMaterialText(plate_obj, 1, textnz, 120, "Arial", 115, 1, 0xFF000000, 0x00000000, 1);
                }
                case 4:{
                    new prefix1[3], suffix[3];
                    prefix1[0] = region[0], prefix1[1] = region[1], prefix1[2] = '\0';
                    suffix[0] = region[2], suffix[1] = region[3], suffix[2] = '\0';

                    format(textnz, sizeof(textnz), "%s %s %s", prefix1, number, suffix);
                    SetDynamicObjectMaterialText(plate_obj, 1, textnz, 70, "Arial", 43, 1, 0xFF000000, 0x00000000, 1);
                }
                case 5:{
                    SetDynamicObjectMaterialText(plate_obj, 1, number, 80, "Arial", 55, 1, 0xFF000000, 0x00000000, 1);
                }
            }
            SetGarageData(garage_id, G_PLATE_NUMBER_SLOT[slot], plate_obj);
        }
    }
    return 1;
}

stock NumberBoardDelete(garage_id, slots_plate)
{
    new plate_obj = GetGarageData(garage_id, G_PLATE_NUMBER_SLOT[slots_plate]);
                
    if(IsValidDynamicObject(plate_obj))
    {
        DestroyDynamicObject(plate_obj);

        SetGarageData(garage_id, G_PLATE_NUMBER_SLOT[slots_plate], 0);
    }
}

stock NumberBoardUpdateSql(garage_id)
{
    static query[219];
    format(query, sizeof(query), "SELECT slots, typenumber, number, region FROM items WHERE plate=%d", garage_id);
    mysql_tquery(mysql, query, "NumberBoardSql", "i", garage_id);
}

forward NumberBoardSql(garage_id);
public NumberBoardSql(garage_id)
{
    new rows = cache_num_rows();

    if(rows > 0)
    {
        for(new i = 0; i < rows; i++)
        {
            new number[32];
            new region[32];

            new slots = cache_get_field_content_int(i, "slots");
            new typenumber = cache_get_field_content_int(i, "typenumber");

            cache_get_field_content(i, "number", number, sizeof(number));
            cache_get_field_content(i, "region", region, sizeof(region));

            NumberBoardUpdate(typenumber, number, region, garage_id, slots);
        }
    }
}