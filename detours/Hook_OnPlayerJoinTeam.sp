public MRESReturn Hook_OnPlayerJoinTeam(int pThis, DHookReturn hReturn, DHookParam hParams)
{
    if(gfHandleJoinTeam.FunctionCount > 0)
    {
        int team = hParams.Get(1);
        if(team > 0)
        {
            Call_StartForward(gfHandleJoinTeam);
            Call_PushCell(pThis);
            Call_PushCellRef(team);

            Action result = Plugin_Continue;
            Call_Finish(result);
            if(result == Plugin_Handled)
            {
                hReturn.Value = false;
                return MRES_Supercede;
            }
            else if(result == Plugin_Changed)
            {
                hParams.Set(1, team);
                return MRES_ChangedHandled;
            }
        }
    }
    return MRES_Ignored;
}
