public int Native_SetZombieLives(Handle plugin, int params)
{
    GameRules_SetProp("m_iZombieLives", GetNativeCell(1));
    return 1;
}
