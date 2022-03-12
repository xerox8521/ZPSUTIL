public int Native_CreateFragGrenade(Handle plugin, int params)
{
    int thrower = GetNativeCell(5);
    if(thrower < 1 || thrower > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", thrower);
    if(!IsClientInGame(thrower)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", thrower);

    float Pos[3], Angle[3], Velocity[3], angVelocity[3];

    GetNativeArray(1, Pos, 3);   
    GetNativeArray(2, Angle, 3);   
    GetNativeArray(3, Velocity, 3);   
    GetNativeArray(4, angVelocity, 3);

    
    float flExplodeTime = GetNativeCell(6);
    bool bUknown1 = GetNativeCell(7);
    bool bUknown2 = GetNativeCell(8);

    Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Static);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "Fraggrenade_Create");
        PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
        PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByValue);
        PrepSDKCall_AddParameter(SDKType_QAngle, SDKPass_ByValue);
        PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByValue);
        PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByValue);
        PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
        PrepSDKCall_AddParameter(SDKType_Float, SDKPass_Plain);
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            ThrowNativeError(SP_ERROR_NATIVE, "Failed to setup SDKCall for Fraggrenade_Create. Update your gamedata!");
            return INVALID_ENT_REFERENCE;
        }
    }
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall, GRENADE_MODEL, Pos, Angle, Velocity, angVelocity, thrower, flExplodeTime, bUknown1, bUknown2);
    }
    return INVALID_ENT_REFERENCE;
}
