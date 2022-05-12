public MRESReturn Hook_OnGetSpeed(int pThis, DHookReturn hReturn)
{
    if(!pThis)
        return MRES_Ignored;
    if(!IsClientInGame(pThis))
        return MRES_Ignored;
    if(!IsPlayerAlive(pThis))
        return MRES_Ignored;
    
    float flSpeed = flMaxSpeed[pThis];
    int buttons = GetClientButtons(pThis);
    int flags = GetEntityFlags(pThis);
    bool m_bDucked = view_as<bool>(GetEntProp(pThis, Prop_Send, "m_bDucked"));
    if(GetClientTeam(pThis) == TEAM_ZOMBIE)
    {
        if(GetEntProp(pThis, Prop_Send, "m_bBerzerking"))
        {
            flSpeed *= GrabItemsGame_Float("player_data", "player_speed", "berzerk");
        }
        if(GetEntProp(pThis, Prop_Send, "m_fIsSprinting") && GetEntPropFloat(pThis, Prop_Send, "m_flSuitPower") > 0.0)
        {
            flSpeed *= GrabItemsGame_Float("player_data", "player_speed", "runspeed_zombie");
        }
    }

    if(buttons & IN_BACK)
    {
        if(flags & FL_ONGROUND)
        {
            flSpeed -= GrabItemsGame_Float("player_data", "player_speed", "backwards");
        }
    }

    if(m_bDucked)
    {
        if(flags & FL_ONGROUND)
        {
            flSpeed -= GrabItemsGame_Float("player_data", "player_speed_reduce", "ducking");
        }
    }

    flSpeed -= GetEntPropFloat(pThis, Prop_Send, "m_flPlayerJumpFatigue");
    
    if(GetClientTeam(pThis) == TEAM_SURVIVOR)
    {
        flSpeed -= GetEntPropFloat(pThis, Prop_Send, "m_flPlayerWeight");
        flSpeed -= GetEntPropFloat(pThis, Prop_Send, "m_flPlayerFatigue");

        if(buttons & IN_SPEED)
        {
            if(flags & FL_ONGROUND)
            {
                flSpeed -= GrabItemsGame_Float("player_data", "player_speed_reduce", "walking");
            }
        }
        if(flSpeed < GrabItemsGame_Float("player_data", "player_speed_reduce", "minimum"))
        {
            flSpeed = GrabItemsGame_Float("player_data", "player_speed_reduce", "minimum");
        }
    }

    if(GetClientTeam(pThis) == TEAM_ZOMBIE)
    {
        if(flSpeed < GrabItemsGame_Float("player_data", "player_speed_reduce", "minimum_zombie"))
        {
            flSpeed = GrabItemsGame_Float("player_data", "player_speed_reduce", "minimum_zombie");
        }
    }
    hReturn.Value = flSpeed;
    return MRES_Supercede;
}
