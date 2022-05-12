bool bModifiedChat[MAXPLAYERS+1];

bool IsLinux = false;
bool bIsUberPushEnabled;

Address gZPData = Address_Null;

float flMaxSpeed[MAXPLAYERS+1];

int MapType = -1;

char szMapType[][] = 
{
    "Invalid Map Type",
    "Survival",
    "Objective",
    "Team Arena",
    "Hardcore",
    "Bots",
    "Death Run",
    "Uberpush",
    "Guinea Pig - Death Run",
    "Farm Map (Redqueen, Church, Lake etc.)"
};