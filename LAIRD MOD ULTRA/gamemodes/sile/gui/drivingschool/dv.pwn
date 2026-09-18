stock ShowDrivingSchoolGUI(playerid)
{
	new
		outcoming_data[512],
		Node:json = JSON_Object(),
		Node:actual_status_for_type = JSON_Array(),
		Node:actual_price_for_type = JSON_Array();

	actual_price_for_type = JSON_Append(
		actual_price_for_type,
		JSON_Array(
			JSON_Int(1500),
			JSON_Int(2500),
			JSON_Int(3500),
			JSON_Int(5000),
			JSON_Int(20000)
		)
	);

	actual_status_for_type = JSON_Append(
		actual_status_for_type,
		JSON_Array(
			JSON_Int(
				0	//недостаточно средств
			),
			JSON_Int(
				2	// имеется
			),
			JSON_Int(
				1	// можно сдать
			),
			JSON_Int(
				3	// заблокировано
			),
			JSON_Int(
				2   // имеется
			)
		)
	);

	JSON_SetInt(json, "t", 1);
	JSON_SetInt(json, "o", 1);
	JSON_SetArray(json, "a", actual_status_for_type);
	JSON_SetArray(json, "p", actual_price_for_type);

	SendPacketToClient(playerid, 37, json);

	printf("outcoming_data = %s", outcoming_data);


	return true;
}

CMD:dv(playerid)
{
	ShowDrivingSchoolGUI(playerid);
	return 1;
}

