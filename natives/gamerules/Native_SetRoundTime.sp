public int Native_SetRoundTime(Handle plugin, int params)
{
    float flRoundTime = GetNativeCell(1);

    flRoundTime = (GetGameTime() + flRoundTime);
    GameRules_SetPropFloat("m_flRoundTime", flRoundTime);
    return 1;
}
