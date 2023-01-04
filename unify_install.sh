#!/bin/bash
#set -x

# Exit codes
ERR_NONE=0
ERR_UNKNOWN=1
ERR_NCP_NOT_FOUND=2
ERR_PERMISSIONS=3

# Change to point to desired Unify SDK / Matter versions:
UNIFY_VERSION="1.2.1"
MATTER_VERSION="1.0.2-1.0"

# Quick device var to make sure at least one NCP is present:
# ** Change this to point to your NCP device **
# - Z-Wave USLR controller on Thunderboard on my test, hence ttyACM0
# - Add Zigbee BLE controllers if desired
# - At the end of the Unify installation, you will be asked to enter values
#   manually, to link each hardware NCP to a software protocol controller.
DEVICE="ttyACM0"

# Need to be root
if [ "$EUID" -ne 0 ]; then
    echo -e "Please run as root!\n"
    exit $ERR_PERMISSIONS
fi

# Check for NCP device
if ls /dev/ | grep -q "$DEVICE"; then
    logger -s -t UNIFY_INSTALLATION "NCP device found! Continuing installation.."
else
    logger -s -t UNIFY_INSTALLATION "NCP device not found, check connections and run again!"
    exit $ERR_NCP_NOT_FOUND
fi

# Install required packages
logger -s -t UNIFY_INSTALLATION "Updating and installing required package.."
apt update
apt install -y mosquitto
apt install -y mosquitto-clients

# -- From: https://siliconlabs.github.io/UnifySDK/doc/system_requirements.html
apt install -y ipset
apt install -y libavahi-client3
apt install -y libboost-atomic1.67.0
apt install -y libboost-chrono1.67.0
apt install -y libboost-date-time1.67.0
apt install -y libboost-filesystem1.67.0
apt install -y libboost-log1.67.0
apt install -y libboost-program-options1.67.0
apt install -y libboost-regex1.67.0
apt install -y libboost-system1.67.0
apt install -y libboost-thread1.67.0
apt install -y libipset11
apt install -y libmbedcrypto3
apt install -y libmbedtls12
apt install -y libmbedx509-0
apt install -y libyaml-cpp0.6
apt install -y socat
apt install -y libmosquitto1

# Retrieve and install Unify SDK packages
logger -s -t UNIFY_INSTALLATION "Retrieving Unify installation: $UNIFY_VERSION"
mkdir -p ~/Downloads/unify-install
wget https://github.com/SiliconLabs/UnifySDK/releases/download/ver_"$UNIFY_VERSION"/unify_"$UNIFY_VERSION"_armhf.zip -P ~/Downloads/unify-install
mkdir ~/Downloads/unify-install/unpack
unzip -o ~/Downloads/unify-install/unify_"$UNIFY_VERSION"_armhf.zip -d ~/Downloads/unify-install/unpack
dpkg -i ~/Downloads/unify-install/unpack/unify_"$UNIFY_VERSION"_armhf/*.deb

# Retrieve matter bridge
logger -s -t UNIFY_INSTALLATION "Retrieving Matter installation: $MATTER_VERSION"
mkdir -p ~/Downloads/matter-install
wget https://github.com/SiliconLabs/matter/releases/download/v"$MATTER_VERSION"/unify_matter_bridge_"$MATTER_VERSION".zip -P ~/Downloads/matter-install
mkdir ~/Documents/matter-binaries
unzip -o ~/Downloads/matter-install/unify_matter_bridge_"$MATTER_VERSION".zip -d ~/Documents/matter-binaries

# Finish script with some notes.
logger -s -t UNIFY_INSTALLATION "Unify installation attempt complete."
logger -s -t UNIFY_INSTALLATION "From this machine, connect to sample UI via: 127.0.0.1:3080/nodes"
logger -s -t UNIFY_INSTALLATION "Manually REBOOT machine or restart all uic- services!"

exit "$ERR_NONE"
