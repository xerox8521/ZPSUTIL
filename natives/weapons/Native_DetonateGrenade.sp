public any Native_DetonateGrenade(Handle plugin, int params)
{
    int grenade = GetNativeCell(1);
    if(!IsValidEntity(grenade)) return ThrowNativeError(SP_ERROR_NATIVE, "Entity index %d is invalid", grenade);
    if(!HasEntProp(grenade, Prop_Send, "m_iThrowState")) return ThrowNativeError(SP_ERROR_NATIVE, "Entity %d is not a grenade", grenade);

    Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Entity);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Virtual, "CBaseGrenade::Detonate");
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            ThrowNativeError(SP_ERROR_NATIVE, "Failed to setup SDKCall for CBaseGrenade::Detonate. Update your gamedata!");
            return INVALID_ENT_REFERENCE;
        }
    }
    if(hSDKCall != null)
    {
        SDKCall(hSDKCall, grenade);
        
    }
    return 1;
}
