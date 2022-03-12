public int Native_SendPhoneMessage(Handle plugin, int params)
{
    int length;

    GetNativeStringLength(1, length);
    char[] szMessage = new char[length+2];
    GetNativeString(1, szMessage, length+1);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_GameRules);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZombiePanic::SendPhoneMessage");
        PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZombiePanic::SendPhoneMessage. Update your game data!");
            return 0;
        }
    }
    if(hSDKCall != null)
    {
        SDKCall(hSDKCall, szMessage, GetNativeCell(2));
    }
    return 1;
}
