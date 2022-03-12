bool IsMeleeWeapon(int weapon)
{
    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Entity);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Virtual, "CWeaponZPBase::IsMeleeWeapon");
        PrepSDKCall_SetReturnInfo(SDKType_Bool, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CWeaponZPBase::IsMeleeWeapon. Update your game data!");
            return false;
        }
    }
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall, weapon);
    }
    return false;
}
