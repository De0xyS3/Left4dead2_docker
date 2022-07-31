FROM amazonlinux:2

RUN yum -y install nano vim htop git curl wget tar bzip2 gzip unzip python3 binutils bc jq tmux glibc.i686 libstdc++ libstdc++.i686 \
    shadow-utils util-linux file nmap-ncat iproute SDL2.i686 SDL2.x86_64 \
    && yum -y update --security
################
######User######
################
RUN useradd louis
WORKDIR /home/louis
USER louis
################
#####Steam######
################
RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz && tar -xzf steamcmd_linux.tar.gz \
    && rm steamcmd_linux.tar.gz && ./steamcmd.sh +quit
RUN mkdir -p .steam/sdk32/ && ln -s ~/linux32/steamclient.so ~/.steam/sdk32/steamclient.so \
    && mkdir -p .steam/sdk64/ && ln -s ~/linux64/steamclient.so ~/.steam/sdk64/steamclient.so
RUN ./steamcmd.sh +login anonymous +force_install_dir ./l4d2 +app_update 222860 +quit
##################
#Donwload plugins#
##################
RUN wget https://www.dropbox.com/s/30sy3mt20paqlhz/plugins.zip && unzip plugins.zip
RUN cd  plugins/ && cp -r addons /home/louis/l4d2/left4dead2/ && cp -r cfg /home/louis/l4d2/left4dead2/
###################
#Download l4dtoolz#
###################
#RUN wget https://www.dropbox.com/s/45tnd1xtwsf7z6y/moreplayers.zip && unzip moreplayers.zip && cp -r addons /home/louis/l4d2/left4dead2/
#RUN chown louis:louis  /home/louis/l4d2/left4dead2/addons/sourcemod/scripting
###################
##Compile Scripts##
###################
RUN chmod 775 /home/louis/l4d2/left4dead2/addons/sourcemod/scripting/*
RUN chmod 775 /home/louis/l4d2/left4dead2/cfg/sourcemod/*
RUN cd /home/louis/l4d2/left4dead2/addons/sourcemod/scripting/ && ./compile.sh


##ENV
EXPOSE 27015/tcp
EXPOSE 27015/udp
EXPOSE 27016/tcp
EXPOSE 27016/udp
EXPOSE 27017/tcp
EXPOSE 27017/udp
ENV PORT=27015 \
    PLAYERS=12 \
    MAP="c14m1_junkyard" \
    REGION=255 \
    HOSTNAME="Left4Wolf L4D2"

ADD entrypoint.sh entrypoint.sh
ENTRYPOINT ./entrypoint.sh