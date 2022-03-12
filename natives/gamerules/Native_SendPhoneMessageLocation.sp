public int Native_SendPhoneMessageLocation(Handle plugin, int params)
{
    int length;

    GetNativeStringLength(1, length);
    char[] szMessage = new char[length+2];
    GetNativeString(1, szMessage, length+1);

    float vecLoc[3];
    GetNativeArray(2, vecLoc, 3);

    static Handle hSDKCall = null;
    if(hSDKCall == null)
    {
        StartPrepSDKCall(SDKCall_GameRules);
        PrepSDKCall_SetFromConf(g_pGameConfig, SDKConf_Signature, "CZombiePanic::SendPhoneMessageLocation");
        PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
        PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByValue);
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        PrepSDKCall_AddParameter(SDKType_Bool, SDKPass_Plain);
        hSDKCall = EndPrepSDKCall();
        if(hSDKCall == null)
        {
            SetFailState("Failed to setup SDKCall for CZombiePanic::SendPhoneMessageLocation. Update your game data!");
            return 0;
        }
    }
    if(hSDKCall != null)
    {
        SDKCall(hSDKCall, szMessage, vecLoc, GetNativeCell(3), GetNativeCell(4));
    }
    return 1;
}
