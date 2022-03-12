public int Native_HasDeliveryItem(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    int item_delivery = INVALID_ENT_REFERENCE;
    char szClassName[32];
    for(int i = 0; i < 6; i++)
    {
        item_delivery = GetPlayerWeaponSlot(client, i);
        if(item_delivery == -1) continue;
        GetEntityClassname(item_delivery, szClassName, sizeof(szClassName));
        
        if(StrEqual(szClassName, "item_delivery"))
        {
            return 1;
        }
    }
    return 0;
}
