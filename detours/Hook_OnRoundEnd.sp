public MRESReturn Hook_OnRoundEnd(DHookParam hParam)
{
    if(gfRoundEnd.FunctionCount > 0)
    {
        int winner = hParam.Get(1);
        if(winner != WINNER_SURVIVORS && winner != WINNER_ZOMBIES)
        {
            winner = WINNER_STALEMATE;
        }
        Call_StartForward(gfRoundEnd);
        Call_PushCell(winner);
        Call_Finish();
    }
    
    return MRES_Ignored;
}