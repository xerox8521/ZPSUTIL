public MRESReturn Hook_OnGiveAmmoToPlayer(int pThis, DHookParam hParams)
{
    if(gfGiveAmmoToPlayer.FunctionCount > 0)
    {
        if(!hParams.IsNull(1))
        {
            int receiver = hParams.Get(1);
            Action result = Plugin_Continue;

            Call_StartForward(gfGiveAmmoToPlayer);
            Call_PushCell(pThis);
            Call_PushCell(receiver);
            Call_Finish(result);
            if(result == Plugin_Handled)
            {
                return MRES_Supercede;
            }
        }
    }
    return MRES_Ignored;
}