stock HandlePacketDV(playerid, Node:JSONObject)
{
    new t;
    JSON_GetInt(JSONObject, "t", t);

    switch(t)
    {
        case 1: // Выбор категории прав
        {
            new s;
            JSON_GetInt(JSONObject, "s", s);
            
            // Здесь должна быть логика проверки:
            // - Есть ли у игрока доступ к этой категории?
            // - Достаточно ли у него средств?
            // - Разблокирована ли категория?
            
             new cq; // ID вопроса
            JSON_GetInt(JSONObject, "cq", cq);
            
            // Если есть параметр "s" - значит это ответ на вопрос
            // Если нет - значит клиент запрашивает новый вопрос
            
            new has_s;
            if (JSON_GetInt(JSONObject, "s", has_s))
            {
                // Это ответ на вопрос
                // Проверяем правильность ответа и обновляем статистику игрока
                
                // Отправляем следующий вопрос
                new 
                    outcoming_data[512],
                    Node:json = JSON_Object(),
                    next_question_id = 1, // ID следующего вопроса
                    next_question_number = 5, // Номер следующего вопроса (прогресс)
                    correct_answer = 2; // Правильный ответ
                
                JSON_SetInt(json, "t", 3);
                JSON_SetInt(json, "a", next_question_number);
                JSON_SetInt(json, "cq", next_question_id);
                JSON_SetInt(json, "b", correct_answer);
                
                SendPacketToClient(playerid, 37, json);
            }
            else
            {
                // Клиент запрашивает новый вопрос
                // (Обычно это происходит, когда клиент получает команду showNewQuest)
                
                // Отправляем следующий вопрос
                new 
                    outcoming_data[512],
                    Node:json = JSON_Object(),
                    next_question_id = 1,
                    next_question_number = 5,
                    correct_answer = 2;
                
                JSON_SetInt(json, "t", 3);
                JSON_SetInt(json, "a", next_question_number);
                JSON_SetInt(json, "cq", next_question_id);
                JSON_SetInt(json, "b", correct_answer);
                
                SendPacketToClient(playerid, 37, json);
            }
        }
        
        case 2: // Начало теста
        {
            // Логика начала теста для выбранной категории
            // Например: генерируем вопросы, создаем таймер
            
            // Отправляем ответ клиенту
             new cq; // ID вопроса
            JSON_GetInt(JSONObject, "cq", cq);
            
            // Если есть параметр "s" - значит это ответ на вопрос
            // Если нет - значит клиент запрашивает новый вопрос
            
            new has_s;
            if (JSON_GetInt(JSONObject, "s", has_s))
            {
                // Это ответ на вопрос
                // Проверяем правильность ответа и обновляем статистику игрока
                
                // Отправляем следующий вопрос
                new 
                    outcoming_data[512],
                    Node:json = JSON_Object(),
                    next_question_id = 1, // ID следующего вопроса
                    next_question_number = 5, // Номер следующего вопроса (прогресс)
                    correct_answer = 2; // Правильный ответ
                
                JSON_SetInt(json, "t", 3);
                JSON_SetInt(json, "a", next_question_number);
                JSON_SetInt(json, "cq", next_question_id);
                JSON_SetInt(json, "b", correct_answer);
                
                SendPacketToClient(playerid, 37, json);
            }
            else
            {
                // Клиент запрашивает новый вопрос
                // (Обычно это происходит, когда клиент получает команду showNewQuest)
                
                // Отправляем следующий вопрос
                new 
                    outcoming_data[512],
                    Node:json = JSON_Object(),
                    next_question_id = 1,
                    next_question_number = 5,
                    correct_answer = 2;
                
                JSON_SetInt(json, "t", 3);
                JSON_SetInt(json, "a", next_question_number);
                JSON_SetInt(json, "cq", next_question_id);
                JSON_SetInt(json, "b", correct_answer);
                
                SendPacketToClient(playerid, 37, json);
            }
        }
        
        case 3: // Ответ на вопрос / Получение нового вопроса
        {
            new cq; // ID вопроса
            JSON_GetInt(JSONObject, "cq", cq);
            
            // Если есть параметр "s" - значит это ответ на вопрос
            // Если нет - значит клиент запрашивает новый вопрос
            
            new has_s;
            if (JSON_GetInt(JSONObject, "s", has_s))
            {
                // Это ответ на вопрос
                // Проверяем правильность ответа и обновляем статистику игрока
                
                // Отправляем следующий вопрос
                new 
                    outcoming_data[512],
                    Node:json = JSON_Object(),
                    next_question_id = 1, // ID следующего вопроса
                    next_question_number = 5, // Номер следующего вопроса (прогресс)
                    correct_answer = 2; // Правильный ответ
                
                JSON_SetInt(json, "t", 3);
                JSON_SetInt(json, "a", next_question_number);
                JSON_SetInt(json, "cq", next_question_id);
                JSON_SetInt(json, "b", correct_answer);
                
                SendPacketToClient(playerid, 37, json);
            }
            else
            {
                // Клиент запрашивает новый вопрос
                // (Обычно это происходит, когда клиент получает команду showNewQuest)
                
                // Отправляем следующий вопрос
                new 
                    outcoming_data[512],
                    Node:json = JSON_Object(),
                    next_question_id = 1,
                    next_question_number = 5,
                    correct_answer = 2;
                
                JSON_SetInt(json, "t", 3);
                JSON_SetInt(json, "a", next_question_number);
                JSON_SetInt(json, "cq", next_question_id);
                JSON_SetInt(json, "b", correct_answer);
                
                SendPacketToClient(playerid, 37, json);
            }
        }
        
        case 4: // Завершение теста
        {
            // Логика завершения теста
            // (Обычно клиент сам отправляет это при окончании таймера или нажатии кнопки)
            
            new 
                outcoming_data[512],
                Node:json = JSON_Object();
            
            JSON_SetInt(json, "t", 4);
            
            // Статус результата: 0 - провал, 1 - успех
            new status = 1; // Например, игрок сдал тест
            JSON_SetInt(json, "s", status);
            
            // Количество правильных ответов
            new correct_answers = 25;
            JSON_SetInt(json, "cq", correct_answers);
            
            SendPacketToClient(playerid, 37, json);
        }
        
        default:
        {
            printf("[HandlePacketDV] Unknown type: %d", t);
        }
    }

    return true;
}