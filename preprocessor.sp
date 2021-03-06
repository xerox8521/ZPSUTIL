#define PLUGIN_VERSION "1.0.1"

#define GRENADE_MODEL "models/weapons/w_grenade_thrown.mdl"

#define ANIMATION_EVENT_JUMP 7

enum 
{
    TEAM_LOBBY = 0,
    TEAM_SPECTATOR = 1,
    TEAM_SURVIVOR,
    TEAM_ZOMBIE 
}

enum 
{
    WINNER_SURVIVORS = 1,
    WINNER_ZOMBIES,
    WINNER_STALEMATE
}

enum
{
    AMMO_TYPE_PISTOL = 1,
    AMMO_TYPE_REVOLVER,
    AMMO_TYPE_SHOTGUN,
    AMMO_TYPE_RIFLE,
    AMMO_TYPE_BARRICADE
}

enum 
{
    MAPTYPE_SURVIVAL = 1,
    MAPTYPE_OBJECTIVE,
    MAPTYPE_TEAMARENA,
    MAPTYPE_HARDCORE,
    MAPTYPE_BOTS,
    MAPTYPE_DEATHRUN,
    MAPTYPE_UBERPUSH,
    MAPTYPE_GUINEAPIG,
    MAPTYPE_FARMMAP,
}
