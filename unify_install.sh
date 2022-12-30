#!/bin/bash
#set -x

# Exit codes
ERR_NONE=0
ERR_NCP_NOT_FOUND=2
ERR_UNKNOWN=3

# Change to point to desired Unify SDK version:
UNIFY_VERSION="1.2.1"

# Quick device var to make sure at least one NCP is present:
# - Z-Wave USLR controller on Thunderboard on my test, hence ttyACM0
# - Add Zigbee BLE controllers if desired
# - At the end of the Unify installation, you will be asked to enter values
#   manually, to link each hardware NCP to a software protocol controller.
DEVICE="ttyACM0"

# Need to be root
if [ "$EUID" -ne 0 ]; then
    echo -e "Please run as root!\n"
    exit 1
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
apt install -y libboost-program-options1.67.0

# Retrieve and install Unify SDK
logger -s -t UNIFY_INSTALLATION "Retrieving Unify installation: $UNIFY_VERSION"

mkdir -p ~/Downloads/unify-install
wget https://github.com/SiliconLabs/UnifySDK/releases/download/ver_"$UNIFY_VERSION"/unify_"$UNIFY_VERSION"_armhf.zip -P ~/Downloads/unify-install
mkdir ~/Downloads/unify-install/unpack
unzip -o ~/Downloads/unify-install/unify_"$UNIFY_VERSION"_armhf.zip -d ~/Downloads/unify-install/unpack

#Install all packages
dpkg -i ~/Downloads/unify-install/unpack/unify_"$UNIFY_VERSION"_armhf/*.deb

#Install all missing depencies - this will kick off UIC config interfaces.
sudo apt-get install -f

logger -s -t UNIFY_INSTALLATION "Unify installation attempt complete."
logger -s -t UNIFY_INSTALLATION "From this machine, connect to sample UI via: 127.0.0.1:3080/nodes"
logger -s -t UNIFY_INSTALLATION "Manually REBOOT machine or restart all uic- services!"

exit "$ERR_NONE"
