public MRESReturn Hook_OnGiveWeaponToPlayer(int pThis, DHookParam hParams)
{
    if(gfGiveWeaponToPlayer.FunctionCount > 0)
    {
        if(!hParams.IsNull(1) && !hParams.IsNull(2))
        {
            int receiver = hParams.Get(1);
            int weapon = hParams.Get(2);

            Action result = Plugin_Continue;

            char szClassName[32];
            GetEntityClassname(weapon, szClassName, sizeof(szClassName));

            Call_StartForward(gfGiveWeaponToPlayer);
            Call_PushCell(pThis);
            Call_PushCell(receiver);
            Call_PushCell(weapon);
            Call_PushString(szClassName);
            Call_Finish(result);

            if(result == Plugin_Handled)
            {
                return MRES_Supercede;
            }
        }
    }
    
    return MRES_Ignored;
}
