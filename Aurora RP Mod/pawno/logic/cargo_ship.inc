
#if defined _cargo_ship_inc
	#endinput
#endif
#define _cargo_ship_inc

#define _cargo_ship_debug

#define CARGO_CONTAINER_MIN_BOX		(15)
#define CARGO_CONTAINER_MAX_BOX		(25)
// (Всего: 16 контейнеров) 25 * 16 = (400 шт.)

#define CARGO_SHIP_CONTAINER_CHANCE	(65) // (%)
#define CARGO_FIND_SCRAP_CHANCE		(70) // (%)

#define CARGO_SHIP_MIN_TIMER		(1800 + 3600) // 1,5 h.
#define CARGO_SHIP_MAX_TIMER		(3 * 3600) // 3 h.

#define CARGO_SHIP_DISTANCE			(Float:700.0)
#define CARGO_SHIP_MOVING_SPEED		(Float:10.0)
// [13:10:29] start [13:12:07] end => [98 sec = 01:38]

#define MAX_CARGO_CONTAINER			(8 * 2)

enum {
	CARGO_SHIP_STATUS_NONE = 0, // (не создан)
	CARGO_SHIP_STATUS_CREATED, // (создан)
	CARGO_SHIP_STATUS_MOVING, // (в движении)
	CARGO_SHIP_STATUS_ARRIVED, // (прибыл к порту)
}
enum CARGO_SHIP_ATTACH_e {
	attachModel,
	Float:attachPos[6],
}
static const CargoShipAttachPosition[][CARGO_SHIP_ATTACH_e] = {
	{ /*01*/3724, {-16.739013, 0.158935, 15.672492, -0.000007, 0.000000, 0.000000} },
	{ /*02*/3724, {64.781005, 0.158935, 15.742523, 0.000007, 0.000000, 179.999938} },
	{ /*03*/5155, {-65.398925, -0.020996, 10.352500, -0.000007, 0.000000, 0.000000} },
	{ /*04*/5167, {-51.928955, -0.010986, -3.663124, -0.000007, 0.000000, 0.000000} },
	{ /*05*/5154, {23.961181, 0.098876, 4.790000, -0.000007, 0.000000, 0.000000} },
	{ /*06*/5157, {108.891113, -0.000976, 6.063400, -0.000007, 0.000000, 0.000000} },
	{ /*07*/3109, {-49.534423, -10.947265, 1.194099, 0.000007, 0.000000, 179.999954} },
	{ /*08*/2932, {45.782958, -14.627441, 1.502807, 0.000000, 0.000007, 89.999969} },
	{ /*09*/2932, {2.271240, 14.942382, 1.502807, 0.000000, 0.000007, 89.999969} },
	{ /*10*/5166, {55.691162, -8.091064, -5.694374, -0.000007, 0.000000, 0.000000} },
	{ /*11*/5160, {55.691162, -8.091064, -5.694374, -0.000007, 0.000000, 0.000000} },
	{ /*12*/5158, {-89.398925, -0.270996, 1.032196, 0.000000, 0.000007, 89.999969} },
	{ /*13*/2932, {-33.036132, -4.630126, 1.548995, -0.000014, 0.000000, 0.000015} },
	{ /*14*/2932, {-33.036132, 3.822021, 1.548995, 0.000014, 0.000000, 179.999923} },
	{ /*15*/2932, {-24.245361, -4.630126, 1.548995, -0.000021, 0.000000, 0.000038} },
	{ /*16*/2932, {-24.245361, 3.822021, 1.548995, 0.000021, 0.000000, 179.999908} },
	{ /*17*/2932, {2.003906, -4.630126, 1.548995, -0.000029, 0.000000, 0.000061} },
	{ /*18*/2932, {2.003906, 3.822021, 1.548995, 0.000029, 0.000000, 179.999877} },
	{ /*19*/2932, {10.886230, -4.630126, 1.548995, -0.000044, 0.000000, 0.000106} },
	{ /*20*/2932, {10.886230, 3.822021, 1.548995, 0.000044, 0.000000, 179.999832} },
	{ /*21*/2932, {37.106933, -4.630126, 1.548995, -0.000052, 0.000000, 0.000129} },
	{ /*22*/2932, {37.106933, 3.822021, 1.548995, 0.000052, 0.000000, 179.999816} },
	{ /*23*/2932, {46.029296, -4.630126, 1.548995, -0.000059, 0.000000, 0.000152} },
	{ /*24*/2932, {46.029296, 3.822021, 1.548995, 0.000059, 0.000000, 179.999786} },
	{ /*25*/2932, {72.232910, -4.630126, 1.598999, -0.000067, 0.000000, 0.000175} },
	{ /*26*/2932, {72.232910, 3.822021, 1.598999, 0.000067, 0.000000, 179.999771} },
	{ /*27*/2932, {81.143798, -4.630126, 1.598999, -0.000075, 0.000000, 0.000198} },
	{ /*28*/2932, {81.143798, 3.822021, 1.598999, 0.000075, 0.000000, 179.999740} }
};
new const Float:CargoShipFindScrapPos[][4] = {
	{ 2731.0498, -2412.3674, 13.6328, 182.395 },
	{ 2734.0916, -2412.3679, 13.6328, 179.616 },
	{ 2734.1240, -2416.8479, 13.6278, 179.616 },
	{ 2731.1230, -2416.8474, 13.6278, 179.616 },
	{ 2725.4465, -2415.0537, 13.6328, 90.7123 },
	{ 2725.4429, -2412.1143, 13.6328, 90.7123 },
	{ 2725.3142, -2395.7869, 13.6328, 87.4954 },
	{ 2725.3137, -2398.6824, 13.6328, 89.9812 },
	{ 2722.2439, -2396.9102, 13.6328, 91.8821 },
	{ 2722.2422, -2393.9678, 13.6328, 90.8586 }
};
static CargoShipFindScrapArea[sizeof (CargoShipFindScrapPos)];

