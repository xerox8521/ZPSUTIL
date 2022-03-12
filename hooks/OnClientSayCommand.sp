public Action OnClientSayCommand(int client, const char[] szCommand, const char[] szArgs)
{
    if(IsChatTrigger())
        return Plugin_Continue;

    if(sm_zps_util_colored_tags.BoolValue == false)
    {
        if(bModifiedChat[client] == false)
        {
            char buffer[PLATFORM_MAX_PATH];
            StripColors(szArgs, buffer, sizeof(buffer));
            bModifiedChat[client] = true;
            ClientCommand(client, "%s %s", szCommand, buffer);
            CreateTimer(1.5, t_ResetModifiedChat, GetClientSerial(client), TIMER_FLAG_NO_MAPCHANGE);
            return Plugin_Stop;

        }
    }
    return Plugin_Continue;    
}

public Action t_ResetModifiedChat(Handle timer, any serial)
{
    int client = GetClientFromSerial(serial);
    if(!client) 
        return Plugin_Continue;
    if(!IsClientInGame(client)) 
        return Plugin_Continue;

    if(bModifiedChat[client])
    {
        bModifiedChat[client] = false;
    } 
    return Plugin_Continue;
}
