public MRESReturn Hook_OnGetSpeed(int pThis, DHookReturn hReturn)
{
    if(gfGetSpeed.FunctionCount > 0)
    {
        if(!pThis)
        return MRES_Ignored;
        if(!IsClientInGame(pThis))
            return MRES_Ignored;

        float flSpeed = hReturn.Value;
        
        Action result = Plugin_Continue;

        Call_StartForward(gfGetSpeed);
        Call_PushCell(pThis);
        Call_PushFloatRef(flSpeed);
        Call_Finish(result);
        if(result == Plugin_Changed)
        {
            hReturn.Value = flSpeed;
            return MRES_Supercede;
        }
    }
    
    return MRES_Ignored;
}