enum CARGO_SHIP_e {
	shipObjectID[1 + sizeof (CargoShipAttachPosition)],
	shipStep,
	shipStatus,
	shipTimer,
	shipFlatObjectID[2],
}
static CargoShipInfo[CARGO_SHIP_e];

static const Float:CargoShipStepPosition[][6] = {
	{ 3616.808837, -1637.561645, 10.960899, 0.000000, 0.000000, -143.299942 }, // step=0(create)
	{ 3175.126708, -1966.782470, 10.960899, 0.000000, 0.000000, -143.299942 }, // step=1
	{ 2947.957275, -2184.550048, 10.960899, 0.000000, 0.000000, -120.599967 }, // step=2
	{ 2889.488000, -2280.352000, 10.960899, 0.000000, 0.000000, -112.900000 }, // step=3
	{ 2838.040039, -2423.879882, 10.960899, 0.000000, 0.000000, -89.9999920 }, // step=4(stop)
	{ 2902.230712, -2769.070312, 10.960899, 0.000000, 0.000000, -74.9000320 }, // step=5
	{ 3123.012939, -3222.029296, 10.960899, 0.000000, 0.000000, -62.1000480 } // step=6(delete)
};
enum CONTAINER_ATTACH_e {
	attachModel,
	Float:attachPos[6],
}
static const ContainerAttachPosition[][CONTAINER_ATTACH_e] = {
	{ 3062, {1.570999, -3.547088, -0.052231, 0.000014, 0.000000, 180.000000} }, // RightDoorRZ+115
	{ 3062, {-1.548873, -3.504119, -0.052231, -0.000014, 0.000000, 0.000000} }, // LeftDoorRZ-115
	{ 2680, {-0.008102, -3.658416, -0.087235, -0.000014, 0.000000, 0.000015} }, // LockObj
	{ 2991, {-0.045455, 1.372589, -0.886124, 0.000000, 0.000014, 89.999969} }, // BoxObj
	{ 2991, {-0.045455, 1.372589, 0.363876, 0.000000, 0.000014, 89.999969} } // BoxObj
};
enum CARGO_CONTAINER_e {
	containerObjectID[5],
	containerBoxAmount, // max = 5
	// Float:containerPos[6],
	containerArea[2],
	Text3D:containerText,
	Float:containerPos[3],
	Float:containerBreakPos[3],
	containerPickup,
	containerStatus,
}
new CargoContainerInfo[MAX_CARGO_CONTAINER][CARGO_CONTAINER_e];

