public int Native_AddRoundTime(Handle plugin, int params)
{
    float flRoundTime = GetNativeCell(1);

    float flCurrentRoundTime = GameRules_GetPropFloat("m_flRoundTime");
    flCurrentRoundTime += flRoundTime;
    GameRules_SetPropFloat("m_flRoundTime", flCurrentRoundTime);
    return 1;
}
