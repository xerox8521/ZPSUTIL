public int Native_HasActiveIED(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    int ied = INVALID_ENT_REFERENCE;
    while ((ied = FindEntityByClassname(ied, "npc_ied")) != INVALID_ENT_REFERENCE)
    {
        if(GetEntProp(ied, Prop_Send, "m_bIsLive"))
        {
            if(GetEntPropEnt(ied, Prop_Send, "m_hThrower") == client)
            return 1;
        }
    }
    return 0;
}
