

#if defined _inc_json
	#undef _inc_json
#endif

#if defined _json_included
	#endinput
#endif
#define _json_included

#tryinclude <PawnPlus>

enum JSON_NODE {
    JSON_NODE_NUMBER,
    JSON_NODE_BOOLEAN,
    JSON_NODE_STRING,
    JSON_NODE_OBJECT,
    JSON_NODE_ARRAY,
    JSON_NODE_NULL,
}


native JSON_Parse(const string[], &Node:output);
native JSON_ParseFile(const path[], &Node:output);
native JSON_SaveFile(const path[], Node:input, bool:pretty = false);


native JSON_Stringify(Node:node, buf[], len = sizeof(buf), bool:pretty = false);


native JSON_NODE:JSON_NodeType(Node:node);















native Node:JSON_Object({_, Node}:...);


native Node:JSON_Int(value);
native Node:JSON_Bool(bool:value);
native Node:JSON_Float(Float:value);
native Node:JSON_String(const value[]);







native Node:JSON_Array(Node:...);

















native Node:JSON_Append(Node:a, Node:b);
native Node:operator+(Node:a, Node:b) = JSON_Append;


native JSON_Remove(Node:node, const key[]);


native JSON_RemoveNode(Node:node, Node:input);


native JSON_RemoveIndex(Node:node, index);


native JSON_SetObject(Node:node, const key[], Node:object);
native JSON_SetArray(Node:node, const key[], Node:array);
native JSON_SetInt(Node:node, const key[], output);
native JSON_SetFloat(Node:node, const key[], Float:output);
native JSON_SetBool(Node:node, const key[], bool:output);
native JSON_SetString(Node:node, const key[], output[], len = sizeof(output));
















native JSON_GetObject(Node:node, const key[], &Node:output);











native JSON_GetInt(Node:node, const key[], &output);
native JSON_GetFloat(Node:node, const key[], &Float:output);
native JSON_GetBool(Node:node, const key[], &bool:output);
native JSON_GetString(Node:node, const key[], output[], len = sizeof(output));


native JSON_NODE:JSON_GetType(Node:node, const key[]);



















native JSON_GetArray(Node:node, const key[], &Node:output);
native JSON_ArrayLength(Node:node, &length);
native JSON_ArrayObject(Node:node, index, &Node:output);
native JSON_ArrayIterate(Node:node, &index, &Node:output);


native JSON_ArrayAppend(Node:node, const key[], Node:input);



native JSON_ArrayRemove(Node:node, const key[], Node:input);





native JSON_ArrayRemoveIndex(Node:node, const key[], index);


native JSON_ArrayClear(Node:node, const key[]);


native JSON_Keys(Node:node, index, output[], len = sizeof(output));




native JSON_GetNodeInt(Node:node, &output);
native JSON_GetNodeFloat(Node:node, &Float:output);
native JSON_GetNodeBool(Node:node, &bool:output);
native JSON_GetNodeString(Node:node, output[], len = sizeof(output));

















native JSON_ToggleGC(Node:node, bool:toggle);










native JSON_Cleanup(Node:node, auto = false);

native JSON_CountNodes();


stock operator~(const Node:nodes[], len) {
    for(new i; i < len; ++i) {
        JSON_Cleanup(nodes[i], true);
    }
}




#if defined _PawnPlus_included
    native JSON_parse(ConstAmxString:string, &Node:output) = JSON_Parse;
    native JSON_parse_file(ConstAmxString:path, &Node:output) = JSON_ParseFile;
    native JSON_save_file(ConstAmxString:path, Node:input, bool:pretty = false) = JSON_SaveFile;

    native JSON_Stringify_Impl(Node:node, AmxString:buf, len, bool:pretty) = JSON_Stringify;
    stock String:JSON_stringify(Node:node, bool:pretty = false)
    {
        new String:str = str_new_buf(8192);
        JSON_Stringify_Impl(node, str, 8192, pretty);
        return str;
    }

    native JSON_string(ConstAmxString:value) = JSON_String;

    native JSON_set_object(Node:node, ConstAmxString:key, Node:object) = JSON_SetObject;
    native JSON_set_array(Node:node, ConstAmxString:key, Node:array) = JSON_SetArray;
    native JSON_set_int(Node:node, ConstAmxString:key, output) = JSON_SetInt;
    native JSON_set_float(Node:node, ConstAmxString:key, Float:output) = JSON_SetFloat;
    native JSON_set_bool(Node:node, ConstAmxString:key, bool:output) = JSON_SetBool;
    native JSON_set_string_s(Node:node, ConstAmxString:key, output[], len = sizeof(output)) = JSON_SetString;
    native JSON_set_string_str(Node:node, ConstAmxString:key, ConstAmxString:output) = JSON_SetString;

    native JSON_GetInt_Impl(Node:node, ConstAmxString:key, &output) = JSON_GetInt;
    stock JSON_get_int(Node:node, ConstAmxString:key)
    {
        new output;
        JSON_GetInt_Impl(node, key, output);
        return output;
    }

    native JSON_GetFloat_Impl(Node:node, ConstAmxString:key, &Float:output) = JSON_GetFloat;
    stock Float:JSON_get_float(Node:node, ConstAmxString:key)
    {
        new Float:output;
        JSON_GetFloat_Impl(node, key, output);
        return output;
    }

    native JSON_GetBool_Impl(Node:node, ConstAmxString:key, &bool:output) = JSON_GetBool;
    stock bool:JSON_get_bool(Node:node, ConstAmxString:key)
    {
        new bool:output;
        JSON_GetBool_Impl(node, key, output);
        return output;
    }

    native JSON_GetString_Impl(Node:node, ConstAmxString:key, AmxString:output, len) = JSON_GetString;
    stock String:JSON_get_string(Node:node, ConstAmxString:key)
    {
        new String:str = str_new_buf(8192);
        JSON_GetString_Impl(node, key, str, 8192);
        return str;
    }

    native JSON_NODE:JSON_get_type(Node:node, ConstAmxString:key) = JSON_GetType;

    native JSON_get_array(Node:node, ConstAmxString:key, &Node:output) = JSON_GetArray;
    native JSON_array_append(Node:node, ConstAmxString:key, Node:input);
    native JSON_array_remove(Node:node, ConstAmxString:key, Node:input) = JSON_ArrayRemove;
    native JSON_array_remove_index(Node:node, ConstAmxString:key, index) = JSON_ArrayRemoveIndex;
    native JSON_array_clear(Node:node, ConstAmxString:key) = JSON_ArrayClear;

    native JSON_GetNodeString_Impl(Node:node, AmxString:output, len) = JSON_GetNodeString;
    stock String:JSON_get_node_str(Node:node)
    {
        new String:str = str_new_buf(8192);
        JSON_GetNodeString_Impl(node, str, 8192);
        return str;
    }
#endif