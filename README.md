# unify-installation-script

## Brief sample installation script for Unify SDK:
- Quick example check for presence of Thunderboard running Z-Wave NCP serial controller on ZGM230-DK2603A
- Installs all `uic-` packages.
- Post installation, you can disable any `uic-` packages that you do not want running, via: `sudo systemctl disable uic-<package name>`

## Platform:
- Tested functional on Raspberry Pi 400 with connected ZGM230-DK2603A (running Z-Wave NCP serial controller with US_LR region).

## Notes:
- This is a quick script for reference. If there is interest, please reach out and I will expand functionality.
