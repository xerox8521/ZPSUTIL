public int Native_GiveBarricadeAmmo(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    int amount = GetNativeCell(2);
    if(amount <= 0) return ThrowNativeError(SP_ERROR_NATIVE, "Amount: %d is invalid. Value must be > 0", amount);

    int k, l;

    GivePlayerAmmo(client, amount, AMMO_TYPE_BARRICADE);
    
    for(k = 0; k != amount; ++k)
    {
        for(l = 1; l != 7; ++l)
        {
            if(!GetBarricadeHealth(client, l))
                break;
        }
        AddBarricadeHealth(client, l, (GameRules_GetProp("m_bInHardcore") == 0) ? 450 : 350);
    }
    return 1;
}