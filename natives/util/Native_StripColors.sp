public any Native_StripColors(Handle plugin, int params)
{
    int length;
    GetNativeStringLength(1, length);

    char[] szMessage = new char[length+2];
    GetNativeString(1, szMessage, length+1);

    length = GetNativeCell(3);
    char[] szBuffer = new char[length+2];

    StripColors(szMessage, szBuffer, length);
    SetNativeString(2, szBuffer, length);
    return 1;
}
