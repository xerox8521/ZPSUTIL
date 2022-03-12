public int Native_CreateCosmeticWear(Handle plugin, int params)
{
    int client = GetNativeCell(1);
    if(client < 1 || client > MaxClients) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is invalid", client);
    if(!IsClientInGame(client)) return ThrowNativeError(SP_ERROR_NATIVE, "Client index %d is not ingame", client);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_Player);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZP_Player::CreateCosmeticWear");
        PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZP_Player::CreateCosmeticWear. Update your game data!");
            return 0;
        }
    }

    if(hSDKCall != null)
    {
        int length;
        GetNativeStringLength(1, length);

        char[] szModelName = new char[length+2];

        GetNativeString(1, szModelName, length+1);

        SDKCall(hSDKCall, client, szModelName);
        return 1;
    }
    return 0;
}
