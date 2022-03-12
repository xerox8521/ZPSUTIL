public void OnCaptureEnd(const char[] output, int caller, int activator, float delay)
{
    if(gfCaptured.FunctionCount > 0)
    {
        int teamindex = TEAM_LOBBY;
        if(StrEqual(output, "m_OnZombieCaptureCompleted"))
        {
            teamindex = TEAM_ZOMBIE;
        }
        else if(StrEqual(output, "m_OnHumanCaptureCompleted"))
        {
            teamindex = TEAM_SURVIVOR;
        }

        Call_StartForward(gfCaptured);
        Call_PushCell(caller);
        Call_PushCell(teamindex);
        Call_Finish();
    }  
}
