#include <a_samp>
#include "../include/Pawn.RakNet.inc" // Новая версия плагина
#include "../include/Pawn.CMD.inc" // Новая версия плагина
#include "../include/sscanf2.inc" // Новая версия плагина




public OnFilterScriptInit()
{
    
    printf("[SG] Raknet -> Loaded");
    return 1;
}



public OnIncomingPacket(playerid, packetid, BitStream:bs) 
{
    printf("-=-=OnIncomingPacket-=- =-=-==-=-=-=\n");
    printf("Packet Logger\n");
    printf("====> RPCid: %d", packetid);
    printf("====> PlayerID: %d", playerid);
    printf("Packet Logger\n");
    printf("-=-=OnIncomingPacket-=-=-=-==-=-=-=\n");
    switch(packetid)
    {
       
    }
    return 1;
}

public OnOutgoingPacket(playerid, packetid, BitStream:bs)
{
    printf("-=-=OnOutgoingPacket-=-=-=-==-=-=-=\n");
    printf("Packet Logger\n");
    printf("====> PacketID: %d", packetid);
    printf("====> PlayerID: %d", playerid);
    printf("Packet Logger\n");
    printf("-=-=OnOutgoingPacket-=-=-=-==-=-=-=\n");
    switch(packetid)
    {
       
        
    }
    return 1;
}
public OnOutgoingRPC(playerid, rpcid, BitStream:bs)
{
    printf("-=-=Outgoing-=-RPC =-=-==-=-=-=\n");
    printf("Packet Logger\n");
    printf("====> RPC ID: %d", rpcid);
    printf("====> PlayerID: %d", playerid);
    printf("Packet Logger\n");
    printf("-=-=Outgoing-=-RPC =-=-==-=-=-=\n");
    switch(rpcid)
    {
      
      
        
    }
    return 1;
}

