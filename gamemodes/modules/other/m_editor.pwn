#include                                    <custom/edit_object>

enum
{
	AOED = 7000,
	AOED_EDIT_OBJECT,
	AOED_EDITOR_INFO,
	AOED_EDITOR_INFO1,
	d_changes,
	d_change_bone,
	
	AOE,
	AOE_EDIT_OBJECT
} ;

#define MAX_COORD_LIMIT (1.0)

/*new
	gPlayerAttachedObjectBone[MAX_PLAYERS + 1][MAX_PLAYER_ATTACHED_OBJECTS],
	gPlayerAttachedObjectModel[MAX_PLAYERS + 1][MAX_PLAYER_ATTACHED_OBJECTS],
	Float:gPlayerAttachedObjectPos[MAX_PLAYERS + 1][MAX_PLAYER_ATTACHED_OBJECTS][9],
	Float:gPlayerEditObjectTD[MAX_PLAYERS + 1][MAX_PLAYER_ATTACHED_OBJECTS][9],
	gPlayerUsesEditor[MAX_PLAYERS char],

	Float:gPlayerEditorScale[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS ] = {{0.0, ...}, ...},

	Float:gPlayerEditorStep[MAX_PLAYERS ] = {0.1, ...},
	gPlayerChooseIndex[MAX_PLAYERS char],
	bool: gPlayerObjectEdit[MAX_PLAYERS],
	bool: gPlayerEditSize [ MAX_PLAYERS ] ;
*/

