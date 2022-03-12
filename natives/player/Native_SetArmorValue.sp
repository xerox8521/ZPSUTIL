public int Native_SetArmorValue(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    SetEntProp(client, Prop_Send, "m_iArmor", GetNativeCell(2));
    return 1;
}
