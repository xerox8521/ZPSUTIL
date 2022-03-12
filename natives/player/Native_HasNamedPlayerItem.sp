public any Native_HasNamedPlayerItem(Handle plugin, int params)
{

    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    int length;
    GetNativeStringLength(2, length);
    char[] szClassName = new char[length+2];
    GetNativeString(2, szClassName, length+1);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Player);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CBasePlayer::HasNamedPlayerItem");
        PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
        PrepSDKCall_SetReturnInfo(SDKType_CBaseEntity, SDKPass_Pointer);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            ThrowNativeError(SP_ERROR_NATIVE, "Failed to setup SDKCall for CBasePlayer::HasNamedPlayerItem. Update your gamedata!");
            return INVALID_ENT_REFERENCE;
        }
    }
    if(hSDKCall != null)
    {
        return SDKCall(hSDKCall, client, szClassName);
    }
    return INVALID_ENT_REFERENCE;
}
