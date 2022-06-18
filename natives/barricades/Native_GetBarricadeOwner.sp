public int Native_GetBarricadeOwner(Handle plugin, int params)
{
    int barricade = GetNativeCell(1);
    if(!IsValidEntity(barricade)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity index %d is invalid", barricade);
    char szClassname[32];
    GetEntityClassname(barricade, szClassname, sizeof(szClassname));
    if(!StrEqual(szClassname, "prop_barricade")) return ThrowNativeError(SP_ERROR_NATIVE, "Entity %s(%d) is not a barricade", szClassname, barricade);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Player);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CPropBarricade::GetBarricadeOwner");
        PrepSDKCall_SetReturnInfo(SDKType_CBasePlayer, SDKPass_Pointer);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CPropBarricade::GetBarricadeOwner. Update your game data!");
            return 0;
        }
    }
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall, barricade);
    }
    return 0;
}
