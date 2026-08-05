stock CreateObjectEx(modelid, Float:X, Float:Y, Float:Z, Float:rX, Float:rY, Float:rZ, Float:DrawDistance = 0.0) {
	TotalObject++;
	if(TotalObject>490) {
		printf ("TotalObject: %d",TotalObject) ;
	}
	return CreateObject(modelid, X,  Y,  Z,  rX, rY,  rZ, DrawDistance);
}
#define CreateObject CreateObjectEx
public OnDynamicObjectMoved(objectid) {
/* 	for(new id = 0; id < MAX_OBJECT_MOVED; id++) {
		if(objectid == moved_info[id][moved_id] && moved_info[id][status_moved]) {
			moved_info[id][status_moved]=false;
			SetTimerEx("CheckObjectBarrier", 6000, 0, "i", id);
			return 1;
		}
	} */
	if(GetGVarType("WoodConv",objectid) == 1) {
    	DeleteGVar("WoodConv",objectid);
    	DestroyDynamicObject(objectid);
		new rand = Random(10,15);
		woodsklad += rand;
		new string[72];
		format(string,sizeof(string),"Древесины на складе: "ORANGE"%d кг",woodsklad);
		UpdateDynamic3DTextLabelText(wood_3dtext,-1,string);
    }
    for(new id = 0; id < sizeof(pickup_game_golod_2); id++) {
	    if(objectid == objgolod[id]) {
	    	DestroyDynamicObject(objectid);
	    	objgolod[id] = -1;
	    	pickups_game_golod_2[id] = CreateDynamicPickup(11745,23,pickup_game_golod_2[id][0],pickup_game_golod_2[id][1],pickup_game_golod_2[id][2],-1,-1);
	    }
	}
	for(new i = 0; i < sizeof(object_park_ls); i++) {
	    if(objectid == object_park_ls[i]) {
		    if(status_restore_check_job_mower[i] == false) {
		    	MoveDynamicObject(object_park_ls[i],check_job_mower[i][0], check_job_mower[i][1], check_job_mower[i][2],0.001,
				    	check_job_mower[i][3], check_job_mower[i][4], check_job_mower[i][5]);
	    		status_restore_check_job_mower[i] = true;
			}
			else {
			    status_check_job_mower[i] = false;
	            status_restore_check_job_mower[i] = false;
				/*
	            if(i <= 32) check_taxi_park--;
				if(i <= 79) check_verona_beach--;
				if(i > 79 && i <= 138) check_white_house--;
				if(i > 138 && i <= 176) check_medic_ls--;
				if(i > 176 && i <= 273) check_glenpark_1--;
				if(i > 273) check_glenpark_2--;
				*/
				if(i <= 47) check_verona_beach--;
				if(i > 47 && i <= 106) check_white_house--;
				if(i > 106 && i <= 144) check_medic_ls--;
				if(i > 144 && i <= 240) check_glenpark_1--;
				if(i > 240) check_glenpark_2--;
			}
		}
	}
	return 1;
}