CMD:aoe1 ( playerid )
{
	if ( admin_info [ playerid ] [ admin ] < 8 ) return 1 ;
	show_dialog ( playerid, AOE, DIALOG_STYLE_LIST, "{"#cBHD"}Редактор объектов", "{"#cBL"}1. {"#cWH"}Создать объект\n\
																					{"#cBL"}2. {"#cWH"}Информация\n\
																					{"#cGRDialog"}- Закрыть редактор: {"#cWH"}/aoee\n\
																					{"#cGRDialog"}- Включить кликабельность: {"#cWH"}/aoem\n\
																					{"#cGRDialog"}- Редактирование размера: {"#cWH"}/aoesize", "Выбрать", "Закрыть" ) ;
	return 1 ;
}

CMD:aoe2 ( playerid )
{
	if ( admin_info [ playerid ] [ admin ] < 8 ) return 1 ;
	show_dialog ( playerid, AOED, DIALOG_STYLE_LIST, "{"#cBHD"}Редактор крепления объектов", "{"#cBL"}1. {"#cWH"}Создать объект\n\
																								{"#cBL"}2. {"#cWH"}Информация\n\
																								{"#cGRDialog"}- Закрыть редактор: {"#cWH"}/aoee\n\
																								{"#cGRDialog"}- Включить кликабельность: {"#cWH"}/aoem\n\
																								{"#cGRDialog"}- Редактирование размера: {"#cWH"}/aoesize", "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock editor_OnPlayerDisconnect ( playerid )
{
	if ( gPlayerUsesEditor { playerid } == 1 )
	{
		new index = gPlayerChooseIndex{playerid};
		if ( gPlayerObjectEdit [ playerid ] ) DestroyDynamicObject ( gPlayerAttachedObjectBone [ playerid ] [ index ] ) ;
		else RemovePlayerAttachedObject(playerid, index);
		
		clear_editor ( playerid ) ;
	}
	else if ( gPlayerUsesEditor { playerid } == 2 )
	{
		new index = gPlayerChooseIndex{playerid};
		if ( gPlayerObjectEdit [ playerid ] == false )
		{
			create_object_id [ playerid ] = gPlayerAttachedObjectBone [ playerid ] [ index ] ;
			mobile_EditDynamicObject ( playerid, create_object_id [ playerid ], 2, gPlayerEditObjectTD [ playerid ] [ index ] [ 0 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 1 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 2 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 3 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 4 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 5 ] ) ;
		}
		else RemovePlayerAttachedObject ( playerid, index ) ;
		
		mobile_object_edit ( playerid, false, -1 ) ;
		edit_acc [ playerid ] = false ;
	}
	return 1 ;
}

stock editor_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	switch ( dialogid )
	{
		case AOE:
	    {
	    	if ( ! response )
	    		return 1 ;

	       	switch ( listitem )
			{
                case 0:
                {
					show_dialog(playerid, AOE_EDIT_OBJECT, DIALOG_STYLE_INPUT, "{"#cBHD"}Редактор", "{"#cWH"}Укажите ID объекта:\n\n{"#cGRDialog"}* Пример: {"#cBL"}372", "Выбор", "X");
					return 1 ;
                }
                case 1:
                {
                	show_dialog(playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация", "{FFFFFF}Добро пожаловать в {"#cBL"}редактор объектов{fFFFFF}.\nДля редактирования Вам доступно {"#cBL"}6{fFFFFF} координат:\n\n\
			    	{"#cBL"}-{FFFFFF} X, Y, Z: Редактирование позициии объекта;\n\
			    	{"#cBL"}-{FFFFFF} RX, RY, RZ: Редактирование угла объекта;\n\
			    	{"#cBL"}-{FFFFFF} Step: Изменяет шаг при редактировании объекта{"#cBL"}*{FFFFFF}.\n\
			    	Если Вы хотитет отменить либо сохранить изменение, нажмите {"#cBL"}Exit{FFFFFF}.\n\n\
			    	{"#cBL"}*{fFFFFF} К примеру у Вас шаг равен {"#cBL"}0.5{fFFFFF}. Тогда при нажатии на кнопки редактора, координата\n\
					Вашего объекта будет меняться на {"#cBL"}+/-0.5{fFFFFF}.", "Закрыть", "");
                	return 1 ;
                }
			}
	       	return 1 ;
	    }
		case AOE_EDIT_OBJECT:
	    {
	    	if ( ! response )
	    		return 1 ;

			new _value = strval ( inputtext ) ;
			if ( ! ( 0 <= _value <= 20000 ) )
			{
				show_dialog(playerid, AOE_EDIT_OBJECT, DIALOG_STYLE_INPUT, "{"#cBHD"}Редактор", "{"#cWH"}Укажите ID объекта:\n\n{"#cGRDialog"}* Пример: {"#cBL"}372", "Выбор", "X");
				return 1 ;
			}
			
			if ( player_device { playerid } == 2 ) { }
			else
			{
				create_type { playerid } = 10 ;
				create_object_id [ playerid ] = CreateDynamicObject ( _value, p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ], 0.0, 0.0, 0.0 ) ;
				EditDynamicObject ( playerid, create_object_id [ playerid ] ) ;
				return 1 ;
			}
			
			clear_editor ( playerid ) ;

			gPlayerChooseIndex { playerid } 	= 0 ;
			gPlayerUsesEditor { playerid }		= 1 ;
			gPlayerObjectEdit [ playerid ]		= true ;
			
			new _bone_id = gPlayerChooseIndex { playerid } ;
			gPlayerAttachedObjectModel [ playerid ] [ _bone_id ] = _value ;

			GetPlayerPos ( playerid, gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 0 ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 1 ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 2 ] ) ;
			
			gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 0 ] = gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 0 ] + 2 ;
			gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 1 ] = gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 1 ] + 2 ;
			gPlayerAttachedObjectBone [ playerid ] [ _bone_id ] = CreateDynamicObject ( _value, gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 0 ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 1 ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 2 ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 3 ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 4 ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 5 ] ) ;
			if ( _value == 2934 ) SetDynamicObjectMaterialText(gPlayerAttachedObjectBone [ playerid ] [ _bone_id ], 0, "Family Name", 130, "Ariel", 48, 1, 0xFFFFFAF0, 0x00000000, 1);
			update_player_to_object ( playerid ) ;

			editShow ( playerid, true ) ;
			updateEditScale ( playerid, gPlayerEditorStep [ playerid ] ) ;

			TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
	    	return 1 ;
	    }
		case AOED:
	    {
	    	if ( ! response )
	    		return 1 ;

	       	switch ( listitem )
			{
                case 0:
                {
					show_dialog ( playerid, AOED_EDIT_OBJECT, DIALOG_STYLE_INPUT, "{"#cBHD"}Редактор", "{"#cWH"}Укажите ID объекта и слот через запятую:\n\n{"#cBL"}1.{fFFFFF} Позвоночник\n{"#cBL"}2.{fFFFFF} Голова\n{"#cBL"}3.{fFFFFF} Левое плечо\n{"#cBL"}4.{fFFFFF} Правое плечо\n{"#cBL"}5.{fFFFFF} Левая рука\n{"#cBL"}6.{fFFFFF} Правая рука\n{"#cBL"}7.{fFFFFF} Левое предплечье\n{"#cBL"}8.{fFFFFF} Правое предплечье\n\n{"#cGRDialog"}* Пример: {"#cBL"}372, 1", "Выбор", "X");
					return 1 ;
                }
                case 1:
                {
                	show_dialog(playerid, AOED_EDITOR_INFO, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация", "{FFFFFF}Добро пожаловать в {"#cBL"}редактор аксессуаров{fFFFFF}.\nДля редактирования Вам доступно {"#cBL"}6{fFFFFF} координат:\n\n\
			    	{"#cBL"}-{FFFFFF} X, Y, Z: Редактирование позициии объекта;\n\
			    	{"#cBL"}-{FFFFFF} RX, RY, RZ: Редактирование угла объекта;\n\
			    	{"#cBL"}-{FFFFFF} Step: Изменяет шаг при редактировании объекта{"#cBL"}*{FFFFFF}.\n\
			    	Если Вы хотитет отменить либо сохранить изменение, нажмите {"#cBL"}Exit{FFFFFF}.\n\n\
			    	{"#cBL"}*{fFFFFF} К примеру у Вас шаг равен {"#cBL"}0.5{fFFFFF}. Тогда при нажатии на кнопки редактора, координата\n\
					Вашего акссесуара будет меняться на {"#cBL"}+/-0.5{fFFFFF}.", "Закрыть", "");
                	return 1 ;
                }
			}
	       	return 1 ;
	    }
	    case d_changes:
	    {
	    	if ( ! response )
	    		return 1 ;

	    	new
	    		index 	= gPlayerChooseIndex { playerid },
	    		model 	= gPlayerAttachedObjectModel [ playerid ] [ index ],
	    		bone 	= gPlayerAttachedObjectBone [ playerid ] [ index ] ;

			editHide ( playerid ) ;

			TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
			
	    	if ( IsPlayerAttachedObjectSlotUsed ( playerid, index ) )
				RemovePlayerAttachedObject ( playerid, index ) ;

	    	switch ( listitem )
	    	{
	    		case 0:
	    		{
	    			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"} Прикреплённый объект успешно сохранён!" ) ;

					if ( gPlayerObjectEdit [ playerid ] )
					{
						AOE_SaveObject ( playerid, index ) ;
						DestroyDynamicObject ( bone ) ;
					}
					else
					{
						AOE_SavePlayerAttachedObject ( playerid, index ) ;
						RemovePlayerAttachedObject ( playerid, index ) ;
					}
	    			return 1 ;
	    		}
	    		case 1:
	    		{
	    			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Параметры были успешно сброшены!" ) ;

					clear_editor ( playerid ) ;

					if ( gPlayerObjectEdit[playerid] ) gPlayerAttachedObjectBone [ playerid ] [ index ] = CreateDynamicObject ( model, gPlayerEditObjectTD [ playerid ] [ index ] [ 0 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 1 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 2 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 3 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 4 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 5 ] ) ;
					else hook_SetPlayerAttachedObject(playerid, index, model, bone, gPlayerAttachedObjectPos [ playerid ] [ index ] [ 0], gPlayerAttachedObjectPos [ playerid ] [ index ] [ 1], gPlayerAttachedObjectPos [ playerid ] [ index ] [ 2], gPlayerAttachedObjectPos [ playerid ] [ index ] [ 3], gPlayerAttachedObjectPos [ playerid ] [ index ] [ 4], gPlayerAttachedObjectPos [ playerid ] [ index ] [ 5], gPlayerAttachedObjectPos [ playerid ] [ index ] [ 6], gPlayerAttachedObjectPos [ playerid ] [ index ] [ 7], gPlayerAttachedObjectPos [ playerid ] [ index ] [ 8], .editor = true);
					return 1 ;
	    		}
				case 2:
				{
					if ( gPlayerObjectEdit[playerid] ) AOE_SaveObject ( playerid, index ) ;
					else AOE_SavePlayerAttachedObject ( playerid, index ) ;
				}
	    	}
	    	return 1 ;
	    }
	    case AOED_EDIT_OBJECT:
	    {
	    	if ( ! response )
	    		return 1 ;

			new _object_id, _bone_id ;
			if ( sscanf ( inputtext, "p<,>dd", _object_id, _bone_id ) )
			{
				show_dialog(playerid, AOED_EDIT_OBJECT, DIALOG_STYLE_INPUT, "{"#cBHD"}Редактор", "{"#cWH"}Укажите ID объекта и слот через запятую:\n\n{"#cGRDialog"}* Пример: {"#cBL"}372, 1", "Выбор", "X");
				return 1 ;
			}
			
			if ( ! ( 0 <= _bone_id <= 10 ) )
			{
				show_dialog(playerid, AOED_EDIT_OBJECT, DIALOG_STYLE_INPUT, "{"#cBHD"}Редактор", "{"#cWH"}Укажите ID объекта и слот через запятую:\n\n{"#cGRDialog"}* Пример: {"#cBL"}372, 1", "Выбор", "X");
				return 1 ;
			}
			
			if ( ! ( 0 <= _object_id <= 20000 ) )
			{
				show_dialog(playerid, AOED_EDIT_OBJECT, DIALOG_STYLE_INPUT, "{"#cBHD"}Редактор", "{"#cWH"}Укажите ID объекта и слот через запятую:\n\n{"#cGRDialog"}* Пример: {"#cBL"}372, 1", "Выбор", "X");
				return 1 ;
			}
			
			if ( player_device { playerid } == 2 ) { }
			else
			{
				SetPlayerAttachedObject ( playerid, 0, _object_id, _bone_id, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 ) ;
				EditAttachedObject ( playerid, 0 ) ;
				return 1 ;
			}
			
	    	if(IsPlayerAttachedObjectSlotUsed(playerid, _bone_id) || gPlayerAttachedObjectModel [ playerid ] [_bone_id])
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}В данном слоте у Вас уже есть объект!" ) ;			

			clear_editor ( playerid ) ;

			gPlayerChooseIndex { playerid } 	= _bone_id ;
			gPlayerUsesEditor { playerid }		= 1 ;
			gPlayerObjectEdit [ playerid ]		= false ;
			gPlayerAttachedObjectModel [ playerid ] [ _bone_id ] = _object_id ;
			gPlayerAttachedObjectBone [ playerid ] [ _bone_id ] = _bone_id ;
			
			gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 6 ] = gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 7 ] = gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 8 ] = 2.0 ;
			hook_SetPlayerAttachedObject(playerid, _bone_id, gPlayerAttachedObjectModel [ playerid ] [ _bone_id ], gPlayerAttachedObjectBone [ playerid ] [ _bone_id ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 0 ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 1 ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 2 ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 3 ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 4 ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 5 ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 6 ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 7 ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 8 ]);

			editShow ( playerid, true ) ;
			updateEditScale ( playerid, gPlayerEditorStep [ playerid ] ) ;

			TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
	    	return 1 ;
	    }
	    case AOED_EDITOR_INFO: return show_dialog(playerid, d_change_bone, DIALOG_STYLE_LIST, "{"#cBHD"}Изменить кость", "{"#cBL"}1.{fFFFFF} Позвоночник\n{"#cBL"}2.{fFFFFF} Голова\n{"#cBL"}3.{fFFFFF} Левое плечо\n{"#cBL"}4.{fFFFFF} Правое плечо\n{"#cBL"}5.{fFFFFF} Левая рука\n{"#cBL"}6.{fFFFFF} Правая рука\n{"#cBL"}7.{fFFFFF} Левое предплечье\n{"#cBL"}8.{fFFFFF} Правое предплечье", "Далее", "Отмена");
        case d_change_bone:
		{
			if ( ! response )
				return SelectTextDraw ( playerid, 0xB0C4DEFF ) ;

			new
				index = gPlayerChooseIndex{playerid};

			switch ( listitem )
			{
				case 0..5:
				{
					gPlayerAttachedObjectBone [ playerid ] [ index ] = listitem + 1;

					SetPlayerAttachedObject(playerid, index, gPlayerAttachedObjectModel [ playerid ] [ index ], gPlayerAttachedObjectBone [ playerid ] [ index ], gPlayerEditObjectTD [ playerid ] [ index ] [ 0 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 1 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 2 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 3 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 4 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 5 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 6 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 7 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 8 ]);

					SelectTextDraw ( playerid, 0xB0C4DEFF ) ;

					return 1 ;

				}
				case 6, 7:
				{

					gPlayerAttachedObjectBone [ playerid ] [ index ] = listitem + 9;

					SetPlayerAttachedObject(playerid, index, gPlayerAttachedObjectModel [ playerid ] [ index ], gPlayerAttachedObjectBone [ playerid ] [ index ], gPlayerEditObjectTD [ playerid ] [ index ] [ 0 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 1 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 2 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 3 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 4 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 5 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 6 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 7 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 8 ]);

					SelectTextDraw ( playerid, 0xB0C4DEFF ) ;

					return 1 ;
				}
			}

			return 1 ;
		}
	}
	return 0 ;
}

