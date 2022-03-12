public MRESReturn Hook_OnRoundStart()
{
    if(gfRoundStart.FunctionCount > 0)
    {
        Call_StartForward(gfRoundStart);
        Call_Finish();
    }
    
    return MRES_Ignored;
}
