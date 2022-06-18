public MRESReturn Hook_OnGetArmorAmmo(int pThis, DHookReturn hReturn, DHookParam hParams)
{
    if(!hParams.IsNull(1))
    {
        int client = hParams.Get(1);
        int ammo = GetEntData(pThis, CArmorAmmoOffset);
        int MaxArmor = 100;

        Call_StartForward(gfOnGetArmorAmmo);
        Call_PushCell(client);
        Call_PushCellRef(MaxArmor);

        Action result = Plugin_Changed;
        Call_Finish(result);

        if(result == Plugin_Changed)
        {
            int difference = ammo;
            if((GetClientArmor(client) + ammo) > MaxArmor)
            {
                difference = MaxArmor - GetClientArmor(client);
            }
            if(difference > 0)
            {
                SetEntData(pThis, CArmorAmmoOffset, ammo - difference);
                IncrementArmorValue(client, difference, MaxArmor);
                ClientCommand(client, "playgamesound ZPlayer.ArmorPickup");
            }
            if(GetEntData(pThis, CArmorAmmoOffset) <= 0)
            {
                RemoveEntity(pThis);
                hReturn.Value = 0;
                return MRES_Supercede;
            }
            hReturn.Value = 1;
            return MRES_Supercede;
        }
    }
    return MRES_Ignored;
}

/*int GetClientArmor(int client)
{
    return GetEntProp(client, Prop_Send, "m_iArmor");
}*/