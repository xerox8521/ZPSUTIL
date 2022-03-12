public int Native_RemovePlayerWeight(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);
    
    float weight = GetNativeCell(2);
    float curWeight = GetEntPropFloat(client, Prop_Send, "m_flPlayerWeight");
    if((curWeight - weight) <= 0.0)
    {
        SetEntPropFloat(client, Prop_Send, "m_flPlayerWeight", 0.0);
    }
    else
    {
        SetEntPropFloat(client, Prop_Send, "m_flPlayerWeight", (curWeight - weight));
    }
    return 1;
}
