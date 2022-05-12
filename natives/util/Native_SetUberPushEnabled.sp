public int Native_SetUberPushEnabled(Handle plugin, int params)
{
    bool bToggle = view_as<bool>(GetNativeCell(1));

    if(bIsUberPushEnabled == bToggle) // Same value don't do anything
        return 1;

    bIsUberPushEnabled = bToggle;

    if(bIsUberPushEnabled)
    {
        GameRules_SetPropFloat("m_flCustomHandsPushForce", 999999.0);
        GameRules_SetPropFloat("m_flCustomZombieArmsPushForce", 999999.0);
        GameRules_SetPropFloat("m_flCustomCarrierArmsPushForce", 999999.0);
    }
    else
    {
        // Default value is 1.0
        GameRules_SetPropFloat("m_flCustomHandsPushForce", 1.0);
        GameRules_SetPropFloat("m_flCustomZombieArmsPushForce", 1.0);
        GameRules_SetPropFloat("m_flCustomCarrierArmsPushForce", 1.0);
    }
    return 1;
}