hook_SetPlayerAttachedObject(playerid, index, modelid, bone, Float:fOffsetX = 0.0, Float:fOffsetY = 0.0, Float:fOffsetZ = 0.0, Float:fRotX = 0.0, Float:fRotY = 0.0, Float:fRotZ = 0.0, Float:fScaleX = 1.0, Float:fScaleY = 1.0, Float:fScaleZ = 1.0, materialcolor1 = 0, materialcolor2 = 0, bool:editor = false)
{
	if(editor == false && gPlayerAttachedObjectModel [ playerid ] [ index ] == modelid)
    {
        SetPlayerAttachedObject(playerid, index, modelid, gPlayerAttachedObjectBone [ playerid ] [ index ], gPlayerAttachedObjectPos [ playerid ] [ index ] [ 0], gPlayerAttachedObjectPos [ playerid ] [ index ] [ 1], gPlayerAttachedObjectPos [ playerid ] [ index ] [ 2], gPlayerAttachedObjectPos [ playerid ] [ index ] [ 3], gPlayerAttachedObjectPos [ playerid ] [ index ] [ 4], gPlayerAttachedObjectPos [ playerid ] [ index ] [ 5], gPlayerAttachedObjectPos [ playerid ] [ index ] [ 6], gPlayerAttachedObjectPos [ playerid ] [ index ] [ 7], gPlayerAttachedObjectPos [ playerid ] [ index ] [ 8]);
        return 1 ;
    }
    
	gPlayerAttachedObjectModel [ playerid ] [ index ] 	= modelid;
	gPlayerAttachedObjectBone [ playerid ] [ index ]		= bone;

	gPlayerEditObjectTD [ playerid ] [ index ] [ 0 ]			=
	gPlayerAttachedObjectPos [ playerid ] [ index ] [ 0] 	= fOffsetX;

	gPlayerEditObjectTD [ playerid ] [ index ] [ 1 ]			=
	gPlayerAttachedObjectPos [ playerid ] [ index ] [ 1] 	= fOffsetY;

	gPlayerEditObjectTD [ playerid ] [ index ] [ 2 ]			=
	gPlayerAttachedObjectPos [ playerid ] [ index ] [ 2] 	= fOffsetZ;

	gPlayerEditObjectTD [ playerid ] [ index ] [ 3 ]			=
	gPlayerAttachedObjectPos [ playerid ] [ index ] [ 3]	= fRotX;

	gPlayerEditObjectTD [ playerid ] [ index ] [ 4 ]			=
	gPlayerAttachedObjectPos [ playerid ] [ index ] [ 4]	= fRotY;

	gPlayerEditObjectTD [ playerid ] [ index ] [ 5 ]			=
	gPlayerAttachedObjectPos [ playerid ] [ index ] [ 5]	= fRotZ;

	gPlayerEditObjectTD [ playerid ] [ index ] [ 6 ]			=
	gPlayerAttachedObjectPos [ playerid ] [ index ] [ 6]	= fScaleX;

	gPlayerEditObjectTD [ playerid ] [ index ] [ 7 ]			=
	gPlayerAttachedObjectPos [ playerid ] [ index ] [ 7]	= fScaleY;

	gPlayerEditObjectTD [ playerid ] [ index ] [ 8 ]			=
	gPlayerAttachedObjectPos [ playerid ] [ index ] [ 8]	= fScaleZ;

	SetPlayerAttachedObject(playerid, index, modelid, bone, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, materialcolor1, materialcolor2);

	return 1 ;
}

stock clear_editor ( playerid )
{
	for ( new i = 0 ; i < MAX_PLAYER_ATTACHED_OBJECTS ; i ++ )
	{
		gPlayerAttachedObjectBone [ playerid ] [ i ]			=
		gPlayerAttachedObjectModel [ playerid ] [ i ]			= 0;

		for ( new b = 0 ; b < 9 ; b ++ )
			gPlayerAttachedObjectPos [ playerid ] [ i ] [ b ] 	= gPlayerEditObjectTD [ playerid ] [ i ] [ b ] = 0.000;
	}

	gPlayerUsesEditor { playerid }				= 0 ;
	gPlayerEditorStep [ playerid ]  			= 0.05 ;
	
	gPlayerChooseIndex { playerid } 			= 0 ;
	gPlayerObjectClick { playerid } 			= 0 ;
	
	gPlayerEditSize [ playerid ]				= false ;
	return 1 ;
}

stock mobile_object_edit ( playerid, bool: status, object_model_id )
{
	if ( status )
	{
		if ( edit_acc [ playerid ] == false )
		{
			clear_editor ( playerid ) ;
			
			gPlayerChooseIndex { playerid }	= 0 ;
			gPlayerUsesEditor { playerid } 	= 2 ;
			
			new _bone_id = gPlayerChooseIndex { playerid } ;
			gPlayerObjectEdit [ playerid ] = true ;
			gPlayerAttachedObjectModel [ playerid ] [ _bone_id ] 	= object_model_id ;

			GetPlayerPos ( playerid, gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 0 ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 1 ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 2 ] ) ;

			gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 0 ] 	= gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 0 ] + 2 ;
			gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 1 ] 	= gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 1 ] + 2 ;
			gPlayerAttachedObjectBone [ playerid ] [ _bone_id ] 	= create_object_id [ playerid ] ;
			SetDynamicObjectPos ( gPlayerAttachedObjectBone [ playerid ] [ _bone_id ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 0 ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 1 ], gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 2 ] ) ;
			update_player_to_object ( playerid ) ;
			gPlayerObjectClick { playerid } = 0 ;
			gPlayerEditorStep [ playerid ] = 0.25 ;
			
			editShow ( playerid, false ) ;
			updateEditScale ( playerid, gPlayerEditorStep [ playerid ] ) ;

			TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
		}
		else
		{
			gPlayerChooseIndex { playerid } 						= object_model_id ;
			gPlayerUsesEditor { playerid } 							= 2 ;
			
			gPlayerObjectEdit [ playerid ]							= false ;
			
			editShow ( playerid, false ) ;
			updateEditScale ( playerid, gPlayerEditorStep [ playerid ] ) ;

			TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
		}
		return 1 ;                                                                                                        
	}
	else
	{
		gPlayerObjectEdit [ playerid ]	= false ;
		gPlayerUsesEditor { playerid }	= 0 ;
	}
	return 1 ;
}