static const Float:CargoShipContainerPosition[MAX_CARGO_CONTAINER][6] = {
	{ 2833.410888, -2390.842773, 12.508995,  -0.000007, 0.000000, -89.999977 },
	{ 2841.863037, -2390.842773, 12.508995,  0.000007, 0.000000, 89.999977 },
	{ 2833.410888, -2399.633544, 12.508995,  -0.000014, 0.000000, -89.999954 },
	{ 2841.863037, -2399.633544, 12.508995,  0.000014, 0.000000, 89.999954 },
	{ 2833.410888, -2425.882812, 12.508995,  -0.000022, 0.000000, -89.999931 },
	{ 2841.863037, -2425.882812, 12.508995,  0.000022, 0.000000, 89.999931 },
	{ 2833.410888, -2434.765136, 12.508995,  -0.000037, 0.000000, -89.999885 },
	{ 2841.863037, -2434.765136, 12.508995,  0.000037, 0.000000, 89.999885 },
	{ 2833.410888, -2460.985839, 12.508995,  -0.000045, 0.000000, -89.999862 },
	{ 2841.863037, -2460.985839, 12.508995,  0.000045, 0.000000, 89.999862 },
	{ 2833.410888, -2469.908203, 12.508995,  -0.000052, 0.000000, -89.999839 },
	{ 2841.863037, -2469.908203, 12.508995,  0.000052, 0.000000, 89.999839 },
	{ 2833.410888, -2496.111816, 12.558998,  -0.000060, 0.000000, -89.999816 },
	{ 2841.863037, -2496.111816, 12.558998,  0.000060, 0.000000, 89.999816 },
	{ 2833.410888, -2505.022705, 12.558998,  -0.000068, 0.000000, -89.999794 },
	{ 2841.863037, -2505.022705, 12.558998,  0.000068, 0.000000, 89.999794 }
}; 
cargo_OnGameModeInit() {
	CargoShipInfo[shipTimer] = Random(CARGO_SHIP_MIN_TIMER, CARGO_SHIP_MAX_TIMER);
	CargoShipInfo[shipStatus] = CARGO_SHIP_STATUS_NONE;

	for (new i = 0; i < sizeof (CargoShipFindScrapPos); i++) {
		CargoShipFindScrapArea[i] = CreateDynamicSphere(
			CargoShipFindScrapPos[i][0], CargoShipFindScrapPos[i][1], CargoShipFindScrapPos[i][2], 0.5, 
			.worldid = -1, .interiorid = 0
		);
		CreateDynamicCP(CargoShipFindScrapPos[i][0], CargoShipFindScrapPos[i][1], CargoShipFindScrapPos[i][2], 1.0, 0, 0, -1, 5.0);
		SetDynamicAreaType(CargoShipFindScrapArea[i], AREA_TYPE_CARGO_SCRAP, i);
	}
	//CreateCargoShip();
	// (map)
	CreateDynamicObject(1278, 2807.138916, -2368.525634, 15.929687, 0.000000, 0.000000, 90.000000, 0, 0, -1, 300.00, 300.00); 
	CreateDynamicObject(3753, 2779.192382, -2571.590087, 3.039062, 0.000000, 0.000000, 179.999984, -1, 0, -1, 400.0, 400.0);
	CreateDynamicObject(3753, 2778.691894, -2324.260009, 3.039062, 0.000000, 0.000000, -0.000017, -1, 0, -1, 400.0, 400.0);
	CreateDynamicObject(3566, 2787.484619, -2434.529052, 15.024719, 0.000007, 0.000000, 89.999977, -1, 0, -1, 400.0, 400.0);
	CreateDynamicObject(1278, 2807.138916, -2415.065185, 15.929687, 0.000000, 0.000000, 90.000000, -1, 0, -1, 400.0, 400.0);
	CreateDynamicObject(12859, 2795.269287, -2452.133056, 12.643188, 0.000000, 0.000000, 90.000000, -1, 0, -1, 400.0, 400.0);
	CreateDynamicObject(3566, 2787.484619, -2477.577636, 15.024719, 0.000007, 0.000000, 89.999977, -1, 0, -1, 400.0, 400.0);
	CreateDynamicObject(3566, 2788.945068, -2471.097656, 15.024719, 0.000007, 0.000000, 89.999977, -1, 0, -1, 400.0, 400.0);
	CreateDynamicObject(3279, 2801.885742, -2338.532470, 12.604469, 0.000000, 0.000000, 0.000000, -1, 0, -1, 400.0, 400.0);
	CreateDynamicObject(3279, 2801.885742, -2541.233642, 12.604469, 0.000000, 0.000000, 0.000000, -1, 0, -1, 400.0, 400.0);
}
stock CreateCargoShip(step = 0) {
	if (CargoShipInfo[shipStatus] != CARGO_SHIP_STATUS_NONE) 
		return false;
	new idx = 0, Float:stream_distance = CARGO_SHIP_DISTANCE;
	CargoShipInfo[shipObjectID][idx++] = CreateObject(5156,
		CargoShipStepPosition[step][0], CargoShipStepPosition[step][1], CargoShipStepPosition[step][2], 
		CargoShipStepPosition[step][3], CargoShipStepPosition[step][4], CargoShipStepPosition[step][5], 
		CARGO_SHIP_DISTANCE
	); 
	for (new i = 0; i < sizeof (CargoShipAttachPosition); i++) {
		switch (CargoShipAttachPosition[i][attachModel]) {
			case 5166, 5167, 5160: stream_distance += 50.0;
		}
		AttachObjectToObject(CargoShipInfo[shipObjectID][idx] = CreateObject(CargoShipAttachPosition[i][attachModel], 0.0, 0.0, 0.0,  0.0, 0.0, 0.0, stream_distance), 
			CargoShipInfo[shipObjectID][0], 
			CargoShipAttachPosition[i][attachPos][0], CargoShipAttachPosition[i][attachPos][1], CargoShipAttachPosition[i][attachPos][2],
			CargoShipAttachPosition[i][attachPos][3], CargoShipAttachPosition[i][attachPos][4], CargoShipAttachPosition[i][attachPos][5], 1
		); 
		switch (CargoShipAttachPosition[i][attachModel]) {
			case 2932, 19321: SetObjectMaterial(CargoShipInfo[shipObjectID][idx], 0, -1, "none", "none", 0xFFFFFFFF);
		}
		idx++;
	}
	CargoShipInfo[shipStatus] = CARGO_SHIP_STATUS_CREATED;
	CargoShipInfo[shipStep] = step;
	
	MoveCargoShipNext();

	#if defined _cargo_ship_debug
		printf("[cargo] Ship: %i | step: %d created", CargoShipInfo[shipObjectID][0], CargoShipInfo[shipStep]);
	#endif
	return true;
}
stock DestroyCargoShip() {
	for (new idx = 0; idx < (1 + sizeof (CargoShipAttachPosition)); idx++) {
		DestroyObject(CargoShipInfo[shipObjectID][idx]);
	}
	CargoShipInfo[shipTimer] = Random(CARGO_SHIP_MIN_TIMER, CARGO_SHIP_MAX_TIMER);
	CargoShipInfo[shipStatus] = CARGO_SHIP_STATUS_NONE;
	#if defined _cargo_ship_debug
		print("[cargo] Ship Arrived >= sizeof (CargoShipStepPosition) (DestroyCargoShip)");
	#endif
}
stock OnCargoShipArrived() {
	for (new idx = 13, i; idx <= sizeof (CargoShipAttachPosition); idx++) {
		DestroyObject(CargoShipInfo[shipObjectID][idx]);
		i = idx - 13;

		AttachObjectToObject(CargoShipInfo[shipObjectID][idx] = CreateObject(19321, 0.0, 0.0, 0.0,  0.0, 0.0, 0.0, CARGO_SHIP_DISTANCE), 
			CargoShipInfo[shipObjectID][0], 
			CargoShipAttachPosition[idx - 1][attachPos][0], CargoShipAttachPosition[idx - 1][attachPos][1], CargoShipAttachPosition[idx - 1][attachPos][2],
			CargoShipAttachPosition[idx - 1][attachPos][3], CargoShipAttachPosition[idx - 1][attachPos][4], CargoShipAttachPosition[idx - 1][attachPos][5], 1
		); 
		switch (CargoShipAttachPosition[idx - 1][attachModel]) {
			case 2932, 19321: SetObjectMaterial(CargoShipInfo[shipObjectID][idx], 0, -1, "none", "none", 0xFFFFFFFF);
		}
		CreateCargoContainer(i, 
			CargoShipContainerPosition[i][0], CargoShipContainerPosition[i][1], 
			CargoShipContainerPosition[i][2], CargoShipContainerPosition[i][5]
		);
		#if defined _cargo_ship_debug
			printf("CreateCargoContainer(.id = %d)", i);
		#endif
	}
	CargoShipInfo[shipStatus] = CARGO_SHIP_STATUS_ARRIVED;

	new step = CargoShipInfo[shipStep];
	StopObject(CargoShipInfo[shipObjectID][0]);
	SetObjectPos(CargoShipInfo[shipObjectID][0], CargoShipStepPosition[step][0], CargoShipStepPosition[step][1], CargoShipStepPosition[step][2]);
	SetObjectRot(CargoShipInfo[shipObjectID][0], CargoShipStepPosition[step][3], CargoShipStepPosition[step][4], CargoShipStepPosition[step][5]);

	CargoShipInfo[shipFlatObjectID][0] = CreateDynamicObject(19700, 
		2827.020507, -2437.847656, 9.944602, 0.000000, 8.699999, 0.000000, 0, 0, -1, 500.00, 500.00
	);
	SetDynamicObjectMaterial(CargoShipInfo[shipFlatObjectID][0], 0, 3193, "cxref_desert", "drvin_metal", 0x00000000);

	CargoShipInfo[shipFlatObjectID][1] = CreateDynamicObject(19700, 
		2827.020507, -2388.238037, 9.944602, 0.000000, 8.699999, 0.000000, 0, 0, -1, 500.00, 500.00
	); 
	SetDynamicObjectMaterial(CargoShipInfo[shipFlatObjectID][1], 0, 3193, "cxref_desert", "drvin_metal", 0x00000000);
	
	MoveDynamicObject(CargoShipInfo[shipFlatObjectID][0], 2816.612792, -2437.847656, 11.647376, 2.0, 0.000000, 8.699999, 0.000000);
	MoveDynamicObject(CargoShipInfo[shipFlatObjectID][1], 2816.612792, -2388.238037, 11.647376, 2.0, 0.000000, 8.699999, 0.000000);

	SetTimer("OnCargoFlatMoved", 4000, false);

	SendCargoShipMessage(0xD2B48CFF, !"Внимание! Корабль прибыл в порт г.Лос Сантос!");
	CargoShipInfo[shipTimer] = (60 * 60);
	
	#if defined _cargo_ship_debug
		new debug_time[3];
		gettime(debug_time[0], debug_time[1], debug_time[2]);
		printf("[cargo] Ship Arrived Step == 4 [%02d:%02d:%02d]", debug_time[0], debug_time[1], debug_time[2]);
	#endif
}
OnCargoShipTimer() {
	if (!CargoShipInfo[shipTimer]) return;
	CargoShipInfo[shipTimer]--;
	
	switch (CargoShipInfo[shipTimer]) {
		case 0: {
			switch (CargoShipInfo[shipStatus]) {
				case CARGO_SHIP_STATUS_NONE: {
					CreateCargoShip();
				}
				case CARGO_SHIP_STATUS_ARRIVED: {
					MoveCargoShipNext();
					SendCargoShipMessage(0xD2B48CFF, !"Внимание! Корабль отправляется из порта г.Лос Сантос.");
				}
			}
			/*switch (CargoShipInfo[shipStatus]) {
				case CARGO_SHIP_STATUS_CREATED: {
					MoveCargoShipNext();
				}
			}*/
		}
		case (10 * 60): {
			switch (CargoShipInfo[shipStatus]) {
				case CARGO_SHIP_STATUS_ARRIVED: {
					SendCargoShipMessage(0xD2B48CFF, !"Внимание! Корабль оплывает через 5 минут, всем покинуть борт!");
				}
			}
		}
		case (10 * 60 - 90): {
			switch (CargoShipInfo[shipStatus]) {
				case CARGO_SHIP_STATUS_NONE: {
					SendArmy(COLOR_RED, !"Внимание! Через 10 минут к порту г.Лос Сантос прибудет корабль с боеприпасами.");
				}
			}
		}
		case (5 * 60 - 90): {
			switch (CargoShipInfo[shipStatus]) {
				case CARGO_SHIP_STATUS_NONE: {
					SendBand(COLOR_RED, !"Внимание! Через 5 минут к порту г.Лос Сантос прибудет корабль с боеприпасами.");
				}
			}
		}
	}
}
forward OnCargoFlatMoved();
public OnCargoFlatMoved() {
	StopDynamicObject(CargoShipInfo[shipFlatObjectID][0]);
	SetDynamicObjectPos(CargoShipInfo[shipFlatObjectID][0], 2816.612792, -2437.847656, 11.647376);
	SetDynamicObjectRot(CargoShipInfo[shipFlatObjectID][0], 0.000000, 8.699999, 0.000000);

	StopDynamicObject(CargoShipInfo[shipFlatObjectID][1]);
	SetDynamicObjectPos(CargoShipInfo[shipFlatObjectID][1], 2816.612792, -2388.238037, 11.647376);
	SetDynamicObjectRot(CargoShipInfo[shipFlatObjectID][1], 0.000000, 8.699999, 0.000000);
}
stock MoveCargoShipNext() {
	if (CargoShipInfo[shipStatus] == CARGO_SHIP_STATUS_MOVING || CargoShipInfo[shipStatus] == CARGO_SHIP_STATUS_NONE) 
		return false;
	new step = ++CargoShipInfo[shipStep], Float:speed = CARGO_SHIP_MOVING_SPEED;
	CargoShipInfo[shipStatus] = CARGO_SHIP_STATUS_MOVING;
	switch (step) {
		case 4: {
			speed = CARGO_SHIP_MOVING_SPEED / 3.0;
		}
		case 5: {
			for (new di_id = 0; di_id < MAX_DROPPED_ITEMS; di_id++) {
				if (
					(DroppedItemsInfo[di_id][itemPos][0] <= 2866.520 && DroppedItemsInfo[di_id][itemPos][0] >= 2811.080) &&
					(DroppedItemsInfo[di_id][itemPos][1] <= -2329.73 && DroppedItemsInfo[di_id][itemPos][1] >= -2565.27) &&
					DroppedItemsInfo[di_id][itemPos][2] <= 30.0
				) {
					DestroyDroppedItem(di_id);
				}
			}
			for (new id = 0; id < sizeof (CargoContainerInfo); id++) { 
				DestroyCargoContainer(id);
			}
			DestroyDynamicObject(CargoShipInfo[shipFlatObjectID][0]);
			DestroyDynamicObject(CargoShipInfo[shipFlatObjectID][1]);
			speed = CARGO_SHIP_MOVING_SPEED / 3.0;
		}
	}
	//SetObjectPos(CargoShipInfo[shipObjectID][0], CargoShipStepPosition[step - 1][0], CargoShipStepPosition[step - 1][1], CargoShipStepPosition[step - 1][2]);
	//SetObjectRot(CargoShipInfo[shipObjectID][0], CargoShipStepPosition[step - 1][3], CargoShipStepPosition[step - 1][4], CargoShipStepPosition[step - 1][5]);

	MoveObject(CargoShipInfo[shipObjectID][0], 
		CargoShipStepPosition[step][0], CargoShipStepPosition[step][1], CargoShipStepPosition[step][2], speed,
		CargoShipStepPosition[step][3], CargoShipStepPosition[step][4], CargoShipStepPosition[step][5]
	);
	#if defined _cargo_ship_debug
		printf("MoveObject(.objectid = %d, %.2f, %.2f, %.2f);", CargoShipInfo[shipObjectID][0], 
			CargoShipStepPosition[step][0], CargoShipStepPosition[step][1], CargoShipStepPosition[step][2], 
			CargoShipStepPosition[step][3], CargoShipStepPosition[step][4], CargoShipStepPosition[step][5]
		);
	#endif
	return true;
}
public OnObjectMoved(objectid) {
	if (objectid == CargoShipInfo[shipObjectID][0]) {
		new step = CargoShipInfo[shipStep];
		if (step >= sizeof (CargoShipStepPosition)) {
			DestroyCargoShip();
		} else {
			CargoShipInfo[shipStatus] = CARGO_SHIP_STATUS_CREATED;
		
			/*#if defined _cargo_ship_debug
				printf("SetObjectPos(.objectid = %d, %.2f, %.2f, %.2f);", objectid, CargoShipStepPosition[step][0], CargoShipStepPosition[step][1], CargoShipStepPosition[step][2]);
				printf("SetObjectRot(.objectid = %d, %.2f, %.2f, %.2f);", objectid, CargoShipStepPosition[step][3], CargoShipStepPosition[step][4], CargoShipStepPosition[step][5]);
			#endif*/
			switch (step) {
				case 4: {
					OnCargoShipArrived();
				}
				case 6: {
					DestroyCargoShip();

					for (new id = 0; id < sizeof (CargoContainerInfo); id++) { 
						DestroyCargoContainer(id);
					}
				}
				default: {
					MoveCargoShipNext();
				}
			}
		}
		return true;
	}
	return false;
}
stock OpenCargoContainer(id) {
	if (CargoContainerInfo[id][containerStatus]) return;
	new Float:objectPos[6];

	GetDynamicObjectPos(CargoContainerInfo[id][containerObjectID][0], objectPos[0], objectPos[1], objectPos[2]);
	GetDynamicObjectRot(CargoContainerInfo[id][containerObjectID][0], objectPos[3], objectPos[4], objectPos[5]);

	MoveDynamicObject(CargoContainerInfo[id][containerObjectID][0],
		objectPos[0] + 0.005, objectPos[1], objectPos[2], 0.014,
		objectPos[3], objectPos[4], objectPos[5] + 115.0
	);
	GetDynamicObjectPos(CargoContainerInfo[id][containerObjectID][1], objectPos[0], objectPos[1], objectPos[2]);
	GetDynamicObjectRot(CargoContainerInfo[id][containerObjectID][1], objectPos[3], objectPos[4], objectPos[5]);
	
	MoveDynamicObject(CargoContainerInfo[id][containerObjectID][1],
		objectPos[0] + 0.005, objectPos[1], objectPos[2], 0.014,
		objectPos[3], objectPos[4], objectPos[5] - 115.0
	);
	DestroyDynamicObject(CargoContainerInfo[id][containerObjectID][2]);

	foreach (new i: Player) {
		if (!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) 
			continue;
		if (!IsPlayerInRangeOfPoint(i, 150.0, objectPos[0], objectPos[1], objectPos[2])) 
			continue;
		Streamer_Update(i, STREAMER_TYPE_OBJECT);
	}
	UpdateContainerText(id);
	CargoContainerInfo[id][containerStatus] = 1;
} 

