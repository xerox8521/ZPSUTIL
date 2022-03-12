public int Native_SetFlashBattery(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    
    SetEntPropFloat(client, Prop_Send, "m_flFlashBattery", GetNativeCell(2));
    return 1;
}