stock mobile_object_edit_at ( playerid, object_model_id, Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz )
{
	mobile_object_edit ( playerid, true, object_model_id ) ;

	new _bone_id = gPlayerChooseIndex { playerid } ;
	gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 0 ] = x ;
	gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 1 ] = y ;
	gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 2 ] = z ;
	gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 3 ] = rx ;
	gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 4 ] = ry ;
	gPlayerEditObjectTD [ playerid ] [ _bone_id ] [ 5 ] = rz ;

	new _object = gPlayerAttachedObjectBone [ playerid ] [ _bone_id ] ;
	if ( IsValidDynamicObject ( _object ) )
	{
		SetDynamicObjectPos ( _object, x, y, z ) ;
		SetDynamicObjectRot ( _object, rx, ry, rz ) ;
	}
	return 1 ;
}

stock mobile_EditDynamicObject ( playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz )
{
	if ( ! objectid )
	{
		if ( ! IsValidDynamicObject ( objectid ) ) return 1 ;
		MoveDynamicObject ( objectid, x, y, z, 10.0, rx, ry, rz ) ;
	}

	#if defined m_house_object
		if ( h_OnPlayerEditDynamicObject ( playerid, response, x, y, z, rx, ry, rz ) ) return 1 ;
	#endif

	#if defined m_treasure
		if ( tr_OnPlayerEditDynamicObject ( playerid, response, x, y, z ) ) return 1 ;
	#endif

	if ( response == 1 )
	{
		if ( create_type { playerid } == 155 )
		{
			new Vehicle_ID = GetPlayerVehicleID ( playerid ) ;
			if ( IsPlayerInAnyVehicle ( playerid ) && veh_info [ Vehicle_ID - 1 ] [ v_taxi_object ] == objectid && p_t_info [ playerid ] [ time_job ] )
			{
				new Float:Object_Pos[3], Float:Object_Rot[3];
				GetDynamicObjectPos(objectid, Object_Pos[0], Object_Pos[1], Object_Pos[2]);
				GetDynamicObjectRot(objectid, Object_Rot[0], Object_Rot[1], Object_Rot[2]);
				if(floatabs(Object_Pos[2]-z) > 0.5 || floatcmp(Object_Rot[0], rx) != 0
				|| floatcmp(Object_Rot[1], ry) != 0 || floatcmp(Object_Rot[2], rz) != 0
				|| floatabs(Object_Pos[0]-x) > 5.0 || floatabs(Object_Pos[1]-y) > 5.0)
				{
					if(floatabs(Object_Pos[2]-z) > 0.5) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Нельзя так изменять высоту объекта." ) ;
					if(floatcmp(Object_Rot[0], rx) != 0 || floatcmp(Object_Rot[1], ry) != 0) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Нельзя поворачивать объект." ) ;
					if(floatabs(Object_Pos[0]-x) > 5.0 || floatabs(Object_Pos[1]-y) > 5.0) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Нельзя так перемещать объект." ) ;
				}
				else
				{
					new Float:Vehicle_Pos[4];
					GetVehiclePos(Vehicle_ID, Vehicle_Pos[0], Vehicle_Pos[1], Vehicle_Pos[2]);
					GetVehicleZAngle(Vehicle_ID, Vehicle_Pos[3]);
					AttachDynamicObjectToVehicle(objectid, Vehicle_ID, 0.0, -floatabs(Vehicle_Pos[1]-y), z-Vehicle_Pos[2], 0.0, 0.0, rz-Vehicle_Pos[3]);
					TogglePlayerControllable ( playerid, true ) ;
				}
				return 1 ;
			}
		}

	    if ( create_type { playerid } == 1 )
	    {
			switch ( GetPVarInt ( playerid, "TypeRadar" ) )
			{
				case 0: radar_info[radar_count][r_type] = 1, radar_info[radar_count][r_speed] = 20;
				case 1: radar_info[radar_count][r_type] = 2, radar_info[radar_count][r_speed] = 60;
				case 2: radar_info[radar_count][r_type] = 3, radar_info[radar_count][r_speed] = 110;
				case 3: radar_info[radar_count][r_type] = 4, radar_info[radar_count][r_speed] = 90;
			}
			radar_info [ radar_count ] [ r_id ] = radar_count ;

			radar_info [ radar_count ] [ r_x ] = x;
			radar_info [ radar_count ] [ r_y ] = y;
		 	radar_info [ radar_count ] [ r_z ] = z;
		 	radar_info [ radar_count ] [ r_rx ] = rx;
		 	radar_info [ radar_count ] [ r_ry ] = ry;
		 	radar_info [ radar_count ] [ r_rz ] = rz;

			DestroyDynamicObject ( create_object_id [ playerid ] ) ;
			radar_info [ radar_count ] [ r_object ] = CreateDynamicObject(18880, radar_info[radar_count][r_x], radar_info[radar_count][r_y], radar_info[radar_count][r_z], radar_info[radar_count][r_rx], radar_info[radar_count][r_ry], radar_info[radar_count][r_rz], 0, 0, -1, 300.0);

	        global_string [ 0 ] = EOS ;
			format(global_string, 144, "Радар {"#cBL3D"}№%d{"#cWH3D"}\n\nМакс. разрешенная скорость: {"#cBL3D"}%d{"#cWH3D"} км/ч", radar_count + 1, radar_info[radar_count][r_speed]);
			radar_info [ radar_count ] [ r_label ] = CreateDynamic3DTextLabel(global_string, col_white, radar_info[radar_count][r_x], radar_info[radar_count][r_y], radar_info[radar_count][r_z] + 4.0, 10.0);
	        radar_info [ radar_count ] [ r_area ] = CreateDynamicSphere ( radar_info [ radar_count ] [ r_x ], radar_info [ radar_count ] [ r_y ], radar_info [ radar_count ] [ r_z ], 20.0 ) ;
            area_info [ radar_info [ radar_count ] [ r_area ] ] [ a_type ] = area_type_radar ;

			create_type { playerid } = 0 ;
			create_object_id [ playerid ] = INVALID_OBJECT_ID ;
			DeletePVar(playerid, "TypeRadar");
			CancelEdit(playerid);

			format(global_string, 256, "INSERT INTO `radars` (`r_id`, `r_name`, `r_type`, `r_speed`, `r_x`, `r_y`, `r_z`, `r_rx`, `r_ry`, `r_rz`) VALUES (%i, '%s', %i, %i, '%f', '%f', '%f', '%f', '%f', '%f')",
			radar_count, p_info [ playerid ] [ name ], radar_info[radar_count][r_type], radar_info[radar_count][r_speed], radar_info[radar_count][r_x], radar_info[radar_count][r_y], radar_info[radar_count][r_z], radar_info[radar_count][r_rx], radar_info[radar_count][r_ry], radar_info[radar_count][r_rz]);
			mysql_tquery(sql_connection, global_string, "", "");
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Радар успешно создан." ) ;

			radar_count ++ ;
		}

		else if ( create_type { playerid } == 2 )
	    {
	        atm_info [ atm_count ] [ atm_id ] = atm_count + 1 ;

			atm_info [ atm_count ] [ atm_position ] [ 0 ] = x ;
			atm_info [ atm_count ] [ atm_position ] [ 1 ] = y ;
			atm_info [ atm_count ] [ atm_position ] [ 2 ] = z ;
			atm_info [ atm_count ] [ atm_position ] [ 3 ] = rx ;
			atm_info [ atm_count ] [ atm_position ] [ 4 ] = ry ;
			atm_info [ atm_count ] [ atm_position ] [ 5 ] = rz ;

            atm_info [ atm_count ] [ atm_text ] = CreateDynamic3DTextLabel ( "** Банкомат **\n{"#cGR3D"}Нажмите {"#cWH3D"}Y{"#cGR3D"} для взаимодействия", col_blue, atm_info [ atm_count ] [ atm_position ] [ 0 ], atm_info [ atm_count ] [ atm_position ] [ 1 ], atm_info [ atm_count ] [ atm_position ] [ 2 ], 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;
			atm_info [ atm_count ] [ atm_object ] = CreateDynamicObject ( object_atm, atm_info [ atm_count ] [ atm_position ] [ 0 ], atm_info [ atm_count ] [ atm_position ] [ 1 ], atm_info [ atm_count ] [ atm_position ] [ 2 ], atm_info [ atm_count ] [ atm_position ] [ 3 ], atm_info [ atm_count ] [ atm_position ] [ 4 ], atm_info [ atm_count ] [ atm_position ] [ 5 ], 0, 0, -1, 300.0, 300.0 ) ;
            //SetDynamicObjectMaterialText ( atm_info [ atm_count ] [ atm_object ], 2, "\nБанкомат\n \n \n \n \n ", OBJECT_MATERIAL_SIZE_256x256, "Tahoma", 48, 1, 0xFF000000, 0xFF87CEEB, OBJECT_MATERIAL_TEXT_ALIGN_CENTER ) ;
			//SetDynamicObjectMaterial ( atm_info [ atm_count ] [ atm_object ], 0, -1, "none", "none", 0xFFF0FFFF ) ;

			DestroyDynamicObject ( create_object_id [ playerid ] ) ;

			create_object_id [ playerid ] = INVALID_OBJECT_ID ;
			create_type { playerid } = 0 ;
			CancelEdit ( playerid ) ;

			atm_info [ atm_count ] [ atm_area ] = CreateDynamicSphere ( atm_info [ atm_count ] [ atm_position ] [ 0 ], atm_info [ atm_count ] [ atm_position ] [ 1 ], atm_info [ atm_count ] [ atm_position ] [ 2 ], 3.0, 0, 0, -1 ) ;
	    	area_info [ atm_info [ atm_count ] [ atm_area ] ] [ a_type ] = area_type_atm ;

			new query_string [ 256 ] ;
			mysql_format ( sql_connection, query_string, sizeof ( query_string ), "INSERT INTO `atm` ( `atm_id`, `atm_pos_x`, `atm_pos_y`, `atm_pos_z`, `atm_pos_xr`, `atm_pos_yr`, `atm_pos_zr` ) VALUES ( '%d', '%f', '%f', '%f', '%f', '%f', '%f' )", atm_info [ atm_count ] [ atm_id ], x, y, z, rx, ry, rz ) ;
			mysql_tquery ( sql_connection, query_string) ;

			atm_count ++ ;
		}

		else if ( create_type { playerid } == 3 )
	    {
	        bus_station [ bus_station_count ] [ b_id ] = bus_station_count + 1 ;

			bus_station [ bus_station_count ] [ b_position ] [ 0 ] = x ;
			bus_station [ bus_station_count ] [ b_position ] [ 1 ] = y ;
			bus_station [ bus_station_count ] [ b_position ] [ 2 ] = z ;
			bus_station [ bus_station_count ] [ b_position ] [ 3 ] = rx ;
			bus_station [ bus_station_count ] [ b_position ] [ 4 ] = ry ;
			bus_station [ bus_station_count ] [ b_position ] [ 5 ] = rz ;

			bus_station [ bus_station_count ] [ b_price ] = random ( 500 ) + 500 ;

			new station_string [ 178 ] ;
			format ( station_string, sizeof station_string, "** Автобусная остановка №%d **\n{"#cWH3D"}Нет ожидающих\n\n{"#cGR3D"}Будьте на остановке, чтобы проезжающие водители\n{"#cGR3D"}смогли подвезти Вас за вознаграждение.", bus_station [ bus_station_count ] [ b_id ] ) ;
			bus_station [ bus_station_count ] [ b_text ] = CreateDynamic3DTextLabel ( station_string, col_blue, bus_station [ bus_station_count ] [ b_position ] [ 0 ], bus_station [ bus_station_count ] [ b_position ] [ 1 ], bus_station [ bus_station_count ] [ b_position ] [ 2 ] + 2.0, 10.0 ) ;

			bus_station [ bus_station_count ] [ b_price ] = random ( 500 ) + 500 ;

			bus_station [ bus_station_count ] [ b_object ] = CreateDynamicObject ( object_bus_station, bus_station [ bus_station_count ] [ b_position ] [ 0 ],
									bus_station [ bus_station_count ] [ b_position ] [ 1 ],
									bus_station [ bus_station_count ] [ b_position ] [ 2 ],
									bus_station [ bus_station_count ] [ b_position ] [ 3 ],
									bus_station [ bus_station_count ] [ b_position ] [ 4 ],
									bus_station [ bus_station_count ] [ b_position ] [ 5 ] ) ;

			DestroyDynamicObject ( create_object_id [ playerid ] ) ;

			create_type { playerid } = 0 ;
			create_object_id [ playerid ] = INVALID_OBJECT_ID ;
			CancelEdit(playerid);

			new query_string [ 256 ] ;
			mysql_format ( sql_connection, query_string, sizeof ( query_string ), "INSERT INTO `bus_station` ( `b_id`, `b_pos_x`, `b_pos_y`, `b_pos_z`, `b_pos_rx`, `b_pos_ry`, `b_pos_rz` ) VALUES ( '%d', '%f', '%f', '%f', '%f', '%f', '%f' )", bus_station [ bus_station_count ] [ b_id ], x, y, z, rx, ry, rz ) ;
			mysql_tquery ( sql_connection, query_string) ;

			bus_station_count ++ ;
		}

		else if ( create_type { playerid } == 4 )
	    {
	       	new station_id = GetPVarInt ( playerid, "fam_id_select" ) ;
			bus_station [ station_id ] [ b_position ] [ 0 ] = x ;
			bus_station [ station_id ] [ b_position ] [ 1 ] = y ;
			bus_station [ station_id ] [ b_position ] [ 2 ] = z ;
			bus_station [ station_id ] [ b_position ] [ 3 ] = rx ;
			bus_station [ station_id ] [ b_position ] [ 4 ] = ry ;
			bus_station [ station_id ] [ b_position ] [ 5 ] = rz ;

			bus_station [ station_id ] [ b_price ] = random ( 500 ) + 500 ;

			new station_string [ 178 ] ;
			format ( station_string, sizeof station_string, "** Автобусная остановка №%d **\n{"#cWH3D"}Нет ожидающих\n\n{"#cGR3D"}Будьте на остановке, чтобы проезжающие водители\n{"#cGR3D"}смогли подвезти Вас за вознаграждение.", bus_station [ station_id ] [ b_id ] ) ;
			bus_station [ station_id ] [ b_text ] = CreateDynamic3DTextLabel ( station_string, col_blue, bus_station [ station_id ] [ b_position ] [ 0 ], bus_station [ station_id ] [ b_position ] [ 1 ], bus_station [ station_id ] [ b_position ] [ 2 ] + 2.0, 10.0 ) ;

			bus_station [ station_id ] [ b_price ] = random ( 500 ) + 500 ;

			bus_station [ station_id ] [ b_object ] = CreateDynamicObject ( object_bus_station, bus_station [ station_id ] [ b_position ] [ 0 ],
										bus_station [ station_id ] [ b_position ] [ 1 ],
										bus_station [ station_id ] [ b_position ] [ 2 ],
										bus_station [ station_id ] [ b_position ] [ 3 ],
										bus_station [ station_id ] [ b_position ] [ 4 ],
										bus_station [ station_id ] [ b_position ] [ 5 ] ) ;

			DestroyDynamicObject ( create_object_id [ playerid ] ) ;

			create_type { playerid } = 0 ;
			create_object_id [ playerid ] = INVALID_OBJECT_ID ;
			DeletePVar ( playerid, "fam_id_select" ) ;
			CancelEdit(playerid);

			new _sql_string [ 256 ] ;
			format ( _sql_string, sizeof _sql_string, "UPDATE `bus_station` SET `b_pos_x` = '%f', `b_pos_y` = '%f', `b_pos_z` = '%f', `b_pos_rx` = '%f', `b_pos_ry` = '%f', `b_pos_rz` = '%f' WHERE `b_id` = '%d' LIMIT 1",
			x, y, z, rx, ry, rz, bus_station [ station_id ] [ b_id ] ) ;
			mysql_tquery ( sql_connection, _sql_string, "", "" ) ;
		}

		else if ( create_type { playerid } == 5 )
	    {
	       	new station_id = GetPVarInt ( playerid, "fam_id_select" ) ;
			atm_info [ station_id ] [ atm_position ] [ 0 ] = x ;
			atm_info [ station_id ] [ atm_position ] [ 1 ] = y ;
			atm_info [ station_id ] [ atm_position ] [ 2 ] = z ;
			atm_info [ station_id ] [ atm_position ] [ 3 ] = rx ;
			atm_info [ station_id ] [ atm_position ] [ 4 ] = ry ;
			atm_info [ station_id ] [ atm_position ] [ 5 ] = rz ;
			
			atm_info [ station_id ] [ atm_text ] = CreateDynamic3DTextLabel ( "** Банкомат **\n{"#cGR3D"}Нажмите {"#cWH3D"}Y{"#cGR3D"} для взаимодействия", col_blue, atm_info [ station_id ] [ atm_position ] [ 0 ], atm_info [ station_id ] [ atm_position ] [ 1 ], atm_info [ station_id ] [ atm_position ] [ 2 ] + 0.5, 4.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;

			#if defined CRMP
			new _atm_object [ 2 ] = { -1, ... } ;
			if ( atm_info [ station_id ] [ atm_status ] == bank_integr_id [ 0 ] ) _atm_object [ 0 ] = object_atm_sber, _atm_object [ 1 ] = object_atm_sberc ;
			else if ( atm_info [ station_id ] [ atm_status ] == bank_integr_id [ 1 ] ) _atm_object [ 0 ] = object_atm_tinkoff, _atm_object [ 1 ] = -1 ;
			else if ( atm_info [ station_id ] [ atm_status ] == bank_integr_id [ 2 ] ) _atm_object [ 0 ] = object_atm_sber, _atm_object [ 1 ] = object_atm_sberc ;
					
			atm_info [ station_id ] [ atm_object ] [ 0 ] = CreateDynamicObject ( _atm_object [ 0 ], atm_info [ station_id ] [ atm_position ] [ 0 ], atm_info [ station_id ] [ atm_position ] [ 1 ], atm_info [ station_id ] [ atm_position ] [ 2 ], atm_info [ station_id ] [ atm_position ] [ 3 ], atm_info [ station_id ] [ atm_position ] [ 4 ], atm_info [ station_id ] [ atm_position ] [ 5 ], 0, 0, -1, 300.0, 300.0 ) ;
			if ( _atm_object [ 1 ] != -1 )
			{
				atm_info [ station_id ] [ atm_object ] [ 1 ] = CreateDynamicObject ( _atm_object [ 1 ], atm_info [ station_id ] [ atm_position ] [ 0 ], atm_info [ station_id ] [ atm_position ] [ 1 ], atm_info [ station_id ] [ atm_position ] [ 2 ], atm_info [ station_id ] [ atm_position ] [ 3 ], atm_info [ station_id ] [ atm_position ] [ 4 ], atm_info [ station_id ] [ atm_position ] [ 5 ], 0, 0, -1, 300.0, 300.0 ) ;
			}
			#endif

			#if defined SAMP
			atm_info [ station_id ] [ atm_object ] [ 0 ] = CreateDynamicObject ( object_atm, atm_info [ station_id ] [ atm_position ] [ 0 ], atm_info [ station_id ] [ atm_position ] [ 1 ], atm_info [ station_id ] [ atm_position ] [ 2 ], atm_info [ station_id ] [ atm_position ] [ 3 ], atm_info [ station_id ] [ atm_position ] [ 4 ], atm_info [ station_id ] [ atm_position ] [ 5 ], 0, 0, -1, 300.0, 300.0 ) ;
			SetDynamicObjectMaterialText ( atm_info [ station_id ] [ atm_object ], 2, "\nБанкомат\n \n \n \n \n ", OBJECT_MATERIAL_SIZE_256x256, "Tahoma", 48, 1, 0xFF000000, 0xFF87CEEB, OBJECT_MATERIAL_TEXT_ALIGN_CENTER ) ;
			SetDynamicObjectMaterial ( atm_info [ station_id ] [ atm_object ], 0, -1, "none", "none", 0xFFF0FFFF ) ;
			#endif

			DestroyDynamicObject ( create_object_id [ playerid ] ) ;

			create_type { playerid } = 0 ;
			create_object_id [ playerid ] = INVALID_OBJECT_ID ;
			DeletePVar ( playerid, "fam_id_select" ) ;
			CancelEdit ( playerid ) ;

			atm_info [ station_id ] [ atm_area ] = CreateDynamicSphere ( atm_info [ station_id ] [ atm_position ] [ 0 ], atm_info [ station_id ] [ atm_position ] [ 1 ], atm_info [ station_id ] [ atm_position ] [ 2 ], 3.0, 0, 0, -1 ) ;
	    	area_info [ atm_info [ station_id ] [ atm_area ] ] [ a_type ] = area_type_atm ;

			new _sql_string [ 256 ] ;
			format ( _sql_string, sizeof _sql_string, "UPDATE `atm` SET `atm_pos_x` = '%f', `atm_pos_y` = '%f', `atm_pos_z` = '%f', `atm_pos_xr` = '%f', `atm_pos_yr` = '%f', `atm_pos_zr` = '%f' WHERE `atm_id` = '%d' LIMIT 1",
			x, y, z, rx, ry, rz, atm_info [ station_id ] [ atm_id ] ) ;
			mysql_tquery ( sql_connection, _sql_string, "", "" ) ;
		}
	}
	if ( response == 2 )
	{
	    if ( create_type { playerid } == 1 )
	    {
			create_type { playerid } = 0 ;
			DeletePVar(playerid, "TypeRadar");
			DestroyDynamicObject ( create_object_id [ playerid ] ) ;
			create_object_id [ playerid ] = INVALID_OBJECT_ID ;
			CancelEdit(playerid);
		}

		else if ( create_type { playerid } == 2 )
   		{
			DestroyDynamicObject ( create_object_id [ playerid ] ) ;
			create_object_id [ playerid ] = INVALID_OBJECT_ID ;
			create_type { playerid } = 0 ;
			CancelEdit(playerid);
		}

		else if ( create_type { playerid } == 3 )
	    {
			DestroyDynamicObject ( create_object_id [ playerid ] ) ;
			create_object_id [ playerid ] = INVALID_OBJECT_ID ;
			create_type { playerid } = 0 ;
			CancelEdit(playerid);
		}

		else if ( create_type { playerid } == 4 )
	    {
			DestroyDynamicObject ( create_object_id [ playerid ] ) ;
			create_object_id [ playerid ] = INVALID_OBJECT_ID ;
			create_type { playerid } = 0 ;
			DeletePVar ( playerid, "fam_id_select" ) ;
			CancelEdit(playerid);
		}

		else if ( create_type { playerid } == 5 )
	    {
			DestroyDynamicObject ( create_object_id [ playerid ] ) ;
			create_object_id [ playerid ] = INVALID_OBJECT_ID ;
			create_type { playerid } = 0 ;
			DeletePVar ( playerid, "fam_id_select" ) ;
			CancelEdit(playerid);
		}
	}
	return 1 ;
}

stock AOE_SavePlayerAttachedObject ( playerid, index )
{
	global_string [ 0 ] = EOS ;
    format ( global_string, sizeof global_string, "[SAVED ATTACH PLAYER] %d, %d, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f", gPlayerAttachedObjectModel[playerid][index], gPlayerAttachedObjectBone[playerid][index],

	gPlayerEditObjectTD [ playerid ] [ index ] [ 0 ],
	gPlayerEditObjectTD [ playerid ] [ index ] [ 1 ],
	gPlayerEditObjectTD [ playerid ] [ index ] [ 2 ],

	gPlayerEditObjectTD [ playerid ] [ index ] [ 3 ],
	gPlayerEditObjectTD [ playerid ] [ index ] [ 4 ],
	gPlayerEditObjectTD [ playerid ] [ index ] [ 5 ],

	gPlayerEditObjectTD [ playerid ] [ index ] [ 6 ],
	gPlayerEditObjectTD [ playerid ] [ index ] [ 7 ],
	gPlayerEditObjectTD [ playerid ] [ index ] [ 8 ],
	gPlayerEditorScale [ playerid ] [ index ] ) ;
	
	printf ( global_string ) ;
	
	clear_editor ( playerid ) ;
	return 1 ;
}

stock AOE_SaveObject ( playerid, index )
{
	global_string [ 0 ] = EOS ;
    format ( global_string, sizeof global_string, "[SAVED OBJECT] %d, %d, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f", gPlayerAttachedObjectModel[playerid][index], gPlayerAttachedObjectBone[playerid][index],

	gPlayerEditObjectTD [ playerid ] [ index ] [ 0 ],
	gPlayerEditObjectTD [ playerid ] [ index ] [ 1 ],
	gPlayerEditObjectTD [ playerid ] [ index ] [ 2 ],

	gPlayerEditObjectTD [ playerid ] [ index ] [ 3 ],
	gPlayerEditObjectTD [ playerid ] [ index ] [ 4 ],
	gPlayerEditObjectTD [ playerid ] [ index ] [ 5 ] ) ;
	
	printf ( global_string ) ;
	
	clear_editor ( playerid ) ;
	return 1 ;
}

stock update_player_to_object ( playerid ) 
{
	GetPlayerPos ( playerid, p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ] ) ;
	GetPlayerFacingAngle ( playerid, p_t_info [ playerid ] [ p_pos ] [ 3 ] ) ;
	
	set_pos ( playerid, p_t_info [ playerid ] [ p_pos ] [ 0 ] + 0.01, p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ], p_t_info [ playerid ] [ p_pos ] [ 3 ], GetPlayerInterior ( playerid ), GetPlayerVirtualWorld ( playerid ) ) ;
	return 1 ;
}

new EditTickCount [ MAX_PLAYERS ] ;
stock show_packet_edit_object ( playerid, _param )
{
	if ( _param >= 0 && _param <= 7 )
	{
		if ( ( _param >= 0 && _param <= 2 ) && ( gPlayerObjectClick { playerid } > 2 ) )
			gPlayerEditorStep [ playerid ] = gPlayerObjectEdit [ playerid ] ? 0.25 : 0.01 ;
		
		else if ( ( _param >= 3 && _param <= 5 ) && ( gPlayerObjectClick { playerid } < 3 || gPlayerObjectClick { playerid } > 5 ) )
			gPlayerEditorStep [ playerid ] = 2.0 ;
		
		gPlayerObjectClick { playerid } = _param ;
		if ( _param == 7 ) updateEditScale ( playerid, gPlayerEditorStep [ playerid ] ) ;
	}
	else if ( _param == 200 )
	{
		if ( GetTickCount ( ) - EditTickCount [ playerid ] < 100 ) return 1 ;
		EditTickCount [ playerid ] = GetTickCount ( ) ;
		
		new Float: step = gPlayerEditorStep [ playerid ], 
			_id = gPlayerObjectClick { playerid },
			index = gPlayerChooseIndex { playerid }, 
			model = gPlayerAttachedObjectModel [ playerid ] [ index ],
			bone = gPlayerAttachedObjectBone [ playerid ] [ index ] ;
			
		if ( _id == 7 )
		{
			if ( gPlayerEditorStep [ playerid ] <= 0.0 )
			{
				gPlayerEditorStep [ playerid ] = 0.0 ;
				return 1 ;
			}
			if ( gPlayerEditorStep [ playerid ] <= 0.1 ) gPlayerEditorStep [ playerid ] -= 0.01 ;
			else gPlayerEditorStep [ playerid ] -= 0.1 ;
			updateEditScale ( playerid, gPlayerEditorStep [ playerid ] ) ;
			return 1 ;
		}
		else if ( _id == 6 )
		{
			gPlayerEditorScale [ playerid ] [ index ] -= 0.05 ;

			if ( gPlayerEditorScale [ playerid ] [ index ] >= 0.5 ) gPlayerEditorScale [ playerid ] [ index ] = 0.5 ;
			else
			{
				gPlayerEditObjectTD [ playerid ] [ index ] [ 6 ]	-= 0.05 ;
				gPlayerEditObjectTD [ playerid ] [ index ] [ 7 ]	-= 0.05 ;
				gPlayerEditObjectTD [ playerid ] [ index ] [ 8 ]	-= 0.05 ;
			}

			if ( gPlayerObjectEdit [ playerid ] )
			{
				DestroyDynamicObject ( bone ) ;
				gPlayerAttachedObjectBone [ playerid ] [ index ] = CreateDynamicObject ( model, gPlayerEditObjectTD [ playerid ] [ index ] [ 0 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 1 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 2 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 3 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 4 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 5 ] ) ;
				update_player_to_object ( playerid ) ;
			}
			else
			{
				RemovePlayerAttachedObject ( playerid, index ) ;
				SetPlayerAttachedObject(playerid, index, model, bone, gPlayerEditObjectTD [ playerid ] [ index ] [ 1 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 2 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 0 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 3 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 4 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 5 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 6 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 7 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 8 ]);
			}
			return 1 ;
		}
		if ( gPlayerObjectEdit [ playerid ] && ( _id == 1 || _id == 2 ) ) _id = 3 - _id ;
		gPlayerEditObjectTD [ playerid ] [ index ] [ _id ] -= step ;

		if ( gPlayerObjectEdit [ playerid ] )
		{
			SetDynamicObjectPos ( bone, gPlayerEditObjectTD [ playerid ] [ index ] [ 0 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 1 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 2 ] ) ;
			SetDynamicObjectRot ( bone, gPlayerEditObjectTD [ playerid ] [ index ] [ 3 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 4 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 5 ] ) ;
		}
		else
		{
			RemovePlayerAttachedObject ( playerid, index ) ;
			SetPlayerAttachedObject ( playerid, index, model, bone, gPlayerEditObjectTD [ playerid ] [ index ] [ 1 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 2 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 0 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 3 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 4 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 5 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 6 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 7 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 8 ] ) ;
		}
	}
	else if ( _param == 201 )
	{
		if ( GetTickCount ( ) - EditTickCount [ playerid ] < 100 ) return 1 ;
		EditTickCount [ playerid ] = GetTickCount ( ) ;
		
		new Float: step = gPlayerEditorStep [ playerid ], 
			_id = gPlayerObjectClick { playerid },
			index = gPlayerChooseIndex { playerid }, 
			model = gPlayerAttachedObjectModel [ playerid ] [ index ],
			bone = gPlayerAttachedObjectBone [ playerid ] [ index ] ;
			
		if ( _id == 7 )
		{
			if ( gPlayerEditorStep [ playerid ] >= 5.0 )
			{
				gPlayerEditorStep [ playerid ] = 5.0 ;
				return 1 ;
			}
			if ( gPlayerEditorStep [ playerid ] <= 0.1 ) gPlayerEditorStep [ playerid ] += 0.01 ;
			else gPlayerEditorStep [ playerid ] += 0.1 ;
			updateEditScale ( playerid, gPlayerEditorStep [ playerid ] ) ;
			return 1 ;
		}
		else if ( _id == 6 )
		{
			gPlayerEditorScale [ playerid ] [ index ] -= 0.05 ;

			if ( gPlayerEditorScale [ playerid ] [ index ] >= 0.5 ) gPlayerEditorScale [ playerid ] [ index ] = 0.5 ;
			else
			{
				gPlayerEditObjectTD [ playerid ] [ index ] [ 6 ]	+= 0.05 ;
				gPlayerEditObjectTD [ playerid ] [ index ] [ 7 ]	+= 0.05 ;
				gPlayerEditObjectTD [ playerid ] [ index ] [ 8 ]	+= 0.05 ;
			}

			if ( gPlayerObjectEdit [ playerid ] )
			{
				DestroyDynamicObject ( bone ) ;
				gPlayerAttachedObjectBone [ playerid ] [ index ] = CreateDynamicObject ( model, gPlayerEditObjectTD [ playerid ] [ index ] [ 0 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 1 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 2 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 3 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 4 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 5 ] ) ;
				update_player_to_object ( playerid ) ;
			}
			else
			{
				RemovePlayerAttachedObject ( playerid, index ) ;
				SetPlayerAttachedObject(playerid, index, model, bone, gPlayerEditObjectTD [ playerid ] [ index ] [ 1 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 2 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 0 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 3 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 4 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 5 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 6 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 7 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 8 ]);
			}
			return 1 ;
		}
		if ( gPlayerObjectEdit [ playerid ] && ( _id == 1 || _id == 2 ) ) _id = 3 - _id ;
		gPlayerEditObjectTD [ playerid ] [ index ] [ _id ] += step ;

		if ( gPlayerObjectEdit [ playerid ] )
		{
			SetDynamicObjectPos ( bone, gPlayerEditObjectTD [ playerid ] [ index ] [ 0 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 1 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 2 ] ) ;
			SetDynamicObjectRot ( bone, gPlayerEditObjectTD [ playerid ] [ index ] [ 3 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 4 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 5 ] ) ;
		}
		else
		{
			RemovePlayerAttachedObject ( playerid, index ) ;
			SetPlayerAttachedObject ( playerid, index, model, bone, gPlayerEditObjectTD [ playerid ] [ index ] [ 1 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 2 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 0 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 3 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 4 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 5 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 6 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 7 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 8 ] ) ;
		}
	}
	else if ( _param == 202 )
	{
		if ( gPlayerUsesEditor { playerid } == 1 )
		{
			new index = gPlayerChooseIndex { playerid } ;
			if ( gPlayerObjectEdit [ playerid ] ) DestroyDynamicObject ( gPlayerAttachedObjectBone [ playerid ] [ index ] ) ;
			else RemovePlayerAttachedObject(playerid, index);
			
			clear_editor ( playerid ) ;
		}
		else if ( gPlayerUsesEditor { playerid } == 2 )
		{
			new index = gPlayerChooseIndex { playerid } ;
			if ( gPlayerObjectEdit [ playerid ] == true )
			{
				create_object_id [ playerid ] = gPlayerAttachedObjectBone [ playerid ] [ index ] ;
				mobile_EditDynamicObject ( playerid, create_object_id [ playerid ], 2, gPlayerEditObjectTD [ playerid ] [ index ] [ 0 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 1 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 2 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 3 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 4 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 5 ] ) ;
			}
			else RemovePlayerAttachedObject ( playerid, index ) ;
			
			mobile_object_edit ( playerid, false, -1 ) ;
			edit_acc [ playerid ] = false ;
		}
		editHide ( playerid ) ;

		TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
	}
	else if ( _param == 203 )
	{
		if ( gPlayerUsesEditor { playerid } == 1 )
		{
			show_dialog ( playerid, d_changes, DIALOG_STYLE_LIST, "{"#cBHD"}Редактор", "{"#cBL"}1.{fFFFFF} Сохранить параметры\n{"#cBL"}2.{FFFFFF} Сбросить параметры\n{"#cBL"}3.{FFFFFF} Сохранить и оставить на месте", "Далее", "Закрыть" ) ;
		}
		else if ( gPlayerUsesEditor { playerid } == 2 )
		{
			if ( gPlayerObjectEdit [ playerid ] == false )
			{
				new _acc_listitem = get_player_use_listitem ( playerid ), index = gPlayerChooseIndex { playerid } ;
				acc_player [ playerid ] [ acc_object_x ] [ _acc_listitem ] = gPlayerEditObjectTD [ playerid ] [ index ] [ 1 ] ;
				acc_player [ playerid ] [ acc_object_y ] [ _acc_listitem ] = gPlayerEditObjectTD [ playerid ] [ index ] [ 2 ] ;
				acc_player [ playerid ] [ acc_object_z ] [ _acc_listitem ] = gPlayerEditObjectTD [ playerid ] [ index ] [ 0 ] ;

				acc_player [ playerid ] [ acc_rot_x ] [ _acc_listitem ] = gPlayerEditObjectTD [ playerid ] [ index ] [ 3 ] ;
				acc_player [ playerid ] [ acc_rot_y ] [ _acc_listitem ] = gPlayerEditObjectTD [ playerid ] [ index ] [ 4 ] ;
				acc_player [ playerid ] [ acc_rot_z ] [ _acc_listitem ] = gPlayerEditObjectTD [ playerid ] [ index ] [ 5 ] ;

				save_accesories ( playerid, _acc_listitem ) ;
					
				SendClientMessage ( playerid, col_gray, !"{"#cBInfo"}* {"#cGRInfo"}Вы изменили положение аксессуара на своем персонаже." ) ;

				edit_acc [ playerid ] = false ;
			}
			else 
			{
				new index = gPlayerChooseIndex { playerid } ;
				create_object_id [ playerid ] = gPlayerAttachedObjectBone [ playerid ] [ index ] ;
				mobile_EditDynamicObject ( playerid, create_object_id [ playerid ], 1, gPlayerEditObjectTD [ playerid ] [ index ] [ 0 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 1 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 2 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 3 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 4 ], gPlayerEditObjectTD [ playerid ] [ index ] [ 5 ] ) ;
			}
			editHide ( playerid ) ;

			TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
		}
	}
	return 1 ;
}