public int Native_OpenSteamOverlay(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    
    int length;
    GetNativeStringLength(2, length);

    char[] szWebsite = new char[length+2];

    GetNativeString(2, szWebsite, length+1);

    ClientCommand(client, "opensteamoverlay %s", szWebsite);
    return 1;
}
