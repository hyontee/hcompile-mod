#define MAX_JOBS_INFORMATION	4
#define MAX_JOBS_STRUCTURE 		10
enum JOBS_STRUCTURE
{
	JOB_NAME [ 32 ],
	JOB_DESCRIPTION [ 144 ],
	JOB_PROGRESS,
	Float: JOB_PICKUP_VEHICLE [ 3 ],
	Float: JOB_VEHICLE_SPAWN [ 4 ],
	JOB_PICKUP
} ;
new jobs_structure [ MAX_JOBS_STRUCTURE ] [ JOBS_STRUCTURE ] ;
new jobs_information [ MAX_JOBS_STRUCTURE ] [ MAX_JOBS_INFORMATION ] [ 256 ] ;

//========================================================================================================================================
#include									"modules/other/jobs/taxi/m_taxi.pwn"
//========================================================================================================================================
#include									"modules/other/jobs/truck/m_trucker.pwn"
//========================================================================================================================================

callback: OnLoadJobsInfo ( playerid, bool: status )
{
    if ( ! status )
    {
        static const _str [ ] = "SELECT * FROM users_jobs WHERE u_sql_id = %d LIMIT 1" ;
        new query_string [ sizeof _str + 9 ] ;
        format ( query_string, sizeof query_string, _str, p_info [ playerid ] [ id ] ) ;
        mysql_tquery ( sql_connection, query_string, "OnLoadJobsInfo", "ii", playerid, true ) ;
    }
    else
    {
        new rows, fields ;
        cache_get_data ( rows, fields ) ;

        if ( ! rows )
        {
            new query_string [ 64 ] ;
            format ( query_string, sizeof query_string, "INSERT INTO users_jobs (u_sql_id) VALUES (%d)", p_info [ playerid ] [ id ] ) ;
            mysql_tquery ( sql_connection, query_string ) ;

            p_info [ playerid ] [ taxi_skill ] = 
            p_info [ playerid ] [ taxi_progress ] = 
			p_info [ playerid ] [ truck_skill ] = 0 ;
        }
        else
        {
            p_info [ playerid ] [ taxi_skill ] = cache_get_field_content_int ( 0, "u_taxi_skill" ) ;
            p_info [ playerid ] [ taxi_progress ] = cache_get_field_content_int ( 0, "u_taxi_progress" ) ;
			p_info [ playerid ] [ truck_skill ] = cache_get_field_content_int ( 0, "u_truck_skill" ) ;
        }
    }
    return 1 ;
}

stock showJobsDialog ( playerid, jobId )
{
	set_player_use_listitem ( playerid, jobId ) ;

	new jobLevel = 0, jobProgress = 0, jobMax = 0 ;
	if ( jobId == job_taxi )
	{
		if ( p_info [ playerid ] [ taxi_skill ] < MAX_TAXI_LEVEL ) jobLevel = p_info [ playerid ] [ taxi_skill ] + 1 ;
		else jobLevel = -1 ;
		jobProgress = p_info [ playerid ] [ taxi_progress ] ;
		jobMax = MAX_TAXI_PROGRESS ;
	}
	else jobLevel = -1 ;

	new Node: node = JSON_Object (
		"name",			JSON_String ( jobs_structure [ jobId ] [ JOB_NAME ] ),
		"desc",			JSON_String ( jobs_structure [ jobId ] [ JOB_DESCRIPTION ] ),
		"level",		JSON_Int ( jobLevel ),
		"progress",		JSON_Int ( jobProgress ),
		"max",			JSON_Int ( jobMax )
	) ;

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_DIALOG_JOBS, 0, global_string ) ;

	showJobsDialogParams ( playerid, jobId ) ;
	return true ;
}

stock showJobsDialogParams ( playerid, jobId )
{
	new Node: node = JSON_Array ( ) ;
	for ( new i = 0, Node: infoNode ; i < MAX_JOBS_INFORMATION ; i ++ )
	{
		if ( GetString ( jobs_information [ jobId ] [ i ], "null" ) ) continue ;

		infoNode = JSON_Array (
			JSON_String ( jobs_information [ jobId ] [ i ] )
		) ;

		node = JSON_Append ( node, infoNode ) ;
	}

	global_string [ 0 ] = EOS ;
	JSON_Stringify ( node, global_string, sizeof global_string ) ;
	onServerSendData ( playerid, UI_DIALOG_JOBS, 1, global_string ) ;
	return true ;
}

