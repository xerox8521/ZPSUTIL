void SetMapType(const char[] szMapName)
{
    MapType = MAPTYPE_SURVIVAL;

    if(StrContains(szMapName, "lnd_", false) != -1 || StrContains(szMapName, "zps_", false) != -1 || StrContains(szMapName, "zp_", false) != -1 
    || StrContains(szMapName, "zpl_", false) != -1)
    {
        MapType = MAPTYPE_SURVIVAL;
    }
        
    if(StrContains(szMapName, "zpo_", false) != -1)
    {
        MapType = MAPTYPE_OBJECTIVE;
    }

    if(StrContains(szMapName, "zpa_", false) != -1)
    {
        MapType = MAPTYPE_TEAMARENA;
    }
        
    if(StrContains(szMapName, "zph_", false) != -1)
    {
        MapType = MAPTYPE_HARDCORE; // Hardcore
    }
        
    if(StrContains(szMapName, "bots", false) != -1)
    {
        MapType = MAPTYPE_BOTS;
    }

    if(StrContains(szMapName, "deathrun", false) != -1 || StrContains(szMapName, "zps_dr_", false) != -1)
    {
        MapType = MAPTYPE_DEATHRUN;
    }
        

    if(StrContains(szMapName, "uberpush", false) != -1 || StrContains(szMapName, "rallycrash", false) != -1)
    {
        MapType = MAPTYPE_UBERPUSH;
    }
        
    if(StrContains(szMapName, "guinea", false) != -1)
    {
        MapType = MAPTYPE_GUINEAPIG;
    }

    if(StrContains(szMapName, "lake", false) != -1 || StrContains(szMapName, "church", false) != -1 || StrContains(szMapName, "cabin", false) != -1
    || StrContains(szMapName, "redqueen", false) != -1 || StrContains(szMapName, "lila_billy", false) != -1 || StrContains(szMapName, "rabbit_hole", false) != -1)
    {
        MapType = MAPTYPE_FARMMAP;
    }
}
