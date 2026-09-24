// встроенное удаление include guard
// на всякий случай, если у пользователя есть локальная зависимость с тем же именем файла
#if defined _inc_json
	#undef _inc_json
#endif
// пользовательское включение-защита, чтобы гарантировать, что мы не дублируем
#if defined _json_included
	#endinput
#endif
#define _json_included

enum JSON_NODE {
    JSON_NODE_NUMBER,
    JSON_NODE_BOOLEAN,
    JSON_NODE_STRING,
    JSON_NODE_OBJECT,
    JSON_NODE_ARRAY,
    JSON_NODE_NULL,
}

// JSON_Parse декодирует JSON и сохраняет корневой узел в `output`.
native JSON_Parse(const string[], &Node:output);
native JSON_ParseFile(const path[], &Node:output);
native JSON_SaveFile(const path[], Node:input, bool:pretty = false);

// JSON_Stringify кодирует узел JSON в `buf`.
native JSON_Stringify(Node:node, buf[], len = sizeof(buf));

// JSON_NodeType возвращает тип узла из приведенного выше перечислителя.
native JSON_NODE:JSON_NodeType(Node:node);

// JSON_Object выделяет узел из набора пар ключ-значение, где каждый ключ должен
// быть строкой, а каждое значение должно быть значением `Node:`. Например:
//
// JSON_Object("ключ", JSON_String("значение"));
//
// вывод: {"ключ": "значение"}
//
// Возвращает `Узел:` Идентификатор, который может быть передан в качестве аргумента другой функции JSON_Object
// для создания вложенных объектов. Например:
//
// // JSON_Object("ключ", JSON_Object("вложенный ключ", JSON_String("значение")));
//
// // вывод: {"ключ": {"вложенный ключ": "значение"}}
native Node:JSON_Object({_, Node}:...);

// // JSON_Into, JSON_Bool, JSON_Float, JSON_String каждый выделяет JsonNode.
native Node:JSON_Int(value);
native Node:JSON_Bool(bool:value);
native Node:JSON_Float(Float:value);
native Node:JSON_String(const value[]);

// JSON_Array просто принимает список аргументов из идентификаторов 'Node:`.
//
// JSON_Array(JSON_String ("значение"), JSON_Int(1), JSON_Object ("k", JSON_String ("v")))
//
// вывод: ["значение", 1, {"k":"v"}]
//
native Node:JSON_Array(Node:...);

// JSON_Append возвращает новый 'Node:`, который является результатом добавления b к A.
// Это работает как с объектами, так и с массивами, и два входных узла будут удалены
// из глобального хранилища узлов. Например:
//
// новый узел: a = JSON_Object ("ключ1", JSON_String ("значение"));
// новый узел: b = JSON_Object ("ключ2", JSON_String ("значение"));
// новый узел: c = JSON_Append (a, b);
//
// вывод: {"ключ1": "значение","ключ2":"значение"}
//
// новый узел: a = JSON_Array(JSON_Int(1), JSON_Int(2));
// новый узел: a = JSON_Array(JSON_Int(3));
// новый узел: c = JSON_Append (a, b);
//
// вывод: [1, 2, 3]
//
native Node:JSON_Append(Node:a, Node:b);
native Node:operator+(Node:a, Node:b) = JSON_Append;

// JSON_Remove удаляет любой существующий ключ с вашего узла.
native JSON_Remove(Node:node, const key[]);

// JSON_Set* функции напрямую изменяют узлы, вставляя или модифицируя ключи.
native JSON_SetObject(Node:node, const key[], Node:object);
native JSON_SetArray(Node:node, const key[], Node:array);
native JSON_SetInt(Node:node, const key[], output);
native JSON_SetFloat(Node:node, const key[], Float:output);
native JSON_SetBool(Node:node, const key[], bool:output);
native JSON_SetString(Node:node, const key[], output[], len = sizeof(output));

// JSON_GetObject возвращает `Узел:`, хранящийся в "ключе" в данном "узле".
// Например:
//
// ввод: {"ключ": {"внутренний": 1}}
//
// новый узел:вывод;
// JSON_GetObject(узел, "ключ", вывод);
//
// `output` теперь содержит объект JSON, содержащий {"inner": 1}, этот узел можно
// обрабатывать как любой другой узел:
//
//// новое выходное значение;
// // JSON_GetInt(вывод, выходное значение);
// // выходное значение == 1
//
native JSON_GetObject(Node:node, const key[], &Node:output);