stock packetDialogJobs ( playerid, actionId, data [ ] )
{
	#pragma unused data
	if ( actionId == 0 )
	{
		new jobId = get_player_use_listitem ( playerid ) ;
		if ( p_info [ playerid ] [ job ] != jobId )
		{
			send_check_cinfo ( playerid, "Вы не трудоустроены на работу! Устроиться можно в Мэрии.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
        	return true ;
		}

		if ( jobId == job_taxi ) showTaxiWindow ( playerid, -1 ) ;

		onServerDestroy ( playerid, UI_DIALOG_JOBS ) ;
	}
	else if ( actionId == 1 )
	{

	}
	return true ;
}

stock jobs_OnGameModeInit ( )
{
	taxi_OnGameModeInit ( ) ;

	mysql_tquery ( sql_connection, !"SELECT * FROM jobs_structure", "LoadJobsStructure", "" ) ;
	return true ;
}

callback: LoadJobsStructure ( )
{
	new rows, fields, time = GetTickCount ( ) ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return false ;

	for ( new i = 0 ; i < rows ; i ++ )
	{
		new jobId = cache_get_field_content_int ( i, "job_id", sql_connection ) ;
		cache_get_field_content ( i, "job_name", jobs_structure [ jobId ] [ JOB_NAME ], sql_connection ) ;
		cache_get_field_content ( i, "job_description", jobs_structure [ jobId ] [ JOB_DESCRIPTION ], sql_connection ) ;
		jobs_structure [ jobId ] [ JOB_PROGRESS ] = cache_get_field_content_int ( i, "job_progress", sql_connection ) ;

		new sscanf_delimit [ 256 ] ;
		cache_get_field_content ( i, "job_pickup_vehicle", sscanf_delimit, sql_connection, 48 ) ;
		sscanf ( sscanf_delimit, "p<|>fff",
		jobs_structure [ jobId ] [ JOB_PICKUP_VEHICLE ] [ 0 ], jobs_structure [ jobId ] [ JOB_PICKUP_VEHICLE ] [ 1 ],
		jobs_structure [ jobId ] [ JOB_PICKUP_VEHICLE ] [ 2 ] ) ;

		cache_get_field_content ( i, "job_vehicle_spawn", sscanf_delimit, sql_connection, 48 ) ;
		sscanf ( sscanf_delimit, "p<|>ffff",
		jobs_structure [ jobId ] [ JOB_VEHICLE_SPAWN ] [ 0 ], jobs_structure [ jobId ] [ JOB_VEHICLE_SPAWN ] [ 1 ],
		jobs_structure [ jobId ] [ JOB_VEHICLE_SPAWN ] [ 2 ], jobs_structure [ jobId ] [ JOB_VEHICLE_SPAWN ] [ 3 ] ) ;

		cache_get_field_content ( i, "job_information", sscanf_delimit, sql_connection, 256 ) ;
		sscanf ( sscanf_delimit, "p<|>s[64]s[64]s[64]s[64]",
		jobs_information [ jobId ] [ 0 ], jobs_information [ jobId ] [ 1 ],
		jobs_information [ jobId ] [ 2 ], jobs_information [ jobId ] [ 3 ] ) ;

		sscanf_delimit [ 0 ] = EOS ;
		format ( sscanf_delimit, sizeof sscanf_delimit, "** Парковка **\n{"#cWH"}%s\n\n{"#cGR3D"}Используйте {"#cWH"}/stoprent {"#cGR3D"}для сдачи т/с", jobs_structure [ jobId ] [ JOB_NAME ] ) ;
		CreateDynamic3DTextLabel ( sscanf_delimit, col_header_3d, jobs_structure [ jobId ] [ JOB_PICKUP_VEHICLE ] [ 0 ], jobs_structure [ jobId ] [ JOB_PICKUP_VEHICLE ] [ 1 ], jobs_structure [ jobId ] [ JOB_PICKUP_VEHICLE ] [ 2 ] + 1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0 ) ; 
	
		jobs_structure [ jobId ] [ JOB_PICKUP ] = CreateDynamicPickup ( 1239, 23, jobs_structure [ jobId ] [ JOB_PICKUP_VEHICLE ] [ 0 ], jobs_structure [ jobId ] [ JOB_PICKUP_VEHICLE ] [ 1 ], jobs_structure [ jobId ] [ JOB_PICKUP_VEHICLE ] [ 2 ], 0, 0, -1 ) ;
		pick_info [ jobs_structure [ jobId ] [ JOB_PICKUP ] ] [ pick_type ] = pick_type_jobs_vehicle ;
		pick_info [ jobs_structure [ jobId ] [ JOB_PICKUP ] ] [ pick_item ] = jobId ;
	}

	printf ( "[SERVER] Загружено %d информации о работах. (%d ms)", rows, GetTickCount ( ) - time ) ;
	return true ;
}

stock jobs_DynamicPickup ( playerid, pickupid )
{
	switch ( pick_info [ pickupid ] [ pick_type ] )
	{
		case pick_type_jobs_vehicle:
		{
			new jobId = pick_info [ pickupid ] [ pick_item ] ;
			showJobsDialog ( playerid, jobId ) ;
			return true ;
		}
	}
	return false ;
}