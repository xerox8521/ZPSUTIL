public MRESReturn Hook_OnZPDataInit(Address pThis)
{
    gZPData = pThis;
    PrintToServer("Setup gZPData");
    return MRES_Ignored;
}