public any Native_GetMeleeRange(Handle plugin, int params)
{
    int weapon = GetNativeCell(1);
    if(weapon < MaxClients || !IsValidEntity(weapon)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity index %d is invalid", weapon);

    char szClassName[32];
    GetEntityClassname(weapon, szClassName, sizeof(szClassName));
    if(StrContains(szClassName, "weapon_") != -1 && StrEqual(szClassName, "item_delivery") == false) return ThrowNativeError(SP_ERROR_NATIVE, "Entity %s(%d) is not a weapon", szClassName, weapon);

    if(!IsMeleeWeapon(weapon)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity %s(%d) is not a melee weapon", szClassName, weapon);


    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Entity);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Virtual, "CWeaponMeleeBase::GetRange");
        PrepSDKCall_SetReturnInfo(SDKType_Bool, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CWeaponMeleeBase::GetRange. Update your game data!");
            return -1;
        }
    }
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall, GetNativeCell(1));
    }
    return -1;
}