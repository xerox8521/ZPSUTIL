public int Native_SetMaxSpeed(Handle plugin, int args)
{
    int client = GetNativeCell(1);
    if(!IsValidEntity(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    flMaxSpeed[client] = GetNativeCell(2);
    return 1;
}