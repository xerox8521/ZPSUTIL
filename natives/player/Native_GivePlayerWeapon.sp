public int Native_GivePlayerWeapon(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Player);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZP_Player::GiveWeapon");
        PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
        PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        PrepSDKCall_SetReturnInfo(SDKType_CBaseEntity, SDKPass_Pointer);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZP_Player::GiveWeapon. Update your game data!");
            return INVALID_ENT_REFERENCE;
        }
    }

    if(hSDKCall != null)
    {
        int length;
        GetNativeStringLength(2, length);

        char[] szWeaponName = new char[length+2];

        GetNativeString(2, szWeaponName, length+1);
        return SDKCall(hSDKCall, client, szWeaponName, -1, false);
    }
    return INVALID_ENT_REFERENCE;
}