stock CreateCargoContainer(id, Float:x, Float:y, Float:z, Float:angle) {	
	new Float:new_object_pos[3], Float:new_object_rot[3];

	for (new i = 0, Float:stream_distance = 200.0; i < sizeof (ContainerAttachPosition); i++) {
		AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
			ContainerAttachPosition[i][attachPos][0], ContainerAttachPosition[i][attachPos][1], ContainerAttachPosition[i][attachPos][2], 
			ContainerAttachPosition[i][attachPos][3], ContainerAttachPosition[i][attachPos][4], ContainerAttachPosition[i][attachPos][5], 
			new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
		);
		switch (ContainerAttachPosition[i][attachModel]) {
			case 2991: stream_distance = 200.0 / 2.0;
		}
		CargoContainerInfo[id][containerObjectID][i] = CreateDynamicObject(ContainerAttachPosition[i][attachModel],
			new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2],
			0, 0, -1, stream_distance, stream_distance
		);
		switch (ContainerAttachPosition[i][attachModel]) {
			case 3062: {
				SetDynamicObjectMaterial(CargoContainerInfo[id][containerObjectID][i], 0, -1, "none", "none", 0xFFFFFFFF);
			}
			case 2991: {
				SetDynamicObjectMaterial(CargoContainerInfo[id][containerObjectID][i], 0, -1, "none", "none", 0xFFFFFFFF);
				SetDynamicObjectMaterial(CargoContainerInfo[id][containerObjectID][i], 1, 3013, "cr_boxes", "guns_wood", 0x00000000);
			}
		}
	}
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		-0.0483, -0.9776, -0.3625, 0.000, 0.000, 0.000,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	CargoContainerInfo[id][containerPos][0] = new_object_pos[0];
	CargoContainerInfo[id][containerPos][1] = new_object_pos[1];
	CargoContainerInfo[id][containerPos][2] = new_object_pos[2];

	CargoContainerInfo[id][containerPickup] = CreateDynamicPickup(2358, 23, new_object_pos[0], new_object_pos[1], new_object_pos[2], .worldid = 0, .interiorid = 0);
	CargoContainerInfo[id][containerArea][0] = CreateDynamicSphere(new_object_pos[0], new_object_pos[1], new_object_pos[2], 0.5, .worldid = 0, .interiorid = 0);
	SetDynamicAreaType(CargoContainerInfo[id][containerArea][0], AREA_TYPE_CARGO_CONTAINER, id);

	CargoContainerInfo[id][containerStatus] = 0;
	CargoContainerInfo[id][containerBoxAmount] = Random(CARGO_CONTAINER_MIN_BOX, CARGO_CONTAINER_MAX_BOX);

	CargoContainerInfo[id][containerText] = CreateDynamic3DTextLabel(" ", 0xFFFFFFFF, new_object_pos[0], new_object_pos[1], new_object_pos[2] + 1.0, 3.0, .testlos = 1, .worldid = 0, .interiorid = 0);
	
	AttachObjectToPosEx(x, y, z, 0.0, 0.0, angle,
		-0.0407, -4.1911, -0.4366, 0.000, 0.000, 0.000,
		new_object_pos[0], new_object_pos[1], new_object_pos[2], new_object_rot[0], new_object_rot[1], new_object_rot[2]
	);
	CargoContainerInfo[id][containerArea][1] = CreateDynamicSphere(new_object_pos[0], new_object_pos[1], new_object_pos[2], 0.5, .worldid = 0, .interiorid = 0);
	SetDynamicAreaType(CargoContainerInfo[id][containerArea][1], AREA_TYPE_CARGO_SHIP, id);

	CargoContainerInfo[id][containerBreakPos][0] = new_object_pos[0];
	CargoContainerInfo[id][containerBreakPos][1] = new_object_pos[1];
	CargoContainerInfo[id][containerBreakPos][2] = new_object_pos[2];
}
stock UpdateContainerText(id) {
	if (!CargoContainerInfo[id][containerBoxAmount]) return;

	format(STRING_GLOBAL, sizeof (STRING_GLOBAL), ""W"Ящиков: "P"%i шт.", 
		CargoContainerInfo[id][containerBoxAmount]
	);
	UpdateDynamic3DTextLabelText(CargoContainerInfo[id][containerText], 0xFFFFFFFF, STRING_GLOBAL), STRING_GLOBAL[0] = EOS;
}

