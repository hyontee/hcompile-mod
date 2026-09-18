stock Tamik_CheckLicense()
{
    new bind_addr[32], port;
    GetServerVarAsString("bind", bind_addr, sizeof(bind_addr));
    port = GetServerVarAsInt("port");
    
    if(strcmp(bind_addr, "188.127.241.8") != 0 || port != 1448)
    {
        print("Мод запущен на нубо рп ская");
        return 0;
    }
    return 1;
}

forward Tamik_CheckTimer();
public Tamik_CheckTimer()
{
    if(!Tamik_CheckLicense()) GameModeExit();
    SetTimer("Tamik_CheckTimer", 5000, false);
}