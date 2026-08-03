#if defined _pawn_json_included
    #endinput
#endif
#define _pawn_json_included

enum Node
{
    __dummy_node
};

stock JSON_Parse(const data[], &Node:out)
{
    out = Node:0;
    return 1;
}

stock JSON_SetInt(Node:json, const key[], value)
{
    return 1;
}

stock JSON_SetString(Node:json, const key[], const value[])
{
    return 1;
}

stock JSON_Cleanup(Node:json)
{
    return 1;
}