stock DestroyCargoContainer(id) {
	for (new i = 0; i < 5; i++) {
		DestroyDynamicObject(CargoContainerInfo[id][containerObjectID][i]);
	}
	DestroyDynamicPickup(CargoContainerInfo[id][containerPickup]);
	DestroyDynamicArea(CargoContainerInfo[id][containerArea][0]);
	DestroyDynamicArea(CargoContainerInfo[id][containerArea][1]);
	DestroyDynamic3DTextLabel(CargoContainerInfo[id][containerText]);

	CargoContainerInfo[id][containerBoxAmount] = 0;
}
cargo_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
		return false;
	if ((newkeys & KEY_CTRL_BACK) && !(oldkeys & KEY_CTRL_BACK)) {
		if (TI[playerid][tCargoFindScrapID] && (IsAGang(playerid) || IsAMafia(playerid))) {
			new id = TI[playerid][tCargoFindScrapID] - 1;
			if (!IsPlayerInRangeOfPoint(playerid, 0.75, CargoShipFindScrapPos[id][0], CargoShipFindScrapPos[id][1], CargoShipFindScrapPos[id][2])) 
				return true;
			StartKeyMinigame(playerid, 2/*( KEY_MINIGAME_FIND_SCRAP )*/, id);
			return true;
		}
		if (TI[playerid][tContainerID]) {
			new id = TI[playerid][tContainerID] - 1;
			if (CargoContainerInfo[id][containerStatus]) 
				return true;
			if (!IsPlayerInRangeOfPoint(playerid, 0.75, 
				CargoContainerInfo[id][containerBreakPos][0], CargoContainerInfo[id][containerBreakPos][1], CargoContainerInfo[id][containerBreakPos][2])
			) return true;
			if (IsAArm(playerid)) {
				OpenCargoContainer(id);
			} 
			else if (IsAGang(playerid) || IsAMafia(playerid)) {
				if (!ItemContains(playerid, 504)) {
					ErrorMessage(playerid, "У вас нет лома, который можно найти на заводе оружия!");
					return true;
				}
				StartKeyMinigame(playerid, 1/*( KEY_MINIGAME_BREAK_CONTAINER )*/, id);
			}
			return true;
		}
	}
	return false;
}
stock CheckCargoContainers() {
	new activeContainers = 0;
	for (new id = 0; id < sizeof (CargoContainerInfo); id++) { 
		if (!CargoContainerInfo[id][containerBoxAmount]) continue;
		activeContainers++;
	}
	if (activeContainers == 0) {
		CargoShipInfo[shipTimer] = (5 * 60) + 1;
	} 
}
stock SendCargoShipMessage(color, const message[]) {
	foreach (new i: Player) {
		if (!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) 
			continue;
		if (!IsPlayerInRangeOfPoint(i, 50.0, CargoShipStepPosition[4][0], CargoShipStepPosition[4][1], CargoShipStepPosition[4][2])) 
			continue;
		SendClientMessageEx(i, color, message);
	}
}
CMD:gotoship(playerid) {
	if (PI[playerid][pAdmin] < 6 || dostup[playerid] == 0) return true;
	new Float:objectPos[3];
	
	GetObjectPos(CargoShipInfo[shipObjectID][0], objectPos[0], objectPos[1], objectPos[2]);
	SetPlayerPosAC(playerid, objectPos[0], objectPos[1], objectPos[2] + 10.0, 0, 0);
	return true;
}
CMD:moveship(playerid) {
	if (PI[playerid][pAdmin] < 5 || dostup[playerid] == 0) return true;

	if (CargoShipInfo[shipStatus] != CARGO_SHIP_STATUS_NONE || CargoShipInfo[shipTimer] <= (10 * 60 - 90)) {
		ErrorMessage(playerid, "Корабль уже создан!");
		return true;
	}
	CargoShipInfo[shipTimer] = (10 * 60 - 90) + 1;
	ErrorMessage(playerid, "Корабль отправится через 10 минут!");
	return true;
}