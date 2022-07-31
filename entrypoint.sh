#!/bin/bash
# Update Game
./steamcmd.sh +login anonymous +force_install_dir ./l4d2 +app_update 222860 +quit

# Server Config
cat > l4d2/left4dead2/cfg/server.cfg <<EOF
hostname "${HOSTNAME}"
sv_region ${REGION}
sv_logecho 1
sv_gametypes "coop, versus, mutation"
sm_cvar mp_gamemode $MODE
sv_steamgroup "$GROUP"
#sm_cvar mv_maxplayers $PLAYERS
#sm_cvar sv_visiblemaxplayers $PLAYERS
#sm_cvar sv_removehumanlimit 1
#sm_cvar sv_force_unreserved 1

EOF

# Server Config admin
cat > l4d2/left4dead2/addons/sourcemod/configs/admins.cfg <<EOF
Admins
{
"$STEAMNAME"
        {
                "auth"                  "steam"
                "identity"              "$STEAMID"
                "flags"                 "z"
        }
}
EOF


cat > l4d2/left4dead2/addons/sourcemod/configs/admins_simple.ini <<EOF
 "$STEAM_ID"            "z"
EOF


cat > l4d2/left4dead2/host.txt <<EOF
http://sirpleaseny.site.nfoservers.com/compreworkhost.html
EOF

cat > l4d2/left4dead2/motd.txt <<EOF
http://sirpleaseny.site.nfoservers.com/comprework.html
EOF


EOF

# Start Game
cd l4d2 && ./srcds_run -console -game left4dead2 -port "$PORT" +maxplayers "$PLAYERS" +map "$MAP"