// JSON_Get* функции извлекают собственный тип из объекта этими функциями являются
// сокращение от:
//
// новый узел:вывод;
// JSON_GetObject(узел, "ключ", вывод);
// новая строка[128];
// // Строка JSON_GetNode(output, string);
//
// В 99% случаев эти функции нужны вам только для получения значений из объектов.
//
native JSON_GetInt(Node:node, const key[], &output);
native JSON_GetFloat(Node:node, const key[], &Float:output);
native JSON_GetBool(Node:node, const key[], &bool:output);
native JSON_GetString(Node:node, const key[], output[], len = sizeof(output));

// JSON_GetType возвращает тип ключа узла
native JSON_NODE:JSON_GetType(Node:node, const key[]);

// JSON_GetArray возвращает `Node:`, хранящийся в `index` в данном `node`. То
// `Node:` возвращаемый может быть объектом или примитивом, таким как int, float,
// bool или string. Используйте приведенные ниже функции для преобразования `Node:` в собственный тип.
// Например:
//
// ввод: {"ключ": [1, 2, 3]}
//
// новый узел:вывод;
// JSON_GetArray(узел, ключ, вывод);
//
// `output` теперь содержит массив JSON, и к нему можно получить доступ с помощью:
//
// новый узел:элемент;
// // Объект JSON_Array(узел, 1, элемент);
//
// `element` теперь содержит узел целочисленного типа JSON и может быть преобразован в
// // собственный целочисленный тип, использующий `JSON_GetNode Int`.
//
native JSON_GetArray(Node:node, const key[], &Node:output);
native JSON_ArrayLength(Node:node, &length);
native JSON_ArrayObject(Node:node, index, &Node:output);
native JSON_ArrayIterate(Node:node, &index, &Node:output);

// JSON_Array Append добавляет любой заданный узел к существующему массиву JSON.
native JSON_ArrayAppend(Node:node, const key[], Node:input);

// // JSON_Array Remove удаляет любой заданный узел из массива JSON, если внутри него находятся данные узла
native JSON_ArrayRemove(Node:node, const key[], Node:input);

// // JSON_Array Remove Index удаляет элемент из массива JSON по
// указанному индексу. Примечание: индексы не являются постоянными, поэтому, если вы
// создайте массив JSON с 10 элементами внутри него и удалите индекс 3,
// 4-9 будут перетасованы соответственно.
native JSON_ArrayRemoveIndex(Node:node, const key[], index);

// // JSON_Array Clear очищает все элементы в массиве JSON.
native JSON_ArrayClear(Node:node, const key[]);

// JSON_Keys можно использовать для перебора ключей внутри узла JSON
native JSON_Keys(Node:node, index, output[], len = sizeof(output));

// JSON_GetNode* функции извлекают объект JSON `Node:` в `output`.
// Они полезны, когда вы получаете `Node:`, представляющий примитивный тип
// например, из JSON_GetArray.
native JSON_GetNodeInt(Node:node, &output);
native JSON_GetNodeFloat(Node:node, &Float:output);
native JSON_GetNodeBool(Node:node, &bool:output);
native JSON_GetNodeString(Node:node, output[], len = sizeof(output));

// // JSON_Toggle переключает сборку мусора для узла. Это предотвращает удаление узлов
// `JSON_Cleanup`, если значение `auto` равно true. Другими словами,
// отключение сборки мусора для узла предотвратит его удаление
// автоматически, когда он покидает область видимости. Это полезно, когда вы хотите передать
// узел через вызовы функций или сохранить его на более длительный период времени.
// Будьте очень осторожны с этой функцией, так как потеря указателя на узел приведет к
// классической утечке памяти. Например:
//
// новый узел:n = JSON_Object();
// // JSON_Toggle GC(n, false);
// // CallLocalFunction("Заполнить JSON_Object", "d", _:n);
// // JSON_Toggle GC(n, true);
//
// // Это гарантирует, что каждый хук `Fill JSON_Object` не удалит `n`, когда
// он покинет область видимости.
native JSON_ToggleGC(Node:node, bool:toggle);

// -
// Internal
// -

// JSON_Cleanup - это внутренняя функция для очистки объектов `Node:`. Это
// необходимо, поскольку каждая из функций построителя объектов, описанных выше, выделяет узлы
// в пуле, который будет передаваться между вызовами внутренних функций. Если вызывается вручную,
// оставьте `auto` в качестве значения по умолчанию false, которое будет игнорировать мусор
// // отключение сбора выполнено с помощью `JSON_Toggle GC`.
native JSON_Cleanup(Node:node, auto = false);

native JSON_CountNodes();

// очищает узлы, как только они выходят за пределы области видимости.
stock operator~(const Node:nodes[], len) {
    for(new i; i < len; ++i) {
        JSON_Cleanup(nodes[i], true);
    }
}
