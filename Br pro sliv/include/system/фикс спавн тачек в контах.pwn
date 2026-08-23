// Находим в поиске if(cInfo[contid][ItemType] == 2) и за меняем на код который внизу


if(cInfo[contid][ItemType] == 2)
            {
                new colors[] = {1, 10, 22, 53, 50}; // 0-черный, 1-белый, 10-красный, 22-розовый, 53-желтый, 50-зеленый
                cInfo[contid][ContVehicleColor] = colors[random(sizeof(colors))];
                TextDrawSetPreviewVehCol(cont_model[contid], cInfo[contid][ContVehicleColor], 1);
                switch(contid)
                {
                    case 1: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 690.51898, 1738.27002, 14.73000, 90, cInfo[contid][ContVehicleColor], 1, 0);
                    case 2: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 690.51898, 1731.78003, 14.73000, 90, cInfo[contid][ContVehicleColor], 1, 0);
                    case 3: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 665.81897, 1726.96997, 14.73000, 0, cInfo[contid][ContVehicleColor], 1, 0);
                    case 4: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 680.23999, 1694.77002, 14.73000, 0, cInfo[contid][ContVehicleColor], 1, 0);
                    case 5: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 672.75598, 1694.77002, 14.73000, 0, cInfo[contid][ContVehicleColor], 1, 0);
                    case 6: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 665.81897, 1694.77002, 14.73000, 0, cInfo[contid][ContVehicleColor], 1, 0);
                    case 7: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 654.782592,1676.682617,12.162509, 90, cInfo[contid][ContVehicleColor], 1, 0); 
                    case 8: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 652.453918,1669.808837,12.162509, 90, cInfo[contid][ContVehicleColor], 1, 0);
                    case 9: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 656.584472,1663.109741,12.162509, 90, cInfo[contid][ContVehicleColor], 1, 0);
                    case 10: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 634.458496,1709.019531,12.162509, 270, cInfo[contid][ContVehicleColor], 1, 0); 
                    case 11: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 633.160400,1702.422607,12.162509, 270, cInfo[contid][ContVehicleColor], 1, 0);
                    case 12: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 634.832702,1696.067260,12.162509, 270, cInfo[contid][ContVehicleColor], 1, 0);
                }
                SetVehicleParamsEx(cInfo[contid][ContVehicleId], false, false, false, true, false, false, false);
                ChangeVehicleColor(cInfo[contid][ContVehicleId], cInfo[contid][ContVehicleColor], 0);
            }
            else // Если приз не автомобиль (то есть одежда)
            {
                new Float:contX = cContsPos[contid-1][0];
                new Float:contY = cContsPos[contid-1][1];
                new Float:contZ = cContsPos[contid-1][2];
                new Float:contRot = cContsPos[contid-1][3];
                cInfo[contid][ContObjectOdejdaId] = CreateObject(959, contX, contY, contZ, 0.0, 0.0, contRot);
            }