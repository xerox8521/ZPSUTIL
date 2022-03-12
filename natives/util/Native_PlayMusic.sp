public any Native_PlayMusic(Handle plugin, int params)
{
    int length;
    GetNativeStringLength(1, length);

    char[] szTrack = new char[length+2];

    GetNativeString(1, szTrack, length+1);

    GetNativeStringLength(2, length);

    char[] szTitle = new char[length+2];

    GetNativeString(1, szTitle, length+1);

    Event event = CreateEvent("force_song", true);
    if(event != null)
    {
        event.SetString("song", szTrack);
        event.SetString("title", szTitle);
        event.Fire();
    }
    return 1;
}
