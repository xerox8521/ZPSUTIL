public MRESReturn Hook_OnPlayerWeaponPickup(int pThis, DHookParam hParams)
{
    if(gfPlayerWeaponPickup.FunctionCount > 0)
    {
        if(!hParams.IsNull(1))
        {
            int weapon = hParams.Get(1);
            bool bUnknown = hParams.Get(2);
            int inventorySlot = hParams.Get(3);
            bool bForcePickup = hParams.Get(4);

            char szClassName[32];
            GetEntityClassname(weapon, szClassName, sizeof(szClassName));

            Action result = Plugin_Continue;

            Call_StartForward(gfPlayerWeaponPickup);
            Call_PushCell(pThis);
            Call_PushCell(weapon);
            Call_PushString(szClassName);
            Call_PushCell(bUnknown);
            Call_PushCell(inventorySlot);
            Call_PushCell(bForcePickup);
            Call_Finish(result);

            if(result == Plugin_Handled)
            {
                return MRES_Supercede;
            }
        }
    }
    
    return MRES_Ignored;
}
