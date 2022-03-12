public int Native_IsMeleeWeapon(Handle plugin, int params)
{
    int weapon = GetNativeCell(1);
    if(weapon < MaxClients || !IsValidEntity(weapon)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity index %d is invalid", weapon);

    char szClassName[32];
    GetEntityClassname(weapon, szClassName, sizeof(szClassName));
    if(StrContains(szClassName, "weapon_") != -1 && StrEqual(szClassName, "item_delivery") == false) return ThrowNativeError(SP_ERROR_NATIVE, "Entity %s(%d) is not a weapon", szClassName, weapon);
    return IsMeleeWeapon(weapon);
}
