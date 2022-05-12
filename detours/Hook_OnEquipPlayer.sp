public MRESReturn Hook_OnEquipPlayer(int pThis)
{
    if(gfEquipPlayer.FunctionCount > 0)
    {
        Call_StartForward(gfEquipPlayer);
        Call_PushCell(pThis);
        Call_Finish();
    }
    return MRES_Ignored;
}