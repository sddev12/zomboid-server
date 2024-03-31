FROM ubuntu:latest

# Install software-properties-common package
RUN apt-get update && apt-get install -y software-properties-common

# Install wget
RUN apt install wget -y

# Install SteamCMD
RUN add-apt-repository multiverse
RUN dpkg --add-architecture i386
RUN apt update
RUN echo steam steam/question select "I AGREE" | debconf-set-selections
RUN echo steam steam/license note '' | debconf-set-selections
RUN apt install steamcmd -y

# Add user for PZ server so server is not running as root
RUN adduser pzuser

# Create directory for PZ Server
RUN mkdir /opt/pzserver

# Make pzuser the owner of the above directory
RUN chown pzuser:pzuser /opt/pzserver

# Switch to pzuser
USER pzuser

# Download SteamCMD script to install or update the Project Zomboid Server
RUN wget -O $HOME/update_zomboid.txt https://gist.githubusercontent.com/sddev12/46f33cf6abfd49f887b451808e48b8c5/raw/d3eb56de268e2d195892147768bd66e940d97600/update_zomboid.txt

ENV PATH="/usr/games:${PATH}"

RUN steamcmd +runscript /home/pzuser/update_zomboid.txt

# Expose requirted ports
EXPOSE 16261/udp
EXPOSE 16262/udp

CMD ["bash", "/opt/pzserver/start-server.sh", "-adminpassword", "$(cat /run/secrets/PZ_SERVER_ADMIN_PASSWORD)"]