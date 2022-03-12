public MRESReturn Hook_OnCheckAFK(int pThis)
{
    if(!pThis)
        return MRES_Ignored;
    if(!IsClientInGame(pThis))
        return MRES_Ignored;
    
    if(sm_zps_afk_admin_immunity.BoolValue && CheckCommandAccess(pThis, "sm_zps_afk_adm_immunity", ADMFLAG_KICK, true))
    {
        return MRES_Supercede;
    }
    return MRES_Ignored;
}
